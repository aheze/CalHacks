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
