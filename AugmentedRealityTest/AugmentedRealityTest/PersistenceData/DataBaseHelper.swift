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
    
    //Singlton for atomic use
    static var shareInstance = DataBaseHelper()
    private init(){}
    
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
            print("save User error \(error.localizedDescription)")
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
            print("save Pet error \(error.localizedDescription)")
        }
    }
        
    func saveHat(object : [String : String]){
        let hatData = NSEntityDescription.insertNewObject(forEntityName: "HatData", into: context!) as! HatData
        hatData.uid = object["uid"]
        hatData.url = object["url"]
        do{
            try context?.save()
            print("save Hat success")
        } catch let error{
            print("save Hat error \(error.localizedDescription)")
        }
    }
    
    func saveBubble(object : [String : String]){
        let bubbleData = NSEntityDescription.insertNewObject(forEntityName: "BubbleData", into: context!) as! BubbleData
        bubbleData.uid = object["uid"]
        bubbleData.url = object["url"]
        do{
            try context?.save()
            print("save Bubble success")
        } catch let error{
            print("save Bubble error \(error.localizedDescription)")
        }
    }
    
    func fetchUser() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "UserData")
        do {
            let result = try context?.fetch(request)
            if (result?.count)! > 0 {
                for line in result! as! [NSManagedObject]{
                    let uid = (line as AnyObject).value(forKey: "uid") as! String
                    let name = (line as AnyObject).value(forKey: "name") as! String
                    let password = line.value(forKey: "password") as! String
                    let email = line.value(forKeyPath: "email") as! String
                    
                    print(name, uid, email as Any, password)
                }
            } else {
                print("Empty")
            }
        } catch {
            print("fetch User error \(error.localizedDescription)")
        }
    }
    
    func fetchBubble() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "BubbleData")
        
        do {
            let result = try context?.fetch(request)
            if (result?.count)! > 0 {
                for line in result! {
                    let uid = (line as AnyObject).value(forKey: "uid") as! String
                    let url = (line as AnyObject).value(forKey: "url") as! String
                    
                    print(uid, url)
                }
            } else {
                print("Empty")
            }
        } catch {
            print("fetch User error \(error.localizedDescription)")
        }
    }
    
    func fetchPet() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "PetData")
        
        do {
            let result = try context?.fetch(request)
            if (result?.count)! > 0 {
                for line in result! {
                    let uid = (line as AnyObject).value(forKey: "uid") as! String
                    let url = (line as AnyObject).value(forKey: "url") as! String
                    
                    print(uid, url)
                }
            } else {
                print("Empty")
            }
        } catch {
            print("fetch User error \(error.localizedDescription)")
        }
    }
    
    func fetchHat() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "HatData")
        
        do {
            let result = try context?.fetch(request)
            if (result?.count)! > 0 {
                for line in result! {
                    let uid = (line as AnyObject).value(forKey: "uid") as! String
                    let url = (line as AnyObject).value(forKey: "url") as! String
                    
                    print(uid, url)
                }
            } else {
                print("Empty")
            }
        } catch {
            print("fetch User error \(error.localizedDescription)")
        }
    }
    
    func updateProfileUrl(url:String) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: "UserData")
        do{
            let result = try context?.fetch(fetchRequest)
            if (result?.count)! > 0{
                let userData = result![0] as! NSManagedObject
                userData.setValue(url, forKey: "profileUrl")
                do{
                    try context?.save()
                    print("update profileUrl success")
                } catch let error{
                    print("some error \(error.localizedDescription)")
                }
            } else {
                print("No update")
            }
        } catch {
            print("update fetch User error \(error.localizedDescription)")
        }
    }
    
    func fetchUserName() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "UserData")
        do {
            let result = try context?.fetch(request)
            if (result?.count)! > 0 {
                for line in result! as! [NSManagedObject]{
                    let uid = (line as AnyObject).value(forKey: "uid") as! String
                    let name = (line as AnyObject).value(forKey: "name") as! String
                    let password = line.value(forKey: "password") as! String
                    let email = line.value(forKeyPath: "email") as! String
                    print(name, uid, email as Any, password)
                    
                }
            } else {
                print("Empty")
            }
        } catch {
            print("fetch User error \(error.localizedDescription)")
        }
    }
    
}

