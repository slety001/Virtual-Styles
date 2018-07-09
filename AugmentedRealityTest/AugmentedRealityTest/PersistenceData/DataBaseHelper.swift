//
//  DataBaseHelper.swift
//  AugmentedRealityTest
//
//  Created by Semen Letychevskyy on 08.07.18.
//  Copyright © 2018 Anonymer Eintrag. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class DataBaseHelper{
    static var shareInstance = DataBaseHelper()
    
    let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    
    func saveUser(object : [String : String]){
        let userData = NSEntityDescription.insertNewObject(forEntityName: "UserData", into: context!) as! UserData
        userData.uid = object["uid"]
        userData.name = object["name"]
        userData.email = object["email"]
        userData.password = object["password"]
        do{
            try context?.save()
            print("saveUser success")
        } catch let error{
            print("saveUser error \(error.localizedDescription)")
        }
    }
}

