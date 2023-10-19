//
//  ViewController.swift
//  DemoShop
//
//  Created by Konstantin Lyashenko on 18.09.2023.
//

import UIKit

enum SectionKind: Int, CaseIterable {
    case menu, grid, list
}

class ShopViewController: UIViewController {
    var dataSource: UICollectionViewDiffableDataSource<SectionKind, Int>!
    var collectionView: UICollectionView!
    var itemCountsPerSection: [SectionKind: Int] = [
        .menu: 1,
        .grid: 0,
        .list: 0
    ]
    let activityIndicator = AppLayouts.shared.activityIndicator
    
    var sneakerPostManager = SneakerPostManager()
    var sneakerDataManager = SneakerManager()
    var sneakerPosts: [SneakerPost.Post]?
    var sneakerData: [SneakerModel]?
    
    var footerTitle = "Nike App Days"
    var footerSubTitle = "Celebrate with Member Exclusive Products, Giveaways, and More."
    let dataLoadQueue = DispatchQueue(label: "Lyashenko-KV.DemoShop", attributes: .concurrent)

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Shop"
        view.backgroundColor = .white
        setupCollectionView()
        sneakerPostManager.delegate = self
        sneakerDataManager.delegate = self
        AppLayouts.shared.setupActivityIndicator(vc: self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.loadData(.men)
    }
    
    func loadData(_ category: Gender.Category) {
        AppLayouts.shared.showActivityIndicator(vc: self)
        
        dataLoadQueue.async {
            self.sneakerPostManager.getHTMLPost(url: category.url) { result in
                switch result {
                case .success(_):
                    break
                case .failure(let error):
                    print("Ошибка при загрузке HTML-постов: \(error)")
                }
            }
            self.sneakerDataManager.getSneakers(filters: [SneakerFilter.gender(category.rawValue), SneakerFilter.limit("50")]) { result in
                switch result {
                case .success(_):
                    break
                case .failure(let error):
                    print("Ошибка при загрузке JSON-постов: \(error)")
                }
            }
            DispatchQueue.main.async {
                AppLayouts.shared.hideActivityIndicator(vc: self)
            }
        }
    }
    
    private func setupCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: AppLayouts.shared.createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .systemBackground
        collectionView.register(MenuCell.self, forCellWithReuseIdentifier: MenuCell.reuseId)
        collectionView.register(MenuFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: MenuFooterView.reuseId)
        collectionView.register(PostCell.self, forCellWithReuseIdentifier: PostCell.reuseId)
        collectionView.register(ItemCell.self, forCellWithReuseIdentifier: ItemCell.reuseId)
        view.addSubview(collectionView)
    }
    
    func configure<T: SelfConfigureCellProtocol>(cellType: T.Type, with intValue: Int, for indexPath: IndexPath) -> T {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellType.reuseId, for: indexPath) as? T else {
            fatalError("Error \(cellType)")
        }
        return cell
    }
    
    private func setupDataSource() {
        dataSource = UICollectionViewDiffableDataSource<SectionKind, Int>(collectionView: collectionView,
                                                                          cellProvider: { [ weak self ] (_, indexPath, itemIdentifier) -> UICollectionViewCell? in
            guard let self = self else { return nil }
            guard let section = SectionKind(rawValue: indexPath.section) else { return nil }
            switch section {
            case .menu:
                let menuCell = self.configure(cellType: MenuCell.self, with: itemIdentifier, for: indexPath)
                menuCell.delegate = self
                return menuCell
            case .grid:
                if let post = self.sneakerPosts?[indexPath.row] {
                    let postCell = self.configure(cellType: PostCell.self, with: itemIdentifier, for: indexPath)
                    postCell.configureCell(with: post)
                    return postCell
                } else {
                    return self.configure(cellType: PostCell.self, with: itemIdentifier, for: indexPath)
                }
            case .list:
                if let data = self.sneakerData?[indexPath.row] {
                    let itemCell = self.configure(cellType: ItemCell.self, with: itemIdentifier, for: indexPath)
                    itemCell.configureCell(data)
                    return itemCell
                } else {
                    return self.configure(cellType: ItemCell.self, with: itemIdentifier, for: indexPath)
                }
            }
        })
        dataSource.supplementaryViewProvider = { [ weak self ] (collectionView, kind, indexPath) -> UICollectionReusableView? in
            guard let self = self else { return nil }
            if kind == UICollectionView.elementKindSectionFooter {
                let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: MenuFooterView.reuseId, for: indexPath) as? MenuFooterView
                guard let section = SectionKind(rawValue: indexPath.section) else { return nil }
                switch section {
                case .menu:
                    footerView?.titleLabel.text = self.footerTitle
                    footerView?.subTitleLabel.text = self.footerSubTitle
                default:
                    break
                }
                return footerView
            }
            return nil
        }
    }
    
    func reloadData() {
        guard let dataSource = dataSource else {
            print("Ошибка: dataSource не инициализирован")
            return
        }
        var snapshot = NSDiffableDataSourceSnapshot<SectionKind, Int>()
        var itemOffset = 0
        
        SectionKind.allCases.forEach { (sectionKind) in
            guard let itemCount = itemCountsPerSection[sectionKind] else { return }
            let itemUpperbound = itemOffset + itemCount
            snapshot.appendSections([sectionKind])
            snapshot.appendItems(Array(itemOffset..<itemUpperbound))
            itemOffset = itemUpperbound
        }
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

extension ShopViewController: ReloadDataProtocol {
    func didSelectCategory(_ category: Gender.Category) {
        self.loadData(category)
        self.footerTitle = category.rawValue
    }
    
    func getPost(data: [SneakerPost.Post]) {
        self.sneakerPosts = data
        self.itemCountsPerSection[.grid] = sneakerPosts?.count
    }
    
    func getData(data: [SneakerModel]) {
        self.sneakerData = data
        self.itemCountsPerSection[.list] = sneakerData?.count
        
        DispatchQueue.main.async {
            self.setupDataSource()
            self.reloadData()
        }
    }
}

// MARK: - SwiftUI
import SwiftUI

struct ViewControllerAdapter: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> some UIViewController {
        return ShopViewController()
    }
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
}

struct AdvancedProvider: PreviewProvider {
    static var previews: some View {
        ViewControllerAdapter()
    }
}

