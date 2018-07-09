//
//  PetData+CoreDataProperties.swift
//  AugmentedRealityTest
//
//  Created by Semen Letychevskyy on 08.07.18.
//  Copyright © 2018 Anonymer Eintrag. All rights reserved.
//
//

import Foundation
import CoreData


extension PetData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PetData> {
        return NSFetchRequest<PetData>(entityName: "PetData")
    }

    @NSManaged public var uid: String?
    @NSManaged public var url: String?

}
