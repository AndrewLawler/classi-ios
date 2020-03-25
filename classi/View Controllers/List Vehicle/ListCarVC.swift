//
//  ListCarVC.swift
//  classi
//
//  Created by Andrew Lawler on 23/03/2020.
//  Copyright © 2020 andrewlawler. All rights reserved.
//

import UIKit

class ListCarVC: UIViewController {
    
    
    let titleField = ClassiTextField(placeholder: "Title", backgroundColour: .white, outline: .classiBlue)
    let imageUpload = ClassiButton(backgroundColor: .classiBlue, title: "Upload Image", textColor: .white, borderColour: .white)
    
    let makeField = ClassiTextField(placeholder: "Make of Car", backgroundColour: .white, outline: .classiBlue)
    let modelField = ClassiTextField(placeholder: "Model of Car", backgroundColour: .white, outline: .classiBlue)
    let yearField = ClassiTextField(placeholder: "Year Car was produced", backgroundColour: .white, outline: .classiBlue)
    let mileageField = ClassiTextField(placeholder: "Mileage of Car", backgroundColour: .white, outline: .classiBlue)

    let priceField = ClassiTextField(placeholder: "Price of Car", backgroundColour: .white, outline: .classiBlue)
    let descriptionField = ClassiTextField(placeholder: "Description of Car", backgroundColour: .white, outline: .classiBlue)
    let postcodeField = ClassiTextField(placeholder: "Postcode", backgroundColour: .white, outline: .classiBlue)
    let phoneField = ClassiTextField(placeholder: "Phone Number", backgroundColour: .white, outline: .classiBlue)
    let emailField = ClassiTextField(placeholder: "Email", backgroundColour: .white, outline: .classiBlue)
    
    var userID: Auth?
    var myDelegate: FromModal?
    
    let submitButton = ClassiButton(backgroundColor: .classiBlue, title: "Submit", textColor: .white, borderColour: .white)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNav()
        configure()
    }
    
    func setupNav() {
        navigationController?.navigationBar.backgroundColor = .classiBlue
        title = "List Car"
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissVC))
        doneButton.tintColor = .white
        navigationItem.leftBarButtonItem = doneButton
    }
    
    @objc func dismissVC() {
        myDelegate!.fromModal(answer: true)
        dismiss(animated: true)
    }
    
    lazy var contentViewSize = CGSize(width: self.view.frame.width, height: self.view.frame.height + 350)
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.frame.size = contentViewSize
        return view
    }()
    
    lazy var scrollView: UIScrollView = {
        let view = UIScrollView(frame: .zero)
        view.backgroundColor = .white
        view.frame = self.view.bounds
        view.contentSize = contentViewSize
        return view
    }()
    
    @objc func submit() {
        NetworkManager.shared.listCar(token: userID!.token, title: titleField.text!, price: Int(priceField.text!)!, location: postcodeField.text!, description: descriptionField.text, phone: phoneField.text, email: emailField.text, make: makeField.text, model: modelField.text, year: Int(yearField.text!), mileage: Int(mileageField.text!)) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case.success(let listing):
                DispatchQueue.main.async {
                    self.presentClassiAlertOnMainThread(title: "Car Listed", message: "Your \(listing.car.make + " " + listing.car.model) has been successfully listed on the classi marketplace.", buttonTitle: "Ok")
                }
            case.failure(let error):
                print(error.rawValue)
            }
        }
    }
    
    func configure() {
        
        view.addSubview(scrollView)
        
        scrollView.addSubview(containerView)
        
        containerView.addSubview(titleField)
        containerView.addSubview(imageUpload)
        containerView.addSubview(makeField)
        containerView.addSubview(modelField)
        containerView.addSubview(yearField)
        containerView.addSubview(mileageField)
        containerView.addSubview(priceField)
        containerView.addSubview(descriptionField)
        containerView.addSubview(postcodeField)
        containerView.addSubview(phoneField)
        containerView.addSubview(emailField)
        containerView.addSubview(submitButton)
        
        let elements: [UITextField] = [titleField, makeField, modelField, yearField, mileageField, priceField, descriptionField, postcodeField, phoneField, emailField]
        for element in elements {
            element.textColor = .classiBlue
            element.attributedPlaceholder = NSAttributedString(string: element.placeholder!, attributes: [NSAttributedString.Key.foregroundColor : UIColor.systemGray3])
            element.layer.borderWidth = 5
            element.layer.borderColor = UIColor.classiBlue.cgColor
        }
        
        submitButton.addTarget(self, action: #selector(submit), for: .touchUpInside)
    
        submitButton.layer.cornerRadius = 25
        imageUpload.layer.cornerRadius = 25
        
        let padding: CGFloat = 20
        
        NSLayoutConstraint.activate([
            
            // add scroll view
            
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.heightAnchor.constraint(equalToConstant: view.frame.height),
            scrollView.leftAnchor.constraint(equalTo: view.leftAnchor),
            scrollView.rightAnchor.constraint(equalTo: view.rightAnchor),
            
            // add container view
            
            containerView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            containerView.leftAnchor.constraint(equalTo: scrollView.leftAnchor),
            containerView.rightAnchor.constraint(equalTo: scrollView.rightAnchor),
            
            // add rest to container view
            
            titleField.topAnchor.constraint(equalTo: containerView.topAnchor, constant: padding),
            titleField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            titleField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            titleField.heightAnchor.constraint(equalToConstant: 50),
            
            imageUpload.topAnchor.constraint(equalTo: titleField.bottomAnchor, constant: padding),
            imageUpload.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageUpload.widthAnchor.constraint(equalToConstant: 160),
            imageUpload.heightAnchor.constraint(equalToConstant: 50),
            
            makeField.topAnchor.constraint(equalTo: imageUpload.bottomAnchor, constant: padding),
            makeField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            makeField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            makeField.heightAnchor.constraint(equalToConstant: 50),
            
            modelField.topAnchor.constraint(equalTo: makeField.bottomAnchor, constant: padding),
            modelField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            modelField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            modelField.heightAnchor.constraint(equalToConstant: 50),
            
            yearField.topAnchor.constraint(equalTo: modelField.bottomAnchor, constant: padding),
            yearField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            yearField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            yearField.heightAnchor.constraint(equalToConstant: 50),
            
            mileageField.topAnchor.constraint(equalTo: yearField.bottomAnchor, constant: padding),
            mileageField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            mileageField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            mileageField.heightAnchor.constraint(equalToConstant: 50),
            
            priceField.topAnchor.constraint(equalTo: mileageField.bottomAnchor, constant: padding),
            priceField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            priceField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            priceField.heightAnchor.constraint(equalToConstant: 50),
            
            descriptionField.topAnchor.constraint(equalTo: priceField.bottomAnchor, constant: padding),
            descriptionField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            descriptionField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            descriptionField.heightAnchor.constraint(equalToConstant: 150),
            
            postcodeField.topAnchor.constraint(equalTo: descriptionField.bottomAnchor, constant: padding),
            postcodeField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            postcodeField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            postcodeField.heightAnchor.constraint(equalToConstant: 50),
            
            phoneField.topAnchor.constraint(equalTo: postcodeField.bottomAnchor, constant: padding),
            phoneField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            phoneField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            phoneField.heightAnchor.constraint(equalToConstant: 50),
            
            emailField.topAnchor.constraint(equalTo: phoneField.bottomAnchor, constant: padding*2),
            emailField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            emailField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            emailField.heightAnchor.constraint(equalToConstant: 50),
            
            submitButton.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: padding*2),
            submitButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            submitButton.heightAnchor.constraint(equalToConstant: 60),
            submitButton.widthAnchor.constraint(equalToConstant: 250)
            
            
        ])
            
        
        
    }
    
    


}


