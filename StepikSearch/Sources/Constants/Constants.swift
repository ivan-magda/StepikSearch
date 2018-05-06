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

enum Constants {

    enum Strings {
        static let ok = NSLocalizedString("OK", comment: "")
        static let cancel = NSLocalizedString("Cancel", comment: "")
        static let yes = NSLocalizedString("Yes", comment: "")
        static let no = NSLocalizedString("No", comment: "")
        static let search = NSLocalizedString("Search", comment: "")
        static let searchStepik = NSLocalizedString("Search Stepik", comment: "Used as a placeholder for the searchbar when searching for courses.")
        static let clearAll = NSLocalizedString("Clear All", comment: "")
        static let delete = NSLocalizedString("Delete", comment: "")
        static let stepik = NSLocalizedString("Stepik", comment: "")
        static let favorites = NSLocalizedString("Favorites", comment: "")
        static let detail = NSLocalizedString("Detail", comment: "")
    }

    enum Stepik {
        static let apiScheme = "https"
        static let apiHost = "stepik.org"
        static let apiPath = "/api"

        enum Paths {
            static let searchResults = "/search-results"
        }

        enum Params {
            static let query = "query"
        }

        enum Response {
            static let title = "course_title"
            static let coverUrl = "course_cover"
            static let searchResults = "search-results"
        }
    }

}
