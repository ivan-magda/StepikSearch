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

// MARK: DetailViewController: UIViewController

final class DetailViewController: UIViewController {

    // MARK: Instance Variables

    private let course: Course
    private let cache: StepikFavoritesCache

    private let imageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit

        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)

        return label
    }()

    private let scoreLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18, weight: .light)
        label.textColor = Styles.Colors.Gray.light.color

        return label
    }()

    // MARK: Init

    init(course: Course, cache: StepikFavoritesCache) {
        self.course = course
        self.cache = cache
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: UIViewController lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }

    // MARK: Private API

    private func configureView() {
        edgesForExtendedLayout = []

        title = course.title
        view.backgroundColor = Styles.Colors.background

        hideLargeTitle()
        addSubviews()
        addRightBarButtonItem()
    }

    // MARK: Actions

    @objc
    private func addToFavorites() {
        cache.persist(course) { _, _ in }
    }

}

// MARK: - DetailViewController (Configure UI) -

extension DetailViewController {

    private func addSubviews() {
        view.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: Styles.Sizes.cellSpacing),
            imageView.widthAnchor.constraint(equalTo: view.widthAnchor),
            imageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.35)
            ])
        imageView.sd_setImage(with: URL(string: course.coverUrl), completed: nil)

        view.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Styles.Sizes.cellSpacing),
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: Styles.Sizes.cellSpacing),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: Styles.Sizes.cellSpacing)
            ])
        titleLabel.text = course.title

        view.addSubview(scoreLabel)
        NSLayoutConstraint.activate([
            scoreLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Styles.Sizes.cellSpacing),
            scoreLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Styles.Sizes.cellSpacing),
            scoreLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: Styles.Sizes.cellSpacing)
            ])
        scoreLabel.text = NSLocalizedString("Score:", comment: "") + " \(course.score)"
    }

    private func addRightBarButtonItem() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(
            barButtonSystemItem: .bookmarks,
            target: self,
            action: #selector(addToFavorites)
        )
    }

}
