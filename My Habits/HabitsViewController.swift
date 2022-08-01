import UIKit
import SnapKit

class HabitsViewController: UIViewController {
    let store = HabitsStore.shared
    let indexPaths = 0
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.register(ProgressCollectionViewCell.self, forCellWithReuseIdentifier: ProgressCollectionViewCell.identifier )
        view.register(HabitCollectionViewCell.self, forCellWithReuseIdentifier: HabitCollectionViewCell.identifier )
        view.dataSource = self
        view.delegate = self
        return view
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        UITabBar.appearance().tintColor = UIColor(named: "AppFiolet")
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addHabit))
        addButton.tintColor = UIColor(named: "AppFiolet")
        navigationItem.rightBarButtonItem = addButton
        view.layer.backgroundColor = UIColor(red: 0.949, green: 0.949, blue: 0.969, alpha: 1).cgColor
        self.title = "Сегодня"
        self.view.layer.backgroundColor = UIColor.lightGray.cgColor
        UINavigationBar.appearance().barTintColor = UIColor(red: 0.976, green: 0.976, blue: 0.976, alpha: 0.94)

        setupViews()
        setupConstraints()
        let habit1 = Habit(name: "Пить с утра стакан воды", date: Date(timeIntervalSinceNow: 3000), color: UIColor.green)
        let habit2 = Habit(name: "Вовремя ложиться спать по будням и в выходные", date: Date(timeIntervalSinceNow: 1000), color: UIColor.orange)
        let habit3 = Habit(name: "Бегать ежедневно по 5 км", date: Date(timeIntervalSinceNow: 2000), color: UIColor.blue)
        let habit4 = Habit(name: "Читать по 20 страниц книг", date: Date(timeIntervalSinceNow: 0), color: UIColor.red)
        store.habits.removeAll()
        store.habits.append(habit1)
        store.habits.append(habit2)
        store.habits.append(habit3)
        store.habits.append(habit4)
        collectionView.reloadData()
    }
    
    @objc func addHabit() {
        let vc = AddHabitViewController()
        vc.modalPresentationStyle = .fullScreen
        vc.rootVC = self
        self.present(vc, animated: true, completion: nil)
        
    }
    func cancel() {
        self.dismiss(animated: true, completion: nil)
    }
    func reloadCollectionView() {
        collectionView.reloadData()
    }

    let indexpath: [IndexPath] = {
       let index = IndexPath(index: 0)
        return [index]
    }()

     func setupViews() {
        view.addSubview(collectionView)
        collectionView.layer.backgroundColor = UIColor(named: "Gray")?.cgColor
    }
    
    func setupConstraints() {
        collectionView.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
        }
    }
}

extension HabitsViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return store.habits.count+1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProgressCollectionViewCell.identifier, for: indexPath) as! ProgressCollectionViewCell
            cell.progress = store.todayProgress
            cell.rootVC = self
            return cell
        } else {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HabitCollectionViewCell.identifier, for: indexPath) as! HabitCollectionViewCell
            cell.source = store.habits[indexPath.row-1]
            cell.rootVC = self
        return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.row == 0 {
            return CGSize(width: (view.bounds.width), height: 60)
        }
        else {
            return CGSize(width: (view.bounds.width), height: 130)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let controller = EditHabitViewController(controller: self)
        controller.source = store.habits[indexPath.row-1]
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
}

//protocol ProgressProtocol {
//    var id: Int {get}
//    func update(bid : Float)
//}
