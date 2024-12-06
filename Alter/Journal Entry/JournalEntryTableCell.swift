//
//  JournalEntryTableCell.swift
//  Alter
//
//  Created by Guest User on 12/6/24.
//

import Foundation
import UIKit

//This defines a custom table cell protocol to allow for edit button
//taps register for the individual rows so the proper data can be funneled
//to the view
protocol JournalEntryTableCellDelegate : AnyObject {
    
    //function to handle the button taps
    func rowEditButtonTap(at indexPath: IndexPath)
}


//The custom table cell
class JournalEntryTableCell: UITableViewCell {
    //Grab the delegate to allow for the button tap function to be used
    weak var tableCellDelegate: JournalEntryTableCellDelegate?
    
    //Now make the edit button
    let entryEditButton = UIButton()
    
    //Now make the label
    let entryTitleLabel = UILabel()
    
    //Hold the profile label text
    var entryTitleLabelText : String? {
        didSet{
            //Will update the label text to match
            entryTitleLabel.text = entryTitleLabelText
        }
    }
    
    //setting the indexpath
    var indexPath: IndexPath?
    
    //Init the cell
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        //Set the pencil icon on the
        entryEditButton.setImage(UIImage(systemName: "pencil"), for: .normal)
        
        //Setting the button action
        entryEditButton.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
        
        //Add the button to the cells view
        contentView.addSubview(entryEditButton)
        contentView.addSubview(entryTitleLabel)
        
        //Set autolayout on both elements to be false to specify the position
        //manually
        entryTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        entryEditButton.translatesAutoresizingMaskIntoConstraints = false
        
        //Setting the anchors of each element
        NSLayoutConstraint.activate([
            
            entryTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            entryTitleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
                    
                    entryEditButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
                    entryEditButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
                ])
    }
    
    
    
    //The objective-c tap method to pick up the button taps
    @objc
    func editButtonTapped() {
        if let indexPath = indexPath {
            tableCellDelegate?.rowEditButtonTap(at: indexPath)
        }
    }
    
    
    
    //Required initalizer
    required init?(coder: NSCoder)  {
        //Fatially error out since the NSCoder is required to conform to
        fatalError()
    }
    
    
}

