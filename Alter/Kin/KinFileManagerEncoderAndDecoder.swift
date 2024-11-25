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
    private static var profileID : Int = 1
    
    private let fileManager = FileManager.default
    
    
    //Will be used to determine if in edit mode when encoding and writing to
    //the file system
    private let editMode = false
    
    init() {
        //Grab the file directory for the documents directory
        //Then append the folder called kin, this will hold the kin JSON
        //profile information to read and write from
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .allDomainsMask).first else { return }
        
        self.kinJSONDirectory = documentsDirectory.appendingPathComponent("kinProfiles")

        //Now check if the directory exists, on first run it will not
        //So will only create if it does NOT exist
        var isDirectory: ObjCBool = true
        if (!FileManager.default.fileExists(atPath: self.kinJSONDirectory.absoluteString, isDirectory: &isDirectory)) {
            //Directory does not exist, so create it!
            try! fileManager.createDirectory(at: kinJSONDirectory, withIntermediateDirectories: true, attributes: nil)
        }
        
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
    
    private func decodeProfile() -> Void {
        
    }
    
    public func saveProfile(profileDetails: Dictionary<String, String>) -> Void {
        //To save to the system we want to do the following
        // 1. Encode for JSON format based on the Struct made
        // 2. Write to a file titled with the name of the profile_species_id
        // 3. Save file to the kinJSONDirectory for the app
        
        /* TESTING: NEED TO MAKE FOR ALL FIELDS */
        let currentProfile = KinDetailsStructure(
            kinName: profileDetails["kinName"]!,
            kinSpecies: profileDetails["kinSpecies"]!
        )
        
        //Now encode it
        let profileContentToWriteToFile = encodeProfile(profile: currentProfile)
        
        print("NOW CREATING FILE!!")
        
        var fileName = String()
        
        //Determine if in edit mode
        if (!editMode) {
            //Now generate the file name
             fileName = kinJSONDirectory.absoluteString + "/\(profileDetails["kinName"]!)_\(KinFileManagerEncoderAndDecoder.profileID).json"
            
            
            //Update the ID so the next profile is valid
            KinFileManagerEncoderAndDecoder.profileID += 1
        }
        
        //Now write it into the file
        let successfulCreation = fileManager.createFile(atPath: fileName,
                               contents: profileContentToWriteToFile)
        
        print("Created file \(fileName)?: \(successfulCreation)")
        
    }
    
    
    
}
