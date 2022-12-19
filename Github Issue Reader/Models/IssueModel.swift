//
//  IssueModel.swift
//  Github Issue Reader
//
//  Created by Savannah Sosa on 8/30/22.
//

import Foundation
import UIKit

// 1 hour

// the data within the struct is going to need to conform to the protocols codable and hashable so we take those types in at the beginning.
struct Issue: Codable, Hashable {
    // every constant below is pulled from the JSON data model in the API most of the data is required in the API so it's okay that they're non-optional. Only optional is the "body" property because it could return a nil
    let id: Int
    let title: String
    // state data has more than just a type to return which is handled in the enum below
    let state: State
    // User is data that has even more data within it so it's broken out into it's own model to handle that info
    let user: User
    let body: String?
    let createdAt: String
    
    enum State: String, Codable, Hashable {
        // Is the issue closed or open? That's what we are asking the state to represent.
        case open
        case closed
        //
        var localizedTitle: String {
             rawValue.capitalized
//            switch self {
//            case .open:
//                return "Open"
//            case .closed:
//                return "Closed"
//            }
        }
    }
}

// this extension is telling the state cases to be assigned a specific color.
extension UIColor {
    // INACCURATE private keeps the function only accessible to this file. if Issue gets called elsewhere in the project this function will not be available to modify.
    
    // static means this func is a part of uicolor -- look more into this. 
    static func from(state: Issue.State) -> UIColor {
        // when the state is case - return -
        switch state {
        case .open:
            return .green
        case .closed:
            return .red
        }
    }
}
