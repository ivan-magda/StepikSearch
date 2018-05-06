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
import SDWebImage

// MARK: SearchTableViewDelegate: NSObject, UITableViewDelegate

final class SearchTableViewDelegate: NSObject, UITableViewDelegate {

    // MARK: Instance variables

    var didSelect: (Course) -> Swift.Void = { _ in }

    private var data = [Course]()
    private var viewModel: SearchResultCellViewModel!

    // MARK: Public API

    func onDataChanged(_ data: [Course]) {
        self.data = data

        if viewModel == nil && data.count > 0 {
            self.viewModel = SearchResultCellViewModel(course: data[0])
        }
    }

    // MARK: UITableViewDelegate

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? BasicTableViewCell else { fatalError("Unexpected cell type") }

        let course = data[indexPath.row]
        viewModel.setCourse(course)

        cell.titleLabel?.text = viewModel.title
        cell._imageView?.sd_setImage(
            with: URL(string: course.coverUrl),
            placeholderImage: UIImage(named: "loading"),
            options: [.cacheMemoryOnly, .retryFailed],
            completed: nil
        )
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelect(data[indexPath.row])
    }

}
