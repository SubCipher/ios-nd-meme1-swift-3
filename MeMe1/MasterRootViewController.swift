//
//  MasterRootViewController.swift
//  MeMe1
//
//  Created by kpicart on 2/16/17.
//  Copyright © 2017 StepwiseDesigns. All rights reserved.
//

import UIKit


class MasterRootViewController: UIViewController, UITextFieldDelegate, UINavigationBarDelegate {
    //MARK: - set local instance of ViewSettings() and delegates
    
    //set local instances to access their methods
    let viewSettings = ViewSettings()
    let memeCustomText = MemeCustomTextx()
    let scrollView = ScrollViewController()
    let localImagePickerController = UIImagePickerController()
    let imagePickerDelegate = ImagePickerDelegate()
    
    //MARK: - Set the required IBOutlets for main storyboard
    @IBOutlet weak var greenButtonOutlet: UIButton!
    @IBOutlet weak var blueButtonOutlet: UIButton!
    @IBOutlet weak var memeToolBar: UIToolbar!
    @IBOutlet weak var topNavToolBar: UINavigationItem!
    
    //naviagation bar items on bottom of UI
    @IBOutlet weak var cameraLaunchOutlet: UIBarButtonItem!
    @IBOutlet weak var photoAlbumOutlet: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        localImagePickerController.delegate = imagePickerDelegate
    }
    //modify textFields based on device orientation
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
      
        if traitCollection.verticalSizeClass == .compact {
            isDeviceVertical = false
            deviceVariableSetting()
        }
        else { isDeviceVertical = true
            deviceVariableSetting()
        }
    }
    
    
    func deviceVariableSetting(){
        //remove the textFields so redrawn fields are not placed along side the originals
        memeTextField.topTextField.removeFromSuperview()
        memeTextField.bottomTextField.removeFromSuperview()
        
        memeCustomText.setupMemeTextFields()
        memeTextField.topTextField.delegate = self
        memeTextField.bottomTextField.delegate = self
        
        //add textFields with new Rects
        view.addSubview(memeTextField.topTextField)
        view.addSubview(memeTextField.bottomTextField)
        
    }

    
    
    //MARK: - Prepare For Segue and ActivityViewController for sharing options
    
    //used directly by nav barButtonItem action and called by greenButton to generate meme
    
    
    override func  prepare(for segue:UIStoryboardSegue, sender: Any?){
        
        if segue.identifier == "MemeViewController" {
            //hide stuff you dont want in meme
            viewSettings.hideNavButtons(true,topNavBar: topNavToolBar, bottomNavBar: memeToolBar, button1: blueButtonOutlet, button2: greenButtonOutlet)
            
            //build meme/initialize mem with parameters
            let meme = createMeme()
            
            (segue.destination as! MemeViewController).segueMemedImage = meme.memedImage
            
            //set meme image as target for activity
            let controller = UIActivityViewController(activityItems: [meme.memedImage], applicationActivities:nil)
            
            //exclude some stuff if needed
            controller.excludedActivityTypes = [UIActivityType.addToReadingList,.openInIBooks,.print]
            self.present(controller, animated: true, completion: nil)
            
            //unhide hidden elements after meme is created
            viewSettings.hideNavButtons(false,topNavBar: topNavToolBar, bottomNavBar: memeToolBar, button1: blueButtonOutlet , button2: greenButtonOutlet)
        }
    }
    
    //MARK: - The Meme Image
    
    private func createMeme() ->MemeBluePrint {
        let meme = MemeBluePrint(topText: memeTextField.topTextField.text ?? "", bottomText: memeTextField.bottomTextField.text ?? "", orgImage: sourceImageView.image ?? viewSettings.noMemeImage! , memedImage: generateMemedImage())
        
        return meme
    }
    
    //generate Meme Image
    
    private func generateMemedImage() -> UIImage {
        //create the meme
        UIGraphicsBeginImageContext(self.view.frame.size)
        
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage = UIGraphicsGetImageFromCurrentImageContext() ?? viewSettings.noMemeImage
        
        UIGraphicsEndImageContext()
        return memedImage!
    }
    
    //Navagationbar and Actionlist to generate meme
    
    private func setMemeSourceDevice(_ senderTag: Int){
        
        //set source device based on sender.tag value, then assign its rawValue to sourceDeviceAsInt
        let sourceDevice = senderTag == 0 ?  UIImagePickerControllerSourceType.photoLibrary: UIImagePickerControllerSourceType.camera
        
        //check if sourceType is available
        if UIImagePickerController.isSourceTypeAvailable(sourceDevice){
            
            //assign the souceType to the localImagePickerController
            self.localImagePickerController.sourceType = (sourceDevice)
            
            //enable camera option (so user can check if it is still unavaiable)
            cameraLaunchOutlet.isEnabled = true
            
            //show image picker
            self.present(self.localImagePickerController,animated:  true, completion: nil)
            
        } else {
            
            //disable button for device that is not available
            let availabilityOptions = senderTag == 0 ? (photoAlbumOutlet) : (cameraLaunchOutlet)
            availabilityOptions?.isEnabled = false
        }
    }
    
    //MARK: - Button actions and actionSheet alert menu
    //used for UI blue button and the action barButtonItem in navToolBar
    @IBAction func blueActionButton(_ sender: UIButton){
        
        let actionSheet = UIAlertController(title: "Photo Source", message: "Choose a source", preferredStyle: .alert)
        
        //camera action alert
        actionSheet.addAction(UIAlertAction(title: "camera", style: .default, handler: { (action:UIAlertAction) in
            self.setMemeSourceDevice(sender.tag + 1)
        }))
        
        //photo library action alert
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: {(action:UIAlertAction)
            in self.localImagePickerController.sourceType = .photoLibrary
            self.setMemeSourceDevice(sender.tag)
        }))
        
        //cancel action alert
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(actionSheet,animated: true, completion: nil)
    }
    
    @IBAction func greenActionButton(_ sender: UIButton) {
        performSegue(withIdentifier: "MemeViewController", sender: sender)
    }
    
    //used in navToolBar at bottom of UI for camera and photo album
    @IBAction func imagePickerAction(_ sender: UIBarButtonItem) {
        setMemeSourceDevice(sender.tag)
    }
    
    //MARK: - NotificationCenter for adjusting view when showing and hiding keyboard
    
    func subscribeToKeyboardNotificationsWillShow(){
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
    }
    
    func subscribeToKeyboardNotificationsWillHide(){
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    private func unsubscribeFromKeyboardNotificationsWillShow(){
        
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
    }
    
    private func unsubscribeFromKeyboardNotificationsWillHide(){
        
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    func keyboardWillShow(_ notification: Notification){
        
        //set parameters for when view has to move (make space for keyboard)
        if memeTextField.bottomTextField.isEditing && isDeviceVertical == false {
            self.view.frame.origin.y = 50 - getKeyboardHeight(notification)
        } else {
            self.view.frame.origin.y = 0
        }
    }
    //return frame to original position
    func keyboardWillHide(_ notification: Notification){
        self.view.frame.origin.y = 0
    }
    
    private func getKeyboardHeight(_ notification: Notification)-> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        
        return keyboardSize.cgRectValue.height
    }
    
    //MARK: - delegate methods
    
    func textFieldDidBeginEditing(_ : UITextField) {
        //allow image push when typing in textField
        subscribeToKeyboardNotificationsWillShow()
        subscribeToKeyboardNotificationsWillHide()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        //remove form notification after editing textField
        unsubscribeFromKeyboardNotificationsWillShow()
        unsubscribeFromKeyboardNotificationsWillHide()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
}
