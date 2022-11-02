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
    
    var issueTitle: UILabel = {
        var label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    let userPic = UIImageView (image: UIImage(systemName: "person.circle"))
    
    var issueUsername: UILabel = {
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
    
    var issueStatus: UIButton = {
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
        containerView.addArrangedSubview(issueTitle)
        containerView.addArrangedSubview(containerHView)
        containerHView.addArrangedSubview(userPic)
        containerHView.addArrangedSubview(issueUsername)
        containerHView.addArrangedSubview(spacerView)
        containerHView.addArrangedSubview(issueStatus)
        
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
        issueTitle.text = issue.title
        issueUsername.text = issue.user?.login
        issueStatus.configuration?.title = issue.state
        
        issueStatus.configuration?.baseBackgroundColor = .green

        
        if issue.state == "open" {
            issueStatus.configuration?.baseBackgroundColor = .green
        } else {
            issueStatus.configuration?.baseBackgroundColor = .red
        }
    }
}



