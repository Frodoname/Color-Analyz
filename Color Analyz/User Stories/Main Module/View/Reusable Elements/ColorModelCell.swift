//
//  ColorModelCell.swift
//  Color Analyz
//
//  Created by Fed on 11.01.2023.
//

import UIKit

final class ColorModelCell: UICollectionViewCell {
    
    // MARK: - Public Methods
    
    func configureCell(with color: ColorModel) {
        precentLabel.text = "\(color.precentArea) %"
        redColorLabel.text = "r: \(color.red)"
        greenColorLabel.text = "g: \(color.green)"
        blueColorLabel.text = "b: \(color.blue)"
        opacityLabel.text = "a: \(color.alpha)"
    }
    
    // MARK: - Local Constants
    
    private let padding: CGFloat = 5
    private let precentLabelFontSize: CGFloat = 17
    private let colorLabelFontSize: CGFloat = 11
    
    // MARK: - UI Elements
    
    private lazy var precentLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: precentLabelFontSize)
        label.textColor = .white
        label.text = "0 %"
        label.textAlignment = .center
        return label
    }()
    
    private lazy var redColorLabel: UILabel = {
        let label = UILabel()
        label.text = "r:"
        label.font = UIFont.systemFont(ofSize: colorLabelFontSize)
        label.textColor = .white
        return label
    }()
    
    private lazy var greenColorLabel: UILabel = {
        let label = UILabel()
        label.text = "g:"
        label.font = UIFont.systemFont(ofSize: colorLabelFontSize)
        label.textColor = .white
        return label
    }()
    
    private lazy var blueColorLabel: UILabel = {
        let label = UILabel()
        label.text = "b:"
        label.font = UIFont.systemFont(ofSize: colorLabelFontSize)
        label.textColor = .white
        return label
    }()
    
    private lazy var opacityLabel: UILabel = {
        let label = UILabel()
        label.text = "a:"
        label.font = UIFont.systemFont(ofSize: colorLabelFontSize)
        label.textColor = .white
        return label
    }()
    
    private lazy var vStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [redColorLabel, greenColorLabel, blueColorLabel, opacityLabel])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 0
        return stackView
    }()

    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        layout()
        viewSetup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layout setup
    
    private func viewSetup() {
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.white.cgColor
    }
    
    private func layout() {
        [precentLabel, vStack].forEach {
            contentView.addSubview($0)
            $0.prepareForAutoLayOut()
        }
        
        NSLayoutConstraint.activate([
            precentLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            precentLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            precentLabel.topAnchor.constraint(equalTo: topAnchor),
            
            vStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            vStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            vStack.topAnchor.constraint(equalTo: precentLabel.bottomAnchor),
            vStack.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
