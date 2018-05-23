//
//  ChuckNorrisFactsService.swift
//  ChuckNorrisFacts
//
//  Created by Isa Hashim on 2/22/18.
//  Copyright © 2018 Crampsalot LLC. All rights reserved.
//

import Foundation
/*
 {"category":null,"icon_url":"https:\/\/assets.chucknorris.host\/img\/avatar\/chuck-norris.png","id":"SVDmg6M5RQekrwS_1rGRXA","url":"https:\/\/api.chucknorris.io\/jokes\/SVDmg6M5RQekrwS_1rGRXA","value":"Chuck Norris owns a squad of Oompa Loompas"}
 
 NOTE: 'category' is an array of strings.
 */
struct ChuckNorrisFact: Decodable {
    let category: [String]?
    let icon_url: String?
    let id: String?
    let url: String?
    let value: String?
}

class ChuckNorrisFactsService {
    private let FACT_URL_STRING = "https://api.chucknorris.io/jokes/random"
    
    
    static let sharedInstance = ChuckNorrisFactsService()
    
    private init() {
    }
    
    func getFact(completion: ((_ fact: String?, _ errorString: String?) -> Void)?) {
        guard let url = URL(string: FACT_URL_STRING) else {
            completion?(nil, "Error initializing url: " + FACT_URL_STRING)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let httpurlResponse = response as? HTTPURLResponse else {
                completion?(nil, "Response type is not HTTPURLResponse")
                return
            }
            
            guard httpurlResponse.statusCode == 200 else {
                completion?(nil, "HTTP status code is: \(httpurlResponse.statusCode). It should be 200")
                return
            }
            
            guard let data = data else {
                completion?(nil, "Data received back is nil")
                return
            }
            
            do {
                if let fact = try self.getFactFromJSON(jsonData: data) {
                    completion?(fact, nil)
                }
            } catch let error as NSError {
                var errorString = "JSON parsing error: \(error)"
                if let jsonDataAsString = String(data: data, encoding: .utf8) {
                    errorString += "\nJSON: " + jsonDataAsString
                }
                
                completion?(nil, errorString)
            }
            
            }.resume()
    }
    
    private func getFactFromJSON(jsonData: Data) throws -> String? {
        let cnFact = try JSONDecoder().decode(ChuckNorrisFact.self, from: jsonData)
        print(cnFact)
        return cnFact.value
    }
    
    private func getFactFromJSONOld(jsonData: Data) throws -> String? {
        if let jsonDict = try JSONSerialization.jsonObject(with: jsonData, options: .mutableLeaves) as? Dictionary<String, Any> {
            if let fact = jsonDict["value"] as? String {
                return fact
            }
        }
        
        return nil
    }
    
   
}
