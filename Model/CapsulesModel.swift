//
//  CapsulesModel.swift
//  AhTeckDylanHW5
//
//  Created by Dylan  Ah Teck on 10/20/19.
//  Copyright © 2019 Dylan  Ah Teck. All rights reserved.
//

import Foundation
import GoogleMaps
import UIKit

/*
 Name: Dylan Ah Teck
 Email: ahteck@usc.edu
 */

/*
 Capsule Model of Life App
 - Contains array of capsules that is shared via singleton
 - Implements persistent storage through plists
 - Contains delete, insert, count, etc functions to provide API
 - Has a save function to commit data to device memory
 */

class CapsulesModel: NSObject {
    
    var capsules = [Capsule]()
    //var capsules = Capsule.allCapsules()
    
    //Singleton
    public static let shared = CapsulesModel()
  
    // properties/instance variable
    var filepath:String
    
    override init()
    {
        
       filepath = ""
        
          // find the Documents directory
                let manager = FileManager.default
                filepath = ""
                if let url = manager.urls(for: .documentDirectory,
                                          in: .userDomainMask).first {
                    filepath = url.appendingPathComponent("Capsules.plist").path
                    //print("filepath=\(filepath)")
                         
        }
        super.init()
        
        //Persistent Storage Implementation: 
        //read from plist file if it exists
        if manager.fileExists(atPath: filepath){
            if let capsulesArray = NSArray(contentsOfFile: filepath){
                for dict in capsulesArray {
                    //converting from NSString to String
                    
                    let capsuleDict = dict as! [String: String]
                    if let title = capsuleDict["titleKey"], let description = capsuleDict["descriptionKey"], let mood = capsuleDict["moodKey"],
                        let date = capsuleDict["dateKey"], let location  = capsuleDict["locationKey"], let image = capsuleDict["imageKey"] {
                        
        
                        let capsule = Capsule(title: title, description: description, mood: mood, image: image, location: location, date: date)
                        capsules.append(capsule)
                    }
                    
                    
                }
            }
            
        }
        else {
            let capsule1 = Capsule(title: "Fire Pit", description: "Fun day", mood: "Happy", image: "fire", location: "Tahoe Lake", date: "25th Dec")
            let capsule2 = Capsule(title: "Lake", description: "Two mates having fun", mood: "Relaxed", image: "lads", location: "River", date: "26th Dec")
            let capsule3 = Capsule(title: "Tree", description: "Beautiful Tree", mood: "Excited", image: "tree", location: "Next to tree", date: "27th Dec")
            
            capsules.append(capsule1)
            capsules.append(capsule2)
            capsules.append(capsule3)
        }
    
    }
    
    func removeCapsule(at index: Int){
        
        //Removes image from document
        let imageName = capsules[index].getImage()
            let fileManager = FileManager.default
            let imagePath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(imageName)
            if fileManager.fileExists(atPath: imagePath){
                do {
                    try fileManager.removeItem(atPath: imagePath)
                }
                catch {
                    print("Error")
                }
            }
        
        capsules.remove(at: index)
        save()
    }

    // Returns number of capsules
    func numberOfCapsules() -> Int{
        return capsules.count
    }

    // Creates a new memory capsule
    func insert(title: String, description: String, mood: String, image: String, location: String, date: String){

        let capsule = Capsule(title: title, description: description, mood: mood, image: image, location: location, date: date)
        capsules.append(capsule)
        save()
    }

//    Save the array of capsules to a plist in the
//    Documents folder
    
   func save() {
        //An array of dictionary objects where the key are Strings and the values are Strings
        var capsulesArray = [[String:String]]()

        (capsulesArray as NSArray).write(toFile: filepath, atomically: true)

        for capsule in capsules{
            let dict = ["titleKey": capsule.getTitle(),
                        "descriptionKey": capsule.getDescription(),
                        "moodKey": capsule.getMood(),
                        "imageKey": capsule.getImage(),
                        "locationKey": capsule.getLocation(),
                        "dateKey": capsule.getDate()
                        ]

            capsulesArray.append(dict)
        }
        (capsulesArray as NSArray).write(toFile: filepath, atomically: true)
    }
    
 
}

