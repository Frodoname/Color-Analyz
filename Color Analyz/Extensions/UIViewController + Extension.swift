//
//  UIViewController + Extension.swift
//  Color Analyz
//
//  Created by Fed on 11.01.2023.
//

import UIKit

extension UIViewController {
    func showAlert(alertText : String, alertMessage : String, completion: @escaping () -> Void) {
        let alert = UIAlertController(title: alertText, message: alertMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Clear", style: .destructive, handler: { _ in
            completion()
            
        }))
        self.present(alert, animated: true, completion: nil)
    }
}
