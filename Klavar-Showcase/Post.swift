//
//  Post.swift
//  Klavar-Showcase
//
//  Created by Tony Merritt on 09/10/2016.
//  Copyright © 2016 Tony Merritt. All rights reserved.
//

import Foundation
import Firebase

class Post {
    fileprivate var _postDescription: String!
    fileprivate var _imageUrl: String?
    fileprivate var _likes: Int!
    fileprivate var _username: String!
    fileprivate var _postKey: String!
    fileprivate var _postRef: FIRDatabaseReference!
    fileprivate var _username_Ref: FIRDatabaseReference!
    
    
    var postDescription: String {
        return _postDescription
    }
    
    var imageUrl: String? {
        return _imageUrl
    }
    
    var likes: Int {
        return _likes
    }
    
    var username: String {
        return _username
    }

    
    var postKey: String {
        return _postKey
    }
    
    init(description: String, imageUrl: String?, username: String) {
        self._postDescription = description
        self._imageUrl = imageUrl
        self._username = username     
    }
    
    init(postKey: String, dictionary: Dictionary<String, AnyObject>) {
        self._postKey = postKey
        
        if let likes = dictionary["likes"] as? Int {
            self._likes = likes
        }
        
        if let imageUrl = dictionary["imageUrl"] as? String {
            self._imageUrl = imageUrl
        }else {
            _imageUrl = ""
            }
        
        if let desc = dictionary["description"] as? String {
            self._postDescription = desc
        }
        
        if let username = dictionary["username"] as? String {
            self._username = username
        }else {
            _username = ""
        }

        self._postRef = DataService.ds.posts.child(self._postKey)
 
        
        self._username_Ref = DataService.ds.userCurrent.child("profile").child("username")
   
    }
    
    func adjustLikes(addLike: Bool) {
        
        if addLike {
            _likes = _likes + 1
        }else {
            _likes = _likes - 1
        }
        
        _postRef.child("likes").setValue(_likes)
        print(_likes)
    }
}
