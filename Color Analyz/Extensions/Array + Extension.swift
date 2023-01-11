//
//  Array + Extension.swift
//  Color Analyz
//
//  Created by Fed on 11.01.2023.
//

import Foundation

extension Array {
    init(repeating: (() -> Element), count: Int) {
        self = []
        for _ in 0..<count {
            self.append(repeating())
        }
    }
}
