//
//  IssueLoadingCell.swift
//  Github Issue Reader
//
//  Created by Kevin Randrup on 12/5/22.
//

import UIKit

class IssueLoadingCell: UICollectionViewCell {

    static let identifier = "IssueLoadingCell"

    private let activityIndicator = UIActivityIndicatorView(style: .large)

    override init(frame: CGRect) {
        super.init(frame: frame)

        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.startAnimating()

        contentView.addSubview(activityIndicator)
        contentView.backgroundColor = .purple

        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: activityIndicator.leadingAnchor),
            contentView.topAnchor.constraint(equalTo: activityIndicator.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: activityIndicator.bottomAnchor),
            contentView.trailingAnchor.constraint(equalTo: activityIndicator.trailingAnchor),
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
