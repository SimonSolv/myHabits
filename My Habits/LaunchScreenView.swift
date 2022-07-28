//
//  LaunchScreenView.swift
//  My Habits
//
//  Created by Simon Pegg on 01.10.2021.
//

import UIKit

class LaunchScreenView: UIView {
    
    var labelView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .white
        view.image = UIImage(named: "AppIcon")
        view.layer.backgroundColor = UIColor(red: 0.949, green: 0.949, blue: 0.969, alpha: 1).cgColor
        view.layer.cornerRadius = 27
        view.clipsToBounds = true
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = UIColor(red: 0.361, green: 0.38, blue: 0.399, alpha: 1)
        addSubview(labelView)
        let constraints = [
            labelView.topAnchor.constraint(equalTo: topAnchor, constant: 346),
            labelView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 128),
            labelView.heightAnchor.constraint(equalToConstant: 120),
            labelView.widthAnchor.constraint(equalToConstant: 120)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
