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

// MARK: Styles

enum Styles {

    enum Sizes {
        static let gutter: CGFloat = 15
        static let eventGutter: CGFloat = 8 // comment gutter 2x
        static let commentGutter: CGFloat = 8
        static let icon = CGSize(width: 20, height: 20)
        static let buttonMin = CGSize(width: 44, height: 44)
        static let buttonIcon = CGSize(width: 25, height: 25)
        static let buttonTopPadding: CGFloat = 2
        static let barButton = CGRect(x: 0, y: 0, width: 30, height: 44)
        static let avatarCornerRadius: CGFloat = 3
        static let labelCornerRadius: CGFloat = 3
        static let columnSpacing: CGFloat = 8
        static let rowSpacing: CGFloat = 8
        static let cellSpacing: CGFloat = 15
        static let tableCellHeight: CGFloat = 44
        static let tableCellHeightLarge: CGFloat = 55
        static let tableSectionSpacing: CGFloat = 35
        static let avatar = CGSize(width: 30, height: 30)
        static let inlineSpacing: CGFloat = 4
        static let listInsetLarge = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        static let listInsetLargeHead = UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0)
        static let listInsetLargeTail = UIEdgeInsets(top: 0, left: 0, bottom: 8, right: 0)
        static let listInsetTight = UIEdgeInsets(top: 4, left: 0, bottom: 4, right: 0)
        static let textViewInset = UIEdgeInsets(
            top: Styles.Sizes.rowSpacing,
            left: Styles.Sizes.gutter,
            bottom: Styles.Sizes.rowSpacing,
            right: Styles.Sizes.gutter
        )
        static let labelEventHeight: CGFloat = 30
        static let labelRowHeight: CGFloat = 18
        static let labelSpacing: CGFloat = 4
        static let labelTextPadding: CGFloat = 4
        static let cardCornerRadius: CGFloat = 6

        static let maxImageHeight: CGFloat = 300
        static let splashImageSize: CGFloat = 200
    }

    enum Colors {

        static let background = Styles.Colors.Gray.lighter.color
        static let purple = "6f42c1"
        static let blueGray = "8697af"

        enum Red {
            static let medium = "cb2431"
            static let light = "ffeef0"
        }

        enum Green {
            static let medium = "28a745"
            static let light = "e6ffed"
        }

        enum Blue {
            static let medium = "0366d6"
            static let light = "f1f8ff"
        }

        enum Gray {
            static let dark = "24292e"
            static let medium = "586069"
            static let light = "a3aab1"
            static let lighter = "f6f8fa"
            static let border = "bcbbc1"

            static let alphaLighter = UIColor(white: 0, alpha: 0.10)
        }

        enum Yellow {
            static let medium = "f29d50"
            static let light = "fff5b1"
        }

    }

    static func setupAppearance() {
        UINavigationBar.appearance().tintColor =  Styles.Colors.Blue.medium.color
        UINavigationBar.appearance().titleTextAttributes =
            [NSAttributedStringKey.foregroundColor: Styles.Colors.Gray.dark.color]
    }

}

// MARK: - String (Color) -

extension String {

    public var color: UIColor {
        return UIColor.fromHex(self)
    }

}

