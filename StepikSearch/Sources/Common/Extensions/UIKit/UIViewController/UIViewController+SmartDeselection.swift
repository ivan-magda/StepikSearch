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

import UIKit.UIViewController

// https://www.raizlabs.com/dev/2016/05/smarter-animated-row-deselection-ios/
extension UIViewController {

    func rz_smoothlyDeselectRows(tableView: UITableView?) {
        // if part of a split VC and "full screen" in the primary spot, dont deselect
        // also consider if embedded in nav VC
        if let split = splitViewController,
            let first = split.viewControllers.first,
            (first === self || first === navigationController) && split.isCollapsed == false {
            return
        }

        // Get the initially selected index paths, if any
        let selectedIndexPaths = tableView?.indexPathsForSelectedRows ?? []

        // Grab the transition coordinator responsible for the current transition
        if let coordinator = transitionCoordinator {
            coordinator.animate(alongsideTransition: { context in
                // Deselect the cells, with animations enabled if this is an animated transition
                selectedIndexPaths.forEach {
                    tableView?.deselectRow(at: $0, animated: context.isAnimated)
                }
            }, completion: { context in
                // If the transition was cancel, reselect the rows that were selected before,
                // so they are still selected the next time the same animation is triggered
                if context.isCancelled {
                    selectedIndexPaths.forEach {
                        tableView?.selectRow(at: $0, animated: context.isAnimated, scrollPosition: .none)
                    }
                }
            })
        }
    }

    func rz_smoothlyDeselectRows(collectionView: UICollectionView?) {
        // if part of a split VC and "full screen" in the primary spot, dont deselect
        // also consider if embedded in nav VC
        if let split = splitViewController,
            let first = split.viewControllers.first,
            (first === self || first === navigationController) && split.isCollapsed == false {
            return
        }

        // Get the initially selected index paths, if any
        let selectedIndexPaths = collectionView?.indexPathsForSelectedItems ?? []

        // Grab the transition coordinator responsible for the current transition
        if let coordinator = transitionCoordinator {
            coordinator.animate(alongsideTransition: { context in
                // Deselect the cells, with animations enabled if this is an animated transition
                selectedIndexPaths.forEach {
                    collectionView?.deselectItem(at: $0, animated: context.isAnimated)
                }
            }, completion: { context in
                // If the transition was cancel, reselect the rows that were selected before,
                // so they are still selected the next time the same animation is triggered
                if context.isCancelled {
                    selectedIndexPaths.forEach {
                        collectionView?.selectItem(at: $0, animated: context.isAnimated, scrollPosition: [])
                    }
                }
            })
        }
    }

}
