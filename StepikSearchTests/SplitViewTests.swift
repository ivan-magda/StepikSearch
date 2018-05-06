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

import XCTest
@testable import StepikSearch

class RootViewController: UIViewController, PrimaryViewController {}

class SplitViewTests: XCTestCase {

    func test_whenSeparating_withPrimaryAndOtherVCs_thatSplitVCIsSeparated_andResultHasNonPrimary() {
        let masterTab = UITabBarController()

        let leftNav = UINavigationController()
        let left = UIViewController()
        leftNav.pushViewController(left, animated: false)

        let rightNav = UINavigationController()
        let right1 = RootViewController()
        let right2 = RootViewController()
        let right3 = UIViewController()
        let right4 = UIViewController()
        right2.hidesBottomBarWhenPushed = true
        rightNav.pushViewController(right1, animated: false)
        rightNav.pushViewController(right2, animated: false)
        rightNav.pushViewController(right3, animated: false)
        rightNav.pushViewController(right4, animated: false)
        masterTab.viewControllers = [leftNav, rightNav]
        masterTab.selectedIndex = 1

        let split = UISplitViewController()
        split.viewControllers = [masterTab]

        let delegate = SplitViewControllerDelegate()

        let result = delegate.splitViewController(split, separateSecondaryFrom: masterTab)

        let resultTab = (split.viewControllers[0] as! UITabBarController)
        let resultLeft = resultTab.viewControllers![0] as! UINavigationController
        let resultRight = resultTab.viewControllers![1] as! UINavigationController
        XCTAssertEqual(resultTab, masterTab)
        XCTAssertEqual(resultLeft, leftNav)
        XCTAssertEqual(resultRight, rightNav)
        XCTAssertEqual(resultTab.selectedViewController, rightNav)
        XCTAssertEqual(resultRight.viewControllers.count, 2)
        XCTAssertEqual(resultRight.viewControllers[0], right1)
        XCTAssertEqual(resultRight.viewControllers[1], right2)

        let resultDetailVCs = (result as! UINavigationController).viewControllers
        XCTAssertEqual(resultDetailVCs.count, 2)
        XCTAssertEqual(resultDetailVCs[0], right3)
        XCTAssertEqual(resultDetailVCs[1], right4)
    }

    func test_whenSeparating_withSinglePrimary_thatSplitVCIsSeparated_andResultHasPlaceholder() {
        let masterTab = UITabBarController()

        let leftNav = UINavigationController()
        let left = UIViewController()
        leftNav.pushViewController(left, animated: false)

        let rightNav = UINavigationController()
        let right1 = RootViewController()
        rightNav.pushViewController(right1, animated: false)
        masterTab.viewControllers = [leftNav, rightNav]
        masterTab.selectedIndex = 1

        let split = UISplitViewController()
        split.viewControllers = [masterTab]

        let delegate = SplitViewControllerDelegate()

        let result = delegate.splitViewController(split, separateSecondaryFrom: masterTab)

        let resultTab = (split.viewControllers[0] as! UITabBarController)
        let resultLeft = resultTab.viewControllers![0] as! UINavigationController
        let resultRight = resultTab.viewControllers![1] as! UINavigationController
        XCTAssertEqual(resultTab, masterTab)
        XCTAssertEqual(resultLeft, leftNav)
        XCTAssertEqual(resultRight, rightNav)
        XCTAssertEqual(resultTab.selectedViewController, rightNav)
        XCTAssertEqual(resultRight.viewControllers.count, 1)
        XCTAssertEqual(resultRight.viewControllers[0], right1)

        let resultDetailVCs = (result as! UINavigationController).viewControllers
        XCTAssertEqual(resultDetailVCs.count, 1)
        XCTAssert(resultDetailVCs[0] is SplitPlaceholderViewController)
    }

    func test_whenCollapsing_withVCsStackedOnMasterAndDetail_thatVCsStackedOnSelectedNav() {
        let masterTab = UITabBarController()

        let leftNav = UINavigationController()
        let left = UIViewController()
        leftNav.pushViewController(left, animated: false)

        let rightNav = UINavigationController()
        let right1 = RootViewController()
        let right2 = RootViewController()
        rightNav.pushViewController(right1, animated: false)
        rightNav.pushViewController(right2, animated: false)
        masterTab.viewControllers = [leftNav, rightNav]
        masterTab.selectedIndex = 1

        let detailNav = UINavigationController()
        let detail1 = UIViewController()
        let detail2 = UIViewController()
        detailNav.pushViewController(detail1, animated: false)
        detailNav.pushViewController(detail2, animated: false)

        let split = UISplitViewController()
        split.viewControllers = [masterTab, detailNav]

        let delegate = SplitViewControllerDelegate()

        _ = delegate.splitViewController(split, collapseSecondary: detailNav, onto: masterTab)

        let resultTab = split.viewControllers[0] as! UITabBarController
        XCTAssertEqual(resultTab.viewControllers?.count, 2)
        XCTAssertEqual(resultTab.selectedViewController, rightNav)
        XCTAssertEqual(rightNav.viewControllers.count, 4)
        XCTAssertEqual(rightNav.viewControllers[0], right1)
        XCTAssertEqual(rightNav.viewControllers[1], right2)
        XCTAssertEqual(rightNav.viewControllers[2], detail1)
        XCTAssertEqual(rightNav.viewControllers[3], detail2)

        XCTAssertFalse(rightNav.viewControllers[0].hidesBottomBarWhenPushed)
        XCTAssertFalse(rightNav.viewControllers[1].hidesBottomBarWhenPushed)
        XCTAssertTrue(rightNav.viewControllers[2].hidesBottomBarWhenPushed)
        XCTAssertTrue(rightNav.viewControllers[3].hidesBottomBarWhenPushed)
    }

    func test_whenCollapsing_withPlaceholderStackedOnDetail_thatVCsStackedWithoutPlaceholder() {
        let masterTab = UITabBarController()

        let leftNav = UINavigationController()
        let left = UIViewController()
        leftNav.pushViewController(left, animated: false)

        let rightNav = UINavigationController()
        let right1 = RootViewController()
        let right2 = RootViewController()
        rightNav.pushViewController(right1, animated: false)
        rightNav.pushViewController(right2, animated: false)
        masterTab.viewControllers = [leftNav, rightNav]
        masterTab.selectedIndex = 1

        let detailNav = UINavigationController()
        let detail1 = SplitPlaceholderViewController()
        detailNav.pushViewController(detail1, animated: false)

        let split = UISplitViewController()
        split.viewControllers = [masterTab, detailNav]

        let delegate = SplitViewControllerDelegate()

        _ = delegate.splitViewController(split, collapseSecondary: detailNav, onto: masterTab)

        let resultTab = split.viewControllers[0] as! UITabBarController
        XCTAssertEqual(resultTab.viewControllers?.count, 2)
        XCTAssertEqual(resultTab.selectedViewController, rightNav)
        XCTAssertEqual(rightNav.viewControllers.count, 2)
        XCTAssertEqual(rightNav.viewControllers[0], right1)
        XCTAssertEqual(rightNav.viewControllers[1], right2)
    }

}
