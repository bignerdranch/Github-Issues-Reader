//
//  IssueModel.swift
//  Github Issue Reader
//
//  Created by Savannah Sosa on 8/30/22.
//

import Foundation
import UIKit

// 1 hour
struct Issue: Codable, Hashable {
    let id: Int
    let title: String
    let state: State
    let user: User
    let body: String?
    let createdAt: String

    enum State: String, Codable, Hashable {
        case open
        case closed

        var localizedTitle: String {
            rawValue.capitalized
        }
    }
}

extension UIColor {
    static func from(state: Issue.State) -> UIColor {
        switch state {
        case .open:
            return .green
        case .closed:
            return .red
        }
    }
}
