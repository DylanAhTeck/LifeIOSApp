//
//  SearchViewController.swift
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
 This ViewController manages the Life's search functionality
 Users can:
    - Search for a Memory Capsule by Title, Description, Mood, Location or Date
    - Delete a Memory Capsule
 */
class SearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate{
    
 
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var model = CapsulesModel.shared
    let searchController = UISearchController(searchResultsController: nil)
    
    //Need two capsule arrays: one for all and another for filtered results
    var capsules : [Capsule] = []
    var filteredCapsules: [Capsule] = []
    
    //Bool to keep track of whether user is searching
    var searching = false
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let image = UIImageView(image: UIImage(named: "life_nav"))
        let item = UIBarButtonItem(customView: image)
        self.navigationItem.leftBarButtonItem = item
        
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        capsules = model.capsules
    }
    
    override func viewWillAppear(_ animated: Bool) {
        capsules = model.capsules
        super.viewWillAppear(animated)
        self.tableView?.reloadData()
        if let index = self.tableView.indexPathForSelectedRow{
            self.tableView.deselectRow(at: index, animated: true)
        }
    }
     
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
  
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching {
            return filteredCapsules.count
        }
        else {
        return model.numberOfCapsules()
        }
    }
    
    //Delete functionality
    
    // Override to support editing the table view.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            // Delete the row from the data source (i.e., model)
            model.removeCapsule(at: indexPath.row)
            
            // Delete from tableview
            tableView.deleteRows(at: [indexPath], with: .fade)
            
        }
    }
    
  
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath as IndexPath)
        
        //If user is using search bar, only return filtered results
        if searching
        {
            cell.textLabel?.text = filteredCapsules[indexPath.row].getTitle()
            cell.detailTextLabel?.text = filteredCapsules[indexPath.row].getDescription()
            let imageName = filteredCapsules[indexPath.row].getImage()
            var image = filteredCapsules[indexPath.row].returnPhoto(imageName: imageName)
                
                //For purpose of demo, use image in assets in some cases
                if (image == nil) {
                    image = UIImage(named: imageName)
                    
                    cell.imageView?.image = image
            }
                else {
            cell.imageView?.image = filteredCapsules[indexPath.row].returnPhoto(imageName: imageName)
            }
           
        }

        //Else return everything
        else {
        
        cell.textLabel?.text = capsules[indexPath.row].getTitle()
        cell.detailTextLabel?.text = capsules[indexPath.row].getDescription()
            
            let imageName = capsules[indexPath.row].getImage()
            var image = capsules[indexPath.row].returnPhoto(imageName: imageName)
            
            //For purpose of demo, use image in assets in some cases
            if (image == nil) {
                image = UIImage(named: imageName)
                
                cell.imageView?.image = image
               
            }
            else {
                cell.imageView?.image = capsules[indexPath.row].returnPhoto(imageName: imageName)
            }
        }
        
        return cell
    }
    
    //Sets "capsule" property of DetailedViewController linked to selected row
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
            let vc = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController
        
        if searching {
            vc?.capsule = filteredCapsules[indexPath.row]
        }
        else {
            vc?.capsule = capsules[indexPath.row]
        }
        
            self.navigationController?.pushViewController(vc!, animated: true)
    }

    

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0;//Choose your custom row height
    }
    
    /*
     Function: Search bar functionality that filters capsules on title, date, description, mood and location
     */
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        let st = searchText.lowercased()
        
        filteredCapsules = capsules.filter({$0.title.lowercased().contains(st) || $0.description.lowercased().contains(st) || $0.date.lowercased().contains(st) || $0.location.lowercased().contains(st) || $0.mood.lowercased().contains(st) })
        searching = true
        tableView.reloadData()
    }
    /*
     Function: Search cancel button
    */
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.text = ""
        tableView.reloadData()
        searchBar.resignFirstResponder()
    }
}
