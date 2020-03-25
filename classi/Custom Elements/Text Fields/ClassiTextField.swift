//
//  ClassiTextField.swift
//  classi
//
//  Created by Andrew Lawler on 08/03/2020.
//  Copyright © 2020 andrewlawler. All rights reserved.
//

import UIKit

class ClassiTextField: UITextField {

    // adding the init method
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    // adding the needed required init but it is not implemented as we don't use storyboard
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(placeholder: String, backgroundColour: UIColor, outline: UIColor ) {
        super.init(frame: .zero)
        configure()
        self.placeholder = placeholder
        self.backgroundColor = backgroundColor
        self.layer.borderColor = outline.cgColor
    }
    
    // styling the text fields
    private func configure() {
        
        // don't auto generate autolayout constraints
        translatesAutoresizingMaskIntoConstraints = false
    
        textColor = .classiBlue
        textAlignment = .center
        font = UIFont.preferredFont(forTextStyle: .title2)
        adjustsFontSizeToFitWidth = true
        minimumFontSize = 12
        layer.cornerRadius = 16
        layer.borderWidth = 2
                            
        autocorrectionType = .no
        returnKeyType = .continue
        clearButtonMode = .whileEditing
    }
}
