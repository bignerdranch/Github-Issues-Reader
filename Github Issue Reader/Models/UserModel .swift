//
//  UserModel .swift
//  Github Issue Reader
//
//  Created by Savannah Sosa on 8/30/22.
//

import Foundation

struct User: Codable, Hashable {
    let id: Int
    let login: String
    let avatarURL: String?
}
