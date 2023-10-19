//
//  InfoCell.swift
//  DemoShop
//
//  Created by Konstantin Lyashenko on 19.09.2023.
//

import UIKit

class PostCell: UICollectionViewCell, SelfConfigureCellProtocol {
    
    static var reuseId = "InfoCell"
    
    lazy var postImgView: UIImageView = {
        let catImg = UIImageView()
        catImg.translatesAutoresizingMaskIntoConstraints = false
        catImg.contentMode = .scaleAspectFit
        catImg.clipsToBounds = true
        catImg.layer.cornerRadius = 3
        return catImg
    }()

    lazy var postLabel: UILabel = {
        let catLabel = UILabel()
        catLabel.translatesAutoresizingMaskIntoConstraints = false
        catLabel.font = UIFont.systemFont(ofSize: 10,weight: .light)
        catLabel.numberOfLines = 2
        catLabel.textAlignment = .center
        catLabel.textColor = .label.withAlphaComponent(0.8)
        return catLabel
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .blue
        configureCell()
        configureConstrains()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureCell(){
        self.backgroundColor = .clear
        self.layer.cornerRadius = 5
        addSubview(postImgView)
        addSubview(postLabel)
        postImgView.image = UIImage(systemName: "figure.walk.motion")
        postLabel.text = "Text"
    }

    func configureConstrains(){
        NSLayoutConstraint.activate([
            postImgView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 3),
            postImgView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -3),
            postImgView.topAnchor.constraint(equalTo: topAnchor, constant: 3),
            postImgView.heightAnchor.constraint(equalToConstant: 180),
            
            postLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 3),
            postLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -3),
            postLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -3),
            postLabel.topAnchor.constraint(equalTo: postImgView.bottomAnchor, constant: 3),
            
        ])
    }

    func configure(with intValue: Int) {
        //categoryLabel.text = String(intValue)
    }
}

extension PostCell: PostProtocol {
    func getPost(data: SneakerPost) {
        
    }
}

// MARK: - SwiftUI
import SwiftUI

struct InfoCellAdapter: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> some UIViewController {
        return ViewController()
    }
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
}

struct InfoProvider: PreviewProvider {
    static var previews: some View {
        InfoCellAdapter()
    }
}
