//
//  CoreDataAnswer.swift
//  StackExchangeCore
//
//  Created by rasim rifat erken on 22.09.2022.
//


import UIKit
import CoreData

class CoreDataAnswer {
    
    static let sharedInstance = CoreDataAnswer()
    private init(){}
    
//    private let continer: NSPersistentContainer? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    private let continer: NSPersistentContainer? = AddressDatabase.shared.persistentContainer
    
    private let fetchRequest = NSFetchRequest<Answers>(entityName: "Answers")
    
    func saveDataOf(answers:[GetAnsweredItemsData]) {
        
        // Updates CoreData with the new data from the server - Off the main thread
        self.continer?.performBackgroundTask{ [weak self] (context) in
//            self?.deleteObjectsfromCoreData(context: context)
            self?.saveDataToCoreData(answers: answers, context: context)
        }
    }

    private func deleteObjectsfromCoreData(context: NSManagedObjectContext) {
        do {
            // Fetch Data
            let objects = try context.fetch(fetchRequest)
            
            // Delete Data
            _ = objects.map({context.delete($0)})
            
            // Save Data
            try context.save()
        } catch {
            print("Deleting Error: \(error)")
        }
    }

    private func saveDataToCoreData(answers:[GetAnsweredItemsData], context: NSManagedObjectContext) {
       
        context.perform {
            for answer in answers {
                let answersEntity = Answers(context: context)
                guard let fakeReputation = answer.owner?.reputation else {return}
                answersEntity.reputation = String(fakeReputation)
                answersEntity.profileImage = answer.owner?.profileImage
                guard let fakeDate = answer.creationDate else {return}
                answersEntity.date = String(fakeDate)
                guard let fakeAnswer = answer.questionID else {return}
                answersEntity.answerNo = String(fakeAnswer)
                guard let fakeScore = answer.score else {return}
                answersEntity.score = String(fakeScore)
                answersEntity.name = answer.owner?.displayName
                
            }
            do {
                try context.save()
            } catch {
                fatalError("Failure to save context: \(error)")
            }
        }
    }
}
