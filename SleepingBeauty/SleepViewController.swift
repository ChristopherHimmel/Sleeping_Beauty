//
//  SleepViewController.swift
//  SleepingBeauty
//
//  Created by Jane Appleseed on 10/17/16.
//  Copyright © 2016 Apple Inc. All rights reserved.
//

import UIKit
import os.log

class SleepViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate {
    
    //MARK: Properties
    @IBOutlet weak var hoursOverUnderTextField: UITextField!
    @IBOutlet weak var timeStampLabel: UILabel!
    //    @IBOutlet weak var photoImageView: UIImageView!
//    @IBOutlet weak var ratingControl: RatingControl!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var sleep: Sleep?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Handle the text field’s user input through delegate callbacks.
        hoursOverUnderTextField.delegate = self
        
        // Set up views if editing an existing Sleep
        if let sleep = sleep {
            navigationItem.title = "Enter Hours Over/Under"
            hoursOverUnderTextField.text = sleep.hoursOverUnder
            timeStampLabel.text = sleep.entryTimeStamp
//            photoImageView.image = sleep.photo
//            ratingControl.rating = sleep.rating
        } else{
            
            let now = Date()
            
            let formatter = DateFormatter()
            formatter.timeZone = TimeZone.current
            formatter.dateFormat = "yyyy-MM-dd HH:mm"
            
            let dateString = formatter.string(from: now)
            
            timeStampLabel.text = dateString
        }
        
        //Enable the Save button if the text field has a valid Sleep hoursOverUnder.
        updateSaveButtonState()
    }
    
    //MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateSaveButtonState()
//        navigationItem.title = textField.text
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Disable the Save button while editing.
        saveButton.isEnabled = false
    }
    
    //MARK: UIImagePickerControllerDelegate
/*
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Dismiss the picker if the user canceled.
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        // The info dictionary may contain multiple representations of the image. You want to use the original.
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        // Set photoImageView to display the selected image.
        photoImageView.image = selectedImage
        
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
    }
*/
    
    //MARK: Navigation
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        // Depending on style of presentation (modal or push presentation), this view controller needs to be dismissed in two different ways.
        let isPresentingInAddSleepMode = presentingViewController is UINavigationController
        
        if isPresentingInAddSleepMode {
            dismiss(animated: true, completion: nil)
        }
        else if let owningNavigationController = navigationController {
            owningNavigationController.popViewController(animated: true)
        }
        else {
            fatalError("The SleepViewController is not inside a navigation controller.")
        }
    }
    
    // This method lets you configure a view controller before it's presented.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        // Configure the destination view controller only when the save button is pressed.
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        
        let hoursOverUnder = hoursOverUnderTextField.text ?? ""
//        let photo = photoImageView.image
//        let rating = ratingControl.rating
        let entryTimeStamp = timeStampLabel.text
        
        // Set the sleep to be passed to SleepTableViewController after the unwind segue.
        sleep = Sleep(hoursOverUnder: hoursOverUnder, photo: nil, rating: 0, entryTimeStamp: entryTimeStamp!)
    }

    /*
    //MARK: Action
    @IBAction func selectImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {

        // Hide the keyboard.
        hoursOverUnderTextField.resignFirstResponder()

        // UIImagePickerController is a view controller that lets a user pick media from their photo library.
        let imagePickerController = UIImagePickerController()

        // Only allow photos to be picked, not taken.
        imagePickerController.sourceType = .photoLibrary
        
        // Make sure ViewController is notified when the user picks an image.
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    */
    
    //MARK: Private Methods
    
    private func updateSaveButtonState() {
        //Disable the Save button if the text field is empty.
        let text = hoursOverUnderTextField.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }
    
}

