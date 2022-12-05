//
//  ViewController.swift
//  Github Issue Reader
//
//  Created by Savannah Sosa on 8/30/22.
//

import UIKit

class ViewController: UIViewController {

    var containerView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.alignment = .leading
        view.distribution = .fill
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var gitLabel: UILabel = {
        let label = UILabel()
        label.text = "GitHub Issue Viewer"
        label.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        return label
    }()
    
    var gitSubLabel: UILabel = {
        let label = UILabel()
        label.text = "View issues in a repository:"
        label.font = .preferredFont(forTextStyle: .title2)
        label.textColor = .systemGray
        return label
    }()
    
    var orgLabel: UILabel = {
        let label = UILabel()
        label.text = "Organization"
        label.font = UIFont.preferredFont(forTextStyle: .title2)
        return label
    }()
    
    var repoLabel: UILabel = {
        let label = UILabel()
        label.text = "Repository"
        label.font = UIFont.preferredFont(forTextStyle: .title2)
        return label
    }()
    
    var orgTextfield: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "Enter an organization"
        textfield.borderStyle = .roundedRect
        textfield.backgroundColor = .clear
        return textfield
    }()
    
    var repoTextfield: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "Enter a repository"
        textfield.borderStyle = .roundedRect
        textfield.backgroundColor = .clear
        return textfield
    }()
    
    lazy var submitButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.filled()
        config.title = "View Issues"
        config.baseForegroundColor = .white
        config.baseBackgroundColor = .black
        config.cornerStyle = .capsule
        button.configuration = config
        button.addTarget(self, action: #selector(fetchIssues), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .systemGray6
        
        // AUTO SET UP TYPE TEXT WHEN LAUNCH
        orgTextfield.text = "Apple"
        repoTextfield.text = "Swift"
        
        setupUI()
    }
    
    func setupUI() {
        
        let standardPadding: CGFloat = 20
        
        submitButton.titleLabel?.text = "Submit"
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

        let viewModel = IssueViewModel()
        let issuesVC = IssuesCollectionVC(viewModel: viewModel)
        navigationController?.pushViewController(issuesVC, animated: true)

        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            viewModel.fetchIssues(for: organization, repo: repo) { [self] issues in
                print("Loaded \(issues?.count ?? 0) issues")
                issuesVC.reload()
            }
        }
    }
}
