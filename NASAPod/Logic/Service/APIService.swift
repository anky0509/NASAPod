//
//  APIService.swift
//  NASAPod
//
//  Created by Ankita Porwal on 09/04/22.
//

import Foundation
import CoreData

class APIService {
    private var operation: APIClient
    private var coreDataService: CoreDataService
    
    init() {
        operation = APIClient.init()
        coreDataService = CoreDataService.init()
    }
    
    func fetchPicture(forDate date: String, completionHandler: @escaping (_ picture: PictureDefinationManagedObject?, _ error: Error?) -> Void) {
        
        let fetchAndSavePicture = { [unowned self] in
            let request = APIRequest(path: "/planetary/apod", parameters: [URLKeys.date: date])
            operation.execute(request: request) { result in
                switch result {
                case .success(let data):
                    if let data = data {
                        self.coreDataService.updatePictureToCoreData(data: data) { picture, error in
                            if let _ = picture {
                                self.coreDataService.fetchPicture(forDate: date) { picture, error in
                                    completionHandler(picture, error)
                                }
                            } else {
                                completionHandler(picture, error)
                            }
                        }
                    } else {
                        completionHandler(nil, nil)
                    }
                case .failure(let error):
                    guard let error = error as? Failure else {
                        return
                    }
                    completionHandler(nil, error);
                case .none:
                    break
                }
            }
        }
        coreDataService.fetchPicture(forDate: date) { picture, error in
            if let picture = picture {
                completionHandler(picture, nil)
            } else {
                fetchAndSavePicture()
            }
        }
    }
    
    func fetchFavPictures(completionHandler: @escaping (_ pictures: [PictureDefinationManagedObject]?, _ error: Error?) -> Void) {
        coreDataService.fetchFavoritePictures(completionHandler: completionHandler)
    }
    
    func toggleFavorite(_ picture: PictureDefinationManagedObject, completionHandler: @escaping (_ success: Bool, _ error: Error?) -> Void) {
        coreDataService.toggleFavorite(picture, completionHandler: completionHandler)
    }
}
