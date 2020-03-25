//
//  ViewCarVC.swift
//  classi
//
//  Created by Andrew Lawler on 08/03/2020.
//  Copyright © 2020 andrewlawler. All rights reserved.
//

import UIKit
import MessageUI

class ViewCarVC: UIViewController, MFMailComposeViewControllerDelegate {
    
    let carImage = UIImageView()
    let carDescriptionLabel = UILabel()
    let contactOwnerLabel = UILabel()
    let contactOwnerButton = ClassiButton(backgroundColor: .white, title: "Contact Owner", textColor: .classiBlue, borderColour: .classiBlue)
    let reportView = UIView()
    let infoView = UIView()
    
    var listing: Listing?
    var userID: Auth?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNav()
        getUser()
        add(childVC: ReportListingVC(listing: listing!, id: userID), to: reportView)
        view.backgroundColor = .classiBlue
        configureUI()
    }
    
    // Network call to get user info so we don't display email to non signed up users
    func getUser() {
        NetworkManager.shared.getUser(id: listing!.userId) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let user):
                DispatchQueue.main.async {
                    self.add(childVC: CarInfoVC(owner: user.name, price: "\(self.listing!.price)", year: "\(self.listing!.car.year)"), to: self.infoView)
                }
            case.failure(let error):
                print(error.rawValue)
            }
        }
    }
    
    func setupNav() {
        title = "\((listing?.car.make)! + " " + (listing?.car.model)!)"
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissVC))
        doneButton.tintColor = .white
        navigationItem.leftBarButtonItem = doneButton
    }
    
    @objc func dismissVC() {
        dismiss(animated: true)
    }
    
    func add(childVC: UIViewController, to containerView: UIView) {
        addChild(childVC)
        containerView.addSubview(childVC.view)
        childVC.view.frame = containerView.bounds
        childVC.didMove(toParent: self)
    }
    
    @objc func contactOwner() {
        if userID != nil {
            if MFMailComposeViewController.canSendMail() {
                let mail = MFMailComposeViewController()
                mail.mailComposeDelegate = self
                mail.setToRecipients(["\(listing?.email)"])
                mail.setMessageBody("<p>Classi Enquiry</p>", isHTML: true)
                present(mail, animated: true)
            } else {
                print("Failure")
            }
        }
        else {
            self.presentClassiAlertOnMainThread(title: "Access Denied! Sign Up", message: "You cannot use that feature without signing up to the app.", buttonTitle: "Ok")
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
    func configureUI() {
        
        let carImageView = UIView()
        carImageView.addSubview(carImage)
        carImageView.layer.cornerRadius = 30
        carImageView.layer.masksToBounds = true
        carImageView.translatesAutoresizingMaskIntoConstraints = false
        carImageView.layer.borderWidth = 3
        carImageView.layer.borderColor = UIColor.white.cgColor
        
        carImage.clipsToBounds = true
        carImage.translatesAutoresizingMaskIntoConstraints = false
        carImage.image = UIImage(named: "Car")
        
        carDescriptionLabel.text = listing?.description
        carDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        carDescriptionLabel.textAlignment = .center
        carDescriptionLabel.numberOfLines = 0
        carDescriptionLabel.adjustsFontSizeToFitWidth = true
        carDescriptionLabel.font = UIFont(name: "HelveticaNeue", size: 15)
        carDescriptionLabel.textColor = .white
        
        contactOwnerLabel.text = "Contact the owner to view or make a bid on this vehicle."
        contactOwnerLabel.translatesAutoresizingMaskIntoConstraints = false
        contactOwnerLabel.textAlignment = .center
        contactOwnerLabel.numberOfLines = 0
        contactOwnerLabel.font = UIFont(name: "HelveticaNeue", size: 15)
        contactOwnerLabel.textColor = .white
        
        reportView.translatesAutoresizingMaskIntoConstraints = false
        infoView.translatesAutoresizingMaskIntoConstraints = false
        
        contactOwnerButton.addTarget(self, action: #selector(contactOwner), for: .touchUpInside)
        
        view.addSubview(carImageView)
        view.addSubview(carDescriptionLabel)
        view.addSubview(infoView)
        view.addSubview(contactOwnerLabel)
        view.addSubview(contactOwnerButton)
        view.addSubview(reportView)
        
        let padding: CGFloat = 20
        let itemPadding: CGFloat = 10
        
        NSLayoutConstraint.activate([
        
            carImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: padding),
            carImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            carImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            carImageView.heightAnchor.constraint(equalToConstant: 200),
            
            carImage.centerYAnchor.constraint(equalTo: carImageView.centerYAnchor),
            carImage.centerXAnchor.constraint(equalTo: carImageView.centerXAnchor),
            carImage.widthAnchor.constraint(equalToConstant: view.frame.width-20),
            carImage.heightAnchor.constraint(equalToConstant: 220),
            
            carDescriptionLabel.topAnchor.constraint(equalTo: carImageView.bottomAnchor, constant: itemPadding),
            carDescriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding+5),
            carDescriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding-5),
            carDescriptionLabel.heightAnchor.constraint(equalToConstant: 40),
            
            infoView.topAnchor.constraint(equalTo: carDescriptionLabel.bottomAnchor, constant: itemPadding),
            infoView.heightAnchor.constraint(equalToConstant: 150),
            infoView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            infoView.widthAnchor.constraint(equalToConstant: 330),
            
            contactOwnerLabel.topAnchor.constraint(equalTo: infoView.bottomAnchor, constant: itemPadding),
            contactOwnerLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 80),
            contactOwnerLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -80),
            contactOwnerLabel.heightAnchor.constraint(equalToConstant: 40),
            
            contactOwnerButton.topAnchor.constraint(equalTo: contactOwnerLabel.bottomAnchor, constant: itemPadding),
            contactOwnerButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 60),
            contactOwnerButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -60),
            contactOwnerButton.heightAnchor.constraint(equalToConstant: 60),
            
            reportView.topAnchor.constraint(equalTo: contactOwnerButton.bottomAnchor, constant: padding),
            reportView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            reportView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            reportView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }



}
