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
            
            print(selectedData?.awakenDate)
        }
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
    }
    
    
    
    //
    //  Objec functions
    //
    
    
    
    
    
    
}
