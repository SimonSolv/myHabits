import Foundation
import UIKit

class MainCoordinator {
    var childControllers: [Coordinated] = []
    var tabBarController: UITabBarController?
    let habitStore = HabitsStore.shared
    
    //MARK: Immortal ViewControllers
    lazy var habitsVC: HabitsViewController = {
        let vc = HabitsViewController(coordinator: self)
        vc.title = "Сегодня"
        vc.tabBarItem = UITabBarItem(title: "Привычки", image: UIImage(named: "HabitsBarIcon") , tag: 0)
        vc.view.backgroundColor = .systemBackground
        return vc
    }()
    
    lazy var infoVC: InfoViewController = {
        let vc = InfoViewController(coordinator: self)
        vc.tabBarItem = UITabBarItem(title: "Информация", image:UIImage(named: "InfoBarItem") , tag: 1)
        vc.view.backgroundColor = .systemBackground
        return vc
    }()
    //MARK: Coordinator methods
    
    func showCurrent(index: IndexPath) {
        let controller = CurrentHabitViewController(coordinator: self)
        controller.source = habitStore.habits[index.row-1]
        controller.currentIndex = index
        self.addDependency(controller)
        habitsVC.navigationController?.pushViewController(controller, animated: true)
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
    
    func showHabits() {
        self.tabBarController?.navigationController?.popToViewController(habitsVC, animated: true)
        print("Pressed Save")
    }
    
    func startMain() -> UITabBarController {
        tabBarController = UITabBarController()
        let habitsNavVc = UINavigationController(rootViewController: habitsVC)
        habitsNavVc.navigationBar.prefersLargeTitles = true
        let infoNavVc = UINavigationController(rootViewController: infoVC)
        tabBarController!.viewControllers = [habitsNavVc , infoNavVc]
        tabBarController!.tabBar.backgroundColor = .systemBackground
        addDependency(habitsVC)
        addDependency(infoVC)
        return tabBarController!
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
