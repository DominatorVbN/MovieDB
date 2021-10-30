//
//  MovieDetailVC.swift
//  MovieDB
//
//  Created by Amit Samant on 30/10/21.
//

import UIKit

class MovieDetailVC: UIViewController {
    
    let viewModel: MovieDetailViewModel = .init()
    let movie: Movie
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        if #available(iOS 13.0, *) {
            imageView.backgroundColor = UIColor.secondarySystemBackground
            imageView.layer.shadowColor = UIColor.systemBackground.cgColor
        } else {
            imageView.backgroundColor = .gray
            imageView.layer.shadowColor = UIColor.black.cgColor
        }
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 150),
            imageView.heightAnchor.constraint(equalToConstant: 216)
        ])
        return  imageView
    }()
    
    private lazy var releaseDateNameLabel: UILabel = {
        return createLabel(
            withTextStyle: .headline,
            initialText: "Release date"
        )
    }()
    
    private lazy var releaseDateLabel: UILabel = {
        return createLabel(withTextStyle: .subheadline)
    }()
    
    private lazy var ratingNameLabel: UILabel = {
        return createLabel(
            withTextStyle: .headline,
            initialText: "🌟 Ratings"
        )
    }()
    
    private lazy var ratingLabel: UILabel = {
        return createLabel(withTextStyle: .subheadline)
    }()
    
    private lazy var popularityNameLabel: UILabel = {
        return createLabel(
            withTextStyle: .headline,
            initialText: "❤️ Popularity"
        )
    }()
    
    private lazy var popularityLabel: UILabel = {
        return createLabel(withTextStyle: .subheadline)
    }()
    
    private lazy var overviewNameLabel: UILabel = {
        return createLabel(
            withTextStyle: .headline,
            initialText: "❤️ Popularity"
        )
    }()
    
    private lazy var overviewLabel: UILabel = {
        return createLabel(withTextStyle: .subheadline)
    }()
    
    init(movie: Movie) {
        self.movie = movie
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        if #available(iOS 13.0, *) {
            view.backgroundColor = UIColor.systemBackground
        } else {
            view.backgroundColor = .white
        }
        layoutViews()
        setData()
    }
    
    func layoutViews() {
        
        let movieDataStack = UIStackView()
        movieDataStack.axis = .vertical
        movieDataStack.spacing = 12
        
        let releaseDateStack = createInfoStack(
            withHeadingLabel: releaseDateNameLabel,
            subheadingLabel: releaseDateLabel
        )
        let ratingStack = createInfoStack(
            withHeadingLabel: ratingNameLabel,
            subheadingLabel: ratingLabel
        )
        
        let popularityStack = createInfoStack(
            withHeadingLabel: popularityNameLabel,
            subheadingLabel: popularityLabel
        )
        
        
        movieDataStack.addArrangedSubview(releaseDateStack)
        movieDataStack.addArrangedSubview(ratingStack)
        movieDataStack.addArrangedSubview(popularityStack)
        movieDataStack.addArrangedSubview(createSpacer())
        
        let topHorizontalStack = UIStackView()
        topHorizontalStack.axis = .horizontal
        topHorizontalStack.spacing = 12
        
        topHorizontalStack.addArrangedSubview(imageView)
        topHorizontalStack.addArrangedSubview(movieDataStack)
        
        let superVerticalStack = UIStackView()
        superVerticalStack.axis = .vertical
        superVerticalStack.spacing = 24
        
        let overviewStack = createInfoStack(
            withHeadingLabel: overviewNameLabel,
            subheadingLabel: overviewLabel
        )
        
        superVerticalStack.addArrangedSubview(topHorizontalStack)
        superVerticalStack.addArrangedSubview(overviewStack)
        superVerticalStack.addArrangedSubview(createSpacer())
        
        superVerticalStack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(superVerticalStack)
        NSLayoutConstraint.activate([
            superVerticalStack.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                constant: 24
            ),
            superVerticalStack.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                constant: -24
            ),
            superVerticalStack.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: 24
            ),
            superVerticalStack.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                constant: -24
            )
        ])
    }
    
    func setData() {
        title = movie.title
        releaseDateLabel.text = movie.releaseDate ?? "N/A"
        if let rating = movie.rating {
            ratingLabel.text = String(format: "%.2f", rating)
        } else {
            ratingLabel.text = "N/A"
        }
        if let popularity = movie.popularity {
            popularityLabel.text = String(format: "%.2f", popularity)
        } else {
            popularityLabel.text = "N/A"
        }
        overviewLabel.text = movie.overview ?? "N/A"
        guard let url = movie.imageURL else {
            return
        }
        viewModel.loadImage(forUrl: url) { image in
            self.imageView.image = image
            self.imageView.setNeedsLayout()
        }
        
    }
    
    func createInfoStack(withHeadingLabel headingLabel: UILabel, subheadingLabel: UILabel) -> UIStackView {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 8
        stack.addArrangedSubview(headingLabel)
        stack.addArrangedSubview(subheadingLabel)
        return stack
    }
    
    func createLabel(withTextStyle style: UIFont.TextStyle, initialText: String? = nil) -> UILabel {
        let label = UILabel()
        label.font = UIFont.preferredFont(
            forTextStyle: style
        )
        label.text = initialText
        label.numberOfLines = 0
        return label
    }
    
    func createSpacer() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }

}

