//
//  ClassiButton.swift
//  classi
//
//  Created by Andrew Lawler on 08/03/2020.
//  Copyright © 2020 andrewlawler. All rights reserved.
//

import UIKit

class ClassiButton: UIButton {

    override init(frame: CGRect) {
        // calling apples super.button code
        super.init(frame: frame)
        // configuring our button
        configure()
    }
    
    // we are not using StoryBoard so this doesn't matter
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // making a customsed initialiser for the button, think of this as a constructor
    convenience init(backgroundColor: UIColor, title: String, textColor: UIColor, borderColour: UIColor){
        // needs to call super init and we have no frame so use .zero
        self.init(frame: .zero)
        // set the background color and the title
        self.backgroundColor = backgroundColor
        self.setTitle(title, for: .normal)
        self.setTitleColor(textColor, for: .normal)
        self.layer.borderColor = borderColour.cgColor
    }
    
    private func configure() {
        // setting the style of the button
        layer.cornerRadius = 30
        titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
        translatesAutoresizingMaskIntoConstraints = false
        layer.borderWidth = 2
    }

}
