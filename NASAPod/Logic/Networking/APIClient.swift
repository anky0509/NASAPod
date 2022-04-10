//
//  NetworkOperatiom.swift
//  NASAPod
//
//  Created by Ankita Porwal on 09/04/22.
//

import Foundation

struct Failure: Error {
    var message: String?
}

struct APIRequest {
    var path: String
    var parameters: [String: String]
}

final class APIClient {
    
    func execute(request: APIRequest, completionHandler: @escaping (_ result: Result<[String: Any]?, Error>?) -> Void) {
        var parameters = request.parameters
        parameters.updateValue(URLValues.NASAAPIKey, forKey: URLKeys.APIKey)
        
        let requestURL = constructURL(path: request.path, parameters: parameters)
        
        URLSession.shared.dataTask(with: requestURL) { (responseData, response, error) in
            guard (error == nil) else {
                completionHandler(.failure(Failure(message: error?.localizedDescription)))
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                let code: String = String((response as? HTTPURLResponse)?.statusCode ?? 0)
                completionHandler(.failure(Failure(message: "Something went wrong!!! We have received \(code)")))
                return
            }
            
            guard let data = responseData, data.count != 0 else {
                completionHandler(.failure(Failure(message: error?.localizedDescription)))
                return
            }
            
            do {
                let result = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                completionHandler(.success(result as? [String: Any]))
            } catch let error {
                completionHandler(.failure(Failure(message: error.localizedDescription)))
            }
        }.resume()
    }
    
    private func constructURL(path: String, parameters: [String: String]?) -> URL {
        var components = URLComponents()
        components.scheme = Constants.ApiScheme
        components.host = Constants.ApiHost
        components.path = path
        guard let parameters = parameters else { return components.url! }
        var queryItems: [URLQueryItem] = [URLQueryItem]()
        for (key,value) in parameters {
            queryItems.append(URLQueryItem(name: key, value: value))
        }
        components.queryItems = queryItems
        return components.url!
    }
}

