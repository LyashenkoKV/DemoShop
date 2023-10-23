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
    private var shopViewControllerDataSource: ShopViewControllerDataSource!
    
    var sneakerPostManager = SneakerPostManager()
    var sneakerDataManager = SneakerManager()
    var sneakerPosts: [SneakerPost.Post]?
    var sneakerData: [SneakerModel]?
    
    var footerTitle = "MNs SNKRs"
    var footerSubTitle = "Celebrate with Member Exclusive Products, Giveaways, and More."

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
        let dataLoadQueue = DispatchQueue(label: "Lyashenko-KV.DemoShop", attributes: .concurrent)
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
    
    func openWebPage(for post: SneakerPost.Post) {
        shopViewControllerDataSource.openWebPage(for: post)
    }
}

extension ShopViewController: ReloadDataProtocol {
    func didSelectCategory(_ category: Gender.Category) {
        self.loadData(category)
        switch category {
        case .men:
            self.footerTitle = "MNs SNKRs"
        case .women:
            self.footerTitle = "WMNs SNKRs"
        case .child:
            self.footerTitle = "KDs SNKRs"
        }
    }
    
    func getPost(data: [SneakerPost.Post]) {
        self.sneakerPosts = data
        self.itemCountsPerSection[.grid] = sneakerPosts?.count
    }
    
    func getData(data: [SneakerModel]) {
        self.sneakerData = data
        self.itemCountsPerSection[.list] = sneakerData?.count
        shopViewControllerDataSource = ShopViewControllerDataSource(viewController: self)
        
        DispatchQueue.main.async {
            self.shopViewControllerDataSource.setupDataSource()
            self.shopViewControllerDataSource.setupSupplementaryViewProvider()
            self.shopViewControllerDataSource.reloadData()
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

