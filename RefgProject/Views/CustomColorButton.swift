//
//  CustomColorButton.swift
//  RefgProject
//
//  Created by 23 09 on 2024/01/24.
//

import Foundation
import UIKit

class CustomColorButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        //원일때 사이즈 조정
        if let image = UIImage(systemName: "circle.fill") {
            let resizedImage = image.withConfiguration(UIImage.SymbolConfiguration(pointSize: 24, weight: .regular))
            self.setImage(resizedImage, for: .normal)

        }

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
