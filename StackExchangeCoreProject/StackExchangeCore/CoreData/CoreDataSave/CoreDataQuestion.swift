//
//  CoreData.swift
//  StackExchangeCore
//
//  Created by rasim rifat erken on 19.09.2022.
//

import UIKit
import CoreData

class CoreDataQuestion {
    
    static let sharedInstance = CoreDataQuestion()
    private init(){}
    
    private let continer: NSPersistentContainer? = AddressDatabase.shared.persistentContainer
    
    private let fetchRequest = NSFetchRequest<Questions>(entityName: "Questions")
    
    func saveDataOf(questions:[QuestionItemsData]) {
        
        // Updates CoreData with the new data from the server - Off the main thread
        self.continer?.performBackgroundTask{ [weak self] (context) in
//            self?.deleteObjectsfromCoreData(context: context)
            self?.saveDataToCoreData(questions: questions, context: context)
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

    private func saveDataToCoreData(questions:[QuestionItemsData], context: NSManagedObjectContext) {
       
        context.perform {
            for question in questions {
                let questionsEntity = Questions(context: context)
                guard let questionid = question.questionID else {return}
                questionsEntity.questionID = String(questionid)
                guard let date = question.creationDate else {return}
                questionsEntity.date = String(date)
                questionsEntity.questionTitle = question.title
                questionsEntity.profileImage = question.owner?.profileImage
                questionsEntity.name = question.owner?.displayName
                guard let reputation = question.owner?.reputation else {return}
                questionsEntity.reputation = String(reputation)
            }
          
            do {
                try context.save()
            } catch {
                fatalError("Failure to save context: \(error)")
            }
        }
    }
}
