//
//  Profile.swift
//  AugmentedRealityTest
//
//  Created by Semen Letychevskyy on 30.06.18.
//  Copyright © 2018 Anonymer Eintrag. All rights reserved.
//

import Foundation
import FirebaseDatabase

class Profile {
    
    static var currentUserProfile : User?
    
    static func observeUserProfile(_ uid : String, completion: @escaping ((_ userProfile : User?)->())) {
        let userRef = Database.database().reference().child("users/profile/\(uid)")
        
        userRef.observe(.value, with: { snapshot in
            var userProfile : User?
            
            if let dict = snapshot.value as? [String :  Any],
                let username = dict["username"] as? String,
                let profileImgUrl = dict["profileImgUrl"] as? String {
                
                userProfile = User (uid : snapshot.key, username : username, profileImgUrl : profileImgUrl)
            }
            
            completion(userProfile)
        })
    }
    
}
