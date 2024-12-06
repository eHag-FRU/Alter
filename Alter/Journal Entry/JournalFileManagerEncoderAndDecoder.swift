//
//  JournalFileManagerEncoderAndDecoder.swift
//  Alter
//
//  Created by Elliott Hager on 12/5/24.
//

import Foundation
class JournalFileManagerEncoderAndDecoder {
    
    //Gives the journalJSONDirectory a temp directory until assigning in the init constructor
    private var journalJSONDirectory : URL = FileManager.default.temporaryDirectory
    
    //This will hold the global ID of the next profile to be assigned
    //This will allow for a unique profile to be saved for many kin/personalities
    //of the same name and species
    private var journalEntryID : Int = 1
    
    private let fileManager = FileManager.default
    
    
    //Will be used to determine if in edit mode when encoding and writing to
    //the file system
    private let editMode = false
    
    init() {
        //Grab the file directory for the documents directory
        //Then append the folder called kin, this will hold the kin JSON
        //profile information to read and write from
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .allDomainsMask).first else { return }
        
        self.journalJSONDirectory = documentsDirectory.appendingPathComponent("journalEntries")
        
        //Now check if the directory exists, on first run it will not
        //So will only create if it does NOT exist
        var isDirectory: ObjCBool = true
        if (!FileManager.default.fileExists(atPath: self.journalJSONDirectory.path, isDirectory: &isDirectory)) {
            //Directory does not exist, so create it!
            try! fileManager.createDirectory(at: journalJSONDirectory, withIntermediateDirectories: true, attributes: nil)
        }
        
        //Now need to set the profile id to keep going from as the count of files plus 1
        self.journalEntryID = highestID()
        
        print(documentsDirectory)
    }
    
    private func encodeEntry(entry: JournalEntryStructure) -> Data {
        //Set up the encoder
        let jsonEncoder = JSONEncoder()
        jsonEncoder.outputFormatting = .prettyPrinted
        
        //Now encode and put it in the variable data
        let data = try? jsonEncoder.encode(entry)
        
        print(String(data: data!, encoding: .utf8)!)
        
        //Return the data that was encoded as JSON
        return data!
    }
    
    private func decodeEntry(entryJSONDate: Data) -> JournalEntryStructure {
        //Set up the decoder
        let jsonDecorder = JSONDecoder()
        
        let decodedData = try! jsonDecorder.decode(JournalEntryStructure.self, from: entryJSONDate)
        
        return decodedData
    }
    
    public func saveEntry(profileDetails: Dictionary<String, String>) -> Void {
        //To save to the system we want to do the following
        // 1. Encode for JSON format based on the Struct made
        // 2. Write to a file titled with the name of the profile_species_id
        // 3. Save file to the kinJSONDirectory for the app
        
        /* TESTING: NEED TO MAKE FOR ALL FIELDS */
        let currentEntry = JournalEntryStructure(
            entryName: profileDetails["entryName"]!
        )
        
        //Now encode it
        let entryContentToWriteToFile = encodeEntry(entry: currentEntry)
        
        print(entryContentToWriteToFile)
        
        print("NOW CREATING FILE!!")
        
        var fileName = String()
        
        //Determine if in edit mode
        if (!editMode) {
            //Now generate the file name
            fileName = journalJSONDirectory.path + "/\(journalEntryID).json"
            
            
            //Update the ID so the next profile is valid
            journalEntryID += 1
        }
        
        //Now write it into the file
        let successfulCreation = fileManager.createFile(atPath: fileName,
                                                        contents: entryContentToWriteToFile)
        
        print("Created file \(fileName)?: \(successfulCreation)")
        
    }
    
    func loadProfile(profileID: Int) -> JournalEntryStructure{
        //This will hold the profile when loaded
        //nil is given if the profile is not found
        //var entryDetails : JournalEntryStructure = JournalEntryStructure(entryName: "", entryDate: "", kinName: "", entryInfo: "", mentalExperience: "", physicalExperience: "", spiritualExperence: "")
        var entryDetails : JournalEntryStructure = JournalEntryStructure(entryName: "")
        
        //Grab the file from the file manager
        let loadEntryFileManager = FileManager.default
        let loadEntryFileManagerPath =  journalJSONDirectory.appendingPathComponent("\(journalEntryID).json")
        guard let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .allDomainsMask).first else { return entryDetails}
        //let numberOfItems = try! FileManager.default.contentsOfDirectory(atPath:documentsPath.path ).count
        
        //print(loadProfileFileManagerPath)
        //print("Number of files in the path: \(numberOfItems)")
        
        if (loadEntryFileManager.fileExists(atPath: loadEntryFileManagerPath.path)) {
            //File exists, now we are safe to read from it
            //let profileData = loadProfileFileManager.contents(atPath: loadProfileFileManagerPath.absoluteString)
            
            //Now send it to decode to get the profile struct back
            entryDetails = decodeEntry(entryJSONDate: try! Data(contentsOf: loadEntryFileManagerPath))
        } else {
            print("COULD NOT FIND ENTRY WITH ID \(journalEntryID)")
        }
        
        
        
        
        //let profileJSONFile = FileManager.default.urls(for: kinJSONDirectory, in: .userDomainMask).first else { return }
        
        
        return entryDetails
    }
    
    func count() -> Int {
        return try! FileManager.default.contentsOfDirectory(atPath: self.journalJSONDirectory.path).filter({(fileName:String)->Bool in
                return fileName != ".DS_Store"
        }).count

    }
    
    func highestID() -> Int {
        //Grab the file names
        var entryIDs = entryNames()
        
        //Now sort them, by asscending
        entryIDs.sort(by:>)
        
        if (entryIDs.count > 0) {
            //If there are profiles now set the profile ID to the largest plus 1
            return entryIDs[0] + 1
        }
        
        //Else there are no profiles, so the start is 1
        return 1
    }
    
    func entryNames() -> [Int] {
        //Grabs the fileURLs
        let fileURLs = try! fileManager.contentsOfDirectory(at: self.journalJSONDirectory, includingPropertiesForKeys: nil).filter({(fileName:URL)->Bool in
            return !fileName.path().contains(".DS_Store")
        })
        
        //Will hold the names
        var fileNames : [Int] = []
        
        //Removes the path and the file extension and adds it to the array
        //0s will be treated as invalid profile names and invalid profiles
        for url in fileURLs {
            let currentFileName = Int(url.deletingPathExtension().lastPathComponent)
            
            //Only add if the file actually exists, 0 is an id of a file that does not exist
            if(currentFileName ?? 0  > 0) {
                fileNames.append(currentFileName!)
            }
            
        }
        
        
        print("JournalFileManagerEncoderAndDecoder Names: \(fileNames)")
        
        return fileNames
        
    }
    
    func deleteAllProfiles() -> Void {
        //Grab all of the files in the directory
        let files = try! FileManager.default.contentsOfDirectory(at: journalJSONDirectory, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
        
        //Iterate through the files, only grabbing the JSON files
        for file in files where file.pathExtension == "json" {
            try! FileManager.default.removeItem(at: file)
        }
        
    }
    
}
