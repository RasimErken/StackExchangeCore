//
//  Answers+CoreDataProperties.swift
//  StackExchangeCore
//
//  Created by rasim rifat erken on 22.09.2022.
//
//

import Foundation
import CoreData


extension Answers {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Answers> {
        return NSFetchRequest<Answers>(entityName: "Answers")
    }

    @NSManaged public var name: String?
    @NSManaged public var answerNo: String?
    @NSManaged public var date: String?
    @NSManaged public var reputation: String?
    @NSManaged public var profileImage: String?
    @NSManaged public var uuID: UUID?
    @NSManaged public var score: String?

}

extension Answers : Identifiable {

}
