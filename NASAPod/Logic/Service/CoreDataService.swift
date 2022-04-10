//
//  CoreDataService.swift
//  NASAPod
//
//  Created by Ankita Porwal on 09/04/22.
//

import Foundation
import CoreData
import UIKit

class CoreDataService {
    
    private lazy var persistentContainer: NSPersistentContainer? = {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return nil
        }
        return appDelegate.persistentContainer
    }()
    
    func fetchPicture(forDate date: String, completionHandler: @escaping (_ picture: PictureDefinationManagedObject?, _ error: Error?) -> Void) {
        guard let persistentContainer = self.persistentContainer else {
            return
        }
        let managedContext = persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<PictureDefinationManagedObject>(entityName: "Picture")
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = NSPredicate(format: "date = %@", date )
        
        do {
            let picture = try managedContext.fetch(fetchRequest).first
            completionHandler(picture, nil)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            completionHandler(nil, error)
        }
    }
    
    func fetchFavoritePictures( completionHandler: @escaping (_ pictures: [PictureDefinationManagedObject]?, _ error: Error?) -> Void) {
        guard let persistentContainer = self.persistentContainer else {
            return
        }
        let managedContext = persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<PictureDefinationManagedObject>(entityName: "Picture")
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.predicate = NSPredicate(format: "isFavorite = true")
        do {
            let pictures = try managedContext.fetch(fetchRequest)
            completionHandler(pictures, nil)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            completionHandler(nil, error)
        }
    }
    
    func updatePictureToCoreData(data: [String: Any], completionHandler: @escaping (_ picture: PictureDefinationManagedObject?, _ error: Error?) -> Void) {
        guard let persistentContainer = self.persistentContainer, let date = data["date"] as? String else { return }
        
        let taskContext = persistentContainer.newBackgroundContext()
        taskContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        taskContext.undoManager = nil
        
        taskContext.performAndWait {
            let matchingPictureRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Picture")
            matchingPictureRequest.predicate = NSPredicate(format: "date = %@", date)
            let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: matchingPictureRequest)
            batchDeleteRequest.resultType = .resultTypeObjectIDs
            
            do {
                let batchDeleteResult = try taskContext.execute(batchDeleteRequest) as? NSBatchDeleteResult
                
                if let deletedObjectIDs = batchDeleteResult?.result as? [NSManagedObjectID] {
                    NSManagedObjectContext.mergeChanges(fromRemoteContextSave: [NSDeletedObjectsKey: deletedObjectIDs],
                                                        into: [persistentContainer.viewContext])
                }
            } catch {
                print("Error: \(error)\ndelete operation failed")
                completionHandler(nil, error)
            }
            
            guard let picture = NSEntityDescription.insertNewObject(forEntityName: "Picture", into: taskContext) as? PictureDefinationManagedObject else {
                print("Error: failed to create object")
                completionHandler(nil, nil)
                return
            }
            
            var error1: Error?
            do {
                try picture.update(with: data)
            } catch {
                print("Error: \(error)\nobject will be deleted")
                taskContext.delete(picture)
                error1 = error
            }
            
            if taskContext.hasChanges {
                do {
                    try taskContext.save()
                } catch {
                    print("Error: \(error)\nnot able to save to coredata")
                    error1 = error
                }
                taskContext.reset()
                completionHandler(picture, error1)
            }
        }
    }
    
    func toggleFavorite(_ picture: PictureDefinationManagedObject, completionHandler: @escaping (_ success: Bool, _ error: Error?) -> Void) {
        guard let persistentContainer = self.persistentContainer else { return }
        picture.isFavorite = !picture.isFavorite
        do {
            try persistentContainer.viewContext.save()
            completionHandler(true, nil)
        } catch {
          print("error in update record")
            completionHandler(false, error)
        }
    }
}
