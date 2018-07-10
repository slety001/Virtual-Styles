//
//  DataBasePlayGround.swift
//  AugmentedRealityTest
//
//  Created by Semen Letychevskyy on 10.07.18.
//  Copyright © 2018 Anonymer Eintrag. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class DataBasePlayGround {
    
    static let databasePlayground = DataBasePlayGround()
    private init(){}
    
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func create(uid: String, url: String) -> PetData{
        let newItem = NSEntityDescription.insertNewObject(forEntityName: "PetData", into: context) as! PetData
        newItem.uid = uid
        newItem.url = url
        return newItem
    }
    
    // Gets all.
    func getAll() -> [PetData]{
        return get(withPredicate: NSPredicate(value:true))
    }
    
    // Gets all that fulfill the specified predicate.
    // Predicates examples:
    // - NSPredicate(format: "name == %@", "Juan Carlos")
    // - NSPredicate(format: "name contains %@", "Juan")
    func get(withPredicate queryPredicate: NSPredicate) -> [PetData]{
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PetData")
        
        fetchRequest.predicate = queryPredicate
        
        do {
            let response = try context.fetch(fetchRequest)
            return response as! [PetData]
            
        } catch let error as NSError {
            // failure
            print(error)
            return [PetData]()
        }
    }
    
    // Saves all changes
    func saveChanges(){
        do{
            try context.save()
        } catch let error as NSError {
            // failure
            print(error)
        }
    }
    
}
