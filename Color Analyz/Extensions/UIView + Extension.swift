//
//  UIView + Extension.swift
//  Color Analyz
//
//  Created by Fed on 11.01.2023.
//

import UIKit

extension UIView {
    @discardableResult
    func prepareForAutoLayOut() -> Self {
        self.translatesAutoresizingMaskIntoConstraints = false
        return self
    }
}
