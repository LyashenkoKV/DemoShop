//
//  SneakerModel.swift
//  DemoShop
//
//  Created by Konstantin Lyashenko on 28.09.2023.
//

import Foundation

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
    let image: SneakerImageModel
    let story: String
}

struct SneakerImageModel: Decodable {
    let original: String
    let small: String
    let thumbnail: String
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
