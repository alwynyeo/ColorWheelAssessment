//
//  HomeViewTypes.swift
//  ColorWheel
//
//  Created by Alwyn Yeo on 8/15/24.
//

import UIKit

protocol HomeBusinessLogic {
    func updateSelectedSegmentedControlView(for type: SegmentedControlViewTypeEnum?, currentColor: UIColor?)
    func updateColorWheel(color: ColorWheelNewColor)
    func updateBrightness(value: Float, color: UIColor)
}

protocol HomeDisplayLogic: AnyObject {
    func updateFirstSegmentedControlViewStyle(isSelected: Bool)
    func updateSecondSegmentedControlViewStyle(isSelected: Bool)
    func updateThirdSegmentedControlViewStyle(isSelected: Bool)
    func updateFirstSegmentedControlViewCircularColor(with color: UIColor)
    func updateSecondSegmentedControlViewCircularColor(with color: UIColor)
    func updateThirdSegmentedControlViewCircularColor(with color: UIColor)
    func updateColorWheel(brightness: CGFloat)
    func updateColorWheel(color: UIColor)
}
