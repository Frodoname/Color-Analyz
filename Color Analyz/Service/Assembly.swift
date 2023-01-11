//
//  Assembly.swift
//  Color Analyz
//
//  Created by Fed on 11.01.2023.
//

import UIKit
import AVFoundation

protocol AssemblyProtocol: AnyObject {
    func createMainModule() -> UIViewController
}

final class Assembly: AssemblyProtocol {
    func createMainModule() -> UIViewController {
        let view = MainViewController()
        let analyzeService = AnalyzeService()
        let session = AVCaptureSession()
        let output = AVCaptureVideoDataOutput()
        let previewLayer = AVCaptureVideoPreviewLayer()
        let presenter = MainPresenter(view: view, analyzeService: analyzeService, session: session, output: output, previewLayer: previewLayer)
        view.presenter = presenter
        return view
    }
}
