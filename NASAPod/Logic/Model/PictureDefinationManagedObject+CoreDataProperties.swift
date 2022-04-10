//
//  PictureDefinationManagedObject+CoreDataProperties.swift
//  NASAPod
//
//  Created by Ankita Porwal on 10/04/22.
//
//

import Foundation
import CoreData


extension PictureDefinationManagedObject {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<PictureDefinationManagedObject> {
        return NSFetchRequest<PictureDefinationManagedObject>(entityName: "Picture")
    }
    
    @NSManaged public var date: String?
    @NSManaged public var imageUrl: String?
    @NSManaged public var explanation: String?
    @NSManaged public var isFavorite: Bool
    @NSManaged public var mediaType: String?
    @NSManaged public var title: String?
    @NSManaged public var url: String?
    
    func update(with jsonDictionary: [String: Any]) throws {
        guard let date = jsonDictionary["date"] as? String,
              let explanation = jsonDictionary["explanation"] as? String,
              let imageUrl = jsonDictionary["hdurl"] as? String,
              let mediaType = jsonDictionary["media_type"] as? String,
              let title = jsonDictionary["title"] as? String,
              let url = jsonDictionary["url"] as? String
        else {
            throw NSError(domain: "", code: 100, userInfo: nil)
        }
        
        self.date = date
        self.explanation = explanation
        self.imageUrl = imageUrl
        self.mediaType = mediaType
        self.title = title
        self.url = url
    }
    
}

extension PictureDefinationManagedObject : Identifiable {
    
}
