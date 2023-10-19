//
//  SneakerPost.swift
//  DemoShop
//
//  Created by Konstantin Lyashenko on 29.09.2023.
//

import Foundation
import UIKit

struct SneakerPost {
    struct Post {
        let image: UIImage
        let title: String
        let date: String
        let author: String
        let link: URL
    }
    var sneakerPosts: [Post]
}
