import Foundation
import UIKit

class MainCoordinator: CoordinatorProtocol {
    var controllers: [Coordinated] = []
    var model = HabitsModel()
    lazy var habitsVC: HabitsViewController = {
        let vc = HabitsViewController(coordinator: self)
        vc.title = "Сегодня"
        vc.tabBarItem = UITabBarItem(title: "Привычки", image: UIImage(named: "HabitsBarIcon") , tag: 0)
        vc.view.backgroundColor = .white
        return vc
    }()
    
    lazy var infoVC: InfoViewController = {
        let vc = InfoViewController(coordinator: self)
        vc.tabBarItem = UITabBarItem(title: "Информация", image:UIImage(named: "InfoBarItem") , tag: 1)
        return vc
    }()
    
    func start() {
        
    }
    
    func updateCV() {
        habitsVC.reloadCollectionView()
    }
    
    func startMain() -> UITabBarController {
        let tabBarController = UITabBarController()
        let habitsNavVc = UINavigationController(rootViewController: habitsVC)
        habitsNavVc.navigationBar.prefersLargeTitles = true
        let infoNavVc = UINavigationController(rootViewController: infoVC)
        tabBarController.viewControllers = [habitsNavVc , infoNavVc]
        tabBarController.tabBar.backgroundColor = UIColor(red: 0.969, green: 0.969, blue: 0.969, alpha: 0.8)
        controllers.append(habitsVC)
        controllers.append(infoVC)
        return tabBarController
    }
    
    func showAdd() {
        let vc = AddHabitViewController(coordinator: self)
        vc.modalPresentationStyle = .fullScreen
        controllers.append(vc)
        habitsVC.present(vc, animated: true, completion: nil)
    }
    
    func showDates() {
        
    }
}

protocol Coordinated {
    var coordinator: MainCoordinator {get set}
}

protocol CoordinatorProtocol {
    func start()
}
