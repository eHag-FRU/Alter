//
//  KinFileManagerEncoderAndDecoder.swift
//  Alter
//
//  Created by Elliott Hager on 11/24/24.
//

import Foundation

class KinFileManagerEncoderAndDecoder {
    
    //Gives the kinJSONDirectory a temp directory until assigning in the init constructor
    var kinJSONDirectory : URL = FileManager.default.temporaryDirectory
    
    init() {
        //Grab the file directory for the documents directory
        //Then append the folder called kin, this will hold the kin JSON
        //profile information to read and write from
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .allDomainsMask).first else { return }
        
        self.kinJSONDirectory = documentsDirectory.appendingPathComponent("kinProfiles")

    }
    
    func encodeProfile() -> Void {
        
    }
    
    func decodeProfile() -> Void {
        
    }
    
    func saveToSystem() -> Void {
        
    }
    
    
    
}
