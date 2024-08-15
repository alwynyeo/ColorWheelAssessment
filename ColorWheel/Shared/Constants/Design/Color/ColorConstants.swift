//
//  DesignConstants.swift
//  ColorWheel
//
//  Created by Alwyn Yeo on 8/15/24.
//

import UIKit

typealias Color = Constants.Design.Color

extension Constants.Design {
    enum Color {
        static let background = UIColor(hexString: "#1a1a1a")
        static let white = UIColor.white
        static let elementBackground = UIColor(hexString: "#2c2c2c")
        static let elementSelectedBackground = UIColor(hexString: "#3b3b3b")

        static let teal = UIColor(hexString: "#00c2a3")
        static let green = UIColor(hexString: "#4ba54f")
        static let orange = UIColor(hexString: "#ff6100")
    }
}
