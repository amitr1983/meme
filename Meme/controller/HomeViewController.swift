//
//  HomeViewController.swift
//  Meme
//
//  Created by amit kumar on 6/21/18.
//  Copyright © 2018 amit kumar. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {

    @IBOutlet weak var myView: UIImageView!
    
    @IBOutlet weak var shareBtn: UIBarButtonItem!
    
    @IBOutlet weak var clearBtn: UIBarButtonItem!
    
    @IBOutlet weak var albumBtn: UIBarButtonItem!
    
    @IBOutlet weak var cameraBtn: UIBarButtonItem!
    
    @IBOutlet weak var topTextfield: UITextField!
    
    @IBOutlet weak var bottomTextfield: UITextField!
    
    @IBOutlet weak var navBar: UINavigationBar!
    
    @IBOutlet weak var toolBar: UIToolbar!
    
    let myPickerController = UIImagePickerController()
    
    var memedImage: UIImage?
    
    // Atrribute for text
    let memeTextAttributes:[String: Any] = [
        NSAttributedStringKey.strokeColor.rawValue: UIColor.black,
        NSAttributedStringKey.foregroundColor.rawValue: UIColor.white,
        NSAttributedStringKey.font.rawValue: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedStringKey.strokeWidth.rawValue:-3.0]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        
        // Do any additional setup after loading the view.
        topTextfield.text = "TOP"
        bottomTextfield.text = "BOTTOM"
        setStyle(toTextField: topTextfield)
        setStyle(toTextField: bottomTextfield)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true);
        hide_btn()
        subscribeToKeyboardNotifications()
        setStyle(toTextField: topTextfield)
        setStyle(toTextField: bottomTextfield)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
        
    }
    
    //Hide status bar
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // Pick image from album
    @IBAction func tapAlbumBtn(_ sender: Any) {
        print("Album Button Pressed")
        selectPicker(sourcetype: .photoLibrary)
    }
    
    //Pick image from image capture
    @IBAction func tapCameraBtn(_ sender: Any) {
        print("Camera Button Pressed")
        selectPicker(sourcetype: .camera)
    }
    
    // Handle cancel button on camera
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        myPickerController.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let image = info[UIImagePickerControllerOriginalImage] else {return}
        myView.image = image as? UIImage
        myPickerController.dismiss(animated: true, completion: nil)
    }
    
    // Hide button based on condition
    func hide_btn() {
        if !UIImagePickerController.isSourceTypeAvailable(.camera) {
            cameraBtn.isEnabled = false
        }
        
        if myView.image == nil {
            shareBtn.isEnabled = false
            clearBtn.isEnabled = false
        } else {
            shareBtn.isEnabled = true
            clearBtn.isEnabled = true
        }
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        if self.bottomTextfield.isFirstResponder {
            view.frame.origin.y = -getKeyboardHeight(notification)
        }
    }
    
    @objc func keyboardWillHide(_ notification:Notification) {
        view.frame.origin.y = 0
    }
    
    //Get keyboard height
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications(){
        NotificationCenter.default.removeObserver(self)
    }
    
    // Clear image and reset default text
    @IBAction func tapClearBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // tap on Share button. It will open activity view with few sharing/saving options
    @IBAction func tapShareBtn(_ sender: Any) {
        // generate memed image
        let memeImage = generateMemedImage()
        memedImage = memeImage
        
        let activityViewController = UIActivityViewController(activityItems: [memedImage!], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view

        activityViewController.completionWithItemsHandler =      { (activity, success, items, error) in
            if(success && error == nil){
                self.save()
                self.dismiss(animated: true, completion: nil);
            }
            else if (error != nil){
                print(error.debugDescription)
            }
        }
        present(activityViewController, animated: true, completion: nil)
    }
    
    // Save meme
    func save() {
        // Create the meme
        let meme = Meme(topText: topTextfield.text!, bottomText: bottomTextfield.text!, orginalImage: myView.image!, memedImage: memedImage!)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.memes.append(meme)
    }
    
    // Create meme
    func generateMemedImage() -> UIImage {
        
        hideTabNavBar(true)
        self.toolBar.isHidden = true
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        hideTabNavBar(false)
        
        return memedImage
    }
    
    func hideTabNavBar(_ isBoolean: Bool) {
        self.navBar.isHidden = isBoolean
        self.toolBar.isHidden = isBoolean
    }
    
    func selectPicker(sourcetype: UIImagePickerControllerSourceType) {
        if UIImagePickerController.isSourceTypeAvailable(sourcetype){
            myPickerController.delegate = self;
            myPickerController.sourceType = sourcetype
            myPickerController.allowsEditing = false
            self.present(myPickerController, animated: true, completion: nil)
        }
    }
    
    func setStyle(toTextField textField: UITextField) {
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = .center
        textField.textAlignment = NSTextAlignment.center
        textField.autocapitalizationType = .allCharacters
        textField.delegate = self
    }
    
}

// Handle textfield events
extension HomeViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }
}
