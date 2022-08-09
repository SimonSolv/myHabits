import UIKit
import SwiftUI

class HabitCollectionViewCell: UICollectionViewCell {

    static let identifier = "habit"
    var habitIndex: Int = 0

    var rootVC: HabitsViewController? {
        didSet {
            self.store = rootVC?.store
        }
    }

    var source: Habit? {
        didSet {
            currentHabit = source
            self.counterNum = (currentHabit?.trackDates.count)!
            habitCounter.text = "Счетчик: \(counterNum)"
            titleLabel.text = currentHabit?.name
            frequencyLabel.text = currentHabit?.dateString
            titleLabel.textColor = currentHabit?.color
            checkButton.layer.borderColor = currentHabit?.color.cgColor
            checkButton.tintColor = currentHabit?.color
            if currentHabit?.isAlreadyTakenToday == true {
                setSelected()
            } else {
                setDeselected()
            }
        }
    }
    var currentHabit: Habit?
    var store: HabitsStore?
    var counterNum: Int = 0
    var currenttDate = Date(timeIntervalSinceNow: 0)
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17)
        label.numberOfLines = 2
        return label
    }()
    
    lazy var frequencyLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        label.font = .systemFont(ofSize: 12)
        return label
    }()
    
    lazy var habitCounter: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray2
        label.font = .systemFont(ofSize: 13)
        return label
    }()
    
    private let checkedImage = UIImage(
        systemName: "checkmark.circle.fill",
        withConfiguration: UIImage.SymbolConfiguration(
            pointSize: 35,
            weight: .regular,
            scale: .large
        )
    )
    
    lazy var checkButton: UIButton = {
        let view = UIButton(frame: CGRect(origin: .zero, size: CGSize(width: 34, height: 34)))
        view.layer.cornerRadius = 19
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addTarget(self, action: #selector(checkTapped), for: .touchUpInside)
        return view
    }()
    
    func setSelected() {
        checkButton.layer.borderWidth = 0
        checkButton.setImage(checkedImage, for: .normal)
    }
    
    func setDeselected() {
        checkButton.layer.backgroundColor = UIColor(named: "AppWhite")?.cgColor
        checkButton.layer.borderWidth = 2
        checkButton.setImage(nil, for: .normal)
    }
    
    @objc func checkTapped() {
        if rootVC?.store.habit(source!, isTrackedIn: currenttDate) == false {
            store?.track(currentHabit!)
            counterNum = (currentHabit?.trackDates.count)!
            setSelected()
            habitCounter.text = "Счетчик: \(counterNum)"
            rootVC?.updateCV1()
        } else {
            currentHabit?.trackDates.removeLast()
            setDeselected()
            counterNum = (currentHabit?.trackDates.count)!
            habitCounter.text = "Счетчик: \(counterNum)"
            rootVC?.updateCV1()
        }
    }
    
    private func setupConstraints() {
        contentView.snp.makeConstraints { (make) in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(12)
            make.height.equalTo(130)
            make.leading.equalTo(snp.leading).offset(12)
            make.trailing.equalTo(snp.trailing).offset(-12)
        }

        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(contentView.snp.top).offset(10)
            make.leading.equalTo(contentView.snp.leading).offset(20)
            make.width.equalTo(220)

        }

        frequencyLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.leading.equalTo(titleLabel.snp.leading)
        }

        habitCounter.snp.makeConstraints { (make) in
            make.top.equalTo(contentView.snp.top).offset(92)
            make.leading.equalTo(titleLabel.snp.leading)
        }
        
        checkButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(contentView.snp.centerY)
            make.trailing.equalTo(contentView.snp.trailing).offset(-25)
            make.width.equalTo(38)
            make.height.equalTo(38)
        }

    }
    private func setupView() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(frequencyLabel)
        contentView.addSubview(habitCounter)
        contentView.addSubview(checkButton)
        contentView.layer.backgroundColor = UIColor(named: "AppWhite")?.cgColor
        contentView.layer.cornerRadius = 8
   //     contentView.addSubview(checkedImage)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        setupConstraints()
    }
}

    

