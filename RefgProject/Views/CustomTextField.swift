//
//  CustomTextField.swift
//  RefgProject
//
//  Created by 23 09 on 2024/01/24.
//

import Foundation
import UIKit

class CustomTextField: UITextField {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = UIColor(hexString: "F1F1F1")
        self.layer.cornerRadius = 15
        self.autocorrectionType = .no
        self.spellCheckingType = .no
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
