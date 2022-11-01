//
//  IssuePreviewView.swift
//  Github Issue Reader
//
//  Created by Alivia Fairchild on 10/13/22.
//

import Foundation
import UIKit

class IssuePreviewView: UIView {
    
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var issueTitleLabel: UILabel!
    
    func configure(issue: Issue) {
        issueTitleLabel.text = issue.title ?? "I Dunno"
        username.text = issue.user?.login
        
//        // constraints for the labels
//        let constraints = [
//            issueTitleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
//            issueTitleLabel.topAnchor.constraint(equalTo: self.topAnchor ),
//            issueTitleLabel.bottomAnchor.constraint(equalTo: username.topAnchor),
//            issueTitleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
//
//            username.leadingAnchor.constraint(equalTo: self.leadingAnchor),
//       //     username.topAnchor.constraint(equalTo: issueTitleLabel.bottomAnchor),
//            username.bottomAnchor.constraint(equalTo: self.bottomAnchor),
//            username.trailingAnchor.constraint(equalTo: self.trailingAnchor)
//        ]
//
//        NSLayoutConstraint.activate(constraints)
       
    }
    
//    class func nib() -> IssuePreviewView {
//        return UINib(nibName: "IssuePreviewView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! IssuePreviewView
//    }
    
}
