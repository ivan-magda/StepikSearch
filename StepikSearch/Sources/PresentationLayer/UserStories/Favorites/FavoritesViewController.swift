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

// MARK: FavoritesViewController: UIViewController

final class FavoritesViewController: UIViewController, PrimaryViewController {

    // MARK: Instance Variables

    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.alwaysBounceVertical = true

        return tableView
    }()

    private let tableViewDataSource = FavoritesTableViewDataSource()
    private let tableViewDelegate = FavoritesTableViewDelegate()

    weak var navigationDelegate: NavigationDelegate?

    // MARK: Init

    init(navigationDelegate: NavigationDelegate?) {
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
        title = Constants.Strings.favorites

        view.addSubview(tableView)
        tableView.dataSource = tableViewDataSource
        tableView.delegate = tableViewDelegate
        tableView.register(
            BasicTableViewCell.nib,
            forCellReuseIdentifier: BasicTableViewCell.identifier
        )
        tableViewDelegate.didSelect = { [weak self] course in
            guard let strongSelf = self else { return }
            strongSelf.navigationDelegate?.showDetailViewController(onto: strongSelf, course: course)
        }

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleChangeNotification(_:)),
            name: StepikFavoritesCacheImplementation.changedNotification,
            object: nil
        )

        let courses = StepikFavoritesCacheImplementation().load()
        reloadData(courses)
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
