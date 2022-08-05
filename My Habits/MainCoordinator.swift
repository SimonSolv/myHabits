import Foundation
import UIKit

class MainCoordinator {
    var childControllers: [Coordinated] = []
    let habitStore = HabitsStore.shared
    
    //MARK: Immortal ViewControllers
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
    //MARK: Coordinator methods
    
    func showCurrent(index: IndexPath, sourceController: UIViewController) {
        let controller = CurrentHabitViewController(coordinator: self)
        controller.source = habitStore.habits[index.row-1]
        controller.currentIndex = index
        self.addDependency(controller)
        sourceController.navigationController?.pushViewController(controller, animated: true)
    }
    
    func showEdit(index: IndexPath, sourceController: CurrentHabitViewController) {
        let controller = EditHabitViewController(coordinator: self)
        controller.modalPresentationStyle = .fullScreen
        controller.currentHabit = habitStore.habits[index.row-1]
        controller.habitsVC = habitsVC
        controller.rootVC = sourceController
        self.addDependency(controller)
        sourceController.present(controller, animated: true, completion: nil)
    }

    func addDependency(_ controller: Coordinated) {
        for element in childControllers {
            if element === controller { return }
        }
        childControllers.append(controller)
    }
    
    func removeDependency(_ controller: Coordinated?) {
        guard
            childControllers.isEmpty == false,
            let removeController = controller
            else { return }
        
        for (index, element) in childControllers.enumerated() {
            if element === removeController {
                childControllers.remove(at: index)
                break
            }
        }
    }
    
    func startMain() -> UITabBarController {
        let tabBarController = UITabBarController()
        let habitsNavVc = UINavigationController(rootViewController: habitsVC)
        habitsNavVc.navigationBar.prefersLargeTitles = true
        let infoNavVc = UINavigationController(rootViewController: infoVC)
        tabBarController.viewControllers = [habitsNavVc , infoNavVc]
        tabBarController.tabBar.backgroundColor = UIColor(red: 0.969, green: 0.969, blue: 0.969, alpha: 0.8)
        addDependency(habitsVC)
        addDependency(infoVC)
        return tabBarController
    }
    
    func showAdd() {
        let vc = AddHabitViewController(coordinator: self)
        vc.modalPresentationStyle = .fullScreen
        addDependency(vc)
        habitsVC.present(vc, animated: true, completion: nil)
    }

}

//MARK: Protocol
protocol Coordinated: class {
    var coordinator: MainCoordinator {get set}
}
