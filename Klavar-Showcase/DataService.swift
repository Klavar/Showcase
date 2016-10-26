//
//  DataService.swift
//  Klavar-Showcase
//
//  Created by Tony Merritt on 06/10/2016.
//  Copyright © 2016 Tony Merritt. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase
import FirebaseStorage

//var images: FIRStorage!
//var posts: FIRDatabaseReference!
//var ref:  FIRDatabaseReference!
//var users: FIRDatabaseReference!
//var userCurrent:

class DataService {
     static let ds = DataService()

    
    private var _images = FIRStorage.storage().reference().child("images")
    private var _posts = FIRDatabase.database().reference().child("posts")
    private var _ref = FIRDatabase.database().reference()
    private var _users = FIRDatabase.database().reference().child("users")

    
    
    var images: FIRStorageReference {
        return _images
    }
    var posts: FIRDatabaseReference {
        return _posts
    }
    var ref: FIRDatabaseReference {
        return _ref
    }
    var users: FIRDatabaseReference {
        return _users
    }
  
    
      var userCurrent: FIRDatabaseReference! {
        let uid = UserDefaults.standard.value(forKey: KEY_UID) as! String
        let user = FIRDatabase.database().reference().child("users").child(uid)
        return user

    }

    func createFirebaseUser(_ users: String, uid: String, user: Dictionary<String, String>) {
     
        ref.child("users").child(uid).setValue(user)
    }
}
