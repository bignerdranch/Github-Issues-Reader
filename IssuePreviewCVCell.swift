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
    
    var issuePreviewView: IssuePreviewView = {
        var issue = IssuePreviewView.nib()
        issue.translatesAutoresizingMaskIntoConstraints = false
        return issue
    }()
    
    func configure(issue: Issue){
        issuePreviewView.configure(issue: issue)
        addSubview(issuePreviewView)
        // subView constraints added here
        let constraints = [
            issuePreviewView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            issuePreviewView.topAnchor.constraint(equalTo: self.topAnchor),
            issuePreviewView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            issuePreviewView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
}



