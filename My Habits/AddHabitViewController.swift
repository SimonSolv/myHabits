import UIKit
import SwiftUI

class AddHabitViewController: UIViewController, Coordinated {
    var coordinator: MainCoordinator
    
    var habitName = ""
    var habitColor: UIColor = .cyan
    var habitDate = Date()
    let calendar = Calendar.current
    var prefix = ""
    var rootVC: HabitsViewController?
    var newHabit: Habit?

    lazy var navBar: UINavigationBar = {
        let bar = UINavigationBar()
        bar.barTintColor = .white
        bar.translatesAutoresizingMaskIntoConstraints = false
        return bar
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "НАЗВАНИЕ"
        label.font = .boldSystemFont(ofSize: 13)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var nameTextField: UITextField = {
        var textfield: UITextField = UITextField()
        textfield.translatesAutoresizingMaskIntoConstraints = false
        textfield.backgroundColor = .white
        textfield.placeholder = "Бегать по утрам, спать по 8 часов и т.п."
        textfield.font = .systemFont(ofSize: 17)
        textfield.textColor = .lightGray
        textfield.addTarget(self, action: #selector(statusTextChanged), for: .editingChanged)
        return textfield
    }()

    lazy var colorLabel: UILabel = {
        let label = UILabel()
        label.text = "ЦВЕТ"
        label.font = .boldSystemFont(ofSize: 13)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var colorPicker: UIColorWell = {
       let color = UIColorWell()
        color.supportsAlpha = true
        color.selectedColor = .cyan
        color.title = "Выберите цвет"
        color.translatesAutoresizingMaskIntoConstraints = false
        return color
    }()
    
    lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.text = "ВРЕМЯ"
        label.font = .boldSystemFont(ofSize: 13)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let datePicker: UIDatePicker = {
       let date = UIDatePicker()
        date.preferredDatePickerStyle = .wheels
        date.datePickerMode = .time
        date.translatesAutoresizingMaskIntoConstraints = false
        return date
    }()
    
    lazy var timeTextField: UITextField = {
        var textfield: UITextField = UITextField()
        textfield.translatesAutoresizingMaskIntoConstraints = false
        textfield.backgroundColor = .white
        textfield.text = "Каждый день в "
        textfield.font = .systemFont(ofSize: 17)
        textfield.textColor = .black
        return textfield
    }()
    
    lazy var exactTimeTextField: UITextField = {
        var textfield: UITextField = UITextField()
        textfield.translatesAutoresizingMaskIntoConstraints = false
        textfield.backgroundColor = .white
        textfield.placeholder = "11.00 PM"
        textfield.font = .systemFont(ofSize: 17)
        textfield.textColor = UIColor(named: "AppFiolet")
        return textfield
    }()
    
    lazy var barItems: UINavigationItem = {
        let button = UINavigationItem(title: "Создать")
        return button
    }()
    
    lazy var saveButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Сохранить", style: .done, target: self, action: #selector(save))
        button.tintColor = UIColor(named: "AppFiolet")
        return button
    }()
    
    lazy var cancelButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Отмена", style: .done, target: self, action: #selector(canсel))
        button.tintColor = UIColor(named: "AppFiolet")
        return button
    }()
    //MARK: Making View
    init(coordinator: MainCoordinator) {
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Создать"
        navBar.setItems([barItems], animated: false)
        barItems.rightBarButtonItem = saveButton
        barItems.leftBarButtonItem = cancelButton
        self.view.backgroundColor = .white
        colorPicker.addTarget(self, action: #selector(colorChanged), for: .valueChanged)
        datePicker.addTarget(self, action: #selector(timeChanged), for: .valueChanged)
        setupViews()
    }
   // MARK: Button Functions
    @objc func statusTextChanged(_ textField: UITextField) {
        textField.textColor = #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)
        textField.font = UIFont.boldSystemFont(ofSize: 18)
        habitName = textField.text!
    }
    
    @objc private func colorChanged() {
        habitColor = colorPicker.selectedColor!
    }
    
    @objc private func timeChanged() {
        habitDate = datePicker.date
        let hour = calendar.component(.hour, from: habitDate)
        let minute = calendar.component(.minute, from: habitDate)
        if minute < 10 {
            prefix = "0"
        }
        else {
            prefix = ""
        }
        exactTimeTextField.text = "\(hour):\(prefix)\(minute)"
    }
    
    @objc private func canсel() {
        self.dismiss(animated: true)
        coordinator.controllers.remove(at: 2)
    }
    
    @objc private func save() {
        if self.nameTextField.text?.isEmpty == true {
            let alert = UIAlertController(title: "Ошибка!", message: "Введите название привычки", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ок", style: .cancel, handler: { _ in
            }))
            present(alert, animated: true)
        }
        else {
            newHabit = Habit(name: habitName, date: habitDate, color: habitColor)
            coordinator.model.habitStore.habits.append(newHabit!)
            coordinator.model.habitStore.save()
            coordinator.updateCV()
            self.canсel()
        }
    }
    // MARK: Setup
    private func setupViews() {
        view.addSubview(navBar)
        view.addSubview(nameLabel)
        view.addSubview(nameTextField)
        view.addSubview(colorLabel)
        view.addSubview(colorPicker)
        view.addSubview(timeLabel)
        view.addSubview(timeTextField)
        view.addSubview(exactTimeTextField)
        view.addSubview(datePicker)
        
        let constraints = [
            navBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            navBar.heightAnchor.constraint(equalToConstant: 50),
            navBar.widthAnchor.constraint(equalTo: view.widthAnchor),
            
            nameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80),
            nameLabel.heightAnchor.constraint(equalToConstant: 18),
            nameLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            nameTextField.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor ,constant: -16),
            nameTextField.topAnchor.constraint(equalTo: nameLabel.bottomAnchor,constant: 10),
            nameTextField.heightAnchor.constraint(equalToConstant: 30),
        
            colorLabel.leadingAnchor.constraint(equalTo: nameTextField.leadingAnchor),
            colorLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor ,constant: -16),
            colorLabel.topAnchor.constraint(equalTo: nameTextField.bottomAnchor,constant: 10),
            colorLabel.heightAnchor.constraint(equalToConstant: 30),
            
            colorPicker.leadingAnchor.constraint(equalTo: colorLabel.leadingAnchor),
            colorPicker.topAnchor.constraint(equalTo: colorLabel.bottomAnchor,constant: 10),
            colorPicker.heightAnchor.constraint(equalToConstant: 30),
            colorPicker.widthAnchor.constraint(equalToConstant: 30),
            
            timeLabel.leadingAnchor.constraint(equalTo: colorPicker.leadingAnchor),
            timeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor ,constant: -16),
            timeLabel.topAnchor.constraint(equalTo: colorPicker.bottomAnchor,constant: 10),
            timeLabel.heightAnchor.constraint(equalToConstant: 30),
            
            timeTextField.leadingAnchor.constraint(equalTo: timeLabel.leadingAnchor),
            timeTextField.widthAnchor.constraint(equalToConstant: 124),
            timeTextField.topAnchor.constraint(equalTo: timeLabel.bottomAnchor,constant: 10),
            timeTextField.heightAnchor.constraint(equalToConstant: 30),
            
            exactTimeTextField.leadingAnchor.constraint(equalTo: timeTextField.trailingAnchor),
            exactTimeTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor ,constant: -16),
            exactTimeTextField.topAnchor.constraint(equalTo: timeLabel.bottomAnchor,constant: 10),
            exactTimeTextField.heightAnchor.constraint(equalToConstant: 30),
            
            datePicker.leadingAnchor.constraint(equalTo: timeLabel.leadingAnchor),
            datePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor ,constant: -16),
            datePicker.topAnchor.constraint(equalTo: view.topAnchor,constant: 370),
            datePicker.heightAnchor.constraint(equalToConstant: 100),
        
        ]
        NSLayoutConstraint.activate(constraints)
    }

}
