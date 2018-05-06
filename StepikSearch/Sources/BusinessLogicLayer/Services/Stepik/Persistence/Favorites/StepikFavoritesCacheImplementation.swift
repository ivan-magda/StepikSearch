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

// MARK: StepikFavoritesCacheImplementation: StepikFavoritesCache

final class StepikFavoritesCacheImplementation: StepikFavoritesCache {

    // MARK: Instance Variables

    static let changedNotification = Notification.Name("FavoritesCacheChanged")

    private lazy var courses: [Course] = {
        let courses: [Course] = self.cache.load(fileName: Constants.Stepik.Cache.favoriteCourses) ?? []
        self.postNotification(courses)

        return courses
    }()

    private lazy var cache: Cache = {
        return Cache(destination: .atFolder(self.fileName))
    }()

    // MARK: Init

    init() {
        // Preload the data.
        _ = self.courses
    }

    // MARK: StepikFavoritesCacheImplementation: StepikFavoritesCache

    var fileName: String {
        return Constants.Stepik.Cache.favoritesFolder
    }

    func persist(_ course: Course, completion: @escaping CachePersistenceBlock) {
        courses.append(course)
        courses.removeDuplicates()

        cache.persist(data: courses.transform(), at: Constants.Stepik.Cache.favoriteCourses) { [weak self] (url, error) in
            guard let strongSelf = self else { return }
            strongSelf.postNotification(strongSelf.courses)
            completion(url, error)
        }
    }

    func load() -> [Course] {
        return cache.load(fileName: Constants.Stepik.Cache.favoriteCourses) ?? []
    }

    // MARK: Private API

    private func postNotification(_ notifying: [Course]) {
        NotificationCenter.default.post(
            name: StepikFavoritesCacheImplementation.changedNotification,
            object: notifying,
            userInfo: nil
        )
    }

}
