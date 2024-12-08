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
    
    var kinDataSource: [String] = []
    
    var selectedKin: String = ""
    
    //Make a flag to see if it found the kin profile
    var foundMenuItemMatch: Bool = false
    
    
    //
    // IBOutlets
    //
    @IBOutlet weak var EntryEditAddSaveButton: UIButton!
    @IBOutlet weak var EntryEditAddCancelButton: UIButton!
    @IBOutlet var EntryEditAddTableView: UITableView!
    
    //Done
    @IBOutlet weak var journalEntryTitle: UITextField!
    @IBOutlet weak var journalEntryKinPersonality: UIButton!
    @IBOutlet weak var journalEntryDate: UIDatePicker!
    @IBOutlet weak var journalEntryText: UITextView!
    @IBOutlet weak var journalEntryPhysical: UISwitch!
    @IBOutlet weak var journalEntrySpritual: UISwitch!
    @IBOutlet weak var journalEntryMental: UISwitch!
    
    //Need to implement
    
    @IBOutlet weak var kinPersonalityPicker: UIButton!
    
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
        //entryDetails["kinName"] = kinPersonalityPicker.menu?.selectedElements.title
        entryDetails["kinName"] = selectedKin
        
        
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
    // Functions
    //
    
    //Function to handle edits to set the kin name to the same one in the saved
    // entry
    func selectKinProfileByName(menu: UIMenu, kinName: String) -> UIAction? {
        //loop through the menu action items
        for action in menu.children {
            //Ensures the action is valid and then check if the title is
            //equal to the name
            if let action = action as? UIAction, action.title == kinName {
                //The name is equal to the menu items title, so now t
                return action
            }
        }
        
        return nil
    }
    
    
    
    //
    //  Overriden Functions
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Making valid date constraint to be up to the current day
        journalEntryDate.maximumDate = Date.now
        
        //Grab the personality names
        kinDataSource = KinFileManagerEncoderAndDecoder.getAllProfileNamesSpecies()
        
        //Set up the action handler
        let kinActionHandler = {(action: UIAction) in
            print(action.title)
            
            //Update the kin selected
            self.selectedKin = action.title
            
            //update the UIMenu to the selected element
        }
        
        //Now setup each of the menu options
        var menuChildren: [UIMenuElement] = []
        for item in kinDataSource {
            menuChildren.append(UIAction(title:item, state: .off, handler: kinActionHandler))
        }
        
        //Replace the children with the new list pulled from the file manager
        print(kinPersonalityPicker.titleLabel)
        
        //Add the menu to the button
        kinPersonalityPicker.menu = UIMenu(options: .displayInline, children: menuChildren)
        
        //Check if the data is not nil
        if ((selectedData) != nil) {
            print("Has Edit Data")
            
            print("Setting the edit mode flag in the journal filemanager")
            JournalFileManagerEncoderAndDecoder.setEditMode(mode: true)
            
            //Now fill in the data that the profile has
            journalEntryTitle.text = selectedData?.entryName
            journalEntryText.text = selectedData?.entryText
            //KinPersonalityBiography.text = selectedData?.biography
            
            //Set the date
            //Handle the string to NSDate for the date picker
            //Date string format
            let dateFormat = "MM/dd/yy"
            
            //Make a date formatter
            let dateFormater = DateFormatter()
            
            //Set the date formatters format string that was set above to match what is in the JSON object
            dateFormater.dateFormat = dateFormat
            
  
            //Grab the awaken date and force unwrap, there will always be
            //an awaken date, so we can safely force unwrap it
            let currentAwakenDate: String = selectedData!.entryDate
            
            //Now convert the date string to an NSDate
            let dateObject = dateFormater.date(from: currentAwakenDate)
            
            //Now set the date picker to the date
            journalEntryDate.date = dateObject!
            
            
            //Now handle the profile edit
            //Remake the children and update the menu
            //Now setup each of the menu options
            print("Selected Kin: \(selectedData!.kinName)")
            
            
            
            var menuChildren: [UIMenuElement] = []
            for item in kinDataSource {
                print("Items type: \(type(of: item))")
                
                //printing out the type of the selectedKin
                print("Selected kin type: \(type(of: selectedData!.kinName))")
                
                print("Seleted kin == item?: \(item == selectedData!.kinName)")
                
                if (item == selectedData!.kinName) {
                    print("FOUND A MATCH!!!")
                    menuChildren.append(UIAction(title:item, state: .on, handler: kinActionHandler))
                    
                    //Set the flag to indicate that the match was found
                    foundMenuItemMatch = true
                } else {
                    menuChildren.append(UIAction(title:item, state: .off, handler: kinActionHandler))
                }
                
            }
        
            //Replace the buttons menu with the new one
            kinPersonalityPicker.menu = UIMenu(options: .displayInline, children: menuChildren)
            
            
        } else {
            //Set the edit mode to false to allow for the adding of a new profile
            JournalFileManagerEncoderAndDecoder.setEditMode(mode: false)
            
            //Now clear the data selected
            selectedData = nil
        }
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        //Now if it did not find it, alert the user
        //Ensures that there is selectedData for editing
        if (!foundMenuItemMatch && (selectedData) != nil) {
            print("ALERTING THE USER THE PROFILE COULD NOT BE FOUND AND THE DEFAULT PROFILE IS BEING USED")
            
            let alert = UIAlertController(title: "Could not find Kin", message: "The Personality/Kin profile this entry uses could not be found. This can be caused by an update to the profiles name or species. The default kin/personality has been selected. Please review this selection and change it to the apropriate kin/personality for this entry", preferredStyle: .alert)
            
            //Make the okay button
            let okayButton = UIAlertAction(title: "Ok", style: .default)
            
            //Add the button to the alert
            alert.addAction(okayButton)
            
            //Now display the alert
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        if let entryM = journalEntryManager {
            
            //print("VIEW APPEARING!!!")
            
            //Clear the profiles present
            entryM.entries.removeAll(keepingCapacity: false)
            
            //Reload the array
            entryM.loadEntries()
            
            //print("viewWillAppear profile count: \(entryM.profiles.count)")
            
            //reload the table data
            entryM.jorunalEntryTable.reloadData()
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
