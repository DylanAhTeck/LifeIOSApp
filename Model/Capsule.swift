//
//  Capsule.swift
//  Life
//
//  Created by Dylan  Ah Teck on 12/10/19.
//  Copyright © 2019 Dylan  Ah Teck. All rights reserved.
//

import Foundation
import UIKit


/*
 Name: Dylan Ah Teck
 Email: ahteck@usc.edu
 */

/*
Capsule Model of Life App
Contains 6 variables, all stored as strings:
Title
Description
Mood (out of 5 possibilities)
Location (in human address format)
Date (in verbose format)
Image (image file name)

*/

struct Capsule  {
    
   var title: String
   var description: String
   var mood : String
   var image: String
   var location: String
   var date: String
  
    init(title: String, description: String, mood: String, image: String, location: String, date: String) {
      self.title = title
      self.description = description
        self.mood = mood
      self.image = image
        self.location = location
        self.date = date
    }
    
    
    func getTitle() -> String {
        return title
    }

    func getDescription() -> String {
           return description
    }
    
    func getMood() -> String {
           return mood
       }
    
    func getImage() -> String {
        return image
    }
    
    func getLocation() -> String {
        return location
    }
    
    func getDate() -> String {
        return date
    }
    
    //Returns actual UIImage when given the name of the image file
    func returnPhoto(imageName: String) -> UIImage? {
        let fileManager = FileManager.default
        let imagePath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(imageName)
        if fileManager.fileExists(atPath: imagePath){
            return UIImage(contentsOfFile: imagePath)
        }else{
            //Image does not exist
            return nil
        }
    }
}


/*
 Used for plist storage, can be used for later projects
 
 init?(dictionary: [String: String]) {
 guard
 let title = dictionary["Title"],
 let comment = dictionary["Comment"],
 let mood = dictionary["Mood"],
 let image = dictionary["Image"],
 let location = dictionary["Location"],
 let date = dictionary["Date"]
 else {
 return nil
 }
 
 self.init(title: title, comment: comment, mood: mood, image: image, location: location, date: date)
 }
 
 static func allCapsules() -> [Capsule] {
 var capsules: [Capsule] = []
 guard
 let URL = Bundle.main.url(forResource: "Capsules", withExtension: "plist"),
 let capsulesFromPlist = NSArray(contentsOf: URL) as? [[String: String]]
 else {
 return capsules
 }
 for dictionary in capsulesFromPlist {
 if let capsule = Capsule(dictionary: dictionary) {
 capsules.append(capsule)
 }
 }
 return capsules
 }
 
 */
