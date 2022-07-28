//
//  SceneDelegate.swift
//  My Habits
//
//  Created by Simon Pegg on 01.10.2021.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let scene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: scene)
        window?.makeKeyAndVisible()
        
        let tabBarController = UITabBarController()
      
        let habitsVC: HabitsViewController = {
            let vc = HabitsViewController()
            vc.title = "Сегодня"
            vc.tabBarItem = UITabBarItem(title: "Привычки", image: UIImage(named: "HabitsBarIcon") , tag: 0)
            vc.view.backgroundColor = .white
            return vc
        }()

        let infoVC: InfoViewController = {
            let vc = InfoViewController()
            vc.tabBarItem = UITabBarItem(title: "Информация", image:UIImage(named: "InfoBarItem") , tag: 1)
            return vc
        }()
        let habitsNavVc = UINavigationController(rootViewController: habitsVC)
        habitsNavVc.navigationBar.prefersLargeTitles = true
        let infoNavVc = UINavigationController(rootViewController: infoVC)
        tabBarController.viewControllers = [habitsNavVc , infoNavVc]
        tabBarController.tabBar.backgroundColor = UIColor(red: 0.969, green: 0.969, blue: 0.969, alpha: 0.8)
        window?.rootViewController = tabBarController
    }


}

