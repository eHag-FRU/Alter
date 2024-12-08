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
    @IBOutlet weak var journalEntryAddButton: UIButton!
    
    //
    // IBActions
    //
    
    @IBAction func journalEntryAddClicked(_ sender: UIButton) {
        //Clear the selected data since adding a new entry
        dataToEdit = nil
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
            //cell.textLabel?.text = "\(entries[indexPath.row].entryName)"
            
            //Sets the labels text
            cell.entryTitleLabel.text = "\(entries[indexPath.row].entryName)"
            
            //Set the index path to pass along the struct data
            cell.indexPath = indexPath
            
            //Sets the delegate to self since it conforms
            //to a delegate
            cell.tableCellDelegate = self
        }
        
        dataToEdit = entries[indexPath.row]
        
        
        
        
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath)
        
        //This ensures what data is being passed to the view matches the
        //row selected
        dataToEdit = entries[indexPath.row]
        //Seugues over to the profile view
        self.performSegue(withIdentifier: "entryManagerToView", sender: self)
    }
    
    
    func rowEditButtonTap(at indexPath: IndexPath) {
        print("Edit entry button tapped! :)")
        print("Rows entry name: \(entries[indexPath.row].entryName)")
        
        //setting the entry to edit to be the current one
        dataToEdit = entries[indexPath.row]
        
        //Perform the segue to the edit screen
        self.performSegue(withIdentifier: "entryManagerToAddEdit", sender: self)
    }
    
    
    func loadEntries() -> Void {
        //Grab each of the profile names
        let entryFileNames = journalEntryDataSource.entryNames()
        
        //Go through each of the profiles
        for entryName in entryFileNames {
            
            print(type(of: entryName))
            if (entryName > 0) {
                print("Currently loading entry number \(entryName)")
                
                //Grab and decode the profile
                let currentEntry = journalEntryDataSource.loadEntry(entryID: entryName)
                
                //Adds the profile to the list
                entries.append(currentEntry)
            }
        }
        
        print(entryFileNames)
    }
    
    
    
    
    //
    // Overriden Functions
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        print("Getting the profile names and species of the profiles")
        print(KinFileManagerEncoderAndDecoder.getAllProfileNamesSpecies())
        
        //Set the data source
        jorunalEntryTable.delegate = self
        jorunalEntryTable.dataSource = self
        
        //Set the custom data cell
        jorunalEntryTable.register(JournalEntryTableCell.self,
        forCellReuseIdentifier: "EntryCell")
        
        //Reload the entries array
        loadEntries()
        
        print("viewDidLoad entry count: \(entries.count)")
        
        //reload the table data
        jorunalEntryTable.reloadData()
            
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "entryManagerToAddEdit" {
            
            //Grabs the next segue
            let vc = segue.destination as? JournalEntryAddController
            
            //Sets the profileManager view controller instance
            vc?.journalEntryManager = self
            
            //Passes over the data to edit
            if let data = dataToEdit {
                vc?.selectedData = data
            }
        } else if segue.identifier == "entryManagerToView" {
            //View
            
            //Grabs the next segue
            let vc = segue.destination as? JournalEntryViewController
            
            //Sets the profileManager view controller instance
            //vc?.journalEntryManager = self
            
            //Passes over the data to edit
            vc?.selectedData = dataToEdit
        
            
            print("SELECTED CELL")
        }
    }
    
}
