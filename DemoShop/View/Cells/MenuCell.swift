//
//  MenuCell.swift
//  DemoShop
//
//  Created by Konstantin Lyashenko on 19.09.2023.
//

import UIKit

class MenuCell: UICollectionViewCell, SelfConfigureCellProtocol {
    static var reuseId = "MenuCell"
    
    let friendImageView = UIImageView()
    
    var firstButton: UIButton!
    var secondButton: UIButton!
    var thirdButton: UIButton!
    
    var firstUnderline: UIView!
    var secondUnderline: UIView!
    var thirdUnderline: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.clipsToBounds = true
        setupUI()
        firstButton.isSelected = true
        firstUnderline.backgroundColor = .black
        firstButton.addTarget(self, action: #selector(buttonOneTapped), for: .touchUpInside)
        secondButton.addTarget(self, action: #selector(buttonTwoTapped), for: .touchUpInside)
        thirdButton.addTarget(self, action: #selector(buttonThreeTapped), for: .touchUpInside)
    }
    
    func setupUI() {
        let verticalStack1 = UIStackView()
        verticalStack1.axis = .vertical
        verticalStack1.alignment = .leading
        
        let spacingView = UIView()
        spacingView.heightAnchor.constraint(equalToConstant: 10).isActive = true
        verticalStack1.addArrangedSubview(spacingView)
        
        let horizontalStack1_1 = UIStackView()
        horizontalStack1_1.axis = .horizontal
        horizontalStack1_1.spacing = 10
        verticalStack1.addArrangedSubview(horizontalStack1_1)
        
        let leftMarginStack = UIStackView()
        leftMarginStack.axis = .vertical
        leftMarginStack.widthAnchor.constraint(equalToConstant: 10).isActive = true
        horizontalStack1_1.addArrangedSubview(leftMarginStack)
        
        let leftMarginView = UIView()
        leftMarginStack.addArrangedSubview(leftMarginView)
        
        let firstButtonStack = UIStackView()
        firstButtonStack.axis = .vertical
        horizontalStack1_1.addArrangedSubview(firstButtonStack)
        
        firstButton = UIButton()
        firstButton.setTitle("Men", for: .normal)
        firstButton.setTitleColor(UIColor.gray, for: .normal)
        firstButton.setTitleColor(UIColor.black, for: .selected)
        firstButtonStack.addArrangedSubview(firstButton)
        
        let secondButtonStack = UIStackView()
        secondButtonStack.axis = .vertical
        horizontalStack1_1.addArrangedSubview(secondButtonStack)
        
        secondButton = UIButton()
        secondButton.setTitle("Women", for: .normal)
        secondButton.setTitleColor(UIColor.gray, for: .normal)
        secondButton.setTitleColor(UIColor.black, for: .selected)
        secondButtonStack.addArrangedSubview(secondButton)
        
        let thirdButtonStack = UIStackView()
        thirdButtonStack.axis = .vertical
        horizontalStack1_1.addArrangedSubview(thirdButtonStack)
        
        thirdButton = UIButton()
        thirdButton.setTitle("Kids", for: .normal)
        thirdButton.setTitleColor(UIColor.gray, for: .normal)
        thirdButton.setTitleColor(UIColor.black, for: .selected)
        thirdButtonStack.addArrangedSubview(thirdButton)
        
        let spacerView = UIView()
        spacerView.heightAnchor.constraint(equalToConstant: 2).isActive = true
        leftMarginStack.addArrangedSubview(spacerView)
        
        firstUnderline = UIView()
        firstUnderline.heightAnchor.constraint(equalToConstant: 2).isActive = true
        firstButtonStack.addArrangedSubview(firstUnderline)
        
        secondUnderline = UIView()
        secondUnderline.heightAnchor.constraint(equalToConstant: 2).isActive = true
        secondButtonStack.addArrangedSubview(secondUnderline)
        
        thirdUnderline = UIView()
        thirdUnderline.heightAnchor.constraint(equalToConstant: 2).isActive = true
        thirdButtonStack.addArrangedSubview(thirdUnderline)
        
        let lineView = UIView()
        lineView.widthAnchor.constraint(equalToConstant: self.frame.width).isActive = true
        lineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        lineView.backgroundColor = .lightGray
        verticalStack1.addArrangedSubview(lineView)
        
        contentView.addSubview(verticalStack1)
        verticalStack1.translatesAutoresizingMaskIntoConstraints = false
    }
    
    @objc func buttonOneTapped() {
        firstButton.isSelected = true
        secondButton.isSelected = false
        thirdButton.isSelected = false
        firstUnderline.backgroundColor = .black
        secondUnderline.backgroundColor = .clear
        thirdUnderline.backgroundColor = .clear
    }
    
    @objc func buttonTwoTapped() {
        firstButton.isSelected  = false
        secondButton.isSelected  = true
        firstUnderline.backgroundColor = .clear
        secondUnderline.backgroundColor = .black
        thirdUnderline.backgroundColor = .clear
    }
    
    @objc func buttonThreeTapped() {
        secondButton.isSelected  = false
        thirdButton.isSelected  = true
        firstUnderline.backgroundColor = .clear
        secondUnderline.backgroundColor = .clear
        thirdUnderline.backgroundColor = .black
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with intValue: Int) {
        print("123")
    }
}


// MARK: - SwiftUI
import SwiftUI

struct MenuCellViewControllerAdapter: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> some UIViewController {
        return ViewController()
    }
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
}

struct MenuAdvancedProvider: PreviewProvider {
    static var previews: some View {
        ViewControllerAdapter()
    }
}
