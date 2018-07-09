//
//  HatData+CoreDataProperties.swift
//  AugmentedRealityTest
//
//  Created by Semen Letychevskyy on 09.07.18.
//  Copyright © 2018 Anonymer Eintrag. All rights reserved.
//
//

import Foundation
import CoreData


extension HatData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<HatData> {
        return NSFetchRequest<HatData>(entityName: "HatData")
    }

    @NSManaged public var uid: String?
    @NSManaged public var url: String?
    @NSManaged public var belongs: UserData?

}
