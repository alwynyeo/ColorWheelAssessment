//
//  HomeViewController.swift
//  ColorWheel
//
//  Created by Alwyn Yeo on 8/15/24.
//

import UIKit

final class HomeViewController: UIViewController {

    // MARK: - UI
    
    private var firstSegmentedControlView: SegmentedControlView!
    private var secondSegmentedControlView: SegmentedControlView!
    private var thirdSegmentedControlView: SegmentedControlView!
    private var segmentedControlStackView: UIStackView!

    private var colorWheelView: ColorWheelView!

    private var brightnessSliderView: BrightnessSliderView!

    private var mainStackView: UIStackView!

    // MARK: - State

    var viewModel: HomeBusinessLogic!

    // MARK: - Object Lifecycle

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    convenience init() {
        self.init(nibName: nil, bundle: nil)
    }

    deinit {
        print("Deinit HomeViewController")
    }

    // MARK: - View Lifecycle

    override func loadView() {
        super.loadView()
        setupUI()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Override Parent Methods

    // MARK: - Setup

    private func setup() {
        let view = self
        let viewModel = HomeViewModel(view: view)
        view.viewModel = viewModel
    }

    // MARK: - Helpers
}

// MARK: - HomeDisplayLogic Extension
extension HomeViewController: HomeDisplayLogic {
    func updateFirstSegmentedControlViewStyle(isSelected: Bool) {
        firstSegmentedControlView.setIsSelected(isSelected)
    }

    func updateSecondSegmentedControlViewStyle(isSelected: Bool) {
        secondSegmentedControlView.setIsSelected(isSelected)
    }

    func updateThirdSegmentedControlViewStyle(isSelected: Bool) {
        thirdSegmentedControlView.setIsSelected(isSelected)
    }

    func updateFirstSegmentedControlViewCircularColor(with color: UIColor) {
        firstSegmentedControlView.setSelectedColor(with: color)
    }

    func updateSecondSegmentedControlViewCircularColor(with color: UIColor) {
        secondSegmentedControlView.setSelectedColor(with: color)
    }

    func updateThirdSegmentedControlViewCircularColor(with color: UIColor) {
        thirdSegmentedControlView.setSelectedColor(with: color)
    }

    func updateColorWheel(brightness: CGFloat) {
        colorWheelView.setViewBrightness(brightness)
    }

    func updateColorWheel(color: UIColor) {
        colorWheelView.setViewColor(color)
    }
}

// MARK: - ColorWheelDelegate Extension
extension HomeViewController: ColorWheelDelegate {
    func colorWheelDidChange(_ newColor: ColorWheelNewColor) {
        viewModel.updateColorWheel(color: newColor)
    }
}

// MARK: - SegmentedControlViewDelegate Extension
extension HomeViewController: SegmentedControlViewDelegate {
    func didTap(_ type: SegmentedControlViewTypeEnum?, currentColor: UIColor?) {
        viewModel.updateSelectedSegmentedControlView(for: type, currentColor: currentColor)
    }
}

// MARK: - BrightnessSliderViewDelegate Extension
extension HomeViewController: BrightnessSliderViewDelegate {
    func sliderDidChange(_ value: Float) {
        let color = colorWheelView.color
        viewModel.updateBrightness(value: value, color: color)
    }
}

// MARK: - Programmatic UI Setup
private extension HomeViewController {
    func setupUI() {
        view.backgroundColor = Color.background
        setupSegmentedControlViews()
        setupSegmentedControlStackView()
        setupColorWheelView()
        setupBrightnessSlider()
        setupMainStackView()
    }

    func setupSegmentedControlViews() {
        // FirstSegmentedControlView
        firstSegmentedControlView = SegmentedControlView(selectedColor: Color.teal)
        firstSegmentedControlView.delegate = self
        firstSegmentedControlView.tag = SegmentedControlViewTypeEnum.first.rawValue

        // SecondSegmentedControlView
        secondSegmentedControlView = SegmentedControlView(selectedColor: Color.green)
        secondSegmentedControlView.delegate = self
        secondSegmentedControlView.tag = SegmentedControlViewTypeEnum.second.rawValue

        // ThirdSegmentedControlView
        thirdSegmentedControlView = SegmentedControlView(selectedColor: Color.orange)
        thirdSegmentedControlView.delegate = self
        thirdSegmentedControlView.tag = SegmentedControlViewTypeEnum.third.rawValue
    }

    func setupSegmentedControlStackView() {
        segmentedControlStackView = UIStackView()
        segmentedControlStackView.axis = NSLayoutConstraint.Axis.horizontal
        segmentedControlStackView.distribution = UIStackView.Distribution.fillEqually
        segmentedControlStackView.spacing = 0.0
        segmentedControlStackView.alignment = UIStackView.Alignment.fill
        segmentedControlStackView.translatesAutoresizingMaskIntoConstraints = false

        segmentedControlStackView.addArrangedSubview(firstSegmentedControlView)
        segmentedControlStackView.addArrangedSubview(secondSegmentedControlView)
        segmentedControlStackView.addArrangedSubview(thirdSegmentedControlView)

        let constraints = [
            segmentedControlStackView.heightAnchor.constraint(equalToConstant: 120),
        ]
        
        NSLayoutConstraint.activate(constraints)
    }

    func setupColorWheelView() {
        let width = view.frame.width - 32
        let frame = CGRect(x: 0, y: 0, width: width, height: width)

        colorWheelView = ColorWheelView(frame: frame)
        colorWheelView.delegate = self
    }

    func setupBrightnessSlider() {
        brightnessSliderView = BrightnessSliderView()
        brightnessSliderView.delegate = self
    }

    func setupMainStackView() {
        mainStackView = UIStackView()
        mainStackView.axis = NSLayoutConstraint.Axis.vertical
        mainStackView.distribution = UIStackView.Distribution.fill
        mainStackView.spacing = 24.0
        mainStackView.alignment = UIStackView.Alignment.fill
        mainStackView.translatesAutoresizingMaskIntoConstraints = false

        mainStackView.addArrangedSubview(segmentedControlStackView)
        mainStackView.addArrangedSubview(colorWheelView)
        mainStackView.addArrangedSubview(brightnessSliderView)

        view.addSubview(mainStackView)

        let constraints = [
            mainStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            mainStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            mainStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            mainStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
        ]

        NSLayoutConstraint.activate(constraints)
    }
}
