//
//  DetailViewController.swift
//  Life
//
//  Created by Dylan  Ah Teck on 12/11/19.
//  Copyright © 2019 Dylan  Ah Teck. All rights reserved.
//

import UIKit

/*
 Name: Dylan Ah Teck
 Email: ahteck@usc.edu
 */

/*
 Description:
 DetailViewController manages the view the user gets when they
 select a memory capsule either on Home or Search page.
 Users can:
 - Appreciate their memory
 - Contains title, description, image, mood, location and date
 */

class DetailViewController: UIViewController {
    var capsule : Capsule?
    
    //Outlet for all the labels
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var moodLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    //Assigns outlets accordingly
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = capsule?.getTitle()
        descriptionLabel.text = capsule?.getDescription()
        
        
        if let photo = capsule?.getImage()
        {
            var image = capsule?.returnPhoto(imageName: photo)
            
        //For purpose of demo only, use image in assets in some cases
        if (image == nil) {image = UIImage(named: photo)}
            imageView.image = image
        }
        
        dateLabel.text = capsule?.getDate()
        
       
        locationLabel.text = capsule?.getLocation()
        moodLabel.text = "\(capsule?.getMood() ?? "")"

    }
    
    
}
