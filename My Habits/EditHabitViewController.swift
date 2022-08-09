import SwiftUI
import UIKit

class EditHabitViewController: UIViewController, Coordinated {
    var coordinator: MainCoordinator
    
    var currentHabit: Habit? {
        didSet {
            self.nameTextField.text = currentHabit!.name
            self.nameTextField.font = UIFont.boldSystemFont(ofSize: 18)
            self.nameTextField.textColor = .systemBlue
            self.colorPicker.selectedColor = currentHabit!.color
            self.timeTextField.text = currentHabit?.dateString
        }
    }
    
    var habitName = ""
    var habitColor: UIColor = .cyan
    var habitDate = Date()
    let calendar = Calendar.current
    var prefix = ""
    var rootVC: CurrentHabitViewController?
    var habitsVC: HabitsViewController?
    var newHabit: Habit?
    
    lazy var navBar: UINavigationBar = {
        let bar = UINavigationBar()
        bar.barTintColor = .systemBackground
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
        textfield.backgroundColor = .systemGray3
        textfield.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: textfield.frame.height))
        textfield.leftViewMode = .always
        textfield.layer.cornerRadius = 5
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
        textfield.backgroundColor = .systemGray3
        textfield.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: textfield.frame.height))
        textfield.leftViewMode = .always
        textfield.layer.cornerRadius = 5
        textfield.text = "Каждый день в "
        textfield.font = .systemFont(ofSize: 17)
        return textfield
    }()
    
    lazy var exactTimeTextField: UITextField = {
        var textfield: UITextField = UITextField()
        textfield.translatesAutoresizingMaskIntoConstraints = false
        textfield.backgroundColor = .clear
        textfield.placeholder = "11.00 PM"
        textfield.font = .systemFont(ofSize: 17)
        textfield.textColor = UIColor(named: "AppFiolet")
        return textfield
    }()
    
    lazy var barItems: UINavigationItem = {
        let button = UINavigationItem(title: "Править")
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
    
    lazy var deleteButton: UIButton = {
        let button = UIButton()
        button.setTitle("Удалить привычку", for: .normal)
        button.setTitleColor(UIColor.red, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(deleteHabit), for: .touchUpInside)
        return button
    }()
    
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
        self.view.backgroundColor = .systemBackground
        colorPicker.addTarget(self, action: #selector(colorChanged), for: .valueChanged)
        datePicker.addTarget(self, action: #selector(timeChanged), for: .valueChanged)
        setupViews()
    }
    // MARK: Button Functions
    @objc func statusTextChanged(_ textField: UITextField){
        habitName = textField.text!
    }
    @objc func deleteHabit() {
        let alert = UIAlertController(title: "Удалить привычку", message: "Вы дейстаительно хотите удалить привычку \(currentHabit!.name)?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: { _ in
        }))
        alert.addAction(UIAlertAction(title: "Удалить", style: .destructive, handler: { _ in
            self.habitsVC?.removeHabit(self.currentHabit)
            self.habitsVC?.reloadCollectionView()
            self.coordinator.removeDependency(self)
            self.rootVC?.navigationController?.popToRootViewController(animated: true)
        }))
        present(alert, animated: true)
        
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
        exactTimeTextField.isHidden = false
        timeTextField.text = "Каждый день в "
        exactTimeTextField.text = "\(hour):\(prefix)\(minute)"
    }
    @objc private func canсel() {
        self.dismiss(animated: true)
    }
    
    @objc private func save() {
        if self.nameTextField.text?.isEmpty == true {
            let alert = UIAlertController(title: "Ошибка!", message: "Введите название привычки", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ок", style: .cancel, handler: { _ in
            }))
            present(alert, animated: true)
        }
        else {
            currentHabit?.name = nameTextField.text!
            currentHabit?.color = colorPicker.selectedColor!
            currentHabit?.date = datePicker.date
            self.rootVC?.navigationController?.popToRootViewController(animated: true)
            self.dismiss(animated: true)
        }
    }
    
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
        view.addSubview(deleteButton)
        exactTimeTextField.isHidden = true
        
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
            timeTextField.widthAnchor.constraint(equalToConstant: 200),
            timeTextField.topAnchor.constraint(equalTo: timeLabel.bottomAnchor,constant: 10),
            timeTextField.heightAnchor.constraint(equalToConstant: 30),
            
            exactTimeTextField.leadingAnchor.constraint(equalTo: timeTextField.trailingAnchor, constant: -76),
            exactTimeTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor ,constant: -16),
            exactTimeTextField.topAnchor.constraint(equalTo: timeLabel.bottomAnchor,constant: 10),
            exactTimeTextField.heightAnchor.constraint(equalToConstant: 30),
            
            datePicker.leadingAnchor.constraint(equalTo: timeLabel.leadingAnchor),
            datePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor ,constant: -16),
            datePicker.topAnchor.constraint(equalTo: view.topAnchor,constant: 370),
            datePicker.heightAnchor.constraint(equalToConstant: 100),
            
            deleteButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            deleteButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            deleteButton.topAnchor.constraint(equalTo: view.bottomAnchor,constant: -100),
            deleteButton.heightAnchor.constraint(equalToConstant: 50)
            
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
}




