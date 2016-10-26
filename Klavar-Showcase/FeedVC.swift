//
//  FeedVC.swift
//  Klavar-Showcase
//
//  Created by Tony Merritt on 06/10/2016.
//  Copyright © 2016 Tony Merritt. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth
import Alamofire


class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var postField: MaterialTextField!
    @IBOutlet weak var selectImageSelector: UIImageView!
    
    var posts = [Post] ()
    var imageSelected = false
    var imagePicker: UIImagePickerController!
    var usernameValue = ""
    static var imageCache = NSCache<AnyObject, AnyObject>()
  
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 441
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
//        usernameValue = ""
        
//        
//        
//        let userID = FIRAuth.auth()?.currentUser?.uid
//        DataService.ds.ref.child("users").child(userID!).child("profile").observeSingleEvent(of: .value, with: { (snapshot) in
//            // Get user value
//            
//            let value = snapshot.value as? NSDictionary
//            let username = value?["username"] as! String
//
//            print(username)
//        
//        })
//            usernameValue = ("Frank")
        
        
        DataService.ds.posts.observe(.value, with: { (snapshot) in
            print(snapshot.value)

        
        self.posts = []
        if let snapshots  = snapshot.children.allObjects as? [FIRDataSnapshot] {
         
            for snap in snapshots {
                print("SNAP: \(snap)")
                    
                if let postDict =  snap.value as? Dictionary<String, AnyObject> {
                    let key = snap.key
                    let post = Post(postKey: key, dictionary: postDict)
                    self.posts.append(post)
                }
            } 
        }
            self.tableView.reloadData()
      })
    }
 
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let post = posts[indexPath.row]
        
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as? PostCell {
           
            cell.request?.cancel()
            
            var image: UIImage?
            
            if let url = post.imageUrl {
                 image = FeedVC.imageCache.object(forKey: url as AnyObject) as? UIImage
        
            }
            
            cell.configureCell(post, image: image)
            return cell
        }else {
            return PostCell()
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let post = posts[indexPath.row]
        
        if post.imageUrl == "" {
            return 200
        }else {
            return tableView.estimatedRowHeight
        }
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        imagePicker.dismiss(animated: true, completion: nil)
        selectImageSelector.image = image
        imageSelected = true

    }
    
    @IBAction func selectImage(_ sender: UITapGestureRecognizer) {
        present(imagePicker,animated: true, completion:  nil)
                
    }
    @IBAction func makePost(_ sender: AnyObject) {
        if let text = postField.text, text != "" {
            if let image = selectImageSelector.image, imageSelected == true {
                
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
                                
                                self.postToFirebase(imageUrl: imageLink)
                            }
                        }
                    }
                })
            }else {
                self.postToFirebase(imageUrl: nil)
                
            }
        }
    }
    
    func postToFirebase(imageUrl: String?) {
        var post: Dictionary<String, AnyObject> = ["description": postField.text! as AnyObject, "likes": 0 as AnyObject, "username": usernameValue as AnyObject]
        if imageUrl != nil {
            post["imageUrl"] = imageUrl! as AnyObject?
           
        }
        
        let firebasePost = DataService.ds.posts.childByAutoId()
        firebasePost.setValue(post)
        
        postField.text = ""
        selectImageSelector.image = UIImage(named: "camera")
        imageSelected = false
        
        tableView.reloadData()
    }
}
