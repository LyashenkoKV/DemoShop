//
//  SneakerPostManager.swift
//  DemoShop
//
//  Created by Konstantin Lyashenko on 29.09.2023.
//

import Foundation
import SwiftSoup
import UIKit

struct SneakerPostManager {
    
    var delegate: ReloadDataProtocol?
    
    func getHTMLPost(url: String, completion: @escaping (Result<SneakerPost, Error>) -> Void) {
        if let url = URL(string: url) {
            let session = URLSession.shared
            let dataTask = session.dataTask(with: url) { (data, _, error) in
                if let error = error {
                    print("Ошибка при загрузке страницы: \(error)")
                    completion(.failure(error))
                    return
                }
                if let data = data, let htmlString = String(data: data, encoding: .utf8) {
                    do {
                        guard let post = try parseHTML(htmlString) else {
                            let parsingError = NSError(domain: "ParsingErrorDomain", code: 1, userInfo: nil)
                            print("Ошибка при разборе HTML")
                            completion(.failure(parsingError))
                            return
                        }
                        completion(.success(post))
                    } catch {
                        print("Ошибка при разборе HTML: \(error)")
                        completion(.failure(error))
                    }
                }
            }
            dataTask.resume()
        }
    }

    func parseHTML(_ htmlString: String) throws -> SneakerPost? {
        do {
            let doc = try SwiftSoup.parse(htmlString)
            let postElements = try doc.select(".latest-news-v2__post")
            var sneakerPosts: [SneakerPost.Post] = []
            
            for postElement in postElements {
                let imageElement = try postElement.select("img").first()
                let imageURLString = try imageElement?.attr("src")
                if let imageURLString = imageURLString,
                   let encodedURLString = imageURLString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
                   let imageURL = URL(string: encodedURLString) {
                    URLSession.shared.dataTask(with: imageURL) { (data, _, error) in
                        if let error = error {
                            print("Ошибка при загрузке изображения: \(error)")
                            return
                        }
                        do {
                            if let data = data, let image = UIImage(data: data) {
                                let titleElement = try? postElement.select("h4 a").first()
                                let title = try titleElement?.text() ?? ""
                                let linkElement = try? postElement.select("h4 a").first()
                                let linkURLString = try linkElement?.attr("href") ?? ""
                                let linkURL = URL(string: linkURLString)
                                guard let linkURL = linkURL else { return }
                                let post = SneakerPost.Post(image: image, title: title, link: linkURL)
                                sneakerPosts.append(post)
                                
                                DispatchQueue.main.async {
                                    let response = SneakerPost(sneakerPosts: sneakerPosts)
                                    self.delegate?.getPost(data: response.sneakerPosts)
                                }
                            }
                        } catch {
                            print("Ошибка при разборе HTML: \(error)")
                        }
                    }.resume()
                } else {
                    print("Invalid imageURLString: \(String(describing: imageURLString))")
                }
            }
            return nil
        } catch {
            print("Ошибка при разборе HTML: \(error)")
            return nil
        }
    }
}
