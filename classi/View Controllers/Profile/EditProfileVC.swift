//
//  EditProfileVC.swift
//  classi
//
//  Created by Andrew Lawler on 09/03/2020.
//  Copyright © 2020 andrewlawler. All rights reserved.
//

import UIKit

class EditProfileVC: UIViewController {
    
    let usernameTextView = UITextField()
    let bioTextView = UITextField()
    let emailTextView = UITextField()
    
    let infoLabel = UILabel()
    let imageInfoLabel = UILabel()
    let emailInfoLabel = UILabel()
    
    let emailLabel = ClassiProfileLabel(textInput: "E-mail", numOfLines: 1)
    let usernameLabel = ClassiProfileLabel(textInput: "Name", numOfLines: 2)
    let bioLabel = ClassiProfileLabel(textInput: "Bio", numOfLines: 1)
    
    let saveButton = ClassiButton(backgroundColor: .classiBlue, title: "Save Changes", textColor: .white, borderColour: .classiBlue)
    let imageUploadButton = ClassiButton(backgroundColor: .white, title: "Upload Image", textColor: .classiBlue, borderColour: .classiBlue)
    
    var userID: Auth?
    
    lazy var contentViewSize = CGSize(width: self.view.frame.width, height: self.view.frame.height + 100)
    
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

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configure()
        setupNav()
    }
    
    func setupNav() {
        navigationController?.navigationBar.backgroundColor = .classiBlue
        title = "Edit Profile"
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissVC))
        doneButton.tintColor = .white
        navigationItem.leftBarButtonItem = doneButton
    }
    
    @objc func dismissVC() {
        dismiss(animated: true)
    }
    
    @objc func saveChanges() {
        // saveChanges
        // make post request to userID
    }
    
    func configure() {
        infoLabel.text = "Use the input areas to edit your profile! Click save once you've finished."
        infoLabel.numberOfLines = 0
        infoLabel.textAlignment = .center
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        infoLabel.font = UIFont(name: "HelveticaNeue", size: 17)
        infoLabel.textColor = .systemGray2
        
        imageInfoLabel.text = "The image uploaded here will be used on your profile, we will need permissions so be sure to accept them!"
        imageInfoLabel.numberOfLines = 0
        imageInfoLabel.textAlignment = .center
        imageInfoLabel.translatesAutoresizingMaskIntoConstraints = false
        imageInfoLabel.font = UIFont(name: "HelveticaNeue", size: 17)
        imageInfoLabel.textColor = .systemGray2
        
        emailInfoLabel.text = "Your email will not be displayed on your profile, it will only be used when a user wants to make a bid"
        emailInfoLabel.numberOfLines = 0
        emailInfoLabel.textAlignment = .center
        emailInfoLabel.translatesAutoresizingMaskIntoConstraints = false
        emailInfoLabel.font = UIFont(name: "HelveticaNeue", size: 17)
        emailInfoLabel.textColor = .systemGray2
        
        usernameTextView.translatesAutoresizingMaskIntoConstraints = false
        usernameTextView.layer.cornerRadius = 16
        usernameTextView.layer.borderColor = UIColor.classiBlue.cgColor
        usernameTextView.layer.borderWidth = 5
        usernameTextView.placeholder = "Add a name"
        usernameTextView.textAlignment = .center
        
        emailTextView.translatesAutoresizingMaskIntoConstraints = false
        emailTextView.layer.cornerRadius = 16
        emailTextView.layer.borderColor = UIColor.classiBlue.cgColor
        emailTextView.layer.borderWidth = 5
        emailTextView.placeholder = "Add an Email"
        emailTextView.textAlignment = .center
        
        bioTextView.translatesAutoresizingMaskIntoConstraints = false
        bioTextView.layer.cornerRadius = 30
        bioTextView.layer.borderColor = UIColor.classiBlue.cgColor
        bioTextView.layer.borderWidth = 5
        bioTextView.placeholder = "Add a Bio, max 50 characters!"
        bioTextView.textAlignment = .center
        
        usernameLabel.textAlignment = .left
        usernameLabel.textColor = .classiBlue
        bioLabel.textAlignment = .left
        bioLabel.textColor = .classiBlue
        emailLabel.textAlignment = .left
        emailLabel.textColor = .classiBlue
        
        saveButton.addTarget(self, action: #selector(saveChanges), for: .touchUpInside)
        
        view.addSubview(scrollView)
        
        scrollView.addSubview(containerView)
        
        containerView.addSubview(usernameTextView)
        containerView.addSubview(bioTextView)
        containerView.addSubview(infoLabel)
        containerView.addSubview(usernameLabel)
        containerView.addSubview(bioLabel)
        containerView.addSubview(imageUploadButton)
        containerView.addSubview(saveButton)
        containerView.addSubview(imageInfoLabel)
        containerView.addSubview(emailLabel)
        containerView.addSubview(emailTextView)
        containerView.addSubview(emailInfoLabel)
        
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
            
            infoLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: padding),
            infoLabel.widthAnchor.constraint(equalToConstant: view.bounds.width-40),
            infoLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            infoLabel.heightAnchor.constraint(equalToConstant: 40),
            
            usernameLabel.topAnchor.constraint(equalTo: infoLabel.bottomAnchor, constant: padding),
            usernameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            usernameLabel.heightAnchor.constraint(equalToConstant: 40),
            usernameLabel.widthAnchor.constraint(equalToConstant: 300),
            
            usernameTextView.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: padding),
            usernameTextView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            usernameTextView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            usernameTextView.heightAnchor.constraint(equalToConstant: 50),
            
            emailLabel.topAnchor.constraint(equalTo: usernameTextView.bottomAnchor, constant: padding),
            emailLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            emailLabel.heightAnchor.constraint(equalToConstant: 40),
            emailLabel.widthAnchor.constraint(equalToConstant: 300),
            
            emailInfoLabel.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: padding),
            emailInfoLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            emailInfoLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            emailInfoLabel.heightAnchor.constraint(equalToConstant: 60),
            
            emailTextView.topAnchor.constraint(equalTo: emailInfoLabel.bottomAnchor, constant: padding),
            emailTextView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            emailTextView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            emailTextView.heightAnchor.constraint(equalToConstant: 50),
            
            bioLabel.topAnchor.constraint(equalTo: emailTextView.bottomAnchor, constant: padding),
            bioLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            bioLabel.heightAnchor.constraint(equalToConstant: 40),
            bioLabel.widthAnchor.constraint(equalToConstant: 70),
            
            bioTextView.topAnchor.constraint(equalTo: bioLabel.bottomAnchor, constant: padding),
            bioTextView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            bioTextView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            bioTextView.heightAnchor.constraint(equalToConstant: 150),
            
            imageInfoLabel.topAnchor.constraint(equalTo: bioTextView.bottomAnchor, constant: padding),
            imageInfoLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            imageInfoLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            imageInfoLabel.heightAnchor.constraint(equalToConstant: 60),
            
            imageUploadButton.topAnchor.constraint(equalTo: imageInfoLabel.bottomAnchor, constant: padding),
            imageUploadButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            imageUploadButton.heightAnchor.constraint(equalToConstant: 60),
            imageUploadButton.widthAnchor.constraint(equalToConstant: 180),
            
            saveButton.topAnchor.constraint(equalTo: imageUploadButton.bottomAnchor, constant: padding*2),
            saveButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            saveButton.heightAnchor.constraint(equalToConstant: 60),
            saveButton.widthAnchor.constraint(equalToConstant: 180)
            
            
        ])
            
        
        
    }
    
    


}
