//
//  Questions+CoreDataProperties.swift
//  StackExchangeCore
//
//  Created by rasim rifat erken on 22.09.2022.
//
//

import Foundation
import CoreData


extension Questions {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Questions> {
        return NSFetchRequest<Questions>(entityName: "Questions")
    }

    @NSManaged public var name: String?
    @NSManaged public var questionTitle: String?
    @NSManaged public var questionID: String?
    @NSManaged public var profileImage: String?
    @NSManaged public var uuID: UUID?
    @NSManaged public var reputation: String?
    @NSManaged public var date: String?

}

extension Questions : Identifiable {

}
