//
//  UserModel .swift
//  Github Issue Reader
//
//  Created by Savannah Sosa on 8/30/22.
//

import Foundation

// 2 mins
// the data within the struct is going to need to conform to the protocols codable and hashable so we take those types in at the beginning.
// Kevin - what does "take those types" mean?
struct User: Codable, Hashable {
    // simply pulling in the JSON data and translating it to Swift again here. the avatarURL May or may not have a value so it's an optional.
    // Kevin - this is declaring variables, `Codable` is responsible for translating JSON <-> Swift
    let id: Int
    let login: String
    let avatarURL: String?
}
