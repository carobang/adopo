//
//  CardCell.swift
//  finalproject
//
//  Created by kun peng on 2022-04-16.
//

import UIKit

class CardCell: UITableViewCell {

    @IBOutlet weak var cardView: UIView!
    
    @IBOutlet weak var pictureView: UIImageView!
    
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    // Set up the cell
    func configure(picture:UIImage, title:String, age:Int,gender:String,description:String){
        pictureView.image = picture
        titleLabel.text = "Name: \(title)"
        ageLabel.text = "Age: \(age)"
        genderLabel.text = "Gender: \(gender)"
        descriptionLabel.text = description
    }
}
