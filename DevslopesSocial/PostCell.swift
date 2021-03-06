//
//  PostCell.swift
//  DevslopesSocial
//
//  Created by Juan M Mariscal on 1/15/17.
//  Copyright © 2017 Juan M Mariscal. All rights reserved.
//

import UIKit
import Firebase

class PostCell: UITableViewCell,UIImagePickerControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var postImg: UIImageView!
    @IBOutlet weak var caption: UITextView!
    @IBOutlet weak var likesLbl: UILabel!
    @IBOutlet weak var likeImg: UIImageView!
    
    
    var post: Post!
    var likesRef: FIRDatabaseReference!
    var profileImgRef: FIRDatabaseReference!
    var imagePicker: UIImagePickerController!
    static var imageCache: NSCache<NSString, UIImage> = NSCache()
    var imageSelected = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(likeTapped))
        tap.numberOfTapsRequired = 1
        likeImg.addGestureRecognizer(tap)
        likeImg.isUserInteractionEnabled = true
    }
    
//    func configureCellWithProfileImg(post: Post, profileImg: UIImage? = nil) {
//        self.post = post
//        
//        if profileImg != nil {
//            self.profileImg.image = profileImg
//        } else {
//            let ref = FIRStorage.storage().reference(forURL: post.profileImgUrl)
//            ref.data(withMaxSize: 2 * 1024 * 1024, completion: { (data, error) in
//                if error != nil {
//                    print("TEST: unable to download image form Firebase storage")
//                } else {
//                    print("TEST: Image downloaded from Firebase storage")
//                    if let imgData = data {
//                        
//                        if let img = UIImage(data: imgData) {
//                            
//                            self.profileImg.image = img
//                            FeedVC.imageCache.setObject(img, forKey: post.profileImgUrl as NSString)
//                        }
//                    }
//                }
//            })
//        }
//    }
    
    func configureCell(post: Post, img: UIImage? = nil, profileImg: UIImage? = nil) {
        
        self.post = post
        print("TEST: configureCell")

        likesRef = DataService.ds.REF_USER_CURRENT.child("likes").child(post.postKey)
        profileImgRef = DataService.ds.REF_USER_CURRENT.child("profileImgUrl")
        self.caption.text = post.caption
        self.likesLbl.text = "\(post.likes)"
        
        if img != nil {
            self.postImg.image = img
        } else {
            let ref = FIRStorage.storage().reference(forURL: post.imageUrl)
            ref.data(withMaxSize: 2 * 1024 * 1024, completion: { (data, error) in
                if error != nil {
                    print("TEST: unable to download image form Firebase storage")
                } else {
                    print("TEST: Image downloaded from Firebase storage")
                    if let imgData = data {
                        
                        if let img = UIImage(data: imgData) {
                            
                            self.postImg.image = img
                            FeedVC.imageCache.setObject(img, forKey: post.imageUrl as NSString)
                        }
                    }
                }
            })
        }
        
        if profileImg != nil {
            self.profileImg.image = img
            print("TEST: configureCell")
        } else {
            let ref = FIRStorage.storage().reference(forURL: post.profileImgUrl)
            ref.data(withMaxSize: 2 * 1024 * 1024, completion: { (data, error) in
                if error != nil {
                    print("TEST: unable to download image form Firebase storage")
                } else {
                    print("TEST: Image downloaded from Firebase storage")
                    if let imgData = data {
                        
                        if let img = UIImage(data: imgData) {
                            
                            self.profileImg.image = img
                            FeedVC.imageCache.setObject(img, forKey: post.profileImgUrl as NSString)
                        }
                    }
                }
            })
        }
        
        likesRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let _ = snapshot.value as? NSNull {
                
                self.likeImg.image = UIImage(named: "empty-heart")
            } else {
                self.likeImg.image = UIImage(named: "filled-heart")
            }
        })
    }

    func likeTapped(sender: UITapGestureRecognizer) {
        
            likesRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let _ = snapshot.value as? NSNull {
                self.likeImg.image = UIImage(named: "filled-heart")
                self.post.adjustLikes(addLike: true)
                self.likesRef.setValue(true)
            } else {
                self.likeImg.image = UIImage(named: "empty-heart")
                self.post.adjustLikes(addLike: false)
                self.likesRef.removeValue()
            }
        })
    }
    
    
    

}
























