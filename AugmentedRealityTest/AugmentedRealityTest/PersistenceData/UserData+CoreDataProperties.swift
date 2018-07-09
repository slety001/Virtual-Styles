//
//  UserData+CoreDataProperties.swift
//  AugmentedRealityTest
//
//  Created by Semen Letychevskyy on 08.07.18.
//  Copyright © 2018 Anonymer Eintrag. All rights reserved.
//
//

import Foundation
import CoreData


extension UserData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserData> {
        return NSFetchRequest<UserData>(entityName: "UserData")
    }

    @NSManaged public var uid: String?
    @NSManaged public var name: String?
    @NSManaged public var email: String?
    @NSManaged public var password: String?
    @NSManaged public var profileUrl: String?

}

// MARK: Generated accessors for hasHats
extension UserData {

    @objc(addHasHatsObject:)
    @NSManaged public func addToHasHats(_ value: HatData)

    @objc(removeHasHatsObject:)
    @NSManaged public func removeFromHasHats(_ value: HatData)

    @objc(addHasHats:)
    @NSManaged public func addToHasHats(_ values: NSSet)

    @objc(removeHasHats:)
    @NSManaged public func removeFromHasHats(_ values: NSSet)

}

// MARK: Generated accessors for hasBubbles
extension UserData {

    @objc(addHasBubblesObject:)
    @NSManaged public func addToHasBubbles(_ value: BubbleData)

    @objc(removeHasBubblesObject:)
    @NSManaged public func removeFromHasBubbles(_ value: BubbleData)

    @objc(addHasBubbles:)
    @NSManaged public func addToHasBubbles(_ values: NSSet)

    @objc(removeHasBubbles:)
    @NSManaged public func removeFromHasBubbles(_ values: NSSet)

}

// MARK: Generated accessors for hasPets
extension UserData {

    @objc(addHasPetsObject:)
    @NSManaged public func addToHasPets(_ value: PetData)

    @objc(removeHasPetsObject:)
    @NSManaged public func removeFromHasPets(_ value: PetData)

    @objc(addHasPets:)
    @NSManaged public func addToHasPets(_ values: NSSet)

    @objc(removeHasPets:)
    @NSManaged public func removeFromHasPets(_ values: NSSet)

}
