//
//  EditHabitViewController.swift
//  My Habits
//
//  Created by Simon Pegg on 29.05.2022.
//

import UIKit

class EditHabitViewController: UIViewController {
    var initialController: HabitsViewController
    lazy var label = UILabel()
    var source: Habit? {
        didSet {
            self.title = source?.name
        }
    }
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = .init(identifier: "ru_RU")
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        formatter.doesRelativeDateFormatting = true
        return formatter
    }()
    
    let tableView = UITableView()
    
    func setupViews() {
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setupConstraints() {
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        
    }
    init (controller: HabitsViewController) {

        self.initialController = controller
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.navigationBar.prefersLargeTitles = false
        setupViews()
        setupConstraints()
    }
    
    public func trackHabitString(forIndex index: Int) -> String? {
        guard index < (source?.trackDates.count)! else {
            return nil
        }
        return dateFormatter.string(from: (source?.trackDates[index])!)
    }

}
extension EditHabitViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return source?.trackDates.count ?? 0
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let text = (trackHabitString(forIndex: indexPath.row))
        if text != nil {
            cell.textLabel?.text = "\(text!)"
        }

        
        return cell
    }
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
//        cell.textLabel?.text = sourceDates[indexpath.row]
//            return cell
//    }

}
