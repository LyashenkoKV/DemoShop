//
//  SneakerModel.swift
//  DemoShop
//
//  Created by Konstantin Lyashenko on 28.09.2023.
//

import Foundation
import UIKit

struct SneakerModel: Decodable {
    let id: String
    let brand: String
    let name: String
    let colorway: String
    let gender: String
    let silhouette: String
    let retailPrice: Int
    let releaseDate: String
    let releaseYear: String
    let links: SneakerLinksModel
    var image: SneakerImageModel
    let story: String
}

struct SneakerImageModel: Decodable {
    let original: String
    let small: String
    let thumbnail: String
    var originalImage: UIImage?
    
    enum CodingKeys: String, CodingKey {
        case original, small, thumbnail
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        original = try container.decode(String.self, forKey: .original)
        small = try container.decode(String.self, forKey: .small)
        thumbnail = try container.decode(String.self, forKey: .thumbnail)
        originalImage = nil
    }
}

struct SneakerLinksModel: Decodable {
    let stockX: String
    let goat: String
    let flightClub: String
}

struct SneakerCollectionModel: Decodable {
    let count: Int
    let results: [SneakerModel]
}
