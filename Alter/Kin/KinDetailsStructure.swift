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
    var awakenDate: String
    var biography: String
    var spirtualExperience: String
    var physicalExperience: String
    var psychologicalExperiences: String
    var profileID: Int
    
    init(kinName: String, kinSpecies: String, kinAwakenDate: String, kinMental: String, kinPhysical: String, kinSpiritual: String, kinBio: String, profileID: Int) {
        self.name = kinName
        self.species = kinSpecies
        self.awakenDate = kinAwakenDate
        self.biography = kinBio
        self.psychologicalExperiences = kinMental
        self.physicalExperience = kinPhysical
        self.spirtualExperience = kinSpiritual
        self.profileID = profileID
    }
}
