/**
 * Copyright (c) 2018 Ivan Magda
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import UIKit

// add this shell protocol onto a view controller that should remain part of a tab's root nav VC when splitting out
// detail VCs from primary on split VC expansion
protocol PrimaryViewController {}

// MARK: SplitViewControllerDelegate: UISplitViewControllerDelegate

final class SplitViewControllerDelegate: UISplitViewControllerDelegate {

    // MARK: UISplitViewControllerDelegate

    func splitViewController(
        _ splitViewController: UISplitViewController,
        collapseSecondary secondaryViewController: UIViewController,
        onto primaryViewController: UIViewController
        ) -> Bool {
        if let tab = primaryViewController as? UITabBarController,
            let primaryNav = tab.selectedViewController as? UINavigationController,
            let secondaryNav = secondaryViewController as? UINavigationController {

            // remove any placeholder VCs from the stack
            primaryNav.viewControllers += secondaryNav.viewControllers.filter {
                $0.hidesBottomBarWhenPushed = true
                return ($0 is SplitPlaceholderViewController) == false
            }
        }

        return true
    }

    func splitViewController(
        _ splitViewController: UISplitViewController,
        separateSecondaryFrom primaryViewController: UIViewController
        ) -> UIViewController? {
        guard let tab = primaryViewController as? UITabBarController,
            let primaryNav = tab.selectedViewController as? UINavigationController
            else { return nil }

        var detailVCs = [UIViewController]()

        // for each tab VC that is a nav controller, pluck everything that
        // isn't marked as a primary VC off of the nav stack.
        // If the nav is the currently selected tab VC, then move all non-primary VCs to
        for tabVC in tab.viewControllers ?? [] {
            // they should all be navs, but just in case
            guard let nav = tabVC as? UINavigationController else { continue }

            // pop until hitting a VC marked as "primary"
            while let top = nav.topViewController,
                top !== nav.viewControllers.first,
                (top is PrimaryViewController) == false {
                    if nav === primaryNav {
                        detailVCs.insert(top, at: 0)
                    }

                    nav.popViewController(animated: false)
            }
        }

        if detailVCs.count > 0 {
            // if there are active VCs, push them onto the new nav stack
            let nav = UINavigationController()
            nav.setViewControllers(detailVCs, animated: false)

            return nav
        } else {
            // otherwise use a placeholder VC
            return UINavigationController(rootViewController: SplitPlaceholderViewController())
        }
    }

    func splitViewController(
        _ splitViewController: UISplitViewController,
        showDetail vc: UIViewController,
        sender: Any?
        ) -> Bool {
        guard let tab = splitViewController.viewControllers.first as? UITabBarController
            else { return false }

        if splitViewController.isCollapsed {
            if let nav = vc as? UINavigationController, let first = nav.viewControllers.first {
                tab.selectedViewController?.show(first, sender: sender)
            } else {
                tab.selectedViewController?.show(vc, sender: sender)
            }
        } else {
            splitViewController.viewControllers = [tab, vc]
        }

        return true
    }

}
