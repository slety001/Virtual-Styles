//
//  User.swift
//  AugmentedRealityTest
//
//  Created by Anonymer Eintrag on 29.06.18.
//  Copyright © 2018 Anonymer Eintrag. All rights reserved.
//

import Foundation

class User {
    
    var uid : String
    var username : String
    var photoURL : URL
    
    init(uid : String, username : String, photoURL : URL) {
        self.uid = uid
        self.username = username
        self.photoURL = photoURL
    }
}
