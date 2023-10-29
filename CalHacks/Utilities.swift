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
