//
//  KinPersonalityProfileViewController.swift
//  Alter
//
//  Created by Elliott Hager on 11/24/24.
//

import UIKit
import Foundation

class KinPersonalityProfileViewController : UITableViewController {
    //
    //  Variables and Constants
    //
    var selectedData: KinDetailsStructure?
    
    
    //
    //  IBOutlets
    //
    
    @IBOutlet weak var kinName: UILabel!
    @IBOutlet weak var kinSpecies: UILabel!
    @IBOutlet weak var kinAwakenDate: UILabel!
    @IBOutlet weak var kinBiography: UITextView!
    @IBOutlet weak var kinMental: UILabel!
    @IBOutlet weak var kinPhysical: UILabel!
    @IBOutlet weak var kinSpiritual: UILabel!
    @IBOutlet weak var kinBio: UITextView!
    
    //
    //  IBActions
    //
    
    
    
    
    //
    //  Overriden functions
    //
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Making valid date constraint to be up to the current day
        //KinPersonalityAwakenDatePicker.maximumDate = Date.now
        
        //Check if the data is not nil
        if ((selectedData) != nil) {
            print("Has Data")
            
            print(selectedData?.name)
            
            //Set the label data to view
            kinName.text = selectedData?.name
            kinSpecies.text = selectedData?.species
            kinAwakenDate.text = selectedData?.awakenDate
            kinMental.text = selectedData?.psychologicalExperiences
            kinPhysical.text = selectedData?.physicalExperience
            kinSpiritual.text = selectedData?.spirtualExperience
            kinBio.text = selectedData?.biography
            
        }
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        //Empty the selected data
        selectedData = nil
        
    }
    
    
    
    //
    //  Objec functions
    //
    
    
    
    
    
    
}
