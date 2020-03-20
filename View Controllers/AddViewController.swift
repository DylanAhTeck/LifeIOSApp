//
//  AddViewController.swift
//  Life
//
//  Created by Dylan  Ah Teck on 12/9/19.
//  Copyright © 2019 Dylan  Ah Teck. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation

/*
 Name: Dylan Ah Teck
 Email: ahteck@usc.edu
 */

/*
 Description:
 AddViewController allows users to create new memory capsules
 - The user must enter a title and description, choose from 5 available moods, and select
 an image from their library
 - The user's location is shown to them automatically through GoogleMaps
 - The user's location is also reverse-geocoded to be stored as part of capsule information
 - The ImagePicker technology item is also used to allow users to select a photo from library
 */
class AddViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextViewDelegate, UITextFieldDelegate, CLLocationManagerDelegate {
    
    //Declare imagePicker to use in image selection
    var imagePicker = UIImagePickerController()
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descriptionTV: UITextView!
    @IBOutlet weak var titleTF: UITextField!
    @IBOutlet weak var moodButton: UIButton!
    @IBOutlet weak var imgButton: UIButton!
   
    //Outlet of Google Maps
    @IBOutlet weak var mapView: GMSMapView!
    
    //Stores the location in Coordinate format to be converted to
    //an address later
    var curr_location: CLLocation?
    
    //Key variables
    var newTitle = ""
    var newDescription = ""
    var newMood = ""
    var newImage = ""
    var newAddress = ""
    var newDate = ""
    
    
    //Bools to check if property was filled out by user
    var titleAndDescriptionCheck = false
    var moodCheck = false
    var imageCheck = false
    
    var model = CapsulesModel.shared
    private let locationManager = CLLocationManager()

    
    
    //Stores initial color of mood button to reset it after user has added capsule
    var moodColor: CGColor?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set imagePicker properties
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        
        //Allows user to pick from library
        imagePicker.mediaTypes = ["public.image"]
        imagePicker.sourceType = .photoLibrary
        
        
        //Set various stylistic enhancements and setting of delegates
        titleTF.delegate = self
        descriptionTV.delegate = self
        
        moodColor = moodButton.layer.backgroundColor
        
        moodButton.layer.cornerRadius = 5
        moodButton.layer.borderWidth = 1
        moodButton.layer.borderColor = UIColor.lightGray.cgColor
        
        titleTF.layer.borderColor =
        UIColor.lightGray.cgColor
        titleTF.layer.cornerRadius = 5
        titleTF.layer.borderWidth = 1
        
        descriptionTV.layer.cornerRadius = 5
        descriptionTV.layer.borderWidth = 1
        descriptionTV.layer.borderColor = UIColor.lightGray.cgColor
       
        imgButton.layer.cornerRadius = 5
        imgButton.layer.borderWidth = 1
        imgButton.layer.borderColor = UIColor.lightGray.cgColor
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
        //Reset consists of functions that are called each time
        //the screen is cleared after a succesful addition
        reset()
        
        let imageView = UIImageView(image: UIImage(named: "life_nav"))
        let item = UIBarButtonItem(customView: imageView)
        self.navigationItem.leftBarButtonItem = item
       
        
        locationManager.startUpdatingLocation()
        self.mapView?.isMyLocationEnabled = true
    }
    
 
    /*
     Add function which allows user to create new capsule
     as long as they have filled out all required fields
   */
    @IBAction func add(_ sender: UIBarButtonItem) {
        
        if(moodButton?.titleLabel?.text != "Mood"){ self.moodCheck = true}
        
        //Throw alert if not all fields have been filled in
        if (titleAndDescriptionCheck == false || imageCheck == false || moodCheck == false) {
            let alertController = UIAlertController(title: "Field Missing",
                                                    message: "Please fill out all available fields",
                                                    preferredStyle: .alert)
            let ok = UIAlertAction(title: "Ok", style: .default, handler:  nil)
            alertController.addAction(ok)
           self.present(alertController, animated: true, completion: nil)
            return
        }
        
        //Title, Description assigned
        newTitle = titleTF.text ?? ""
        newDescription = descriptionTV.text ?? ""
        
        // Gets the current date and formats it
        let currentDateTime = Date()
        // initialize the date formatter and set the style
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .medium
        newDate = formatter.string(from: currentDateTime)

        //Calls function to set newAddress to
        //current user's verbose address
        reverseGeocoder()
      
        
        //Insert new capsule into model capsules array
         model.insert(title: newTitle, description: newDescription, mood: newMood, image: newImage, location: newAddress, date: newDate)
        
        //Alert user of success
        let successAlertController = UIAlertController(title: "Success",
                                                message: "Your new memory capsule has been added to Life",
                                                preferredStyle: .alert)
        let ok = UIAlertAction(title: "Yay!", style: .default, handler:  nil)
        successAlertController.addAction(ok)
        self.present(successAlertController, animated: true, completion: nil)
        
        //Resets and clears fields
        reset()
    }
    
    //Helper function to clear fields
    func reset()
    {
        titleTF.text = ""
        moodButton.layer.backgroundColor = moodColor
        imageView.image = nil
        
        descriptionTV.text = "How do you feel today?"
        descriptionTV.textColor = UIColor.lightGray
        imgButton.titleLabel?.text = "Please click to select an image"
        imgButton.titleLabel?.textColor = UIColor.lightGray
    }
    
   
   
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == titleTF {
            titleTF.resignFirstResponder()
            descriptionTV.becomeFirstResponder()
        } else {
            descriptionTV.resignFirstResponder()
        }
        return true
    }
    
  
    func textViewDidBeginEditing(_ textView: UITextView) {
        if descriptionTV.textColor == UIColor.lightGray {
            descriptionTV.text = ""
            descriptionTV.textColor = UIColor.black
        }
    }
   
      //To replicate placeholder functionality for textView
    func textViewDidEndEditing(_ textView: UITextView) {
        if descriptionTV.text.isEmpty {
            descriptionTV.text = "How do you feel today?"
            descriptionTV.textColor = UIColor.lightGray
        }
        descriptionTV.resignFirstResponder()
    }
    
    //Button which overlays imageView; triggers imagePicker
    @IBAction func btnClicked(_ sender: UIButton) {
        
        self.present(imagePicker, animated: true, completion: nil)

    }
    
    //Allows user to pick image from library
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.image = pickedImage
            imgButton.setTitleColor(UIColor.clear, for: .normal)

            if let imgUrl = info[UIImagePickerController.InfoKey.imageURL] as? URL{
                let imgName = imgUrl.lastPathComponent
                
                //Saves the name of image in global variable that will be stored with capsule
                newImage = imgName
                
                //Saves image to Documents folder of device
                saveImage(imageName: imgName)
            }
            }
    
        //Image succesfully selected
        imageCheck = true
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
  
    //Function to save image selected by user to App's document folder
    func saveImage(imageName: String){
        //create an instance of the FileManager
        let fileManager = FileManager.default
        //get the image path
        let imagePath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(imageName)
        
        //ADDITIONAL!
        if fileManager.fileExists(atPath: imagePath) {return}
        
        //get the image we took with camera
        guard let image = imageView.image else { return }
        //get the PNG data for this image
        let data = image.pngData()
        //store it in the document directory
        
        fileManager.createFile(atPath: imagePath as String, contents: data, attributes: nil)
    }
    
   

    //Allows user to select their mood
    @IBAction func moodButton(_ sender: UIButton) {
        
        let alertController = UIAlertController(title: "Choose a mood",
                                                message: "How do you feel in this moment?",
                                                preferredStyle: .actionSheet)
        
       //Each mood is added separately (rather than through a function) as
        //each other has a separate colour
       let happy = UIAlertAction(title: "Happy", style: .default, handler: {action in
        self.moodButton.setTitle("Happy", for: .normal)
        self.moodButton.backgroundColor = UIColor.orange
        self.newMood = "Happy"
       }
        )
        alertController.addAction(happy)
        
        let sad = UIAlertAction(title: "Sad", style: .default, handler: { action in
            self.moodButton.setTitle("Sad", for: .normal)
            self.moodButton.backgroundColor = UIColor.black
            self.newMood = "Sad"
            
        }
        )
        alertController.addAction(sad)
        
        let excited = UIAlertAction(title: "Excited", style: .default, handler: {action in
            self.moodButton.setTitle("Excited", for: .normal)
            self.moodButton.backgroundColor = UIColor.blue
            self.newMood = "Excited"
           
    })
        alertController.addAction(excited)
        
        let relaxed = UIAlertAction(title: "Relaxed", style: .default, handler: {action in
            self.moodButton.setTitle("Relaxed", for: .normal)
            self.moodButton.backgroundColor = UIColor.purple
            self.newMood = "Relaxed"
            
        } )
        alertController.addAction(relaxed)
        
        let loved = UIAlertAction(title: "Loved", style: .default, handler: {action in
            self.moodButton.setTitle("Loved", for: .normal)
            self.moodButton.backgroundColor = UIColor.red
            self.newMood = "Loved"
           
        } )
        alertController.addAction(loved)

        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler:  nil)
        alertController.addAction(cancel)
        
       
        self.present(alertController, animated: true, completion:nil)
        
    }
    
    
    @IBAction func tapBackground(_ sender: UITapGestureRecognizer) {
        titleTF.resignFirstResponder()
        descriptionTV.resignFirstResponder()
    }
    
    
    //Function called when authorization status changes
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
      // asks for authorizatoin when in use
      guard status == .authorizedWhenInUse else {
        return
      }
      
      locationManager.startUpdatingLocation()
        
      //Sets mapView properties to enable location button and display user's location on map
      mapView.isMyLocationEnabled = true
      mapView.settings.myLocationButton = true
    }
    
    // Function recenters map when user changes position
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let location = locations.last else {return}
       
        mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
        mapView.settings.myLocationButton = true // show current location button
        curr_location = location
        
        reverseGeocoder()
    }
    
  //Sets newAddress property from
    //reverse-geocoded location.
    //Calls each time location changes as this
    //is an asynchronous function
    func reverseGeocoder() {
        
        // Create geocoder.
        let myGeocorder = CLGeocoder()
        
        // Create a location.
        guard let myLocation = curr_location else {return}
        
        // Start reverse geocoding.
        myGeocorder.reverseGeocodeLocation(myLocation, completionHandler: { (placemarks, error) -> Void in
            
            if let placemark = placemarks?.first {
                
                self.newAddress = """
                \(placemark.name ?? ""),
                \(placemark.locality ?? "")
                """
                
            }
        })
        
    }



 // Used the two functions below to check that both title and
    //description field was filled before allowing add to occur
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // get the current text, or use an empty string if that failed
        let currentText = textField.text ?? ""

        // attempt to read the range they are trying to change, or exit if we can't
        guard let stringRange = Range(range, in: currentText) else { return false }

        // add their new text to the existing text
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)

        if let desc = descriptionTV.text {
            if (updatedText.count > 0 && desc.count > 0) {
                titleAndDescriptionCheck = true
                newTitle = updatedText
            }
            else {
                titleAndDescriptionCheck = false
            }
        }

        if updatedText == "\n" { return false }
        return true
    }

    // Use this if you have a UITextView
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        // get the current text, or use an empty string if that failed
        let currentText = descriptionTV.text ?? ""

        // attempt to read the range they are trying to change, or exit if we can't
        guard let stringRange = Range(range, in: currentText) else { return false }

        // add their new text to the existing text
        let updatedText = currentText.replacingCharacters(in: stringRange, with: text)

        if let ttext = titleTF.text {
            if (updatedText.count > 0 && ttext.count > 0) {
                titleAndDescriptionCheck = true
                newDescription = updatedText
            }
            else {
                titleAndDescriptionCheck = false
            }
        }
        
        if text == "\n"
        {
            textView.resignFirstResponder()
            return false
        }
        return true
    }

}
