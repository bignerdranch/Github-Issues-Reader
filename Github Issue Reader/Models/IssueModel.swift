//
//  IssueModel.swift
//  Github Issue Reader
//
//  Created by Savannah Sosa on 8/30/22.
//

import Foundation

struct Issue: Codable, Equatable {
    let id: Int
    let title: String?
    let state: String?
    let user: User?
    let body: String?
    let createdAt: String?
}
