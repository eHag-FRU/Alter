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
    
    //
    //  IBOutlets
    //
    @IBOutlet weak var KinPersonalityTable: UITableView!
    
    
    //
    //  IBActions
    //
    
    
    
    //
    //  Functions
    //
    func loadProfiles() -> Void {
        //Grab the count of the profiles
        let profileCount = kinProfileDataSource.count()
        
        //Grab each of the profile names
        let profileFileNames = kinProfileDataSource.profileNames()
        
        //Go through each of the profiles
        for profileName in profileFileNames {
            if (profileName > 0) {
                //Grab and decode the profile
                let currentProfile = kinProfileDataSource.loadProfile(profileID: profileName)
                
                //Adds the profile to the list
                profiles.append(currentProfile)
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //Gets the number of profiles to indicate the number of cells there will be
        return kinProfileDataSource.count()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //Create the cell that was prototyped in the interface builder
        let cell = KinPersonalityTable.dequeueReusableCell(withIdentifier: "kinPersonalityProfileCell", for: indexPath)
        
        
        //Configure the cells contents with each profile's details
        cell.textLabel?.text = profiles[indexPath.row].name
        
        return cell
        
    }
    
    //
    //  Function Overrides
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        //Set the datasource
        KinPersonalityTable.delegate = self
        KinPersonalityTable.dataSource = self
        loadProfiles()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print("VIEW APPEARING!!!")
        
        //Clear the profiles present
        profiles.removeAll(keepingCapacity: false)
        
        //Reload the array
        loadProfiles()
        
        print("viewWillAppear profile count: \(profiles.count)")
        
        //reload the table data
        KinPersonalityTable.reloadData()
    }
    
    
    
}
