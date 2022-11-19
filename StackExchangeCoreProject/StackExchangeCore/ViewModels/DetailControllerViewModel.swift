//
//  DetailControllerViewModel.swift
//  StackExchangeCore
//
//  Created by rasim rifat erken on 22.09.2022.
//


import Foundation
import UIKit
import CoreData

protocol AnswerTableViewDelegate: NSObjectProtocol {
    func reloadData(sender: DetailListViewModel)
}

class DetailListViewModel: NSObject, NSFetchedResultsControllerDelegate {
    
    @NSManaged fileprivate(set) var date: Date
    
    let container: NSPersistentContainer? = AddressDatabase.shared.persistentContainer
    
    var fetchedResultsController: NSFetchedResultsController<Answers>?
    
    weak var delegate: AnswerTableViewDelegate?
    
    //MARK: - Fetched Results Controller - Retrieve data from Core Data
//    func retrieveDataFromCoreData() {
//        
//        if let context = self.container?.viewContext {
//            let request: NSFetchRequest<Answers> = Answers.fetchRequest()
//            
//            request.sortDescriptors = [NSSortDescriptor(key: #keyPath(date), ascending: false)]
//        
//            self.fetchedResultsController = NSFetchedResultsController(
//                fetchRequest: request,
//                managedObjectContext: context,
////                sectionNameKeyPath: nil,
//                sectionNameKeyPath: nil ,
//                cacheName: nil
//            )
//            
//            fetchedResultsController?.delegate = self
//            
//            do {
//                try self.fetchedResultsController?.performFetch()
//            } catch {
//                print("Failed to initialize FetchedResultsController: \(error)")
//            }
//        }
//    }
    
    func a(completion: @escaping (_ dict : Answers) -> Void) {
        if let context = self.container?.viewContext {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Answers")
            request.returnsObjectsAsFaults = false
            do {
                let result = try context.fetch(request)
                for data in result as! [NSManagedObject] {
                    
                    completion(data as! Answers)
                   
              }
                
            } catch {
                
                print("Failed")
            }
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        // Update the tableView
        self.delegate?.reloadData(sender: self)
    }
    
    //MARK: - TableView DataSource functions
    func numberOfRowsInSection (section: Int) -> Int {
//        if let count = fetchedResultsController?.sections?.last?.numberOfObjects {
//            return count
//        }
        guard let sections = self.fetchedResultsController?.sections else {
            return 0
        }
        let sectionInfo = sections[section]
        return sectionInfo.numberOfObjects
       
    }
    
    func object (indexPath: IndexPath) -> Answers? {
          
        return fetchedResultsController?.object(at: indexPath)
        
        
    }
  
    
}

