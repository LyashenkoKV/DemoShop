//
//  ItemCell.swift
//  DemoShop
//
//  Created by Konstantin Lyashenko on 19.09.2023.
//

import UIKit

class ItemCell: UICollectionViewCell, SelfConfigureCellProtocol {
    static var reuseId = "ItemCell"
    
    let friendImageViewSelf = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .purple
        
        self.clipsToBounds = true
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupConstraints() {
        friendImageViewSelf.translatesAutoresizingMaskIntoConstraints = false
        friendImageViewSelf.backgroundColor = .systemPink
        addSubview(friendImageViewSelf)
        friendImageViewSelf.frame = self.bounds
    }
    
    func configure(with intValue: Int) {
        print("321")
    }
}
