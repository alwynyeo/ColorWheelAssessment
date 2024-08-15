//
//  ColorWheelView.swift
//  ColorWheel
//
//  Created by Alwyn Yeo on 8/15/24.
//

import UIKit

// Type alias for RGB color values
typealias RGB = (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat)

// Type alias for HSV color values
typealias HSV = (hue: CGFloat, saturation: CGFloat, brightness: CGFloat, alpha: CGFloat)

struct ColorWheelNewColor {
    let hue: CGFloat
    let saturation: CGFloat
    let brightness: CGFloat
    let alpha: CGFloat
}

protocol ColorWheelDelegate: AnyObject {
    func colorWheelDidChange(_ newColor: ColorWheelNewColor)
}

final class ColorWheelView: UIView {

    // Public properties
    var indicatorCircleRadius: CGFloat = 17.5
    var indicatorColor: CGColor = Color.white.cgColor
    var indicatorBorderWidth: CGFloat = 2.0


    // Color, can only be set privately
    private(set) var color: UIColor = Color.white // Initial color

    // Brightness, can only be set privately
    private(set) var brightness: CGFloat = 1.0 // Initial brightness

    // Layer for the Hue and Saturation wheel
    private var wheelLayer: CALayer!

    // Overlay layer for the brightness
    private var brightnessLayer: CAShapeLayer!

    // Layer for the indicator
    private var indicatorLayer: CAShapeLayer!
    private var point: CGPoint!

    // Retina scaling factor
    let scale: CGFloat = UIScreen.main.scale

    // MARK: - Delegate

    weak var delegate: ColorWheelDelegate?

    // MARK: - Object Lifecycle

    init(frame: CGRect, color: UIColor = Color.white) {
        super.init(frame: frame)

        self.color = color

        // Layer for the Hue/Saturation wheel
        let (width, height) = (frame.width, frame.height)
        let whiteLayerFrame = CGRect(
            x: 0,
            y: 0,
            width: width,
            height: height
        )
        wheelLayer = CALayer()
        wheelLayer.frame = whiteLayerFrame
        wheelLayer.contents = createColorWheel(wheelLayer.frame.size)
        layer.addSublayer(wheelLayer)

        // Layer for the brightness
        brightnessLayer = CAShapeLayer()
        let brightnessLayerRoundedRect = CGRect(
            x: 0,
            y: 0,
            width: width,
            height: height
        )
        let path = UIBezierPath(
            roundedRect: brightnessLayerRoundedRect,
            cornerRadius: height / 2
        ).cgPath
        brightnessLayer.path = path
        layer.addSublayer(brightnessLayer)

        // Layer for the indicator
        indicatorLayer = CAShapeLayer()
        indicatorLayer.strokeColor = indicatorColor
        indicatorLayer.lineWidth = indicatorBorderWidth
        indicatorLayer.fillColor = nil
        layer.addSublayer(indicatorLayer)

        setViewColor(color)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    // MARK: - Override Parent Methods

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchHandler(touches)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchHandler(touches)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchHandler(touches)
    }

    // MARK: - Helpers

    func setViewColor(_ color: UIColor!) {
        // Update the entire view with a given color

        var hue: CGFloat = 0.0
        var saturation: CGFloat = 0.0
        var brightness: CGFloat = 0.0
        var alpha: CGFloat = 0.0

        let isSuccess: Bool = color.getHue(
            &hue,
            saturation: &saturation,
            brightness: &brightness,
            alpha: &alpha
        )

        guard isSuccess else {
            print("Error happened under \(#function) at line \(#line) in \(#fileID) file.")
            return
        }

        // Update the view's brightness and color
        self.color = color
        self.brightness = brightness
        brightnessLayer.fillColor = UIColor(white: 0, alpha: 1.0 - brightness).cgColor
        point = pointAtHueSaturation(hue, saturation: saturation)

        // Redraw the indicator
        drawIndicator()
    }

    func setViewBrightness(_ _brightness: CGFloat) {
        // Update the brightness of the view
        var hue: CGFloat = 0.0
        var saturation: CGFloat = 0.0
        var brightness: CGFloat = 0.0
        var alpha: CGFloat = 0.0

        let isSuccess: Bool = color.getHue(
            &hue,
            saturation: &saturation,
            brightness: &brightness,
            alpha: &alpha
        )

        guard isSuccess else {
            print("Error happened under \(#function) at line \(#line) in \(#fileID) file.")
            return
        }

        // Calculate the scaled point and retrieve hue and saturation at that point
        let point = CGPoint(x: point.x * scale, y: point.y * scale)
        let colorAtPoint = hueSaturationAtPoint(point)

        // Update hue and saturation based on the new brightness
        hue = _brightness > 0.01 ? colorAtPoint.hue : 0.0
        saturation = _brightness > 0.01 ? colorAtPoint.saturation : 0.0

        // Update the view's brightness and color
        self.brightness = _brightness
        brightnessLayer.fillColor = UIColor(white: 0, alpha: 1.0 - _brightness).cgColor
        color = UIColor(hue: hue, saturation: saturation, brightness: _brightness, alpha: 1.0)

        // Redraw the indicator
        drawIndicator()
    }
}

private extension ColorWheelView {
    func touchHandler(_ touches: Set<UITouch>) {
        // Set reference to the location of the touch in member point

        let view = self

        if let touch = touches.first {
            point = touch.location(in: view)
        }

        let indicatorCoordinate = getIndicatorCoordinate(point)

        point = indicatorCoordinate

        let point = CGPoint(x: point.x * scale, y: point.y * scale)

        let color = hueSaturationAtPoint(point)

        let newColor = ColorWheelNewColor(
            hue: color.hue,
            saturation: color.saturation,
            brightness: brightness,
            alpha: 1.0
        )

        self.color = UIColor(
            hue: newColor.hue,
            saturation: newColor.saturation,
            brightness: newColor.brightness,
            alpha: newColor.alpha
        )

        // Notify delegate of the new color
        delegate?.colorWheelDidChange(newColor)

        // Draw the indicator
        drawIndicator()
    }

    func drawIndicator() {
        // Draw the indicator
        guard point != nil else { return }

        let roundedRect = CGRect(
            x: point.x - indicatorCircleRadius,
            y: point.y - indicatorCircleRadius,
            width: indicatorCircleRadius * 2,
            height: indicatorCircleRadius * 2
        )

        let path = UIBezierPath(
            roundedRect: roundedRect,
            cornerRadius: indicatorCircleRadius
        ).cgPath

        indicatorLayer.shouldRasterize = true
        indicatorLayer.shadowOpacity = 0.5
        indicatorLayer.shadowOffset = CGSize(width: 0, height: 4)
        indicatorLayer.shadowRadius = 23.0
        indicatorLayer.shadowColor = Color.black.cgColor
        indicatorLayer.path = path
        indicatorLayer.fillColor = color.cgColor
    }

    func getIndicatorCoordinate(_ coordinate: CGPoint) -> CGPoint {
        // Making sure that the indicator can't get outside the Hue and Saturation wheel

        let dimension = min(wheelLayer.frame.width, wheelLayer.frame.height)
        let radius = dimension / 2
        let wheelLayerCenter = CGPoint(
            x: wheelLayer.frame.origin.x + radius,
            y: wheelLayer.frame.origin.y + radius
        )

        let dx = coordinate.x - wheelLayerCenter.x
        let dy = coordinate.y - wheelLayerCenter.y
        let distance = sqrt((dx * dx) + (dy * dy))
        var outputCoordinate = coordinate

        // If the touch coordinate is outside the radius of the wheel, transform it to the edge of the wheel with polar coordinates
        if (distance > radius) {
            let theta = atan2(dy, dx)
            outputCoordinate.x = (radius * cos(theta)) + wheelLayerCenter.x
            outputCoordinate.y = (radius * sin(theta)) + wheelLayerCenter.y
        }

        return outputCoordinate
    }

    func createColorWheel(_ size: CGSize) -> CGImage {
        // Creates a bitmap of the Hue Saturation wheel
        let originalWidth = size.width
        let originalHeight = size.height
        let dimension = min(originalWidth * scale, originalHeight * scale)
        let bufferLength = Int(dimension * dimension * 4)

        let bitmapData: CFMutableData = CFDataCreateMutable(nil, 0)
        CFDataSetLength(bitmapData, CFIndex(bufferLength))
        let bitmap = CFDataGetMutableBytePtr(bitmapData)

        for y in stride(from: 0, to: dimension, by: 1) {
            for x in stride(from: 0, to: dimension, by: 1) {
                var hsv: HSV = (hue: 0, saturation: 0, brightness: 0, alpha: 0)
                var rgb: RGB = (red: 0, green: 0, blue: 0, alpha: 0)

                let color = hueSaturationAtPoint(CGPoint(x: x, y: y))
                let hue = color.hue
                let saturation = color.saturation
                var a: CGFloat = 0.0
                if (saturation < 1.0) {
                    // Antialias the edge of the circle.
                    if (saturation > 0.99) {
                        a = (1.0 - saturation) * 100
                    } else {
                        a = 1.0
                    }

                    hsv.hue = hue
                    hsv.saturation = saturation
                    hsv.brightness = 1.0
                    hsv.alpha = a
                    rgb = hsv2rgb(hsv)
                }
                let offset = Int(4 * (x + y * dimension))
                bitmap?[offset] = UInt8(rgb.red * 255)
                bitmap?[offset + 1] = UInt8(rgb.green * 255)
                bitmap?[offset + 2] = UInt8(rgb.blue * 255)
                bitmap?[offset + 3] = UInt8(rgb.alpha * 255)
            }
        }

        // Convert the bitmap to a CGImage
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let dataProvider = CGDataProvider(data: bitmapData)
        let bitmapInfo = CGBitmapInfo(rawValue: CGBitmapInfo().rawValue | CGImageAlphaInfo.last.rawValue)
        let imageRef = CGImage(
            width: Int(dimension),
            height: Int(dimension),
            bitsPerComponent: 8,
            bitsPerPixel: 32,
            bytesPerRow: Int(dimension) * 4,
            space: colorSpace,
            bitmapInfo: bitmapInfo,
            provider: dataProvider!,
            decode: nil,
            shouldInterpolate: false,
            intent: CGColorRenderingIntent.defaultIntent
        )
        return imageRef!
    }

    func hueSaturationAtPoint(_ position: CGPoint) -> (hue: CGFloat, saturation: CGFloat) {
        // Get hue and saturation for a given point (x,y) in the wheel

        let c = wheelLayer.frame.width * scale / 2
        let dx = (position.x - c) / c
        let dy = (position.y - c) / c
        let d = sqrt( (dx * dx + dy * dy))

        let saturation = d

        var hue: CGFloat

        if (d == 0) {
            hue = 0
        } else {
            hue = acos(dx/d) / CGFloat(Double.pi) / 2.0
            if (dy < 0) {
                hue = 1.0 - hue
            }
        }
        return (hue, saturation)
    }

    func pointAtHueSaturation(_ hue: CGFloat, saturation: CGFloat) -> CGPoint {
        // Get a point (x,y) in the wheel for a given hue and saturation

        let dimension = min(wheelLayer.frame.width, wheelLayer.frame.height)
        let radius = saturation * dimension / 2
        let x = dimension / 2 + radius * cos(hue * CGFloat((Double.pi) * 2))
        let y = dimension / 2 + radius * sin(hue * CGFloat((Double.pi) * 2))
        return CGPoint(x: x, y: y)
    }

    func hsv2rgb(_ hsv: HSV) -> RGB {
        // Converts HSV to an RGB color
        let hue = hsv.hue.truncatingRemainder(dividingBy: 1) * 6
        let saturation = max(0, min(hsv.saturation, 1))
        let brightness = max(0, min(hsv.brightness, 1))

        let i = Int(hue)
        let f = hue - CGFloat(i)
        let p = brightness * (1 - saturation)
        let q = brightness * (1 - f * saturation)
        let t = brightness * (1 - (1 - f) * saturation)

        let (r, g, b): (CGFloat, CGFloat, CGFloat)

        switch i % 6 {
            case 0: (r, g, b) = (brightness, t, p)
            case 1: (r, g, b) = (q, brightness, p)
            case 2: (r, g, b) = (p, brightness, t)
            case 3: (r, g, b) = (p, q, brightness)
            case 4: (r, g, b) = (t, p, brightness)
            case 5: (r, g, b) = (brightness, p, q)
            default: (r, g, b) = (brightness, t, p) // Default case for safety
        }

        return (red: r, green: g, blue: b, alpha: hsv.alpha)
    }
//
//    func rgb2hsv(_ rgb: RGB) -> HSV {
//        // Converts RGB to an HSV color
//        let red = rgb.red
//        let green = rgb.green
//        let blue = rgb.blue
//
//        let maxV = max(red, max(green, blue))
//        let minV = min(red, min(green, blue))
//        let delta = maxV - minV
//
//        var hue: CGFloat = 0
//        var saturation: CGFloat = 0
//        let brightness = maxV
//
//        if delta > 0 {
//            saturation = delta / brightness
//
//            if maxV == red {
//                hue = (green - blue) / delta
//            } else if maxV == green {
//                hue = 2 + (blue - red) / delta
//            } else {
//                hue = 4 + (red - green) / delta
//            }
//
//            hue /= 6
//            if hue < 0 {
//                hue += 1
//            }
//        }
//
//        return (hue: hue, saturation: saturation, brightness: brightness, alpha: rgb.alpha)
//    }

}
