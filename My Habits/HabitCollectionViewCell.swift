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
            titleLabel.text = source?.name
            frequencyLabel.text = source?.dateString
            titleLabel.textColor = source?.color
            checkButton.layer.borderColor = source?.color.cgColor
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
        label.textColor = .lightGray
        label.font = .systemFont(ofSize: 12)
        return label
    }()
    
    lazy var habitCounter: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = .systemFont(ofSize: 13)
        return label
    }()
    
    lazy var checkButton: UIButton = {
        let view = UIButton(frame: CGRect(origin: .zero, size: CGSize(width: 38, height: 38)))
        view.layer.cornerRadius = 19
        view.layer.borderWidth = 2
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addTarget(self, action: #selector(checkTapped), for: .touchUpInside)
        return view
    }()
    
    
    @objc func checkTapped() {
        if rootVC?.store.habit(source!, isTrackedIn: currenttDate) == false {
            store?.track(currentHabit!)
        }
        checkButton.layer.borderWidth = 0
        checkButton.layer.backgroundColor = UIColor.green.cgColor
        habitCounter.text = "Счетчик: \(counterNum+1)"
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
        }
        
    }
    private func setupView() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(frequencyLabel)
        contentView.addSubview(habitCounter)
        contentView.addSubview(checkButton)
        contentView.layer.backgroundColor = UIColor.white.cgColor
        contentView.layer.cornerRadius = 8
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
        if rootVC?.store.habit(source!, isTrackedIn: currenttDate) == true {
            checkButton.layer.borderWidth = 0
            checkButton.layer.backgroundColor = UIColor.green.cgColor
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        setupConstraints()
    }
}

enum HabitState {
    case isTaken
    case notTaken
}

class CustomCheckButton: UIButton {
    var buttonState: HabitState = .notTaken
    init() {
        super.init(frame: CGRect(origin: .zero, size: CGSize(width: 38, height: 38)))
        switch buttonState {
        case .isTaken:
            self.layer.borderWidth = 0
            self.layer.backgroundColor = UIColor.green.cgColor
        case .notTaken:
            self.layer.cornerRadius = 19
            self.layer.borderWidth = 2
        }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
