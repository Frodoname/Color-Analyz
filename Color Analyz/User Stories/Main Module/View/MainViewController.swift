//
//  MainViewController.swift
//  Color Analyz
//
//  Created by Fed on 11.01.2023.
//

import UIKit

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
        view.layer.addSublayer(presenter.previewLayer)
        layoutSetup()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        presenter.previewLayer.frame = cameraView.bounds
    }
    
    
}

// MARK: - Presenter Output

extension MainViewController: MainViewPresenterOutput {
    func accessToCameraDenied() {
        showAlert(alertText: "Access Denied", alertMessage: "Check the settings, please") {
            #warning("Сделать диплинк в настройки")
        }
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
            colorModelCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    func createCameraView() -> UIView {
        let view = UIView()
        return view
    }
    
    func createCollectionView() -> UICollectionView {
        let layout = createLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isScrollEnabled = false
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

// MARK: - CollectionView Delegate

extension MainViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        presenter.colorModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reusableId, for: indexPath) as? ColorModelCell else {
            return UICollectionViewCell()
        }
        cell.configureCell(with: presenter.colorModel[indexPath.row])
        return cell
    }
}

