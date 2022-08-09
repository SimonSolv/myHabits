import UIKit
import SnapKit

class HabitsViewController: UIViewController, Coordinated {
    var coordinator: MainCoordinator
    let store: HabitsStore
    let indexPaths = 0
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemBackground
        view.register(ProgressCollectionViewCell.self, forCellWithReuseIdentifier: ProgressCollectionViewCell.identifier )
        view.register(HabitCollectionViewCell.self, forCellWithReuseIdentifier: HabitCollectionViewCell.identifier )
        view.dataSource = self
        view.delegate = self
        return view
    }()
    
    init(coordinator: MainCoordinator) {
        self.coordinator = coordinator
        store = self.coordinator.habitStore
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = true
        collectionView.reloadData()
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        UITabBar.appearance().tintColor = UIColor(named: "AppFiolet")
        UINavigationBar.appearance().backgroundColor = .systemBackground
        UINavigationBar.appearance().barTintColor = .systemGray2
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addHabit))
        addButton.tintColor = UIColor(named: "AppFiolet")
        navigationItem.rightBarButtonItem = addButton
        navigationController?.navigationBar.prefersLargeTitles = true
        self.title = "Сегодня"
        setupViews()
        setupConstraints()
        collectionView.reloadData()
    }
    
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
    
    @objc func addHabit() {
        coordinator.showAdd()        
    }

    func reloadCollectionView() {
        collectionView.reloadData()
    }

    func updateCV1() {
        let index = IndexPath(row: 0, section: 0)
        collectionView.reloadItems(at: [index])
    }

    func removeHabit(_ habit: Habit?) {
        guard
            store.habits.isEmpty == false,
            let habit = habit
            else { return }
        
        for (index, element) in store.habits.enumerated() {
            if element === habit {
                store.habits.remove(at: index)
                break
            }
        }
    }

}
//MARK: CollectionView Extention
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
            cell.rootVC = self
            cell.updateProgress(newProgress: store.todayProgress)
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
        guard indexPath.row > 0 else {return}
        coordinator.showCurrent(index: indexPath)
    }
}
