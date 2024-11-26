//
//  KinPersonalityManagerViewController.swift
//  Alter
//
//  Created by Guest User on 11/25/24.
//

import Foundation
import UIKit

class KinPersonalityManagerViewController : UIViewController{
    
    
    //
    //  Variables & Constants
    //
    
    
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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 4
    }
    
    //func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //return KinPersonalityCell
    //}
    
    //
    //  Function Overrides
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Attempt to decode the JSON file to struct
       let profileManager = KinFileManagerEncoderAndDecoder()
        let profileLOADTEST = profileManager.loadProfile(profileID: 1)
        
        print("\(profileLOADTEST.name): \(profileLOADTEST.species)")
    }
    
    
}
