//
//  AnnotatedCapsuleCell.swift
//  Life
//
//  Created by Dylan  Ah Teck on 12/10/19.
//  Copyright © 2019 Dylan  Ah Teck. All rights reserved.
//

/*
 Name: Dylan Ah Teck
 Email: ahteck@usc.edu
 */

import UIKit

class AnnotatedCapsuleCell: UICollectionViewCell {
   
        
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
            super.awakeFromNib()
            containerView.layer.cornerRadius = 5
            containerView.layer.masksToBounds = true
        }
        
        var capsule: Capsule? {
            didSet {
                if let capsule = capsule  {
                    
                    titleLabel.text = capsule.title
                    descriptionLabel.text = capsule.description
                    let photo = capsule.image
                    
                        var image = capsule.returnPhoto(imageName: photo)
                        //For purpose of demo, use image in assets in some cases
                        if (image == nil) {image = UIImage(named: photo)}
                        
                        imageView.image = image
                    
                }
            }
        }

}
