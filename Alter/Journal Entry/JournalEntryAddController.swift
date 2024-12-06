//
//  JournalEntryAddController.swift
//  Alter
//
//  Created by Guest User on 12/6/24.
//

import Foundation
import UIKit

class JournalEntryAddController : UITableViewController {
    //
    //  Variables and Constants
    //
    var journalEntryManager : JournalEntryManagerViewController?
    
    var selectedData: JournalEntryStructure?
    
    var inEditMode: Bool = false
    
    
    //
    // IBOutlets
    //
    @IBOutlet weak var EntryEditAddSaveButton: UIButton!
    @IBOutlet weak var EntryEditAddCancelButton: UIButton!
    @IBOutlet var EntryEditAddTableView: UITableView!
    
    //Done
    @IBOutlet weak var journalEntryTitle: UITextField!
    
    //Still need to implement
    @IBOutlet weak var journalEntryKinPersonality: UIButton!
    @IBOutlet weak var journalEntryDate: UIDatePicker!
    @IBOutlet weak var journalEntryText: UITextView!
    @IBOutlet weak var journalEntryPhysical: UISwitch!
    @IBOutlet weak var journalEntrySpritual: UISwitch!
    @IBOutlet weak var journalEntryMental: UISwitch!
    
    
    //
    // IBActions
    //
    
    @IBAction func EntryEditAddSaveButtonClicked(_ sender: Any) {
        //Now Save is pressed, we want to encode all of the form contents
        let addSaver: JournalFileManagerEncoderAndDecoder = JournalFileManagerEncoderAndDecoder()
        
        //Make a dictonary of the forms values to encode
        var entryDetails : Dictionary<String, String> = Dictionary()
        
        //Pull each control and save into the dictonary
        entryDetails["entryName"] = journalEntryTitle.text
        entryDetails["entryText"] = journalEntryText.text
        
        
        //Handle the toggle switches
        if(journalEntryMental.isOn) {
            entryDetails["mentalExperience"] = "Yes"
        } else {
            entryDetails["mentalExperience"] = "No"
        }
        
        if(journalEntryPhysical.isOn) {
            entryDetails["physicalExperience"] = "Yes"
        } else {
            entryDetails["physicalExperience"] = "No"
        }
        
        if(journalEntrySpritual.isOn) {
            entryDetails["spiritualExperence"] = "Yes"
        } else {
            entryDetails["spiritualExperence"] = "No"
        }
        
        //Code from:
        //https:\/\/stackoverflow
        //.com/questions/26667618/how-to-get-data-from-uidatepicker-swift
        //Grab the Date
        let timeFormatter = DateFormatter()
            timeFormatter.dateStyle = DateFormatter.Style.short

        let strDate = timeFormatter.string(from: journalEntryDate.date)
        //
        //  End code from StackOverFlow
        //
        entryDetails["entryDate"] = strDate
        
        //Now check if in edit mode, if so, set
        //the profile details profileID to the
        //same profile id found in the file
        print("Current edit mode: \(JournalFileManagerEncoderAndDecoder.editMode)")
        if (JournalFileManagerEncoderAndDecoder.editMode) {
            print("Getting the current profiles profile ID to allow for edits to take place")
            print(selectedData?.entryID)
            entryDetails["entryID"] = selectedData!.entryID
        }
        
        //Now encode the text from the form
        addSaver.saveEntry(entryDetails: entryDetails)
        
        //Now dismiss it after the save
        dismiss(animated: true)
    }
    
    
    @IBAction func EntryEditAddCancelButtonClicked(_ sender: UIButton) {
        //Dismiss the modal to bring back to the view that is the
        //list of journal entries
        dismiss(animated: true)
    }
    
    
    //
    //  Overriden Functions
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Making valid date constraint to be up to the current day
        journalEntryDate.maximumDate = Date.now
        
        //Check if the data is not nil
        if ((selectedData) != nil) {
            print("Has Edit Data")
            
            print("Setting the edit mode flag in the kin filemanager")
            JournalFileManagerEncoderAndDecoder.setEditMode(mode: true)
            
            //Now fill in the data that the profile has
            journalEntryTitle.text = selectedData?.entryName
            journalEntryText.text = selectedData?.entryText
            KinPersonalityBiography.text = selectedData?.biography
        }
    }
    
    
    
    
    override func viewDidDisappear(_ animated: Bool) {
        if let entryM = journalEntryManager {
            
            //print("VIEW APPEARING!!!")
            
            //Clear the profiles present
            //entryM.profiles.removeAll(keepingCapacity: false)
            
            //Reload the array
            //entryM.loadProfiles()
            
            //print("viewWillAppear profile count: \(entryM.profiles.count)")
            
            //reload the table data
            //entryM.journalEntryTable.reloadData()
        }
    }
    
    
    //
    // Objective-C Functions
    //
    //Handles hiding the keyboard when tapping away from the textfield
    @objc func handleTapAwayFromTextField(_ sender: UITapGestureRecognizer) {
        EntryEditAddTableView.endEditing(true)
    }
    
}
