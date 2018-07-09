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
        userData.profileUrl = object["profileUrl"]
        do{
            try context?.save()
            print("save User success")
        } catch let error{
            print("saveUser error \(error.localizedDescription)")
        }
    }
        
    func savePet(object : [String : String]){
        let petData = NSEntityDescription.insertNewObject(forEntityName: "PetData", into: context!) as! PetData
        petData.uid = object["uid"]
        petData.url = object["url"]
        do{
            try context?.save()
            print("save Pet success")
        } catch let error{
            print("saveUser error \(error.localizedDescription)")
        }
    }
        
    func saveHat(object : [String : String]){
        let hatData = NSEntityDescription.insertNewObject(forEntityName: "HatData", into: context!) as! HatData
        hatData.uid = object["uid"]
        hatData.url = object["url"]
        do{
            try context?.save()
            print("save Pet success")
        } catch let error{
            print("saveUser error \(error.localizedDescription)")
        }
    }
    
    func saveBubble(object : [String : String]){
        let bubbleData = NSEntityDescription.insertNewObject(forEntityName: "BubbleData", into: context!) as! BubbleData
        bubbleData.uid = object["uid"]
        bubbleData.url = object["url"]
        do{
            try context?.save()
            print("save Pet success")
        } catch let error{
            print("saveUser error \(error.localizedDescription)")
        }
    }
        
}

