//
//  ClassiAlertVC.swift
//  classi
//
//  Created by Andrew Lawler on 23/03/2020.
//  Copyright © 2020 andrewlawler. All rights reserved.
//

import UIKit

class ClassiAlertVC: UIViewController {
    
    // MARK:- UI Elements
    // UI elements
    let containerView = ClassiContainerView(backgroundColor: .systemBackground, cornerRadius: 16, borderWidth: 2, borderColor: .white)
    let titleLabel = ClassiTitleLabel(textAlignment: .center, fontSize: 20)
    let messageLabel = ClassiBodyLabel(textAlignment: .center)
    let dismissButton = ClassiButton(backgroundColor: .classiBlue, title: "Ok", textColor: .white, borderColour: .white)
    
    // MARK:- Parameters
    // parameters being passed into the ViewController
    var alertTitle: String?
    var message: String?
    var buttonTitle: String?
    
    // padding variable which we will use throughout
    let padding: CGFloat = 20
    
    // MARK:- Initialisers
    // custom init to use
    init(title: String, message: String, buttonTitle: String){
        super.init(nibName: nil, bundle: nil)
        self.alertTitle = title
        self.message = message
        self.buttonTitle = buttonTitle
    }

    // required Storyboard init
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK:- ViewDid Load
    // VDL
    override func viewDidLoad() {
        super.viewDidLoad()
        // setting our view's alpha
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.75)
        configureContainerView()
        configureTitleLabel()
        configureButtons()
        configureMessageLabel()
    }
    
    // MARK:- Constraints
    
    func configureContainerView() {
        view.addSubview(containerView)
        
        NSLayoutConstraint.activate([
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.widthAnchor.constraint(equalToConstant: 280),
            containerView.heightAnchor.constraint(equalToConstant: 220)
        ])
    }
    
    // setting up our UI elements constraints and adding them to the main view.
    
    func configureTitleLabel() {
        containerView.addSubview(titleLabel)
        titleLabel.text = alertTitle ?? "Something wen't wrong"
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: padding),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            titleLabel.heightAnchor.constraint(equalToConstant: 28)
        ])
    }
    
    func configureButtons() {
        containerView.addSubview(dismissButton)

        dismissButton.layer.cornerRadius = 10
        
        dismissButton.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            dismissButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -padding),
            dismissButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            dismissButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            dismissButton.heightAnchor.constraint(equalToConstant: 44),
        ])
    }
    
    func configureMessageLabel() {
        containerView.addSubview(messageLabel)
        messageLabel.text = message ?? "Unable to complete request"
        messageLabel.numberOfLines = 4
        
        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            messageLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            messageLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            messageLabel.bottomAnchor.constraint(equalTo: dismissButton.topAnchor, constant: -12)
        ])
    }
    
    // MARK:- Obj-c
    // our dismiss obj-c method
    
    @objc func dismissVC() {
        dismiss(animated: true)
    }
    

}
