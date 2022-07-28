import UIKit
import SwiftUI
import SnapKit

class ProgressCollectionViewCell: UICollectionViewCell {
    static let identifier = "progressCell"
    var source: HabitsStore? {
        didSet {
            progress = source?.todayProgress
            progressBar.snp.makeConstraints { (make) in
                make.width.equalTo(progress!)
                percentLabel.text = "\(Int(progress ?? 0))%"
            }
        }
    }
    var onTap: (() -> Void)?
    var progress: Float? = 0
    var rootVC: HabitsViewController?
    public var screenWidth: CGFloat {
        return UIScreen.main.bounds.width
    }
    
    lazy var titleLabel: UILabel = {
        let label = UILabel(frame: CGRect(origin: .zero, size: CGSize(width: 215, height: 18)))
        label.text = "Все получится!"
        label.font = .systemFont(ofSize: 18)
        label.textColor = .darkGray
        return label
    }()
    
    lazy var percentLabel: UILabel = {
        let label = UILabel(frame: CGRect(origin: .zero, size: CGSize(width: 95, height: 18)))
        label.text = "\(Int(progress ?? 0))%"
        label.font = .systemFont(ofSize: 18)
        label.textAlignment = .right
        label.textColor = .darkGray
        return label
    }()
    
    lazy var progressBarLayout: UIView = {
        let view = UIView()
        view.layer.backgroundColor = UIColor.lightGray.cgColor
        view.layer.cornerRadius = 3
        view.clipsToBounds = true
        return view
    }()
    
    lazy var progressBar: UIView = {
        let view = UIView()
        view.layer.backgroundColor = UIColor(named: "AppFiolet")?.cgColor
        view.layer.cornerRadius = 3
        view.clipsToBounds = true
        return view
    }()
    
    private func setupConstraints() {
        contentView.snp.makeConstraints { (make) in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(12)
            make.height.equalTo(60)
            make.leading.equalTo(snp.leading).offset(12)
            make.trailing.equalTo(snp.trailing).offset(-12)
        }

        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(contentView.snp.top).offset(10)
            make.leading.equalTo(contentView.snp.leading).offset(12)

        }

        percentLabel.snp.makeConstraints { (make) in
            make.top.equalTo(contentView.snp.top).offset(10)
            make.trailing.equalTo(contentView.snp.trailing).offset(-12)
        }

        progressBarLayout.snp.makeConstraints { (make) in
            make.top.equalTo(contentView.snp.top).offset(38)
            make.leading.equalTo(titleLabel.snp.leading)
            make.height.equalTo(7)
            make.width.equalTo(screenWidth - 50)
        }

        progressBar.snp.makeConstraints { (make) in
            make.top.equalTo(progressBarLayout.snp.top)
            make.leading.equalTo(progressBarLayout.snp.leading)
            make.height.equalTo(7)
            make.width.equalTo(progress!)
        }
    }
    
    private func setupView() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(percentLabel)
        contentView.addSubview(progressBarLayout)
        contentView.addSubview(progressBar)
        contentView.bringSubviewToFront(progressBar)
        contentView.layer.backgroundColor = UIColor.white.cgColor
        contentView.layer.cornerRadius = 8
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
