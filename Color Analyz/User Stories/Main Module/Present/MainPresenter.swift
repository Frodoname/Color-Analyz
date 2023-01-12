//
//  MainPresenter.swift
//  Color Analyz
//
//  Created by Fed on 11.01.2023.
//

import UIKit
import AVFoundation

protocol MainViewPresenterOutput: AnyObject {
    func unexpectedError(description: String)
    func accessToCameraDenied()
    func updateValues()
}

protocol MainViewPresenterInput: AnyObject {
    func analyzeColors(from image: CMSampleBuffer)
    var session: AVCaptureSession { get }
    var output: AVCaptureVideoDataOutput { get }
    var previewLayer: AVCaptureVideoPreviewLayer { get }
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
    
    func analyzeColors(from image: CMSampleBuffer) {
        guard let imageBuffer = CMSampleBufferGetImageBuffer(image) else {
            return
        }
        let ciImage = CIImage(cvPixelBuffer: imageBuffer)
        let image = analyzeService.convertToUIImage(from: ciImage)
        let colors = analyzeService.findColors(image)
        colorModel = analyzeService.findPopularColors(with: colors, on: image)
        DispatchQueue.main.async {
            self.view?.updateValues()
        }
    }
    
    // MARK: - Private Methods
    
    private func checkCameraPremissions() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                guard granted else {
                    self?.view?.accessToCameraDenied()
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
            DispatchQueue.main.async {
                self.setupCamera()
            }
        @unknown default:
            view?.accessToCameraDenied()
            break
        }
    }
    
    private func setupCamera() {
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
                
                DispatchQueue.global(qos: .userInteractive).async {
                    self.session.startRunning()
                }
            } catch {
                view?.unexpectedError(description: error.localizedDescription)
            }
        }
    }
}
