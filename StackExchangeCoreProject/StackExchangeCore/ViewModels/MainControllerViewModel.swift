//
//  MainControllerViewModel.swift
//  StackExchangeCore
//
//  Created by rasim rifat erken on 19.09.2022.
//

import Foundation
import UIKit
import CoreData

protocol UpdateTableViewDelegate: NSObjectProtocol {
    func reloadData(sender: MoviesListViewModel)
}

class MoviesListViewModel: NSObject, NSFetchedResultsControllerDelegate {
    
    let container: NSPersistentContainer? =  AddressDatabase.shared.persistentContainer
    
    var fetchedResultsController: NSFetchedResultsController<Questions>?
    
    weak var delegate: UpdateTableViewDelegate?
    
    //MARK: - Fetched Results Controller - Retrieve data from Core Data
//    func retrieveDataFromCoreData() {
//        
//        if let context = self.container?.viewContext {
//            let request: NSFetchRequest<Questions> = Questions.fetchRequest()
//            
//            request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: false)]
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
    
    func a(completion: @escaping (_ dict : Questions) -> Void) {
        if let context = self.container?.viewContext {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Questions")
            request.returnsObjectsAsFaults = false
            do {
                let result = try context.fetch(request)
                for data in result as! [NSManagedObject] {
                    
                    completion(data as! Questions)
                   
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
    
    func object (indexPath: IndexPath) -> Questions? {
       
        return fetchedResultsController?.object(at: indexPath)
        
    }
  
    
}
