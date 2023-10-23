//
//  AppLayout.swift
//  DemoShop
//
//  Created by Konstantin Lyashenko on 26.09.2023.
//

import UIKit

class AppLayouts {
    static let shared = AppLayouts()
    
    let activityIndicator = UIActivityIndicatorView(style: .large)
    
    func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, _) -> NSCollectionLayoutSection? in
            guard let section = SectionKind(rawValue: sectionIndex) else { return nil }
            var sectionMenuFooter: NSCollectionLayoutBoundarySupplementaryItem?
            
            switch section {
            case .menu:
                sectionMenuFooter = self.createSectionMenuFooter()
                return self.createMenuSection(withFooter: sectionMenuFooter)
            case .grid:
                return self.createGridSection()
            case .list:
                return self.createListSection()
            }
        }
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 20
        layout.configuration = config
        return layout
    }
    
    func setupActivityIndicator(vc: UIViewController) {
        activityIndicator.center = vc.view.center
        activityIndicator.color = .darkGray
        activityIndicator.hidesWhenStopped = true
        vc.view.addSubview(activityIndicator)
    }
    
    func showActivityIndicator(vc: UIViewController) {
        activityIndicator.startAnimating()
        vc.view.isUserInteractionEnabled = false
    }
    
    func hideActivityIndicator(vc: UIViewController) {
        self.activityIndicator.stopAnimating()
        vc.view.isUserInteractionEnabled = true
    }
    
    func createSectionMenuFooter() -> NSCollectionLayoutBoundarySupplementaryItem {
        let footerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(50))
        let footer = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: footerSize, elementKind: UICollectionView.elementKindSectionFooter, alignment: .bottom)
        return footer
    }
    
    func createMenuSection(withFooter sectionFooter: NSCollectionLayoutBoundarySupplementaryItem?) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(50))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, repeatingSubitem: item, count: 1)
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0)
        
        if let footer = sectionFooter {
            section.boundarySupplementaryItems += [footer]
        }
        return section
    }
    
    func createGridSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets.init(top: 10, leading: 0, bottom: 0, trailing: 8)
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(220),
                                               heightDimension: .absolute(240))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 11)
        let section = NSCollectionLayoutSection(group: group)
        
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = NSDirectionalEdgeInsets(top: 30, leading: 15, bottom: 10, trailing: 0)
        return section
    }
    
    func createListSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .absolute(111))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, repeatingSubitem: item, count: 1)
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 5
        return section
    }
}
