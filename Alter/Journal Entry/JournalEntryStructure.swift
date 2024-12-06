//
//  JournalEntryStructure.swift
//  Alter
//
//  Created by Elliott Hager on 12/2/24.
//

import Foundation

//
//  This holds the structure of the Journal Entry to be written and
//  read from a JSON object (the basis that the details will be saved in
//
struct JournalEntryStructure : Codable {
    var entryName: String
    //var entryDate: String
    //var kinName: String
    //var entryInfo: String
    //var mentalExperience: String
    //var physicalExperience: String
    //var spiritualExperence: String
    
    //init(entryName: String, entryDate: String, kinName: String, entryInfo: String, mentalExperience: String, physicalExperience: String, spiritualExperence: String) {
        //self.entryName = entryName
        //self.entryDate = entryDate
        //self.kinName = kinName
        //self.entryInfo = entryInfo
        //self.mentalExperience = mentalExperience
        //self.physicalExperience = physicalExperience
        //self.spiritualExperence = spiritualExperence
    //}
    
    init(entryName: String) {
        self.entryName = entryName
    }
}
