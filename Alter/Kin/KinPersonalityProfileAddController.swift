//
//  KinPersonalityProfileAddController.swift
//  Alter
//
//  Created by Elliott Hager on 11/24/24.
//

import UIKit
import Foundation

class KinPersonalityProfileAddController : UITableViewController {
    //
    //  Variables and Constants
    //
    var profileManager : KinPersonalityManagerViewController?
    
    var selectedData: KinDetailsStructure?
    
    
    //
    //  IBOutlets
    //
    @IBOutlet var KinPersonaltiyFormTableView: UITableView!
    @IBOutlet weak var KinPersonalitySpeciesTextField: UITextField!
    @IBOutlet weak var KinPersonalityName: UITextField!
    @IBOutlet weak var KinPersonalitySaveButton: UIButton!
    @IBOutlet weak var KinPersonalityCancelButton: UIButton!
    @IBOutlet weak var KinPersonalityAwakenDatePicker: UIDatePicker!
    @IBOutlet weak var KinPersonalityBiography: UITextView!
    @IBOutlet weak var kinMental: UISwitch!
    @IBOutlet weak var kinPhysical: UISwitch!
    @IBOutlet weak var kinSpiritual: UISwitch!
    
    
    //
    //  IBActions
    //
    
    @IBAction func KinPersonalityButtonSavePressed(_ sender: UIButton) {
        //Now Save is pressed, we want to encode all of the form contents
        let addSaver: KinFileManagerEncoderAndDecoder = KinFileManagerEncoderAndDecoder()
        
        //Make a dictonary of the forms values to encode
        var profileDetails : Dictionary<String, String> = Dictionary()
        
        //Pull each control and save into the dictonary
        profileDetails["kinName"] = KinPersonalityName.text
        profileDetails["kinSpecies"] = KinPersonalitySpeciesTextField.text
        
        //Convert the T/F value to Yes or No
        if (kinMental.isOn) {
            //True
            profileDetails["kinMental"] = "Yes"
        } else {
            //No
            profileDetails["kinMental"] = "No"
        }
        
        //Convert the T/F value to Yes or No
        if (kinPhysical.isOn) {
            //True
            profileDetails["kinPhysical"] = "Yes"
        } else {
            //No
            profileDetails["kinPhysical"] = "No"
        }
        
        //Convert the T/F value to Yes or No
        if (kinPhysical.isOn) {
            //True
            profileDetails["kinPhysical"] = "Yes"
        } else {
            //No
            profileDetails["kinPhysical"] = "No"
        }
        
        //Convert the T/F value to Yes or No
        if (kinSpiritual.isOn) {
            //True
            profileDetails["kinSpiritual"] = "Yes"
        } else {
            //No
            profileDetails["kinSpiritual"] = "No"
        }
        
        profileDetails["kinBio"] = KinPersonalityBiography.text
        
        //Code from:
        //https:\/\/stackoverflow
        //.com/questions/26667618/how-to-get-data-from-uidatepicker-swift
        //Grab the Date
        let timeFormatter = DateFormatter()
            timeFormatter.dateStyle = DateFormatter.Style.short

        let strDate = timeFormatter.string(from: KinPersonalityAwakenDatePicker.date)
        //
        //  End code from StackOverFlow
        //

        //Add the date to the profileDetails dictonary
        profileDetails["kinAwakenDate"] = strDate
        
        //Now encode the text from the form
        addSaver.saveProfile(profileDetails: profileDetails)
        
        //Now dismiss it after the save
        dismiss(animated: true)
        
    }
    
    
    @IBAction func KinPersonalityCancelButtonPressed(_ sender: UIButton) {
        
        //Dismiss the modal to bring back to the view that is the
        //list of kin/personalities
        dismiss(animated: true)
    }
    
    
    
    //
    //  Overriden functions
    //
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Making valid date constraint to be up to the current day
        KinPersonalityAwakenDatePicker.maximumDate = Date.now
        
        //Check if the data is not nil
        if ((selectedData) != nil) {
            print("Has Edit Data")
            
            //Now fill in the data that the profile has
            KinPersonalityName.text = selectedData?.name
            KinPersonalitySpeciesTextField.text = selectedData?.species
            KinPersonalityBiography.text = selectedData?.biography
            
            //Handle the toggle switches
            if(selectedData?.psychologicalExperiences == "Yes") {
                kinMental.setOn(true, animated: true)
            } else {
                kinMental.setOn(false, animated: true)
            }
            
            if(selectedData?.spirtualExperience == "Yes") {
                kinSpiritual.setOn(true, animated: true)
            } else {
                kinMental.setOn(false, animated: true)
            }
            
            if(selectedData?.physicalExperience == "Yes") {
                kinPhysical.setOn(true, animated: true)
            } else{
                kinPhysical.setOn(false, animated: true)
            }
            
            
            //Handle the string to NSDate for the date picker
            //Date string format
            let dateFormat = "mm/dd/yy"
            
            //Make a date formatter
            let dateFormater = DateFormatter()
            
            //Set the date formatters format string that was set above to match what is in the JSON object
            dateFormater.dateFormat = dateFormat
            
            //Now convert the date string to an NSDate
            let dateObject = dateFormater.date(from: dateFormat)
            
            print("Date Object:  \(String(describing: dateObject))")
            
        }
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        if let profileM = profileManager {
            
            //print("VIEW APPEARING!!!")
            
            //Clear the profiles present
            profileM.profiles.removeAll(keepingCapacity: false)
            
            //Reload the array
            profileM.loadProfiles()
            
            print("viewWillAppear profile count: \(profileM.profiles.count)")
            
            //reload the table data
            profileM.KinPersonalityTable.reloadData()
        }
    }
    
    
    
    //
    //  Objec functions
    //
    
    //Handles hiding the keyboard when tapping away from the textfield
    @objc func handleTapAwayFromTextField(_ sender: UITapGestureRecognizer) {
        KinPersonaltiyFormTableView.endEditing(true)
    }
    
    
    
    
}
