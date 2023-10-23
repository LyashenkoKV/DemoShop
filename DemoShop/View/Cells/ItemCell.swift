//
//  ItemCell.swift
//  DemoShop
//
//  Created by Konstantin Lyashenko on 19.09.2023.
//

import UIKit

class ItemCell: UICollectionViewCell, SelfConfigureCellProtocol {
    static var reuseId = "ItemCell"
    
    var benefitHeightConstrains: NSLayoutConstraint?
    var locationHeightConstrains: NSLayoutConstraint?
    
    func configureCell(with data: Any) {
        if let data = data as? SneakerModel {
            brandName.text = data.name
            sneakerImage.image = data.image.originalImage
            sneakerAttributeLabel.attributedText = attributeInfoLabel(withBrand: data.brand, withColor: data.colorway, withReliseYear: Int(data.releaseYear) ?? 0)
            benefitLabel.text = data.silhouette
            offerLabel.text = String("\(data.retailPrice)$")
        }
    }
    
    lazy var imageCard: UIView = {
        let card = UIView()
        card.translatesAutoresizingMaskIntoConstraints = false
        return card
    }()
    
    lazy var sneakerImage: UIImageView = {
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.contentMode = .scaleAspectFit
        img.clipsToBounds = true
        img.layer.cornerRadius = 8
        return img
    }()
    
    lazy var offerView: UIView = {
        let offer = UIView()
        offer.translatesAutoresizingMaskIntoConstraints = false
        offer.backgroundColor = .systemBackground
        offer.layer.cornerRadius = 5
        offer.layer.borderWidth = 0.6
        offer.layer.borderColor = UIColor.gray.withAlphaComponent(0.3).cgColor
        offer.layer.shadowColor = UIColor.gray.withAlphaComponent(0.3).cgColor
        offer.layer.shadowOffset = CGSize(width: 0, height: 4)
        offer.layer.shadowOpacity = 1
        offer.layer.shadowRadius = 5
        return offer
    }()
    
    let offerLabel: UILabel = {
        let o = UILabel()
        o.translatesAutoresizingMaskIntoConstraints = false
        o.textAlignment = .center
        o.numberOfLines = 2
        return o
    }()
    
    lazy var brandName: UILabel = {
        let res = UILabel()
        res.translatesAutoresizingMaskIntoConstraints = false
        res.font = UIFont.systemFont(ofSize: 15,weight: .bold)
        res.textColor = .label
        return res
    }()
    
    let sneakerAttributeLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    let tagLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont.systemFont(ofSize: 13,weight: .regular)
        l.textColor = .darkGray.withAlphaComponent(0.8)
        return l
    }()
    
    let locationLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.textColor = .darkGray.withAlphaComponent(0.8)
        l.font = UIFont.systemFont(ofSize: 13,weight: .regular)
        return l
    }()
    
    let benefitView: UIView = {
        let bn = UIView()
        bn.translatesAutoresizingMaskIntoConstraints = false
        bn.layer.cornerRadius = 8
        bn.layer.cornerCurve = .continuous
        bn.layer.masksToBounds = true
        return bn
    }()
    
    let gradientView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let benefitIcon: UIImageView = {
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.contentMode = .scaleAspectFit
        img.image = UIImage(named: "ic_benefit")
        return img
    }()
    
    let benefitLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.textColor = .orange
        l.font = UIFont.systemFont(ofSize: 11,weight: .bold)
        return l
    }()
    
    // MARK: MAIN -
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        setUpConstrains()
    }
    
    func configure(){
        addSubview(imageCard)
        imageCard.addSubview(sneakerImage)
        
        addSubview(offerView)
        offerView.addSubview(offerLabel)
        
        addSubview(brandName)
        addSubview(sneakerAttributeLabel)
        addSubview(tagLabel)
        addSubview(locationLabel)
        
        addSubview(benefitView)
        benefitView.addSubview(gradientView)
        benefitView.addSubview(benefitIcon)
        benefitView.addSubview(benefitLabel)
        
        DispatchQueue.main.asyncAfter(deadline: .now()) { [self] in
            gradientView.setGradient(withColors: [UIColor.white.withAlphaComponent(0).cgColor, UIColor.orange.withAlphaComponent(0.3).cgColor], startPoint: CGPoint(x: 0.0, y: 1.0), endPoint: CGPoint(x: 1.0, y: 1.0))
        }
        
    }
    
    func setUpConstrains(){
        sneakerImage.setUp(to: imageCard)
        offerLabel.setUp(to: offerView)
        gradientView.setUp(to: benefitView)
        
        NSLayoutConstraint.activate([
            imageCard.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageCard.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            imageCard.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            imageCard.widthAnchor.constraint(equalToConstant: 100),
            
            offerView.leadingAnchor.constraint(equalTo: imageCard.leadingAnchor, constant: 5),
            offerView.trailingAnchor.constraint(equalTo: imageCard.trailingAnchor, constant: -5),
            offerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            offerView.heightAnchor.constraint(equalToConstant: 32),
            
            brandName.leadingAnchor.constraint(equalTo: imageCard.trailingAnchor, constant: 15),
            brandName.trailingAnchor.constraint(equalTo: trailingAnchor),
            brandName.bottomAnchor.constraint(equalTo: sneakerAttributeLabel.topAnchor, constant: -3),
            
            sneakerAttributeLabel.leadingAnchor.constraint(equalTo: imageCard.trailingAnchor, constant: 15),
            sneakerAttributeLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            sneakerAttributeLabel.bottomAnchor.constraint(equalTo: tagLabel.topAnchor, constant: -5),
            
            tagLabel.leadingAnchor.constraint(equalTo: imageCard.trailingAnchor, constant: 15),
            tagLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            tagLabel.bottomAnchor.constraint(equalTo: locationLabel.topAnchor, constant: -8),
            
            locationLabel.leadingAnchor.constraint(equalTo: imageCard.trailingAnchor, constant: 15),
            locationLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            benefitView.leadingAnchor.constraint(equalTo: imageCard.trailingAnchor, constant: 15),
            benefitView.trailingAnchor.constraint(equalTo: trailingAnchor),
            benefitView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15),
            
            benefitLabel.leadingAnchor.constraint(equalTo: benefitView.leadingAnchor, constant: 5),
            benefitLabel.trailingAnchor.constraint(equalTo: benefitView.trailingAnchor, constant: -10),
            benefitLabel.centerYAnchor.constraint(equalTo: benefitView.centerYAnchor),
            
            benefitIcon.trailingAnchor.constraint(equalTo: benefitView.trailingAnchor, constant: -5),
            benefitIcon.centerYAnchor.constraint(equalTo: benefitView.centerYAnchor),
            benefitIcon.widthAnchor.constraint(equalToConstant: 40),
            benefitIcon.heightAnchor.constraint(equalToConstant: 25)
        ])
        
        benefitHeightConstrains = benefitView.heightAnchor.constraint(equalToConstant: 30)
        benefitHeightConstrains?.isActive = true
        
        locationHeightConstrains = locationLabel.bottomAnchor.constraint(equalTo: benefitView.topAnchor, constant: -8)
        locationHeightConstrains?.isActive = true
        
    }
    
    func setOfferAttributedLabel(withTitle title: String, withSubtitle subtitle: String) -> NSAttributedString {
        let attributedText = NSMutableAttributedString(attributedString: NSAttributedString(string: title.uppercased(), attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13,weight: .bold) , NSAttributedString.Key.foregroundColor: UIColor.orange]))
        attributedText.append(NSAttributedString(string: "\n• \(subtitle) •".uppercased(), attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 7,weight: .regular) , NSAttributedString.Key.foregroundColor: UIColor.orange]))
        return attributedText
    }
    
    func attributeInfoLabel(withBrand brand: String, withColor color: String , withReliseYear year: Int) -> NSAttributedString {
        let attributedText = NSMutableAttributedString(string:"")
        
        let fontSize = 13.0
        let fontColor = UIColor.darkGray
        let font = UIFont.systemFont(ofSize: fontSize, weight: .regular)
        
        let maxWidth: CGFloat = 20
        let maxHeight: CGFloat = 20

        if let logo = UIImage(named: brand)?.withRenderingMode(.alwaysTemplate) {
            let resizedLogo = resizeImage(image: logo, maxWidth: maxWidth, maxHeight: maxHeight)
            
            let starImage = NSTextAttachment()
            starImage.image = resizedLogo.withTintColor(fontColor)
            starImage.bounds = CGRect(x: 0, y: (font.capHeight - fontSize).rounded() / 2, width: resizedLogo.size.width, height: resizedLogo.size.height)
            
            let imgString = NSAttributedString(attachment: starImage)
            attributedText.append(imgString)
        }
        
        let maxColorLength = 18
        let truncatedColor = String(color.prefix(maxColorLength))
        
        attributedText.append(NSAttributedString(string: "  \(brand)  •  \(truncatedColor)  •  \(year)" , attributes:[NSAttributedString.Key.font: font , NSAttributedString.Key.foregroundColor: fontColor]))

        return attributedText
    }
    
    func resizeImage(image: UIImage, maxWidth: CGFloat, maxHeight: CGFloat) -> UIImage {
        let size = image.size
        var newSize: CGSize
        
        if size.width > size.height {
            let ratio = maxWidth / size.width
            newSize = CGSize(width: maxWidth, height: size.height * ratio)
        } else {
            let ratio = maxHeight / size.height
            newSize = CGSize(width: size.width * ratio, height: maxHeight)
        }
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, UIScreen.main.scale)
        image.draw(in: CGRect(origin: .zero, size: newSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage ?? image
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


// MARK: - SwiftUI
import SwiftUI

struct ItemAdapter: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> some UIViewController {
        return ShopViewController()
    }
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
}

struct ItemProvider: PreviewProvider {
    static var previews: some View {
        ViewControllerAdapter()
    }
}
