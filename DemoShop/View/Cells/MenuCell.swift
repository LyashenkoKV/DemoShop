//
//  MenuCell.swift
//  DemoShop
//
//  Created by Konstantin Lyashenko on 19.09.2023.
//

import UIKit

class MenuCell: UICollectionViewCell, SelfConfigureCellProtocol {
    static var reuseId = "MenuCell"

    var delegate: ReloadDataProtocol?
    
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
        firstButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        secondButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        thirdButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
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
    
    @objc func buttonTapped(_ sender: UIButton) {
        firstButton.isSelected = (sender == firstButton)
        secondButton.isSelected = (sender == secondButton)
        thirdButton.isSelected = (sender == thirdButton)
        
        firstUnderline.backgroundColor = (sender == firstButton) ? .black : .clear
        secondUnderline.backgroundColor = (sender == secondButton) ? .black : .clear
        thirdUnderline.backgroundColor = (sender == thirdButton) ? .black : .clear
        
        switch sender {
        case firstButton:
            delegate?.didSelectCategory(.men)
        case secondButton:
            delegate?.didSelectCategory(.women)
        case thirdButton:
            delegate?.didSelectCategory(.child)
        default:
            break
        }
    }
    
    func configureCell(with data: Any) {
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - SwiftUI
import SwiftUI

struct MenuCellViewControllerAdapter: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> some UIViewController {
        return ShopViewController()
    }
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
}

struct MenuAdvancedProvider: PreviewProvider {
    static var previews: some View {
        ViewControllerAdapter()
    }
}

