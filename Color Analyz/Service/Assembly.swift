//
//  Assembly.swift
//  Color Analyz
//
//  Created by Fed on 11.01.2023.
//

import UIKit

protocol AssemblyProtocol: AnyObject {
    func createMainModule() -> UIViewController
}

final class Assembly: AssemblyProtocol {
    func createMainModule() -> UIViewController {
        let view = MainViewController()
        return view
    }
}
