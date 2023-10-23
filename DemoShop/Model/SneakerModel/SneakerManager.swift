//
//  SneakerManager.swift
//  DemoShop
//
//  Created by Konstantin Lyashenko on 28.09.2023.
//

import UIKit

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

    func loadImage(from url: URL, completion: @escaping (Result<UIImage?, Error>) -> Void) {
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let data = data, let image = UIImage(data: data) {
                completion(.success(image))
            } else {
                completion(.success(nil))
            }
        }.resume()
    }
    
    func downloadImages(for sneaker: SneakerModel, completion: @escaping (UIImage?) -> Void) {
        guard let imageURL = URL(string: sneaker.image.thumbnail) else {
            print("Invalid thumbnail URL")
            completion(nil)
            return
        }

        loadImage(from: imageURL) { result in
            switch result {
            case .success(let image):
                if let image = image {
                    var modifiedSneaker = sneaker
                    modifiedSneaker.image.originalImage = image
                    completion(image)
                } else {
                    completion(nil)
                }
            case .failure(let error):
                print("Ошибка при загрузке изображения: \(error)")
                completion(nil)
            }
        }
    }
    
    func getSneakers(filters: [SneakerFilter], completion: @escaping (Result<[SneakerModel], Error>) -> Void) {
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

        let session = URLSession.shared
         let dataTask = session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
             if let error = error {
                 print("Ошибка при выполнении запроса: \(error)")
                 completion(.failure(error))
                 return
             }
             guard let httpResponse = response as? HTTPURLResponse else {
                 print("Некорректный HTTP-ответ")
                 return
             }
             
             switch httpResponse.statusCode {
             case 200:
                 if let data = data, let collection = self.parseJSON(data) {
                     var resultArray: [SneakerModel] = []
                     let dispatchGroup = DispatchGroup()
                     
                     for i in collection.results {
                         dispatchGroup.enter()
                         self.downloadImages(for: i) { image in
                             if let image = image {
                                 var modifiedSneaker = i
                                 modifiedSneaker.image.originalImage = image
                                 resultArray.append(modifiedSneaker)
                             }
                             dispatchGroup.leave()
                         }
                     }
                     dispatchGroup.notify(queue: .main) {
                         self.delegate?.getData(data: resultArray)
                     }
                 }
             default:
                 print("Некорректный HTTP-статус: \(httpResponse.statusCode)")
             }
         }
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
