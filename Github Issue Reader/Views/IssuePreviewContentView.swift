//
//  IssuePreviewContentView.swift
//  Github Issue Reader
//
//  Created by Alivia Fairchild on 10/14/22.
//

import Foundation
import UIKit

// Ignore content configuration - 2 hours

struct IssuePreviewContentConfiguration: UIContentConfiguration, Hashable {

    let issueTitle: String
    let username: String
    let status: String
    let statusColor: UIColor

    init(issue: Issue) {
        issueTitle = issue.title
        username = issue.user.login
        status = issue.state.localizedTitle
        statusColor = .from(state: issue.state)
    }

    func makeContentView() -> UIView & UIContentView {
        IssuePreviewContentView(configuration: self)
    }

    func updated(for state: UIConfigurationState) -> IssuePreviewContentConfiguration {
        // Don't need to respond to any UICellConfigurationState changes
        // because we don't have special selected/editing state stuff
        return self
    }
}

class IssuePreviewContentView: UIView, UIContentView {

    private struct Constants {
        static let pictureSize: CGFloat = 20
        static let verticalPadding: CGFloat = 10
        static let horizontalPadding: CGFloat = 20
    }

    // MARK: Initialization

    private var contentConfiguration: IssuePreviewContentConfiguration!

    init(configuration: IssuePreviewContentConfiguration) {
        super.init(frame: .zero)
        self.contentConfiguration = configuration
        setupViews()
    }

    private func setupViews() {
        addSubview(containerView)
        containerView.addArrangedSubview(issueTitleLabel)
        containerView.addArrangedSubview(containerHView)
        containerHView.addArrangedSubview(userPic)
        containerHView.addArrangedSubview(issueUsernameLabel)
        containerHView.addArrangedSubview(spacerView)
        containerHView.addArrangedSubview(issueStatusButton)

        directionalLayoutMargins = .init(
            top: Constants.verticalPadding,
            leading: Constants.horizontalPadding,
            bottom: Constants.verticalPadding,
            trailing: Constants.horizontalPadding
        )
        containerHView.directionalLayoutMargins.top = 10
        containerHView.preservesSuperviewLayoutMargins = true

        containerView.translatesAutoresizingMaskIntoConstraints = false

        let constraints = [
            containerView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            containerView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor),
            containerView.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),

            userPic.widthAnchor.constraint(equalToConstant: Constants.pictureSize),
            userPic.heightAnchor.constraint(equalTo: userPic.widthAnchor),
        ]
        NSLayoutConstraint.activate(constraints)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Private views

    private var containerView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.alignment = .leading
        view.distribution = .fillProportionally
        return view
    }()

    private var containerHView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.alignment = .fill
        view.distribution = .fill
        view.spacing = 20
        return view
    }()

    private var issueTitleLabel: UILabel = {
        var label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.numberOfLines = 0
        label.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        return label
    }()

    private let userPic = UIImageView(image: UIImage(systemName: "person.circle"))

    private var issueUsernameLabel: UILabel = {
        var label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        return label
    }()

    private var spacerView: UIView = {
        let spacer = UIView()
        // Create a view to use as a spacer which expands to fill available area
        let width = spacer.widthAnchor.constraint(equalToConstant: 10_000)
        width.priority = .defaultLow
        width.isActive = true
        return spacer
    }()

    private var issueStatusButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.filled()
        config.cornerStyle = .capsule
        button.configuration = config
        button.isUserInteractionEnabled = false
        return button
    }()


    // MARK: UIContentView

    var configuration: UIContentConfiguration {
        get {
            contentConfiguration
        }
        set {
            guard let config = newValue as? IssuePreviewContentConfiguration else { return }
            contentConfiguration = config
            issueTitleLabel.text = config.issueTitle
            issueUsernameLabel.text = config.username
            issueStatusButton.configuration?.title = config.status
            issueStatusButton.configuration?.baseBackgroundColor = config.statusColor

            invalidateIntrinsicContentSize()
        }
    }

    func supports(_ configuration: UIContentConfiguration) -> Bool {
        return configuration is IssuePreviewContentConfiguration
    }
}
