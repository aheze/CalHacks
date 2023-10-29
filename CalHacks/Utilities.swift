//
//  Utilities.swift
//  CalHacks
//
//  Created by Andrew Zheng on 10/28/23.
//

import SwiftUI

extension UIViewController {
    func addChildViewController(_ childViewController: UIViewController, in view: UIView) {
        /// Add the view controller as a child
        addChild(childViewController)

        /// Insert as a subview
        view.insertSubview(childViewController.view, at: 0)

        /// Configure child view
        childViewController.view.frame = view.bounds
        childViewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        /// Notify child view controller
        childViewController.didMove(toParent: self)
    }

    /// Add a child view controller inside a view with constraints.
    func embed(_ childViewController: UIViewController, in view: UIView) {
        /// Add the view controller as a child
        addChild(childViewController)

        /// Insert as a subview.
        view.insertSubview(childViewController.view, at: 0)

        childViewController.view.pinEdgesToSuperview()

        /// Notify the child view controller.
        childViewController.didMove(toParent: self)
    }

    func removeChildViewController(_ childViewController: UIViewController) {
        /// Notify child view controller
        childViewController.willMove(toParent: nil)

        /// Remove child view from superview
        childViewController.view.removeFromSuperview()

        /// Notify child view controller again
        childViewController.removeFromParent()
    }
}

extension UIView {
    func pinEdgesToSuperview() {
        guard let superview = superview else { return }
        self.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: superview.topAnchor),
            self.rightAnchor.constraint(equalTo: superview.rightAnchor),
            self.bottomAnchor.constraint(equalTo: superview.bottomAnchor),
            self.leftAnchor.constraint(equalTo: superview.leftAnchor)
        ])
    }

    func pinEdgesToSuperview(padding: UIEdgeInsets = .zero) {
        guard let superview = superview else { return }
        self.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: superview.topAnchor, constant: padding.top),
            self.rightAnchor.constraint(equalTo: superview.rightAnchor, constant: -padding.right),
            self.bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -padding.bottom),
            self.leftAnchor.constraint(equalTo: superview.leftAnchor, constant: padding.left)
        ])
    }
    
}

/// from https://stackoverflow.com/a/33397427/14351818
extension UIColor {
    convenience init?(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64

        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            return nil
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}


extension UIColor {
    var color: Color {
        return Color(self)
    }
}


/// get gradient color for search bar field
extension UIColor {
    var rgb: (r: CGFloat, g: CGFloat, b: CGFloat) {
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        if self.getRed(&r, green: &g, blue: &b, alpha: &a) {
            return (r: r, g: g, b: b)
        } else {
            return (0, 0, 0)
        }
    }

    var hsba: (h: CGFloat, s: CGFloat, b: CGFloat, a: CGFloat) {
        var h: CGFloat = 0, s: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        self.getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        return (h: h, s: s, b: b, a: a)
    }

    /// get a gradient color
    func offset(by offset: CGFloat) -> UIColor {
        let (h, s, b, a) = hsba
        var newHue = h - offset

        /// make it go back to positive
        while newHue <= 0 {
            newHue += 1
        }
        let normalizedHue = newHue.truncatingRemainder(dividingBy: 1)
        return UIColor(hue: normalizedHue, saturation: s, brightness: b, alpha: a)
    }

    /// darken or lighten
    func adjust(by offset: CGFloat) -> UIColor {
        let (r, g, b) = rgb
        let newR = r + offset
        let newG = g + offset
        let newB = b + offset

        return UIColor(red: newR, green: newG, blue: newB, alpha: 1)
    }
}

extension Comparable {
    /// used for the UIColor
    func clamped(to limits: ClosedRange<Self>) -> Self {
        return min(max(self, limits.lowerBound), limits.upperBound)
    }
}

extension UIColor {
    /// make a color more visible
    func getTextColor(
        backgroundIsDark: Bool,
        threshold: CGFloat? = nil,
        toBlackPercentage: CGFloat = 0.6, /// how much to make it black
        toWhitePercentage: CGFloat = 0.8
    ) -> UIColor {
        let isLight = isLight(threshold: threshold)
        if isLight, !backgroundIsDark {
            let adjustedTextColor = toColor(.black, percentage: toBlackPercentage)
            return adjustedTextColor
        } else if !isLight, backgroundIsDark {
            let adjustedTextColor = toColor(.white, percentage: toWhitePercentage)
            return adjustedTextColor
        } else {
            return self
        }
    }

    /**
     A color that stands out in the background
     White in light mode -> black
     White in dark mode -> white still
     Pink in light mode -> dark pink
     Pink in dark mode -> pink still
     */
    var controlColor: UIColor {
        let color = UIColor { traits in
            if traits.userInterfaceStyle == .dark {
                return self.getTextColor(backgroundIsDark: true, toBlackPercentage: 0.3, toWhitePercentage: 0.4)
            } else {
                return self.getTextColor(backgroundIsDark: false, toBlackPercentage: 0.3, toWhitePercentage: 0.4)
            }
        }

        return color
    }

    /// extra contrast
    func controlContrastColor(coefficient: CGFloat = 1) -> UIColor {
        let color = UIColor { traits in
            if traits.userInterfaceStyle == .dark {
                return self.getAdjustedColor(backgroundIsDark: true, coefficient: coefficient)
            } else {
                return self.getAdjustedColor(backgroundIsDark: false, coefficient: coefficient)
            }
        }

        return color
    }

    func getAdjustedColor(backgroundIsDark: Bool, coefficient: CGFloat) -> UIColor {
        let brightness = getBrightness()

        if backgroundIsDark {
            let percentage = 1 - brightness
            let adjustedTextColor = toColor(.white, percentage: percentage * coefficient)
            return adjustedTextColor
        } else {
            let percentage = brightness
            let adjustedTextColor = toColor(.black, percentage: percentage * coefficient)
            return adjustedTextColor
        }
    }

    func getBrightness() -> CGFloat {
        let (r, g, b) = rgb
        let brightness = CGFloat(
            ((r * 299) + (g * 587) + (b * 114)) / 1000
        )
        return brightness
    }

    func isLight(threshold: CGFloat? = nil) -> Bool {
        let threshold = threshold ?? CGFloat(0.55)
        let brightness = getBrightness()

        return (brightness > threshold)
    }
}


/// from https://stackoverflow.com/a/46729248/14351818
extension UIColor {
    func toColor(_ color: UIColor, percentage: CGFloat) -> UIColor {
        let percentage = max(min(percentage, 1), 0)
        switch percentage {
        case 0: return self
        case 1: return color
        default:
            var (r1, g1, b1, a1): (CGFloat, CGFloat, CGFloat, CGFloat) = (0, 0, 0, 0)
            var (r2, g2, b2, a2): (CGFloat, CGFloat, CGFloat, CGFloat) = (0, 0, 0, 0)
            guard getRed(&r1, green: &g1, blue: &b1, alpha: &a1) else { return self }
            guard color.getRed(&r2, green: &g2, blue: &b2, alpha: &a2) else { return self }

            return UIColor(
                red: CGFloat(r1 + (r2 - r1) * percentage),
                green: CGFloat(g1 + (g2 - g1) * percentage),
                blue: CGFloat(b1 + (b2 - b1) * percentage),
                alpha: CGFloat(a1 + (a2 - a1) * percentage)
            )
        }
    }
}

/// Use UIKit blurs in SwiftUI.
struct VisualEffectView: UIViewRepresentable {
    /// The blur's style.
    public var style: UIBlurEffect.Style

    /// Use UIKit blurs in SwiftUI.
    public init(_ style: UIBlurEffect.Style) {
        self.style = style
    }

    public func makeUIView(context: Context) -> UIVisualEffectView {
        UIVisualEffectView()
    }

    public func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = UIBlurEffect(style: style)
    }
}
