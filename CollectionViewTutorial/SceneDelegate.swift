//
//  SceneDelegate.swift
//  CollectionViewTutorial
//
//  Created by Alexandr Mefisto on 19.04.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: windowScene.screen.bounds)
        window?.windowScene = windowScene
        let navigationRootController = UINavigationController(rootViewController: CarouselViewController())
        window?.rootViewController = navigationRootController
        window?.makeKeyAndVisible()
    }
}

