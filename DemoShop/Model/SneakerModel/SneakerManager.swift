//
//  SneakerManager.swift
//  DemoShop
//
//  Created by Konstantin Lyashenko on 28.09.2023.
//

import Foundation

enum SneakerFilter {
    case brand(String)
    case name(String)
    case gender(String)
    case colorway(String)
    case releaseYear(String)
    case limit(String)
    
    var queryString: String {
        switch self {
        case .brand(let value):
            return "brand=\(value)"
        case .name(let value):
            return "name=\(value)"
        case .gender(let value):
            return "gender=\(value)"
        case .colorway(let value):
            return "colorway=\(value)"
        case .limit(let value):
            return "limit=\(value)"
        case .releaseYear(let value):
            return "releaseYear=\(value)"
        }
    }
}

struct SneakerManager {
    
    var delegate: ReloadDataProtocol?
    
    func getSneakers(filters: [SneakerFilter]) {
        var headers: [String: String]?
        let urlString = "https://the-sneaker-database.p.rapidapi.com/sneakers?"
        let queryParams = filters.map { $0.queryString }
        let queryString = queryParams.joined(separator: "&")
        let fullURLString = urlString + queryString
        
        if let path = Bundle.main.path(forResource: "ApiKeys", ofType: "plist"),
           let data = try? Data(contentsOf: URL(filePath: path)),
           let keys = try? PropertyListSerialization.propertyList(from: data, format: nil) as? [String: Any],
           let rapidAPIKey = keys["rapidAPIKey"] as? String {
            headers = [
                "X-RapidAPI-Key": rapidAPIKey,
                "X-RapidAPI-Host": "the-sneaker-database.p.rapidapi.com"
            ]
        }
        
        let request = NSMutableURLRequest(url: NSURL(string: fullURLString)! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        var resultArray: [SneakerModel] = []
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error as Any)
            } else {
                if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode == 200 {
                        if let data = data {
                            if let collection = self.parseJSON(data) {
                                for i in collection.results {
                                    resultArray.append(i)
                                }
                                self.delegate?.getData(data: resultArray)
                            }
                        }
                    }
                } else {
                    if let errorData = data, let errorString = String(data: errorData, encoding: .utf8) {
                        print("Error Response: \(errorString)")
                    }
                }
            }
        })
        dataTask.resume()
    }
    
    func parseJSON(_ jsonData: Data) -> SneakerCollectionModel? {
        do {
            let decoder = JSONDecoder()
            let collection = try decoder.decode(SneakerCollectionModel.self, from: jsonData)
            return collection
        } catch {
            print("Error parsing JSON: \(error)")
            return nil
        }
    }
}
