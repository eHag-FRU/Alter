//
//  SettingsViewController.swift
//  Alter
//
//  Created by Elliott Hager on 12/2/24.
//

import Foundation
import UIKit

class SettingsViewController : UITableViewController {
    
    //
    // Variables and constants
    //
    
    //holds the profile manager scene
    var kinPersonalityManagerScreenTest : KinPersonalityManagerViewController?
    //var journalEntryManagerScreenTest
    
    //
    // IBOutlets
    //
    @IBOutlet weak var DeleteAllProfilesButton: UIButton!
    @IBOutlet weak var DeleteAllJournalEntriesButton: UIButton!
    @IBOutlet weak var TextColorWell: UIColorWell!
    
    //
    // IBActions
    //
    @IBAction func DeleteAllProfilesButtonPressed(_ sender: UIButton) {
        kinPersonalityManagerScreenTest!.kinProfileDataSource.deleteAllProfiles()
    }
    
    @IBAction func DeleteAllJournalEntriesButtonPressed(_ sender: Any) {
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Grabing the kinPersonalityViewController instance
        if var kinPersonalityManagerScreen = tabBarController?.viewControllers![0] {
            kinPersonalityManagerScreenTest = (kinPersonalityManagerScreen as! KinPersonalityManagerViewController )
            
        }    }
}
