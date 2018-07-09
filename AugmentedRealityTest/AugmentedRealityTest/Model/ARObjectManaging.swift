//
//  ARObjectManaging.swift
//  AugmentedRealityTest
//
//  Created by Semen Letychevskyy on 07.07.18.
//  Copyright © 2018 Anonymer Eintrag. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class ARObjectManaging {
    
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    func fetch() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "PetData")
        //let searchString = self.searchFor?.text
        //request.predicate = NSPredicate(format: "PetData CONTAINS[cd] %@", searchString!) // contains case insensitive
        //request.predicate = NSPredicate(format: "PetData CONTAINS %@", searchString!) // contains case sensitive
        //request.predicate = NSPredicate(format: "PetData LIKE[cd] %@", searchString!) // like case insensitive
        //request.predicate = NSPredicate(format: "PetData ==[cd] %@", searchString!)  // equal case insensitive
        //request.predicate = NSPredicate(format: "PetData == %@", searchString!)  // equal case sensitive
        
        var outputStr = ""
        do {
            let result = try context.fetch(request)
            if result.count > 0 {
                for line in result {
                    let uid = (line as AnyObject).value(forKey: "uid") as! String
                    let url = (line as AnyObject).value(forKey: "url") as! String
                    
                    outputStr += uid + " " + url + " " + "\n"
                }
            } else {
                outputStr = "No Match Found!"
            }
            //self.searchResult?.text = outputStr
        } catch {
            print(error)
        }
    }
}
