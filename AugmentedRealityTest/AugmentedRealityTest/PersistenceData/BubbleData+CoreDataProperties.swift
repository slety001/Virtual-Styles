//
//  BubbleData+CoreDataProperties.swift
//  AugmentedRealityTest
//
//  Created by Semen Letychevskyy on 08.07.18.
//  Copyright © 2018 Anonymer Eintrag. All rights reserved.
//
//

import Foundation
import CoreData


extension BubbleData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BubbleData> {
        return NSFetchRequest<BubbleData>(entityName: "BubbleData")
    }

    @NSManaged public var uid: String?
    @NSManaged public var url: String?
    @NSManaged public var belongs: UserData?

}
