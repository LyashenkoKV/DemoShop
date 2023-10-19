//
//  PostURL.swift
//  DemoShop
//
//  Created by Konstantin Lyashenko on 02.10.2023.
//

import Foundation

struct Gender {
    enum Category: String, CaseIterable {
        case men, women, child
        
        var url: String {
            switch self {
            case .men:
                return "https://sneakernews.com/"
            case .women:
                return "https://sneakernews.com/category/wmns"
            case .child:
                return "https://sneakernews.com/category/kids/"
            }
        }
    }
}
