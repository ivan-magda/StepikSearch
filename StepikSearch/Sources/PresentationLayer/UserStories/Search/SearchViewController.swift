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
    let stepikTemporaryCache: StepikSearchResultsTemporaryCache

    weak var navigationDelegate: NavigationDelegate?

    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.alwaysBounceVertical = true

        return tableView
    }()

    private let tableViewDataSource = SearchTableViewDataSource()
    private let tableViewDelegate = SearchTableViewDelegate()

    private let searchController = UISearchController(searchResultsController: nil)

    /// Encapsulates request code for search.
    private var pendingSearchRequestWorkItem: DispatchWorkItem?

    // MARK: Init

    init(
        stepikSearchService: StepikSearchService,
        stepikTemporaryCache: StepikSearchResultsTemporaryCache,
        navigationDelegate: NavigationDelegate?
        ) {
        self.stepikSearchService = stepikSearchService
        self.stepikTemporaryCache = stepikTemporaryCache
        self.navigationDelegate = navigationDelegate
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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        rz_smoothlyDeselectRows(tableView: tableView)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        let bounds = view.bounds
        if bounds != tableView.frame {
            tableView.frame = bounds
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: Private API

    private func setup() {
        title = Constants.Strings.search

        view.addSubview(tableView)
        tableView.dataSource = tableViewDataSource
        tableView.delegate = tableViewDelegate
        tableView.register(
            BasicTableViewCell.nib,
            forCellReuseIdentifier: BasicTableViewCell.identifier
        )
        tableViewDelegate.didSelect = { [weak self] course in
            guard let strongSelf = self else { return }
            strongSelf.navigationDelegate?.showCourseDetails(course, vc: strongSelf)
        }

        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = Constants.Strings.stepik
        searchController.searchBar.tintColor = Styles.Colors.Blue.medium.color
        searchController.searchBar.backgroundColor = .clear
        searchController.searchBar.searchBarStyle = .minimal
        navigationItem.searchController = searchController
        searchController.searchBar.resignWhenKeyboardHides()
        definesPresentationContext = true

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleChangeNotification(_:)),
            name: StepikSearchResultsTemporaryCache.changedNotification,
            object: nil
        )
    }

    @objc
    private func handleChangeNotification(_ notification: Notification) {
        onMain {
            self.reloadData(notification.object as? [Course] ?? [])
        }
    }

    private func reloadData(_ data: [Course]) {
        tableViewDataSource.onDataChanged(data)
        tableViewDelegate.onDataChanged(data)
        tableView.reloadSections(
            IndexSet(integer: tableViewDataSource.numberOfSections(in: tableView) - 1),
            with: .automatic
        )
    }

}

// MARK: - SearchViewController (UISearchResultsUpdating) -

extension SearchViewController: UISearchResultsUpdating {

    // MARK: UISearchResultsUpdating

    func updateSearchResults(for searchController: UISearchController) {
        pendingSearchRequestWorkItem?.cancel()

        let requestWorkItem = DispatchWorkItem { [weak self] in
            self?.search(searchController.searchBar.text)
        }

        pendingSearchRequestWorkItem = requestWorkItem
        DispatchQueue.main.asyncAfter(
            deadline: .now() + .milliseconds(750),
            execute: requestWorkItem
        )
    }

    // MARK: Private API

    private func search(_ query: String?) {
        guard let query = query,
            !query.isEmpty else { return reloadData([]) }

        stepikSearchService.search(for: query) { [weak self] result in
            self?.stepikTemporaryCache.persist(result.value, completion: { _, _ in })
        }
    }

}
