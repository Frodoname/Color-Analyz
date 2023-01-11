//
//  MainPresenter.swift
//  Color Analyz
//
//  Created by Fed on 11.01.2023.
//

import Foundation
import AVFoundation

protocol MainViewPresenterOutput: AnyObject {
    func accessToCameraDenied()
}

protocol MainViewPresenterInput: AnyObject {
    var session: AVCaptureSession { get set }
    var output: AVCaptureVideoDataOutput { get set }
    var previewLayer: AVCaptureVideoPreviewLayer { get set }
    var colorModel: [ColorModel] { get set }
    init(view: MainViewPresenterOutput, analyzeService: AnalyzeServiceProtocol, session: AVCaptureSession,
         output: AVCaptureVideoDataOutput, previewLayer: AVCaptureVideoPreviewLayer)
}

final class MainPresenter: MainViewPresenterInput {
    
    weak var view: MainViewPresenterOutput?
    let analyzeService: AnalyzeServiceProtocol!
    var session: AVCaptureSession
    var output: AVCaptureVideoDataOutput
    var previewLayer: AVCaptureVideoPreviewLayer
    var colorModel: [ColorModel] = []
    
    init(view: MainViewPresenterOutput, analyzeService: AnalyzeServiceProtocol, session: AVCaptureSession,
         output: AVCaptureVideoDataOutput, previewLayer: AVCaptureVideoPreviewLayer) {
        self.view = view
        self.analyzeService = analyzeService
        self.session = session
        self.output = output
        self.previewLayer = previewLayer
        checkCameraPremissions()
    }
    
    private func checkCameraPremissions() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                guard granted else {
                    return
                }
                
                DispatchQueue.main.async {
                    self?.setupCamera()
                }
            }
        case .restricted:
            view?.accessToCameraDenied()
            break
        case .denied:
            view?.accessToCameraDenied()
            break
        case .authorized:
            setupCamera()
        @unknown default:
            view?.accessToCameraDenied()
            break
        }
    }
    
    private func setupCamera() {
        let session = AVCaptureSession()
        if let device = AVCaptureDevice.default(for: .video) {
            do {
                let input = try AVCaptureDeviceInput(device: device)
                
                if session.canAddInput(input) {
                    session.addInput(input)
                }
                
                if session.canAddOutput(output) {
                    session.addOutput(output)
                }
                
                previewLayer.videoGravity = .resizeAspectFill
                previewLayer.session = session
                
                DispatchQueue.global(qos: .background).async {
                    session.startRunning()
                    self.session = session
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
