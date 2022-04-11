//
//  Services.swift
//  CodingChallengeAPOD
//
//  Created by Gurleen kaur on 9/4/22.
//

import Foundation
import Alamofire

class NetworkManager: NSObject {
    
    static let sharedInstance : NetworkManager = {
        return NetworkManager()
    }()
    
    
    func sendRequest(_ url: String, parameters: [String: String], completion: @escaping ([String:Any]?, Error?) -> Void) {
        
        var components = URLComponents(string: url)!
        components.queryItems = parameters.map { (key, value) in
            URLQueryItem(name: key, value: value)
        }
        components.percentEncodedQuery = components.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
        let request = URLRequest(url: components.url!)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard
                let data = data,
                let response = response as? HTTPURLResponse,
                200 ..< 300 ~= response.statusCode,
                error == nil
            else {
                completion(nil, error)
                return
            }
            
            let responseObject = (try? JSONSerialization.jsonObject(with: data)) as? [String: Any]
            completion(responseObject, nil)
        }
        task.resume()
    }
}

//MARK: - Decoding...
extension JSONDecoder {
    func decodeObject<Item: Decodable>(_ type: Item.Type, from data: Any) -> Item? {
        
        guard let serializedUserData = try? JSONSerialization.data(withJSONObject: data) else {
            return nil
        }
        
        do {
            let item = try JSONDecoder().decode(type, from: serializedUserData)
            return item
        } catch {
            return nil
        }
    }
}
