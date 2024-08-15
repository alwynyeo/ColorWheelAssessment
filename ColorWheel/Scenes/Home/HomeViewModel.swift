//
//  HomeViewModel.swift
//  ColorWheel
//
//  Created by Alwyn Yeo on 8/15/24.
//

import UIKit

final class HomeViewModel {

    // MARK: - Declarations

    weak var view: HomeDisplayLogic?

    private var selectedSegmentedControlViewType: SegmentedControlViewTypeEnum?

    // MARK: - Object Lifecycle

    init(view: HomeDisplayLogic) {
        self.view = view
    }

    // MARK: - Helpers
}

// MARK: - HomeBusinessLogic Extension
extension HomeViewModel: HomeBusinessLogic {
    func updateSelectedSegmentedControlView(for type: SegmentedControlViewTypeEnum?, currentColor: UIColor?) {
        selectedSegmentedControlViewType = type
        let isFirstSegmentedControlViewSelected = type == SegmentedControlViewTypeEnum.first
        let isSecondSegmentedControlViewSelected = type == SegmentedControlViewTypeEnum.second
        let isThirdSegmentedControlViewSelected = type == SegmentedControlViewTypeEnum.third
        view?.updateFirstSegmentedControlViewStyle(isSelected: isFirstSegmentedControlViewSelected)
        view?.updateSecondSegmentedControlViewStyle(isSelected: isSecondSegmentedControlViewSelected)
        view?.updateThirdSegmentedControlViewStyle(isSelected: isThirdSegmentedControlViewSelected)

        guard let currentColor = currentColor else { return }
        
        view?.updateColorWheel(color: currentColor)
    }

    func updateColorWheel(color: ColorWheelNewColor) {
        guard let selectedSegmentedControlViewType = selectedSegmentedControlViewType else { return }
        
        let color = UIColor(
            hue: color.hue,
            saturation: color.saturation,
            brightness: color.brightness,
            alpha: color.alpha
        )

        switch selectedSegmentedControlViewType {
            case .first:
                view?.updateFirstSegmentedControlViewCircularColor(with: color)
            case .second:
                view?.updateSecondSegmentedControlViewCircularColor(with: color)
            case .third:
                view?.updateThirdSegmentedControlViewCircularColor(with: color)
        }
    }

    func updateBrightness(value: Float, color: UIColor) {
        let brightness = CGFloat(value)
        view?.updateColorWheel(brightness: brightness)

        guard let selectedSegmentedControlViewType = selectedSegmentedControlViewType else { return }

        switch selectedSegmentedControlViewType {
            case .first:
                view?.updateFirstSegmentedControlViewCircularColor(with: color)
            case .second:
                view?.updateSecondSegmentedControlViewCircularColor(with: color)
            case .third:
                view?.updateThirdSegmentedControlViewCircularColor(with: color)
        }
    }
}
