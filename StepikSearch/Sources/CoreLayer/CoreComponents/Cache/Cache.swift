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

typealias CachePersistenceBlock = (_ url: URL?, _ error: Error?) -> Swift.Void

// MARK: Cache

final class Cache {

    // MARK: - Types

    enum CacheDestination {
        /// Stores items in `NSTemporaryDirectory`
        case temporary
        /// Stores items at a specific location
        case atFolder(String)
    }

    // MARK: Instance Variables

    let destination: URL
    private let queue = OperationQueue()

    // MARK: - Init

    init(destination: CacheDestination) {
        switch destination {
        case .temporary:
            self.destination = URL(fileURLWithPath: NSTemporaryDirectory())
        case .atFolder(let folder):
            let documentFolder = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
            self.destination = URL(fileURLWithPath: documentFolder).appendingPathComponent(folder, isDirectory: true)
        }

        try? FileManager.default.createDirectory(at: self.destination,
                                                 withIntermediateDirectories: true,
                                                 attributes: nil)
    }

    // MARK: - Public API

    /// Persists `Cachable` item.
    func persist(item: Cachable,
                 completion: @escaping CachePersistenceBlock) {
        persist(data: item.transform(), at: item.fileName, with: completion)
    }

    /// Persists raw data.
    func persist(data: Data,
                 at path: String,
                 with completion: @escaping CachePersistenceBlock) {
        var url: URL?
        var error: Error?

        // Create an operation to process the request.
        let operation = BlockOperation {
            do {
                url = try self.persist(
                    data: data,
                    at: self.destination.appendingPathComponent(path, isDirectory: false)
                )
            } catch let persistError {
                error = persistError
            }
        }

        operation.completionBlock = {
            completion(url, error)
        }

        // Start the work.
        queue.addOperation(operation)
    }

    /// Load cached data from the directory.
    public func load<T: Cachable & Codable>(fileName: String) -> T? {
        guard
            let data = try? Data(contentsOf: destination.appendingPathComponent(fileName, isDirectory: false)),
            let decoded = try? JSONDecoder().decode(T.self, from: data)
            else { return nil }
        return decoded
    }

    // MARK: - Private API

    private func persist(data: Data, at url: URL) throws -> URL {
        do {
            try data.write(to: url, options: [.atomicWrite])
            return url
        } catch let error {
            throw error
        }
    }

}
