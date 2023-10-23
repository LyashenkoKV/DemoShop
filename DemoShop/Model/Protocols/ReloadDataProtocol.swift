//
//  ReloadDataProtocol.swift
//  DemoShop
//
//  Created by Konstantin Lyashenko on 04.10.2023.
//

import Foundation

protocol ReloadDataProtocol {
    func didSelectCategory(_ category: Gender.Category)
    func getPost(data: [SneakerPost.Post])
    func getData(data: [SneakerModel])
}
