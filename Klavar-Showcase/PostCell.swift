//
//  PostCell.swift
//  Klavar-Showcase
//
//  Created by Tony Merritt on 06/10/2016.
//  Copyright © 2016 Tony Merritt. All rights reserved.
//

import UIKit
import Alamofire
import Firebase
import FirebaseDatabase

class PostCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var showcaseImage: UIImageView!
    @IBOutlet weak var descriptionText: UITextView!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var likeImage: UIImageView!
    
    var user: FeedVC!
    var post: Post!
    var request: Request?
    var likeRef: FIRDatabaseReference!
    var usernameRef: FIRDatabaseReference!
    
    override func awakeFromNib() {
        super.awakeFromNib()
  
        
        
        likeImage.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.likeTapped(_:)))
            tap.numberOfTapsRequired = 1
        likeImage.addGestureRecognizer(tap)
    
    }
    
    override func draw(_ rect: CGRect) {
        profileImage.layer.cornerRadius =  profileImage.frame.size.width / 2
        profileImage.clipsToBounds = true
        
        showcaseImage.clipsToBounds = true
    }
    
    func configureCell(_ post: Post, image: UIImage?) {
        self.post = post
        
        
        likeRef = DataService.ds.userCurrent.child("likes").child(post.postKey)
        
        self.descriptionText.text = post.postDescription
        self.likesLabel.text = "\(post.likes)"
        //getting username from Post.VC and updating the label with it. final output.
        
        self.usernameLabel.text = post.username
        if post.imageUrl != "" {
            
            if image != nil {
            self.showcaseImage.image = image
        }else {
                
                request = Alamofire.request(post.imageUrl!).validate(contentType: ["image/*"])
                    .response { response in
                  
                    print(response.error)

                    if response.error == nil {
                        let image = UIImage(data: response.data!)!
                        self.showcaseImage.image = image
                FeedVC.imageCache.setObject(image, forKey: self.post.imageUrl! as NSString)
                        
                    }
                }
            }
        }else {
            self.showcaseImage.isHidden = true
        }
    
        
        
        likeRef.observeSingleEvent(of: .value, with: { snapshot in

            
            if let doesNotExist = snapshot.value as? NSNull {
                // This means we havenot liked this specific post.
                self.likeImage.image = UIImage(named: "heart-empty")
            }else {
                self.likeImage.image = UIImage(named: "heart-full")
            }
        })
    }
    
    func likeTapped(_ sender: UITapGestureRecognizer) {
        
        likeRef.observeSingleEvent(of: .value, with: { snapshot in
            
            
            if let doesNotExist = snapshot.value as? NSNull {
                
                
            self.likeImage.image = UIImage(named: "heart-full")
                self.post.adjustLikes(addLike: true)
                self.likeRef.setValue(true)
                
            }else {
            self.likeImage.image = UIImage(named: "heart-empty")
                self.post.adjustLikes(addLike: false)
                self.likeRef.removeValue()
            }
        })
    }
}
