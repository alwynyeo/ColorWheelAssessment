//
//  BrightnessSliderView.swift
//  ColorWheel
//
//  Created by Alwyn Yeo on 8/15/24.
//

import UIKit

protocol BrightnessSliderViewDelegate: AnyObject {
    func sliderDidChange(_ value: Float)
}

final class BrightnessSliderView: UIView {

    // MARK: - UI

    private var titleLabel: UILabel!
    private var slider: UISlider!

    // MARK: - Delegate

    weak var delegate: BrightnessSliderViewDelegate?

    // MARK: - Object Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    // MARK: - Private Helpers

    @objc private func handleSlider(_ sender: UISlider) {
        let value = sender.value
        let formattedValue = Int(value * 100)
        let titleString = "Brightness: \(formattedValue)%"
        titleLabel.text = titleString
        delegate?.sliderDidChange(value)
    }
}

// MARK: - Programmatic UI Setup
private extension BrightnessSliderView {
    func setupUI() {
        setupTitleLabel()
        setupSlider()
    }

    func setupTitleLabel() {
        titleLabel = UILabel()
        titleLabel.text = "Brightness: 100%"
        titleLabel.textColor = Color.white
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        addSubview(titleLabel)

        let constraints = [
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
        ]

        NSLayoutConstraint.activate(constraints)
    }

    func setupSlider() {
        slider = UISlider()
        slider.minimumValue = 0
        slider.maximumValue = 1
        slider.value = 1 // Initial value
        slider.translatesAutoresizingMaskIntoConstraints = false

        slider.addTarget(
            self,
            action: #selector(handleSlider(_:)),
            for: UIControl.Event.valueChanged
        )

        addSubview(slider)

        let constraints = [
            slider.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24),
            slider.leadingAnchor.constraint(equalTo: leadingAnchor),
            slider.trailingAnchor.constraint(equalTo: trailingAnchor),
            slider.bottomAnchor.constraint(equalTo: bottomAnchor),
        ]

        NSLayoutConstraint.activate(constraints)
    }
}

