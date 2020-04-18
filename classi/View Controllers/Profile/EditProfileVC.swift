//
//  EditProfileVC.swift
//  classi
//
//  Created by Andrew Lawler on 09/03/2020.
//  Copyright © 2020 andrewlawler. All rights reserved.
//

import UIKit
import SafariServices

class EditProfileVC: UIViewController {
    
    let usernameTextView = UITextField()
    
    let infoLabel = UILabel()
    let imageInfoLabel = UILabel()
    let usernameLabel = ClassiProfileLabel(textInput: "Name", numOfLines: 2)
    
    let saveButton = ClassiButton(backgroundColor: .classiBlue, title: "Save Changes", textColor: .white, borderColour: .classiBlue)
    let imageUploadButton = ClassiButton(backgroundColor: .white, title: "Upload Image via Website", textColor: .classiBlue, borderColour: .classiBlue)
    
    var image: UIImage?
    
    var userID: Auth?
    var user: User?
    
    lazy var contentViewSize = CGSize(width: self.view.frame.width, height: 450)
    
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
        createDismissKeyboardTapGesture()
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
    
    func createDismissKeyboardTapGesture() {
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
    
    @objc func saveChanges() {
        if !(usernameTextView.text!.isEmpty) {
            NetworkManager.shared.editName(user: userID!.user.id, name: usernameTextView.text!, token: userID!.token) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let resp):
                    self.presentClassiAlertOnMainThread(title: "Success", message: "You have successfully changed your name to \(self.usernameTextView.text!).", buttonTitle: "Ok")
                case .failure(let err):
                    self.presentClassiAlertOnMainThread(title: "Error", message: "Your request could not be fulfilled, please try again.", buttonTitle: "Ok")
                }
            }
        }
    }
    
    @objc func showSite() {
        if let url = URL(string: "https://classi-client.herokuapp.com") {
            let config = SFSafariViewController.Configuration()
            config.entersReaderIfAvailable = true
            let vc = SFSafariViewController(url: url, configuration: config)
            present(vc, animated: true)
        }
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
    
        usernameTextView.translatesAutoresizingMaskIntoConstraints = false
        usernameTextView.layer.cornerRadius = 16
        usernameTextView.layer.borderColor = UIColor.classiBlue.cgColor
        usernameTextView.layer.borderWidth = 5
        usernameTextView.placeholder = user?.name
        usernameTextView.textAlignment = .center
        
        usernameLabel.textAlignment = .left
        usernameLabel.textColor = .classiBlue
        
        saveButton.addTarget(self, action: #selector(saveChanges), for: .touchUpInside)
        
        imageUploadButton.addTarget(self, action: #selector(showSite), for: .touchUpInside)
        
        view.addSubview(scrollView)
        
        scrollView.addSubview(containerView)
        
        containerView.addSubview(usernameTextView)
        containerView.addSubview(infoLabel)
        containerView.addSubview(usernameLabel)
        containerView.addSubview(imageUploadButton)
        containerView.addSubview(saveButton)
        containerView.addSubview(imageInfoLabel)
        
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
            
            imageInfoLabel.topAnchor.constraint(equalTo: usernameTextView.bottomAnchor, constant: padding),
            imageInfoLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            imageInfoLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            imageInfoLabel.heightAnchor.constraint(equalToConstant: 60),
            
            imageUploadButton.topAnchor.constraint(equalTo: imageInfoLabel.bottomAnchor, constant: padding),
            imageUploadButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            imageUploadButton.heightAnchor.constraint(equalToConstant: 60),
            imageUploadButton.widthAnchor.constraint(equalToConstant: 250),
            
            saveButton.topAnchor.constraint(equalTo: imageUploadButton.bottomAnchor, constant: padding*2),
            saveButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            saveButton.heightAnchor.constraint(equalToConstant: 60),
            saveButton.widthAnchor.constraint(equalToConstant: 180)
            
            
        ])
            
    }

    
}

