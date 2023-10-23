//
//  SceneDelegate.swift
//  DemoShop
//
//  Created by Konstantin Lyashenko on 18.09.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let viewController = ShopViewController()
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.navigationBar.prefersLargeTitles = true
        navigationController.navigationBar.tintColor = .black
        
        let searchButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchButtonTapped))
        viewController.navigationItem.rightBarButtonItem = searchButton
        
        let window = UIWindow(windowScene: windowScene)
        self.window = window
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
    
    func showNewsWebViewController(with url: URL) {
        let newsWebViewController = NewsWebViewController()
        newsWebViewController.loadURL(url)
    }
    
    @objc func searchButtonTapped() {
        
    }
}

