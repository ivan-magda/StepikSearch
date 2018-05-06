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

import Foundation

// MARK: StepikSearchResultsTemporaryCache

final class StepikSearchResultsTemporaryCache {

    static let changedNotification = Notification.Name("TemporaryCacheChanged")

    // MARK: Public API

    func persist(_ courses: [Course]?, completion: @escaping CachePersistenceBlock) {
        guard let courses = courses else { return }
        persist(courses.transform()) { [weak self] (url, error) in
            self?.postNotification(courses)
            completion(url, error)
        }
    }

    // MARK: Private API

    private func postNotification(_ notifying: [Course]) {
        NotificationCenter.default.post(
            name: StepikSearchResultsTemporaryCache.changedNotification,
            object: notifying,
            userInfo: nil
        )
    }

}

// MARK: - StepikSearchResultsTemporaryCache: StepikTemporaryCache -

extension StepikSearchResultsTemporaryCache: StepikTemporaryCache {

    var fileName: String {
        return Constants.Stepik.Cache.searchResults
    }

    func persist(_ data: Data, completion: @escaping CachePersistenceBlock) {
        let cache = Cache(destination: .temporary)
        cache.persist(data: data, at: fileName, with: completion)
    }

}
