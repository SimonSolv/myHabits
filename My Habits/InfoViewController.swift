//
//  InfoViewController.swift
//  My Habits
//
//  Created by Simon Pegg on 01.10.2021.
//

import UIKit

class InfoViewController: UIViewController, Coordinated {
    var coordinator: MainCoordinator
    let mainView = UIScrollView()
    let contentView = UIView()
    
    let textTitle: UILabel = {
        let label = UILabel()
        label.text = "Привычка за 21 день"
        label.font = .boldSystemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
        
    }()
    
    let textContent: UILabel = {
        let view = UILabel()
        view.text = "Прохождение этапов, за которые за 21 день вырабатывается привычка, подчиняется следующему алгоритму:\n\n1. Провести 1 день без обращения к старым привычкам, стараться вести себя так, как будто цель, загаданная в перспективу, находится на расстоянии шага. \n\n2. Выдержать 2 дня в прежнем состоянии самоконтроля. \n\n3. Отметить в дневнике первую неделю изменений и подвести первые итоги — что оказалось тяжело, что — легче, с чем еще предстоит серьезно бороться.\n\n4. Поздравить себя с прохождением первого серьезного порога в 21 день. За это время отказ от дурных наклонностей уже примет форму осознанного преодоления и человек сможет больше работать в сторону принятия положительных качеств.\n\n5. Держать планку 40 дней. Практикующий методику уже чувствует себя освободившимся от прошлого негатива и двигается в нужном направлении с хорошей динамикой. \n\n6. На 90-й день соблюдения техники все лишнее из «прошлой жизни» перестает напоминать о себе, и человек, оглянувшись назад, осознает себя полностью обновившимся."
        view.font = .systemFont(ofSize: 17)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.numberOfLines = 0
        return view
    }()
    
    init(coordinator: MainCoordinator) {
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Информация"
        self.view.backgroundColor = UIColor(cgColor: CGColor(red: 255, green: 255, blue: 255, alpha: 1))
        setupViews()
    }
    
    private func setupViews() {
        view.addSubview(mainView)
        mainView.addSubview(contentView)
        contentView.addSubview(textTitle)
        contentView.addSubview(textContent)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        mainView.translatesAutoresizingMaskIntoConstraints = false
        
        let constraints = [
            mainView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mainView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            mainView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            mainView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            
            contentView.topAnchor.constraint(equalTo: mainView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: mainView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: mainView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: mainView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: mainView.widthAnchor),
            
            textTitle.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 22),
            textTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            textTitle.heightAnchor.constraint(equalToConstant: 24),
            textTitle.widthAnchor.constraint(equalToConstant: 240),
            
            textContent.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 62),
            textContent.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            textContent.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
        //    textContent.heightAnchor.constraint(equalToConstant: 780),
            textContent.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        
        
        ]
        NSLayoutConstraint.activate(constraints)
    }

}
