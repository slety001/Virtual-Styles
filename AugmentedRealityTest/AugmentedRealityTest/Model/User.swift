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
    var profileImgUrl : String?
    
    init(uid : String, username : String, profileImgUrl : String?) {
        self.uid = uid
        self.username = username
        self.profileImgUrl = profileImgUrl
    }
}
