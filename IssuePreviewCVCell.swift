//
//  IssuePreviewCVCell.swift
//  Github Issue Reader
//
//  Created by Alivia Fairchild on 10/14/22.
//

import Foundation
import UIKit

class IssuePreviewCVCell: UICollectionViewCell {
    static var reuseID = "IssuePreviewCVCell"
    
    var containerView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.alignment = .leading
        view.distribution = .fill
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var containerHView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.alignment = .fill
        view.distribution = .fill
        view.spacing = 20
        return view
    }()
    
    var issueTitleLabel: UILabel = {
        var label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    let userPic = UIImageView(image: UIImage(systemName: "person.circle"))
    
    var issueUsernameLabel: UILabel = {
        var label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        return label
    }()
    
    var spacerView: UIView = {
        let spacer = UIView()
        // Create a view to use as a spacer which expands to fill available area
        let width = spacer.widthAnchor.constraint(equalToConstant: 10_000)
        width.priority = .defaultLow
        width.isActive = true
        return spacer
    }()
    
    var issueStatusButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.filled()
        config.cornerStyle = .capsule
        button.configuration = config
        button.isUserInteractionEnabled = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(containerView)
        containerView.addArrangedSubview(issueTitleLabel)
        containerView.addArrangedSubview(containerHView)
        containerHView.addArrangedSubview(userPic)
        containerHView.addArrangedSubview(issueUsernameLabel)
        containerHView.addArrangedSubview(spacerView)
        containerHView.addArrangedSubview(issueStatusButton)
        
        let constraints = [
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            userPic.widthAnchor.constraint(equalToConstant: 20),
            userPic.heightAnchor.constraint(equalTo: userPic.widthAnchor),
        ]
        NSLayoutConstraint.activate(constraints)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(issue: Issue) {
        issueTitleLabel.text = issue.title
        issueUsernameLabel.text = issue.user?.login
        issueStatusButton.configuration?.title = issue.state.rawValue
        
        var color: UIColor
        
        switch issue.state {
        case .open:
            color = .green
        case .closed:
            color = .red
        }
        
        issueStatusButton.configuration?.baseBackgroundColor = color
    }
}



