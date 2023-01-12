//
//  ColorModel.swift
//  Color Analyz
//
//  Created by Fed on 11.01.2023.
//

import Foundation

struct ColorModel {
    let red: CGFloat
    let green: CGFloat
    let blue: CGFloat
    let alpha: CGFloat
    let numberOfPixels: Int
    let totalNumberOfPixels: Float
    
    var precentArea: String {
        let digit = Float(numberOfPixels) / totalNumberOfPixels * 100
        return String(format: "%.2f", digit)
    }
}
