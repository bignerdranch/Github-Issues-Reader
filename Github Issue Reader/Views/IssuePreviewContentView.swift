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

// this class is going to build out a view and the content within it.
class IssuePreviewContentView: UIView, UIContentView {
// * all things marked "private" are so that they will only show on this class and not be mutable outside of this declaration.
    // Kevin - `let` makes the variables immutable. A `private var` can still be mutated inside `private`
    // Re: Kevin - I just read an article that explained the `static` keyword as making the property available outside of the class without instantiating the class. I'm confused why would make these constants static when the struct they're in is specifically private. If logic serves, the properties within the private struct would not be accessible even with an instance of the struct, because the struct shouldn't be accessible at all outside of this class!
    // I just read another article furthering my understanding of access keywords. So from what I can tell you made this Constants struct private so it can only be used within this IssuePreviewContentView class but due to the static let we don't have to do `var constPic = Constants.pictureSize` we can do `Constants.pictureSize` within this class to use the property if we want. Which you do use actually down on line 97 for the constraints. 
    
    // hard coding the sizing we want for the UI so if there is a problem we can easily adjust it in one spot vs having to debug a whole chain of events.
    private struct Constants {
        static let pictureSize: CGFloat = 20
        static let verticalPadding: CGFloat = 10
        static let horizontalPadding: CGFloat = 20
    }
    
    // MARK: Initialization

    // we're force unwrapping the struct from above (we're CONFIDENT it will return a value because we hardcoded it to up above)
    // Kevin - this struct is described above, but it comes from the initializer below
    private var contentConfiguration: IssuePreviewContentConfiguration!

    // are we simply telling content configuration to conform to everything in the IssuePreviewContentConfiguration struct and making it a view?
    // Kevin - we initialize the UIView, then store the instance of `IssuePreviewContentConfiguration` that we were given, then setup views
    init(configuration: IssuePreviewContentConfiguration) {
        super.init(frame: .zero)
        self.contentConfiguration = configuration
        setupViews()
    }
    
    // UI Configuration
    private func setupViews() {
        // creating a subview to pin all the UI into it
        addSubview(containerView)
        // all the data being added into the empty container view
        containerView.addArrangedSubview(issueTitleLabel)
        containerView.addArrangedSubview(containerHView)
        containerHView.addArrangedSubview(userPic)
        containerHView.addArrangedSubview(issueUsernameLabel)
        containerHView.addArrangedSubview(spacerView)
        containerHView.addArrangedSubview(issueStatusButton)
        
        // declaring the margins to use them on the containerView.
        directionalLayoutMargins = .init(
            top: Constants.verticalPadding,
            leading: Constants.horizontalPadding,
            bottom: Constants.verticalPadding,
            trailing: Constants.horizontalPadding
        )
        containerHView.directionalLayoutMargins.top = 10
        // no matter what the container horizontal containers will abide by the parent class margins
        containerHView.preservesSuperviewLayoutMargins = true
        // because jesus said so
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
    
    // what?
    // Kevin - UIView is required to support 2 initializers. Because IssuePreviewContentView is a subclass, it also needs to support those 2 initializers.
    // `init?(coder: NSCoder)` supports storyboard initialization which we aren't supporting in this class.
    // That's why we `fatalError`
    // I think I need to talk this one out.
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Private views

    // make a UIView that will hold all the subViews (used in above constraints)
    private var containerView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.alignment = .leading
        view.distribution = .fillProportionally
        return view
    }()
    
    // view designed to horizontally hold data
    private var containerHView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.alignment = .fill
        view.distribution = .fill
        view.spacing = 20
        return view
    }()
    // this property is designing the UI of how the title of the issue is going to be displayed.
    private var issueTitleLabel: UILabel = {
        var label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .body)
        // setting this at 0 this is going to help the text not cut off so it can use as many lines as necessary. Hard coding it to any other number will ensure it only will stay within those parameters.
        label.numberOfLines = 0
        // this is setting the importance of the the text since it can be pushed around to make space for more UI. We're telling it it's high priority so it should be one of the last things compromised.
        label.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        return label
    }()

    // a cute lil image to put next to the username
    private let userPic = UIImageView(image: UIImage(systemName: "person.circle"))
    
    // setting up the UI for how the username is going to be displayed.
    private var issueUsernameLabel: UILabel = {
        var label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        return label
    }()
    
    // this is literally just creating a place holder UIView to hold space between displays
    private var spacerView: UIView = {
        let spacer = UIView()
        // Create a view to use as a spacer which expands to fill available area
        let width = spacer.widthAnchor.constraint(equalToConstant: 10_000)
        // Kevin - important to be low priority so that it's the first item to be resized for content
        width.priority = .defaultLow
        width.isActive = true
        return spacer
    }()
    
    // this is using a button for easy UI but it's actually disabled since theres no use for the action.
    private var issueStatusButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.filled()
        config.cornerStyle = .capsule
        button.configuration = config
        button.isUserInteractionEnabled = false
        return button
    }()


    // MARK: UIContentView
    
    // this is a huge property bringing in all the
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
