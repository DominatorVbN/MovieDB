//
//  MovieCell.swift
//  MovieDB
//
//  Created by Amit Samant on 30/10/21.
//

import UIKit

class MovieCell: UITableViewCell {
    
    static let reuseIdentifier = "MovieCell"
    
    lazy var resultImageView: UIImageView = {
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
            imageView.widthAnchor.constraint(equalToConstant: 100),
            imageView.heightAnchor.constraint(equalToConstant: 144)
        ])
        return imageView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        if #available(iOS 13.0, *) {
            label.textColor = UIColor.label
        }
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.numberOfLines = 2
        return label
    }()
    
    lazy var subTitleLabel: UILabel = {
        let label = UILabel()
        if #available(iOS 13.0, *) {
            label.textColor = UIColor.secondaryLabel
        } else {
            label.textColor = UIColor.gray
        }
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        return label
    }()
    
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        if #available(iOS 13.0, *) {
            label.textColor = UIColor.label
        }
        label.numberOfLines = 5
        label.font = UIFont.preferredFont(forTextStyle: .callout)
        return label
    }()
    
    
    
    lazy var verticalTextStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, subTitleLabel, descriptionLabel])
        stackView.spacing = 5
        stackView.axis = .vertical
        return stackView
    }()
    
    lazy var horizontalStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [resultImageView, verticalTextStack])
        stackView.alignment = .center
        stackView.spacing = 10
        stackView.axis = .horizontal
        return stackView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        separatorInset = .init(top: 0, left: 110 + contentView.layoutMargins.left, bottom: 0, right: 0)
        horizontalStack.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(horizontalStack)
        NSLayoutConstraint.activate([
            horizontalStack.leadingAnchor.constraint(equalTo: contentView.readableContentGuide.leadingAnchor),
            horizontalStack.trailingAnchor.constraint(equalTo: contentView.readableContentGuide.trailingAnchor),
            horizontalStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: contentView.layoutMargins.top),
            horizontalStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -contentView.layoutMargins.bottom)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
