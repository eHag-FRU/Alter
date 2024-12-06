//
//  KinPersonalityManagerViewController.swift
//  Alter
//
//  Created by Guest User on 11/25/24.
//

import Foundation
import UIKit

class KinPersonalityManagerViewController : UIViewController, UITableViewDelegate,
                                            UITableViewDataSource {
    
    
    //Holds the list of profiles loaded
    var profiles: [KinDetailsStructure] = []
    
    
    
    //
    //  Variables & Constants
    //
    var kinProfileDataSource : KinFileManagerEncoderAndDecoder = KinFileManagerEncoderAndDecoder()
    
    var dataToEdit: KinDetailsStructure?
    
    @IBOutlet weak var EditButton: UIButton!
    
    
    //
    //  IBOutlets
    //
    @IBOutlet weak var KinPersonalityTable: UITableView!
    
    
    //
    //  IBActions
    //
    
    @IBAction func EditButtonTap(_ sender: Any) {
        
        KinPersonalityTable.setEditing(!KinPersonalityTable.isEditing, animated: true)
        
        self.performSegue(withIdentifier: "profileManagerToAddEdit", sender: self)
        
    }
    
    
    //
    //  Functions
    //
    func loadProfiles() -> Void {
        //Grab the count of the profiles
        let profileCount = kinProfileDataSource.count()
        
        //Grab each of the profile names
        var profileFileNames = kinProfileDataSource.profileNames()
        
        //Remove the .DS_Store element that Macs add automatically
        //var profileNames = tempProfiles.filter {$0.contains(".DS_Store")}
        
        //Go through each of the profiles
        for profileName in profileFileNames {
            
            print(type(of: profileName))
            if (profileName > 0) {
                print("Currently loading profile number \(profileName)")
                
                //Grab and decode the profile
                let currentProfile = kinProfileDataSource.loadProfile(profileID: profileName)
                
                //Adds the profile to the list
                profiles.append(currentProfile)
            }
        }
        
        
        print(profileFileNames)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //Gets the number of profiles to indicate the number of cells there will be
        print(kinProfileDataSource.count())
        return kinProfileDataSource.count()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //Create the cell that was prototyped in the interface builder
        let cell = KinPersonalityTable.dequeueReusableCell(withIdentifier: "kinPersonalityProfileCell", for: indexPath)
        
        //Catches to see if there are no profiles, if there are profiles, then
        //load them, if not, dont add text
        if (kinProfileDataSource.count() > 0) {
            //Configure the cells contents with each profile's details
            cell.textLabel?.text = profiles[indexPath.row].name
        }
        
        dataToEdit = profiles[indexPath.row]
        
        
        
        
        
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Seugues over to the profile view
        self.performSegue(withIdentifier: "ViewProfileEntry", sender: self)
    }
    
    //
    //  Function Overrides
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        //Set the datasource
        KinPersonalityTable.delegate = self
        KinPersonalityTable.dataSource = self
        
        
        //Reload the array
        loadProfiles()
        
        print("viewWillAppear profile count: \(profiles.count)")
        
        //reload the table data
        KinPersonalityTable.reloadData()
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "profileManagerToAddEdit" {
            
            //Grabs the next segue
            let vc = segue.destination as? KinPersonalityProfileAddController
            
            //Sets the profileManager view controller instance
            vc?.profileManager = self
            
            //Passes over the data to edit
            if let data = dataToEdit {
                vc?.selectedData = data
            }
        } else if segue.identifier == "ViewProfileEntry" {
            //View
            
            //Grabs the next segue
            let vc = segue.destination as? KinPersonalityProfileViewController
            
            //Sets the profileManager view controller instance
            //vc?.profileManager = self
            
            //Passes over the data to edit
            vc?.selectedData = dataToEdit
        
            
            print("SELECTED CELL")
        }
    }
}
