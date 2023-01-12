//
//  MainViewController.swift
//  Color Analyz
//
//  Created by Fed on 11.01.2023.
//

import UIKit
import AVFoundation

class MainViewController: UIViewController {
    
    var presenter: MainViewPresenterInput!
    
    // MARK: - Local Constants & Variables
    
    private let reusableId = "reusableIdCell"
    
    // MARK: - UI Elements
    
    private lazy var cameraView: UIView = createCameraView()
    private lazy var colorModelCollectionView: UICollectionView = createCollectionView()
    
    // MARK: - ViewDidLoad & ViewDidLayoutSubViews
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewDidLoadSetup()
        layoutSetup()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        presenter.previewLayer.frame = cameraView.bounds
    }
    
    // MARK: - Private Methods
    
    private func viewDidLoadSetup() {
        view.layer.addSublayer(presenter.previewLayer)
        presenter.output.setSampleBufferDelegate(self, queue: DispatchQueue.global(qos: .userInitiated))
        colorModelCollectionView.delegate = self
        colorModelCollectionView.dataSource = self
    }
}

// MARK: - Presenter Output & AV Delegate

extension MainViewController: MainViewPresenterOutput, AVCaptureVideoDataOutputSampleBufferDelegate {
    func unexpectedError(description :String) {
        showAlert(alertText: "An unexpected error has occurred", alertMessage: description, buttonTitle: "Sadly", buttonStyle: .default) {
            
        }
    }
    
    func updateValues() {
        self.colorModelCollectionView.reloadData()
    }
    
    func accessToCameraDenied() {
        DispatchQueue.main.async {
            self.showAlert(alertText: "Access Denied", alertMessage: "Please allow access to your camera", buttonTitle: "Go To Settings", buttonStyle: .default) {
                guard let url = URL(string: UIApplication.openSettingsURLString) else {
                    return
                }
                UIApplication.shared.open(url)
            }
        }
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        presenter.analyzeColors(from: sampleBuffer)
    }
}

// MARK: - CollectionView Delegate

extension MainViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.colorModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reusableId, for: indexPath) as? ColorModelCell else {
            return UICollectionViewCell()
        }
        cell.configureCell(with: presenter.colorModel[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: view.frame.width * 0.17, height: view.frame.height * 0.1)
    }
}

// MARK: - Creating UI Elements & Layout

private
extension MainViewController {
    func layoutSetup() {
        [cameraView, colorModelCollectionView].forEach {
            view.addSubview($0)
            $0.prepareForAutoLayOut()
        }
        
        NSLayoutConstraint.activate([
            cameraView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            cameraView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            cameraView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            cameraView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.7),
            
            colorModelCollectionView.topAnchor.constraint(equalTo: cameraView.bottomAnchor),
            colorModelCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            colorModelCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            colorModelCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)

        ])
    }
    
    func createCameraView() -> UIView {
        let view = UIView()
        return view
    }
    
    func createCollectionView() -> UICollectionView {
        let layout = createLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .black
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(ColorModelCell.self, forCellWithReuseIdentifier: reusableId)
        return collectionView
    }
    
    func createLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        return layout
    }
}

