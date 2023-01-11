//
//  Sequence + Extension.swift
//  Color Analyz
//
//  Created by Fed on 11.01.2023.
//

import Foundation

extension Sequence where Self.Iterator.Element: Hashable {
    func frequencies() -> [(Self.Iterator.Element,Int)] {
        var frequency: [Self.Iterator.Element:Int] = [:]
        for x in self {
            frequency[x] = (frequency[x] ?? 0) + 1
        }
        return frequency.sorted { $0.1 > $1.1 }
    }
}
