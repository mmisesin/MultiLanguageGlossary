//
//  DictionaryService.swift
//  MultiLanguageGlossary
//
//  Created by Artem Misesin on 4/19/18.
//  Copyright © 2018 misesin. All rights reserved.
//

import Foundation

class DictionaryService {
    
    static let appId = "59dee158"
    static let appKey = "4cec1f4408274f9b097640c62e0ca6ce"
    
    enum RequestBuilder {
        case define(word: String)
        
        private var baseURL: String {
            switch self {
            case .define(let word):
                let urlWord = word.lowercased()
                return "https://od-api.oxforddictionaries.com/api/v1/entries/en/\(urlWord)"
            }
        }
        
        private var url: URL? {
            switch self {
            case .define:
                return URL(string: baseURL)
            }
        }
        
        var request: URLRequest? {
            guard
                let url = self.url
            else {
                return nil
            }
            var request = URLRequest(url: url)
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.addValue(DictionaryService.appId, forHTTPHeaderField: "app_id")
            request.addValue(DictionaryService.appKey, forHTTPHeaderField: "app_key")
            return request
        }
    }
    
    func getDefinition(for word: String, callback: @escaping (DefinitionResult?, Error?) -> Void) {
        let builder = RequestBuilder.define(word: word)
        if let request = builder.request {
            let session = URLSession.shared
            _ = session.dataTask(with: request, completionHandler: { data, response, error in
                guard error == nil,
                    let httpResponse = response as? HTTPURLResponse,
                    httpResponse.statusCode == 200,
                    let data = data
                else {
                    callback(nil, error)
                    return
                }
                let decoder = JSONDecoder()
                do {
                    let result = try decoder.decode(DefinitionResult.self, from: data)
                    callback(result, nil)
                } catch let lastError{
                    print(lastError)
                    callback(nil, lastError)
                }
//                do {
//                    let jsonData = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
//                    print(response)
//                    print(jsonData)
//                } catch {
//                    print(error)
//                    print(NSString.init(data: data, encoding: String.Encoding.utf8.rawValue))
//                }
            }).resume()
        }
    }
    
}
