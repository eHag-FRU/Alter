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
    
    
    //
    //  IBOutlets
    //
    @IBOutlet var KinPersonaltiyFormTableView: UITableView!
    @IBOutlet weak var KinPersonalitySpeciesTextField: UITextField!
    @IBOutlet weak var KinPersonalityName: UITextField!
    @IBOutlet weak var KinPersonalitySaveButton: UIButton!
    @IBOutlet weak var KinPersonalityCancelButton: UIButton!
    
    
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
    }
    
    
    
    //
    //  Objec functions
    //
    
    //Handles hiding the keyboard when tapping away from the textfield
    @objc func handleTapAwayFromTextField(_ sender: UITapGestureRecognizer) {
        KinPersonaltiyFormTableView.endEditing(true)
    }
    
    
    
    
}
