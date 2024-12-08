//
//  KinFileManagerEncoderAndDecoder.swift
//  Alter
//
//  Created by Elliott Hager on 11/24/24.
//

import Foundation

class KinFileManagerEncoderAndDecoder {
    
    //Gives the kinJSONDirectory a temp directory until assigning in the init constructor
    private var kinJSONDirectory : URL = FileManager.default.temporaryDirectory
    
    //This will hold the global ID of the next profile to be assigned
    //This will allow for a unique profile to be saved for many kin/personalities
    //of the same name and species
    private var profileID : Int = 1
    
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
        
        self.kinJSONDirectory = documentsDirectory.appendingPathComponent("kinProfiles")
        
        //Now check if the directory exists, on first run it will not
        //So will only create if it does NOT exist
        var isDirectory: ObjCBool = true
        if (!FileManager.default.fileExists(atPath: self.kinJSONDirectory.path, isDirectory: &isDirectory)) {
            //Directory does not exist, so create it!
            try! fileManager.createDirectory(at: kinJSONDirectory, withIntermediateDirectories: true, attributes: nil)
        }
        
        //Now need to set the profile id to keep going from as the count of files plus 1
        self.profileID = highestID()
        
        print(documentsDirectory)
    }
    
    private func encodeProfile(profile: KinDetailsStructure) -> Data {
        //Set up the encoder
        let jsonEncoder = JSONEncoder()
        jsonEncoder.outputFormatting = .prettyPrinted
        
        //Now encode and put it in the variable data
        let data = try? jsonEncoder.encode(profile)
        
        print(String(data: data!, encoding: .utf8)!)
        
        //Return the data that was encoded as JSON
        return data!
    }
    
    private func decodeProfile(profileJSONDate: Data) -> KinDetailsStructure {
        //Set up the decoder
        let jsonDecorder = JSONDecoder()
        
        let decodedData = try! jsonDecorder.decode(KinDetailsStructure.self, from: profileJSONDate)
        
        return decodedData
    }
    
    public func saveProfile(profileDetails: Dictionary<String, String>) -> Void {
        //Determine if in edit mode
        if (!KinFileManagerEncoderAndDecoder.editMode) {
            //To save to the system we want to do the following
            // 1. Encode for JSON format based on the Struct made
            // 2. Write to a file titled with the name of the profile_species_id
            // 3. Save file to the kinJSONDirectory for the app
            
            /* TESTING: NEED TO MAKE FOR ALL FIELDS */
            let currentProfile = KinDetailsStructure(
                kinName: profileDetails["kinName"]!,
                kinSpecies: profileDetails["kinSpecies"]!,
                kinAwakenDate: profileDetails["kinAwakenDate"]!,
                kinMental: profileDetails["kinMental"]!,
                kinPhysical: profileDetails["kinPhysical"]!,
                kinSpiritual: profileDetails["kinSpiritual"]!,
                kinBio:  profileDetails["kinBio"]!,
                profileID: String(profileID)
            )
            
            //Now encode it
            let profileContentToWriteToFile = encodeProfile(profile: currentProfile)
            
            print(profileContentToWriteToFile)
            
            print("NOW CREATING FILE!!")
            
            var fileName = String()
            
            //Now generate the file name
            fileName = kinJSONDirectory.path + "/\(profileID).json"
            
            
            //Update the ID so the next profile is valid
            profileID += 1
            
            //Now write it into the file
            let successfulCreation = fileManager.createFile(atPath: fileName,
                                                            contents: profileContentToWriteToFile)
            
            print("Created file \(fileName)?: \(successfulCreation)")
            
        } else {
            print("IN EDIT MODE, ALREADY HAVE THE PROFILE ID!")
            
            
            print("Current profile (SHOULD BE THE SAME PROFILE ID AS LOADED")
            print(profileDetails)
            
            //Set the details to the changed details and now keep
            //The same ID
            let currentProfile = KinDetailsStructure(
                kinName: profileDetails["kinName"]!,
                kinSpecies: profileDetails["kinSpecies"]!,
                kinAwakenDate: profileDetails["kinAwakenDate"]!,
                kinMental: profileDetails["kinMental"]!,
                kinPhysical: profileDetails["kinPhysical"]!,
                kinSpiritual: profileDetails["kinSpiritual"]!,
                kinBio:  profileDetails["kinBio"]!,
                profileID: profileDetails["profileID"]!
            )
            
            //Now encode it
            let profileContentToWriteToFile = encodeProfile(profile: currentProfile)
            
            print(profileContentToWriteToFile)
            
            print("NOW CREATING FILE!!")
            
            var fileName = String()
            
            //Now generate the file name
            fileName = kinJSONDirectory.path + "/\(profileDetails["profileID"]!).json"
            
            print(fileName)
            
            //Now write it into the file
            let successfulCreation = fileManager.createFile(atPath: fileName,
                                                            contents: profileContentToWriteToFile)
            
            print("Created file \(fileName)?: \(successfulCreation)")
        }
    }
    
    func loadProfile(profileID: Int) -> KinDetailsStructure{
        //This will hold the profile when loaded
        //nil is given if the profile is not found
        var profileDetails : KinDetailsStructure = KinDetailsStructure(kinName: "", kinSpecies: "", kinAwakenDate: "", kinMental: "", kinPhysical: "", kinSpiritual: "", kinBio: "", profileID: "0")
        
        //Grab the file from the file manager
        let loadProfileFileManager = FileManager.default
        let loadProfileFileManagerPath = kinJSONDirectory.appendingPathComponent("\(profileID).json")
        guard let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .allDomainsMask).first else { return profileDetails}
        //let numberOfItems = try! FileManager.default.contentsOfDirectory(atPath:documentsPath.path ).count
        
        //print(loadProfileFileManagerPath)
        //print("Number of files in the path: \(numberOfItems)")
        
        if (loadProfileFileManager.fileExists(atPath: loadProfileFileManagerPath.path)) {
            //File exists, now we are safe to read from it
            //let profileData = loadProfileFileManager.contents(atPath: loadProfileFileManagerPath.absoluteString)
            
            //Now send it to decode to get the profile struct back
            profileDetails = decodeProfile(profileJSONDate: try! Data(contentsOf: loadProfileFileManagerPath))
        } else {
            print("COULD NOT FIND PROFILE WITH ID \(profileID)")
        }
        
        
        
        
        //let profileJSONFile = FileManager.default.urls(for: kinJSONDirectory, in: .userDomainMask).first else { return }
        
        
        return profileDetails
    }
    
    func count() -> Int {
        return try! FileManager.default.contentsOfDirectory(atPath: self.kinJSONDirectory.path).filter({(fileName:String)->Bool in
                return fileName != ".DS_Store"
        }).count

    }
    
    func highestID() -> Int {
        //Grab the file names
        var profileIDs = profileNames()
        
        //Now sort them, by asscending
        profileIDs.sort(by:>)
        
        if (profileIDs.count > 0) {
            //If there are profiles now set the profile ID to the largest plus 1
            return profileIDs[0] + 1
        }
        
        //Else there are no profiles, so the start is 1
        return 1
    }
    
    func profileNames() -> [Int] {
        //Grabs the fileURLs
        let fileURLs = try! fileManager.contentsOfDirectory(at: self.kinJSONDirectory, includingPropertiesForKeys: nil).filter({(fileName:URL)->Bool in
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
        
        
        print("KinFileManagerEncoderAndDecoder Names: \(fileNames)")
        
        return fileNames
        
    }
    
    func deleteAllProfiles() -> Void {
        //Grab all of the files in the directory
        let files = try! FileManager.default.contentsOfDirectory(at: kinJSONDirectory, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
        
        //Iterate through the files, only grabbing the JSON files
        for file in files where file.pathExtension == "json" {
            try! FileManager.default.removeItem(at: file)
        }
        
    }
    
    
    static func setEditMode(mode: Bool) {
        editMode = mode
    }
    
    
    //This will be used to populate the list of kin profiles that can be selected when writing a journal entry
    static func getAllProfileNamesSpecies() -> [String] {
        //Create an instance of itself
        let fileManager = KinFileManagerEncoderAndDecoder()
        
        //Now collect all the profile names
        let profileNames = fileManager.profileNames()
        
        //Holds the names
        var result: [String] = []
        
        //Now for each one grab the profile's kin name stored in the JSON
        for profileID in profileNames {
            //Make a variable to hold the profile
            var currentProfile = fileManager.loadProfile(profileID: profileID)
            result.append("\(currentProfile.name) [Species: \(currentProfile.species)]")
        }
        
        return result
    }
    
}
