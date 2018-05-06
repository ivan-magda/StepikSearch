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

// MARK: SearchViewController: UIViewController

final class SearchViewController: UIViewController, PrimaryViewController {

    // MARK: Instance Variables

    let stepikSearchService: StepikSearchService

    private let searchController = UISearchController(searchResultsController: nil)

    // MARK: Init

    init(stepikSearchService: StepikSearchService) {
        self.stepikSearchService = stepikSearchService
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: UIViewController lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    // MARK: Private API

    private func setup() {
        title = Constants.Strings.search
        view.backgroundColor = Styles.Colors.background

        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = Constants.Strings.stepik
        searchController.searchBar.tintColor = Styles.Colors.Blue.medium.color
        searchController.searchBar.backgroundColor = .clear
        searchController.searchBar.searchBarStyle = .minimal
        navigationItem.searchController = searchController
        searchController.searchBar.resignWhenKeyboardHides()
        definesPresentationContext = true
    }

}

// MARK: - SearchViewController (UISearchResultsUpdating) -

extension SearchViewController: UISearchResultsUpdating {

    func updateSearchResults(for searchController: UISearchController) {
        guard let query = searchController.searchBar.text,
            !searchController.isEmpty() else { return }
        stepikSearchService.search(for: query) { result in
            if let value = result.value {
                print(value[0])
            }
        }
    }

}
