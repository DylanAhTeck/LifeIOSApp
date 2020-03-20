//
//  HomeCollectionViewController.swift
//  Life
//
//  Created by Dylan  Ah Teck on 12/10/19.
//  Copyright © 2019 Dylan  Ah Teck. All rights reserved.
//

/*
 Name: Dylan Ah Teck
 Email: ahteck@usc.edu
 */

/*
 Description:
 HomeCollectionViewController manages the detailed home screen of Life
 Users can skim through all memories
 Each capsule is shown with its image, title and description
 */

import UIKit

private let reuseIdentifier = "Cell"

class HomeCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    //Gets model as per MVC design pattern
    let model = CapsulesModel.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let imageView = UIImageView(image: UIImage(named: "life_nav"))
        let item = UIBarButtonItem(customView: imageView)
        self.navigationItem.leftBarButtonItem = item


        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.collectionView?.reloadData()
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return model.numberOfCapsules()
        
    }

    //Each collection cell is configured as
    //per annotatedCell class
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Configure the cell

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AnnotatedCapsuleCell", for: indexPath as IndexPath) as! AnnotatedCapsuleCell
        
        cell.capsule = model.capsules[indexPath.item]
        
        return cell
    }
    
    
    //Determines size of collectionCell
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        //Each cell is put at slightly less than half the width
        //to accomdate two per row with slight framing inbetween
        let itemSize =  (collectionView.frame.width - (collectionView.contentInset.left + collectionView.contentInset.right + 10)) / 2
        
        
        return CGSize(width: itemSize, height: itemSize)
    }

    // MARK: UICollectionViewDelegate

    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    

    
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    //Same as detailViewController, it sets capsule property of DetailViewController class
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController
        vc?.capsule = model.capsules[indexPath.row]
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
//USEFUL FOR SPACING AND FURTHER LAYOUT ENHANCEMENTS IN FUTURE

//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 0
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return 0
//    }
   
    
}
