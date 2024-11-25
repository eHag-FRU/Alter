//
//  KinDetailsStructure.swift
//  Alter
//
//  Created by Elliott Hager on 11/24/24.
//

import Foundation


//
//  This holds the structure of the Kin/Personality Profile to be written and
//  read from a JSON object (the basis that the details will be saved in
//
struct KinDetailsStructure : Codable {
    var name: String
    var species: String
    //var awakenDate: String
    //var biography: String
    //var spirtualExperience: Bool
    //var physicalExperience: Bool
    //var psychologicalExperiences: Bool
    
    init(kinName: String, kinSpecies: String) {
        self.name = kinName
        self.species = kinSpecies
    }
}
