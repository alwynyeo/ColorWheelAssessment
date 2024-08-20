//
//  UIDevice+Extension.swift
//  ColorWheel
//
//  Created by Alwyn Yeo on 8/21/24.
//

import UIKit

extension UIDevice {
    /// A Boolean value indicating whether the device is in portrait mode.
    ///
    /// - Returns: `true` if the device is in portrait mode (either upright or upside-down), otherwise `false`.
    var isPortrait: Bool {
        return orientation == UIDeviceOrientation.portrait || orientation == UIDeviceOrientation.portraitUpsideDown
    }

    /// A Boolean value indicating whether the device is in landscape mode.
    ///
    /// - Returns: `true` if the device is in landscape mode (either left or right), otherwise `false`.
    var isLandscape: Bool {
        return orientation == UIDeviceOrientation.landscapeLeft || orientation == UIDeviceOrientation.landscapeRight
    }
}
