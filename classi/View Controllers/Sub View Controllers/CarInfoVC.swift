//
//  CarInfoVC.swift
//  classi
//
//  Created by Andrew Lawler on 09/03/2020.
//  Copyright © 2020 andrewlawler. All rights reserved.
//

import UIKit

class CarInfoVC: UIViewController {
    
    let personImage = UIImageView()
    let viewsImage = UIImageView()
    let currencyImage = UIImageView()
    let yearImage = UIImageView()
    
    let personLabel = UILabel()
    let viewsLabel = UILabel()
    let currencyLabel = UILabel()
    let yearLabel = UILabel()
    
    let leftView = UIView()
    let rightView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    init(owner: String, price: String, year: String, views: Int) {
        super.init(nibName: nil, bundle: nil)
        self.personLabel.text = owner
        self.currencyLabel.text = price
        self.viewsLabel.text = "\(views)"
        self.yearLabel.text = year
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureView() {
        view.backgroundColor = .classiBlue
        view.layer.borderColor = UIColor.white.cgColor
        view.layer.borderWidth = 3
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 40
    }
    
    func configureUIElements() {
        personImage.image = UIImage(systemName: "person.circle")
        personImage.translatesAutoresizingMaskIntoConstraints = false
        personImage.tintColor = .white
        
        viewsImage.image = UIImage(systemName: "eye")
        viewsImage.translatesAutoresizingMaskIntoConstraints = false
        viewsImage.tintColor = .white
        
        currencyImage.image = UIImage(systemName: "sterlingsign.circle")
        currencyImage.translatesAutoresizingMaskIntoConstraints = false
        currencyImage.tintColor = .white
        
        yearImage.image = UIImage(systemName: "calendar.circle")
        yearImage.translatesAutoresizingMaskIntoConstraints = false
        yearImage.tintColor = .white
        
        personLabel.adjustsFontSizeToFitWidth = true
        personLabel.translatesAutoresizingMaskIntoConstraints = false
        personLabel.font = UIFont(name: "HelveticaNeue", size: 15)
        personLabel.textColor = .white
        
        viewsLabel.adjustsFontSizeToFitWidth = true
        viewsLabel.translatesAutoresizingMaskIntoConstraints = false
        viewsLabel.font = UIFont(name: "HelveticaNeue", size: 15)
        viewsLabel.textColor = .white
        
        currencyLabel.adjustsFontSizeToFitWidth = true
        currencyLabel.translatesAutoresizingMaskIntoConstraints = false
        currencyLabel.font = UIFont(name: "HelveticaNeue", size: 15)
        currencyLabel.textColor = .white
        
        yearLabel.adjustsFontSizeToFitWidth = true
        yearLabel.translatesAutoresizingMaskIntoConstraints = false
        yearLabel.font = UIFont(name: "HelveticaNeue", size: 15)
        yearLabel.textColor = .white
    }
    
    func configureStackView() {
        leftView.addSubview(personImage)
        leftView.addSubview(personLabel)
        leftView.addSubview(viewsLabel)
        leftView.addSubview(viewsImage)
        
        rightView.addSubview(currencyImage)
        rightView.addSubview(currencyLabel)
        rightView.addSubview(yearImage)
        rightView.addSubview(yearLabel)
        
            
        let stackView = UIStackView(arrangedSubviews: [leftView, rightView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: view.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func configure() {
        configureView()
        configureUIElements()
        configureStackView()
        
        let padding: CGFloat = 10
        let outerPadding: CGFloat = 20
        
        NSLayoutConstraint.activate([
            personImage.topAnchor.constraint(equalTo: leftView.topAnchor, constant: outerPadding),
            personImage.leadingAnchor.constraint(equalTo: leftView.leadingAnchor, constant: outerPadding),
            personImage.heightAnchor.constraint(equalToConstant: 50),
            personImage.widthAnchor.constraint(equalToConstant: 50),
            
            personLabel.topAnchor.constraint(equalTo: leftView.topAnchor, constant: 35),
            personLabel.leadingAnchor.constraint(equalTo: personImage.trailingAnchor, constant: padding),
            personLabel.widthAnchor.constraint(equalToConstant: 100),
            personLabel.heightAnchor.constraint(equalToConstant: 20),
            
            viewsImage.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -outerPadding),
            viewsImage.leadingAnchor.constraint(equalTo: leftView.leadingAnchor, constant: outerPadding),
            viewsImage.heightAnchor.constraint(equalToConstant: 50),
            viewsImage.widthAnchor.constraint(equalToConstant: 50),
            
            viewsLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -35),
            viewsLabel.leadingAnchor.constraint(equalTo: viewsImage.trailingAnchor, constant: padding),
            viewsLabel.widthAnchor.constraint(equalToConstant: 100),
            viewsLabel.heightAnchor.constraint(equalToConstant: 20),
            
            currencyImage.topAnchor.constraint(equalTo: rightView.topAnchor, constant: outerPadding),
            currencyImage.leadingAnchor.constraint(equalTo: rightView.leadingAnchor, constant: outerPadding),
            currencyImage.heightAnchor.constraint(equalToConstant: 50),
            currencyImage.widthAnchor.constraint(equalToConstant: 50),
            
            currencyLabel.topAnchor.constraint(equalTo: rightView.topAnchor, constant: 35),
            currencyLabel.leadingAnchor.constraint(equalTo: currencyImage.trailingAnchor, constant: padding),
            currencyLabel.widthAnchor.constraint(equalToConstant: 100),
            currencyLabel.heightAnchor.constraint(equalToConstant: 20),
            
            yearImage.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -outerPadding),
            yearImage.leadingAnchor.constraint(equalTo: rightView.leadingAnchor, constant: outerPadding),
            yearImage.heightAnchor.constraint(equalToConstant: 50),
            yearImage.widthAnchor.constraint(equalToConstant: 50),
            
            yearLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -35),
            yearLabel.leadingAnchor.constraint(equalTo: yearImage.trailingAnchor, constant: padding),
            yearLabel.widthAnchor.constraint(equalToConstant: 70),
            yearLabel.heightAnchor.constraint(equalToConstant: 20),
        
        ])
        
    }
    
    

}
