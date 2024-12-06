//
//  JournalEntryManagerViewController.swift
//  Alter
//
//  Created by Elliott Hager on 12/5/24.
//

import Foundation
import UIKit
class JournalEntryManagerViewController : UIViewController,
    UITableViewDelegate, UITableViewDataSource, JournalEntryTableCellDelegate {
    
    //
    //  Variables & Constants
    //
    
    //Holds the list of journal entries loaded
    var entries: [JournalEntryStructure] = []
    
    
    var journalEntryDataSource : JournalFileManagerEncoderAndDecoder = JournalFileManagerEncoderAndDecoder()
    
    var dataToEdit: JournalEntryStructure?
    
    
    //
    //  IBOutlets
    //
    @IBOutlet weak var newEntryButton: UIButton!
    @IBOutlet weak var jorunalEntryTable: UITableView!
    
    //
    // IBActions
    //
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        print("Getting the profile names and species of the profiles")
        print(KinFileManagerEncoderAndDecoder.getAllProfileNamesSpecies())
        
    }
    
    
    //
    // Functions
    //
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //Gets the number of profiles to indicate the number of cells there will be
        print(journalEntryDataSource.count())
        return journalEntryDataSource.count()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //Create the cell that was prototyped in the interface builder
        let cell = jorunalEntryTable.dequeueReusableCell(withIdentifier: "EntryCell", for: indexPath) as! JournalEntryTableCell
        
        //Catches to see if there are no profiles, if there are profiles, then
        //load them, if not, dont add text
        if (journalEntryDataSource.count() > 0) {
            //Configure the cells contents with each profile's details
            //cell.textLabel?.text = "\(profiles[indexPath.row].name): \(profiles[indexPath.row].species)"
            
            //Sets the labels text
            //cell.entryTitleLabel = "\(entries[indexPath.row].entryName)"
            
            //Set the index path to pass along the struct data
            //cell.indexPath = indexPath
            
            //Sets the delegate to self since it conforms
            //to a delegate
            //cell.tableCellDelegate = self
        }
        
        //dataToEdit = profiles[indexPath.row]
        
        
        
        
        
        return cell
        
    }
    
    func rowEditButtonTap(at indexPath: IndexPath) {
        
    }
}
