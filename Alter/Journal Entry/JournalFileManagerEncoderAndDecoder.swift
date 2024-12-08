//
//  JournalFileManagerEncoderAndDecoder.swift
//  Alter
//
//  Created by Elliott Hager on 12/5/24.
//

import Foundation

class JournalFileManagerEncoderAndDecoder {
    
    //Gives the kinJSONDirectory a temp directory until assigning in the init constructor
    private var journalJSONDirectory : URL = FileManager.default.temporaryDirectory
    
    //This will hold the global ID of the next profile to be assigned
    //This will allow for a unique profile to be saved for many kin/personalities
    //of the same name and species
    private var entryID : Int = 1
    
    private let fileManager = FileManager.default
    
    
    //Will be used to determine if in edit mode when encoding and writing to
    //the file system
    //Set to public static as only one edit mode could exist
    //Will allow for the toggle to be changed when profiles are edited
    public static var editMode = false
    
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
        self.entryID = highestID()
        
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
    
    private func decodeEntry(jorunalEntryJSONDate: Data) -> JournalEntryStructure {
        //Set up the decoder
        let jsonDecorder = JSONDecoder()
        
        let decodedData = try! jsonDecorder.decode(JournalEntryStructure.self, from: jorunalEntryJSONDate)
        
        return decodedData
    }
    
    public func saveEntry(entryDetails: Dictionary<String, String>) -> Void {
        //Determine if in edit mode
        if (!JournalFileManagerEncoderAndDecoder.editMode) {
            //To save to the system we want to do the following
            // 1. Encode for JSON format based on the Struct made
            // 2. Write to a file titled with the name of the profile_species_id
            // 3. Save file to the kinJSONDirectory for the app
            
            /* TESTING: NEED TO MAKE FOR ALL FIELDS */
            let currentEntry = JournalEntryStructure(
                entryName: entryDetails["entryName"]!,
                entryText: entryDetails["entryText"]!,
                mentalExperience: entryDetails["mentalExperience"]!,
                physicalExperience: entryDetails["physicalExperience"]!,
                spiritualExperence: entryDetails["spiritualExperence"]!,
                entryID: String(entryID),
                entryDate: entryDetails["entryDate"]!,
                kinName: entryDetails["kinName"]!
            )
            
            //Now encode it
            let entryContentToWriteToFile = encodeEntry(entry: currentEntry)
            
            print(entryContentToWriteToFile)
            
            print("NOW CREATING FILE!!")
            
            var fileName = String()
            
            //Now generate the file name
            fileName = journalJSONDirectory.path + "/\(entryID).json"
            
            
            //Update the ID so the next profile is valid
            entryID += 1
            
            //Now write it into the file
            let successfulCreation = fileManager.createFile(atPath: fileName,
                                                            contents: entryContentToWriteToFile)
            
            print("Created file \(fileName)?: \(successfulCreation)")
            
        } else {
            print("IN EDIT MODE, ALREADY HAVE THE PROFILE ID!")
            
            
            print("Current profile (SHOULD BE THE SAME PROFILE ID AS LOADED")
            print(entryDetails)
            
            //Set the details to the changed details and now keep
            //The same ID
            let currentEntry = JournalEntryStructure(
                entryName: entryDetails["entryName"]!,
                entryText: entryDetails["entryText"]!,
                mentalExperience: entryDetails["mentalExperience"]!,
                physicalExperience: entryDetails["physicalExperience"]!,
                spiritualExperence: entryDetails["spiritualExperence"]!,
                entryID: entryDetails["entryID"]!,
                entryDate: entryDetails["entryDate"]!,
                kinName: entryDetails["kinName"]!
            )
            
            //Now encode it
            let entryContentToWriteToFile = encodeEntry(entry: currentEntry)
            
            print(entryContentToWriteToFile)
            
            print("NOW CREATING FILE!!")
            
            var fileName = String()
            
            //Now generate the file name
            fileName = journalJSONDirectory.path + "/\(entryDetails["entryID"]!).json"
            
            print(fileName)
            
            //Now write it into the file
            let successfulCreation = fileManager.createFile(atPath: fileName,
                                                            contents: entryContentToWriteToFile)
            
            print("Created file \(fileName)?: \(successfulCreation)")
        }
    }
    
    func loadEntry(entryID: Int) -> JournalEntryStructure{
        //This will hold the profile when loaded
        //nil is given if the profile is not found
        var entryDetails : JournalEntryStructure = JournalEntryStructure(entryName:"", entryText: "", mentalExperience: "", physicalExperience: "", spiritualExperence: "", entryID: "0", entryDate: "", kinName: "")
        
        //Grab the file from the file manager
        let loadEntryFileManager = FileManager.default
        let loadEntryFileManagerPath = journalJSONDirectory.appendingPathComponent("\(entryID).json")
        guard let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .allDomainsMask).first else { return entryDetails}
        //let numberOfItems = try! FileManager.default.contentsOfDirectory(atPath:documentsPath.path ).count
        
        //print(loadProfileFileManagerPath)
        //print("Number of files in the path: \(numberOfItems)")
        
        if (loadEntryFileManager.fileExists(atPath: loadEntryFileManagerPath.path)) {
            //File exists, now we are safe to read from it
            //let profileData = loadProfileFileManager.contents(atPath: loadProfileFileManagerPath.absoluteString)
            
            //Now send it to decode to get the profile struct back
            entryDetails = decodeEntry(jorunalEntryJSONDate: try! Data(contentsOf: loadEntryFileManagerPath))
        } else {
            print("COULD NOT FIND ENTRY WITH ID \(entryID)")
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
        
        
        print("JournalEntryFileManagerEncoderAndDecoder Names: \(fileNames)")
        
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
    
    
    static func setEditMode(mode: Bool) {
        editMode = mode
    }
    
    
    //This will be used to populate the list of kin profiles that can be selected when writing a journal entry
    static func getAllEntryNamesSpecies() -> [String] {
        //Create an instance of itself
        let fileManager = JournalFileManagerEncoderAndDecoder()
        
        //Now collect all the profile names
        let entryNames = fileManager.entryNames()
        
        //Holds the names
        var result: [String] = []
        
        //Now for each one grab the profile's kin name stored in the JSON
        for entryID in entryNames {
            //Make a variable to hold the profile
            let currentEntry = fileManager.loadEntry(entryID: entryID)
            result.append("\(currentEntry.entryName)")
        }
        
        return result
    }
    
}
