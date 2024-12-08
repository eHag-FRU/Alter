//
//  JournalEntryViewController.swift
//  Alter
//
//  Created by Elliott Hager on 12/7/24.
//

import Foundation
import UIKit

class JournalEntryViewController: UITableViewController {
    //
    //  Variables and Constants
    //
    var selectedData: JournalEntryStructure?
    
    
    //
    //  IBOutlets
    //
    @IBOutlet weak var journalEntryTitle: UILabel!
    @IBOutlet weak var journalEntryKin: UILabel!
    @IBOutlet weak var journalEntryDate: UILabel!
    @IBOutlet weak var journalEntryPhysical: UILabel!
    @IBOutlet weak var journalEntryMental: UILabel!
    @IBOutlet weak var journalEntrySpiritual: UILabel!
    @IBOutlet weak var journalEntryText: UITextView!
    
    //
    //  IBActions
    //
    
    //
    //  Overriden functions
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Check if the data is not nil
        if ((selectedData) != nil) {
            print("Has Data")
            
            print(selectedData?.entryName)
            
            journalEntryTitle.text = selectedData?.entryName
            journalEntryDate.text = selectedData?.entryDate
            journalEntryText.text = selectedData?.entryText
            
            
            //Handle the switches
            journalEntryPhysical.text = selectedData?.physicalExperience
            journalEntryMental.text = selectedData?.mentalExperience
            journalEntrySpiritual.text = selectedData?.spiritualExperence
            
            journalEntryKin.text = selectedData?.kinName
        }
    }
    
}
