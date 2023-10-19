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
    
    var delegate: PostProtocol?
    
    func getHTMLPost() {
        if let url = URL(string: "https://sneakernews.com/") {
            let session = URLSession.shared
            let dataTask = session.dataTask(with: url) { (data, response, error) in
                
                if let error = error {
                    print("Ошибка при загрузке стрыницы: \(error)")
                    return
                }
                if let data = data, let htmlString = String(data: data, encoding: .utf8) {
                    DispatchQueue.main.async {
                        if let post = self.parseHTML(htmlString) {
                            self.delegate?.getPost(data: post.sneakerPosts)
                        }
                    }
                }
            }
            dataTask.resume()
        }
    }
    
    func parseHTML(_ htmlString: String) -> SneakerPost? {
        do {
            let doc = try SwiftSoup.parse(htmlString)
            let postElements = try doc.select(".post-box")
            
            var sneakerPosts: [SneakerPost.Post] = []
            
            for postElement in postElements {
                let imageElement = try postElement.select("img").first()
                let imageURLString = try imageElement?.attr("src")
                let imageURL = URL(string: imageURLString ?? "")
                
                if let imageURL = imageURL {
                    URLSession.shared.dataTask(with: imageURL) { (data, response, error) in
                        if let error = error {
                            print("Ошибка при загрузке изображения: \(error)")
                            return
                        }
                        do {
                            if let data = data, let image = UIImage(data: data) {
                                let titleElement = try? postElement.select("h4 a").first()
                                let title = try titleElement?.text() ?? ""
                                
                                let dateElement = try? postElement.select("span").first { element in
                                    try element.text().contains("20")
                                }
                                let date = try dateElement?.text() ?? ""
                                
                                let authorElement = try? postElement.select(".posted-by a").first()
                                let author = try authorElement?.text() ?? ""
                                
                                let linkElement = try? postElement.select("h4 a").first()
                                let linkURLString = try linkElement?.attr("href") ?? ""
                                let linkURL = URL(string: linkURLString)
                                
                                let post = SneakerPost.Post(image: image, title: title, date: date, author: author, link: linkURL!)
                                sneakerPosts.append(post)
                                
                                DispatchQueue.main.async {
                                    let response = SneakerPost(sneakerPosts: sneakerPosts)
                                    //print(response)
                                    self.delegate?.getPost(data: response.sneakerPosts)
                                }
                            }
                        } catch {
                            print("Ошибка при разборе HTML: \(error)")
                        }
                    }.resume()
                }
            }
            return nil
        } catch {
            print("Ошибка при разборе HTML: \(error)")
            return nil
        }
    }
}
