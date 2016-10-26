//
//  Username.swift
//  Klavar-Showcase
//
//  Created by Tony Merritt on 12/10/2016.
//  Copyright © 2016 Tony Merritt. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseDatabase


class Username: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {

    @IBOutlet weak var nameInput: MaterialTextField!
 
    @IBOutlet weak var profileImage: UIImageView!
    
    
    var usernameRef: FIRDatabaseReference!
    var imagePicker: UIImagePickerController!
    var imageSelected = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
  
        
        self.profileImage.layer.cornerRadius =  profileImage.frame.size.width / 2
        self.profileImage.clipsToBounds = true
        
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        imagePicker.dismiss(animated: true, completion: nil)
        profileImage.image = image
        imageSelected = true
        
    }
    
    
    @IBAction func selectImage(_ sender: UITapGestureRecognizer) {
        present(imagePicker,animated: true, completion:  nil)
    
    
    
    }
    @IBAction func onFinishPressed(_ sender: AnyObject) {
      
            if let text = nameInput.text, text != "" {
                if let image = profileImage.image, imageSelected == true {
                    
                    let imageData = UIImageJPEGRepresentation(image, 0.2)
                    let imagePath = "\(NSDate.timeIntervalSinceReferenceDate)"
                    let metadata = FIRStorageMetadata()
                    metadata.contentType = "image/jpg"
                    
                    DataService.ds.images.child(imagePath).put(imageData!, metadata: metadata, completion: { metadata, error in
                        
                        if error != nil {
                            print("Error uploading image")
                        }else {
                            if let meta = metadata {
                                if let imageLink = (meta.downloadURL()?.absoluteString) {
                                    print("Image uploaded successfully! Link: \(imagePath)")
                                    
                                    self.postToFirebase(profileImageUrl: imageLink)
                                }
                            }
                        }
                    })
                }else {
                    self.postToFirebase(profileImageUrl: nil)
                    
                }
            }
        }
        
        func postToFirebase(profileImageUrl: String?) {
            var post: Dictionary<String, AnyObject> = ["username": nameInput.text! as AnyObject]
           
   
            if profileImageUrl != nil {
                post["profileImageUrl"] = profileImageUrl! as AnyObject?
                
                let firebasePost = DataService.ds.userCurrent.child("profile")
                firebasePost.setValue(post)
                
                 nameInput.text = ""
                profileImage.image = UIImage(named: "camera")
                imageSelected = false
                
                
        }
    }
}
