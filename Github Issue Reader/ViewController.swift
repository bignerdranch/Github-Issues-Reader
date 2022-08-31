//
//  ViewController.swift
//  Github Issue Reader
//
//  Created by Savannah Sosa on 8/30/22.
//

import UIKit

class ViewController: UIViewController {
    
    let viewModel = IssueViewModel()
    
    
    var containerView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var orgTextfield: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "Enter an organization"
        return textfield
    }()
    
    var repoTextfield: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "Enter a repository"
        return textfield
    }()
    
    lazy var submitButton: UIButton = {
        let button = UIButton()
        button.tintColor = .black
        button.backgroundColor = .white
        button.addTarget(self, action: #selector(fetchIssues), for: .touchUpInside)
        return button
    }()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .systemPink
        setupUI()
        
    }
    
    func setupUI() {
        
        submitButton.titleLabel?.text = "Submit"
        containerView.addArrangedSubview(orgTextfield)
        containerView.addArrangedSubview(repoTextfield)
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
        
        viewModel.fetchIssues(for: organization, repo: repo)
        
        for issue in viewModel.issues {
            print(issue.title)
        }
        
    }

}

