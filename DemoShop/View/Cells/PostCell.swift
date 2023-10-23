//
//  InfoCell.swift
//  DemoShop
//
//  Created by Konstantin Lyashenko on 19.09.2023.
//

import UIKit

class PostCell: UICollectionViewCell, SelfConfigureCellProtocol {
    
    static var reuseId = "PostCell"
    
    var tapHandler: (() -> Void)?
    
    @objc func cellTapped() {
        tapHandler?()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cellTapped))
        addGestureRecognizer(tapGesture)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var postImgView: UIImageView = {
        let newsImg = UIImageView()
        newsImg.translatesAutoresizingMaskIntoConstraints = false
        newsImg.contentMode = .scaleAspectFit
        newsImg.clipsToBounds = true
        newsImg.layer.cornerRadius = 3
        return newsImg
    }()

    lazy var postLabel: UILabel = {
        let newsLabel = UILabel()
        newsLabel.translatesAutoresizingMaskIntoConstraints = false
        newsLabel.font = UIFont.systemFont(ofSize: 12,weight: .light)
        newsLabel.numberOfLines = 2
        newsLabel.textAlignment = .center
        newsLabel.textColor = .label.withAlphaComponent(0.8)
        return newsLabel
    }()
    
    func configureCell(with post: Any) {
        if let post = post as? SneakerPost.Post {
            self.backgroundColor = .clear
            self.layer.cornerRadius = 5
            contentView.addSubview(postImgView)
            contentView.addSubview(postLabel)
            
            postImgView.image = post.image
            postLabel.text = post.title
            configureConstrains()
        }
    }

    func configureConstrains() {
        NSLayoutConstraint.activate([
            postImgView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 3),
            postImgView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -3),
            postImgView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 3),
            postImgView.heightAnchor.constraint(equalToConstant: 180),
            
            postLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 3),
            postLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -3),
            postLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -3),
            postLabel.topAnchor.constraint(equalTo: postImgView.bottomAnchor, constant: 3),
        ])
    }
}
