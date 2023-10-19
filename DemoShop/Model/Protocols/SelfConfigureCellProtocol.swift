//
//  SelfConfigureCellProtocol.swift
//  DemoShop
//
//  Created by Konstantin Lyashenko on 19.09.2023.
//

import Foundation

protocol SelfConfigureCellProtocol {
    static var reuseId: String { get }
    func configure(with intValue: Int)
}
