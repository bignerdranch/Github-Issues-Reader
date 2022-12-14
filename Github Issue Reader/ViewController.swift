//
//  ViewController.swift
//  Github Issue Reader
//
//  Created by Savannah Sosa on 8/30/22.
//

import UIKit

// 2 hours
class ViewController: UIViewController {

    // property creating a stackView (like a list) to organize the UI for the entire VC
    var containerView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.alignment = .leading
        view.distribution = .fill
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // text label
    var gitLabel: UILabel = {
        let label = UILabel()
        label.text = "GitHub Issue Viewer"
        label.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        return label
    }()
    
    // text label
    var gitSubLabel: UILabel = {
        let label = UILabel()
        label.text = "View issues in a repository:"
        label.font = .preferredFont(forTextStyle: .title2)
        label.textColor = .systemGray
        return label
    }()
    
    // text label
    var orgLabel: UILabel = {
        let label = UILabel()
        label.text = "Organization"
        label.font = UIFont.preferredFont(forTextStyle: .title2)
        return label
    }()
    
    // text label
    var repoLabel: UILabel = {
        let label = UILabel()
        label.text = "Repository"
        label.font = UIFont.preferredFont(forTextStyle: .title2)
        return label
    }()
    
    // text input (User interactive)
    var orgTextfield: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "Enter an organization"
        textfield.borderStyle = .roundedRect
        textfield.backgroundColor = .clear
        return textfield
    }()
    
    // text input (User interactive)
    var repoTextfield: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "Enter a repository"
        textfield.borderStyle = .roundedRect
        textfield.backgroundColor = .clear
        return textfield
    }()
    
    // a button (User interactive)
    lazy var submitButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.filled()
        config.title = "View Issues"
        config.baseForegroundColor = .white
        config.baseBackgroundColor = .black
        config.cornerStyle = .capsule
        button.configuration = config
        // This is telling the button what to do once it's been tapped. It's going to run the fetchIssues function
        button.addTarget(self, action: #selector(fetchIssues), for: .touchUpInside)
        return button
    }()

    // this function is essentially running all the other functions/ui to present in our VC
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .systemGray6
        
        // AUTO SET UP TYPE TEXT WHEN LAUNCH
        orgTextfield.text = "Apple"
        repoTextfield.text = "Swift"
        
        setupUI()
        activateIndicator()
    }
    
    // this is a catch all func to handle constraints etc.
    func setupUI() {
        // simple declaration for a reusable value. Streamlined here for code readability and easy debugging
        let standardPadding: CGFloat = 20
        
        // I actually can't tell why this line of code is here or where it's relevant so I commented it out. The title of the submit button is declared up in the original property.
       // submitButton.titleLabel?.text = "Submit"
        
        //connecting all the UI to the containerView stack (in order of appearance, with some spacing added)
        containerView.addArrangedSubview(gitLabel)
        containerView.addArrangedSubview(gitSubLabel)
        containerView.setCustomSpacing(standardPadding, after: gitSubLabel)
        containerView.addArrangedSubview(orgLabel)
        containerView.addArrangedSubview(orgTextfield)
        containerView.addArrangedSubview(repoLabel)
        containerView.addArrangedSubview(repoTextfield)
        containerView.setCustomSpacing(standardPadding, after: repoTextfield)
        containerView.addArrangedSubview(submitButton)
        
        view.addSubview(containerView)
        
        
        NSLayoutConstraint.activate([
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    @objc func fetchIssues() {
        
        let organization = orgTextfield.text
        let repo = repoTextfield.text
        
        guard let organization = organization, let repo = repo else {
            return
        }
        
        activityIndicator.startAnimating()
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            
            let viewModel = IssueViewModel()
            viewModel.fetchIssues(for: organization, repo: repo) { [self] issues in
                print("Successfully received issues.")
                
                let issuesVC = IssuesCollectionVC(viewModel: viewModel)                
                navigationController?.pushViewController(issuesVC, animated: true)
                activityIndicator.stopAnimating()
            }
        }
    }
    
    let activityIndicator = UIActivityIndicatorView(style: .large)
    
    func activateIndicator() {
        let container = UIView()
        container.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        
        activityIndicator.center = self.view.center
        
        container.addSubview(activityIndicator)
        self.view.addSubview(container)
    }
    
}

