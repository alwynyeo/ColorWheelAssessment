//
//  SegmentedControlView.swift
//  ColorWheel
//
//  Created by Alwyn Yeo on 8/15/24.
//

import UIKit

enum SegmentedControlViewTypeEnum: Int {
    case first = 1
    case second = 2
    case third = 3
}

protocol SegmentedControlViewDelegate: AnyObject {
    func didTap(_ type: SegmentedControlViewTypeEnum?, currentColor: UIColor?)
}

final class SegmentedControlView: UIView {

    // MARK: - UI

    private var colorView: UIView!
    private var tapGestureRecognizer: UITapGestureRecognizer!
    private var selectedColor: UIColor!

    // MARK: - Delegate

    weak var delegate: SegmentedControlViewDelegate?

    // MARK: - Object Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    convenience init(selectedColor: UIColor) {
        self.init(frame: CGRect.zero)
        setSelectedColor(with: selectedColor)
    }

    // MARK: - Helpers

    func setIsSelected(_ isSelected: Bool) {
        backgroundColor = isSelected ? Color.elementSelectedBackground : Color.elementBackground
    }

    func setSelectedColor(with newColor: UIColor) {
        selectedColor = newColor
        colorView.backgroundColor = newColor
    }

    // MARK: - Private Helpers
    @objc private func handleTapGestureRecognizer(_ sender: UITapGestureRecognizer) {
        let type = SegmentedControlViewTypeEnum(rawValue: tag)
        delegate?.didTap(type, currentColor: selectedColor)
    }
}

// MARK: - Programmatic UI Setup
private extension SegmentedControlView {
    func setupUI() {
        backgroundColor = Color.elementBackground
        setupColorView()
        setupTapGestureRecognizer()
    }

    func setupColorView() {
        let frame = CGRect(x: 0, y: 0, width: 35, height: 35)
        colorView = UIView(frame: frame)
        colorView.backgroundColor = Color.white
        selectedColor = Color.white
        colorView.layer.cornerRadius = frame.width / 2
        colorView.clipsToBounds = true
        colorView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(colorView)

        let constraints = [
            colorView.widthAnchor.constraint(equalToConstant: 35),
            colorView.heightAnchor.constraint(equalToConstant: 35),
            colorView.centerXAnchor.constraint(equalTo: centerXAnchor),
            colorView.centerYAnchor.constraint(equalTo: centerYAnchor),
        ]

        NSLayoutConstraint.activate(constraints)
    }

    func setupTapGestureRecognizer() {
        tapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(handleTapGestureRecognizer(_:))
        )

        addGestureRecognizer(tapGestureRecognizer)
    }
}
