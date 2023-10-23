//
//  DataSource.swift
//  DemoShop
//
//  Created by Konstantin Lyashenko on 17.10.2023.
//

import UIKit

class ShopViewControllerDataSource {
    private weak var viewController: ShopViewController!
    
    init(viewController: ShopViewController) {
        self.viewController = viewController
    }
    
    func configure<T: SelfConfigureCellProtocol>(cellType: T.Type, with intValue: Int, for indexPath: IndexPath) -> T {
        guard let cell = viewController?.collectionView.dequeueReusableCell(withReuseIdentifier: cellType.reuseId, for: indexPath) as? T else {
            fatalError("Error \(cellType)")
        }
        return cell
    }
    
    func setupDataSource() {
        viewController?.dataSource = UICollectionViewDiffableDataSource<SectionKind, Int>(collectionView: viewController?.collectionView ?? UICollectionView(),
                                                                                          cellProvider: { [weak self] (_, indexPath, itemIdentifier) -> UICollectionViewCell? in
            guard let self = self, let section = SectionKind(rawValue: indexPath.section) else { return nil }
            switch section {
            case .menu:
                let menuCell = self.configure(cellType: MenuCell.self, with: itemIdentifier, for: indexPath)
                menuCell.delegate = self.viewController
                return menuCell
            case .grid:
                let postCell = self.configure(cellType: PostCell.self, with: itemIdentifier, for: indexPath)
                if let post = self.viewController?.sneakerPosts?[indexPath.row] {
                    postCell.configureCell(with: post)
                    postCell.tapHandler = { [weak self] in
                        self?.viewController?.openWebPage(for: post)
                    }
                }
                return postCell
            case .list:
                let itemCell = self.configure(cellType: ItemCell.self, with: itemIdentifier, for: indexPath)
                if let data = self.viewController?.sneakerData?[indexPath.row] {
                    itemCell.configureCell(with: data)
                }
                return itemCell
            }
        })
    }
    
    func setupSupplementaryViewProvider() {
        viewController?.dataSource?.supplementaryViewProvider = { [weak self] (collectionView, kind, indexPath) -> UICollectionReusableView? in
            guard let self = self, kind == UICollectionView.elementKindSectionFooter else { return nil }
            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: MenuFooterView.reuseId, for: indexPath) as? MenuFooterView
            if let section = SectionKind(rawValue: indexPath.section), section == .menu {
                footerView?.titleLabel.text = self.viewController?.footerTitle
                footerView?.subTitleLabel.text = self.viewController?.footerSubTitle
            }
            return footerView
        }
    }
    
    func reloadData() {
        guard let dataSource = viewController?.dataSource else {
            print("Ошибка: dataSource не инициализирован")
            return
        }
        var snapshot = NSDiffableDataSourceSnapshot<SectionKind, Int>()
        var itemOffset = 0
        
        SectionKind.allCases.forEach { (sectionKind) in
            guard let itemCount = viewController?.itemCountsPerSection[sectionKind] else { return }
            let itemUpperbound = itemOffset + itemCount
            snapshot.appendSections([sectionKind])
            snapshot.appendItems(Array(itemOffset..<itemUpperbound))
            itemOffset = itemUpperbound
        }
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    func openWebPage(for post: SneakerPost.Post) {
        guard let link = post.link else {
            print("Link отсутствует")
            return
        }
        let newsWebController = NewsWebViewController()
        newsWebController.loadURL(link)
        viewController?.navigationController?.pushViewController(newsWebController, animated: true)
    }
}
