//
//  ProfileTableCell.swift
//  Alter
//
//  Created by Elliott Hager on 12/5/24.
//

import Foundation
import UIKit

//This defines a custom table cell protocol to allow for edit button
//taps register for the individual rows so the proper data can be funneled
//to the view
protocol ProfileTableCellDelegate : AnyObject {
    
    //function to handle the button taps
    func rowEditButtonTap(at indexPath: IndexPath)
}


//The custom table cell
class ProfileTableCell: UITableViewCell {
    //Grab the delegate to allow for the button tap function to be used
    weak var tableCellDelegate: ProfileTableCellDelegate?
    
    //Now make the edit button
    let profileEditButton = UIButton()
    
    //Now make the label
    let profileNameSpeciesLabel = UILabel()
    
    //Hold the profile label text
    var profileNameSpeicesLabelText : String? {
        didSet{
            //Will update the label text to match
            profileNameSpeciesLabel.text = profileNameSpeicesLabelText
        }
    }
    
    //setting the indexpath
    var indexPath: IndexPath?
    
    //Init the cell
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        //Set the pencil icon on the
        profileEditButton.setImage(UIImage(systemName: "pencil"), for: .normal)
        
        //Setting the button action
        profileEditButton.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
        
        //Add the button to the cells view
        contentView.addSubview(profileEditButton)
        contentView.addSubview(profileNameSpeciesLabel)
        
        //Set autolayout on both elements to be false to specify the position
        //manually
        profileNameSpeciesLabel.translatesAutoresizingMaskIntoConstraints = false
        profileEditButton.translatesAutoresizingMaskIntoConstraints = false
        
        //Setting the anchors of each element
        NSLayoutConstraint.activate([
            
                    profileNameSpeciesLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
                    profileNameSpeciesLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
                    
                    profileEditButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
                    profileEditButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
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
