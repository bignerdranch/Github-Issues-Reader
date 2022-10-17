//
//  IssueViewModel.swift
//  Github Issue Reader
//
//  Created by Savannah Sosa on 8/31/22.
//

import Foundation


class IssueViewModel {
    
    var issues: [Issue] = []
    
    func fetchIssues(for organization: String, repo: String, completion: @escaping ([Issue]?) -> Void) {
         let url = "https://api.github.com/repos/\(organization)/\(repo)/issues"
         NetworkingManager.shared.request(url, type: [Issue].self) { [weak self] response in
             DispatchQueue.main.async { [weak self] in
                 switch response {
                 case .success(let response):
                     self?.issues.append(contentsOf: response)
                     completion(self?.issues)
                 case .failure(let error):
                     print(error)
                     completion(nil)
                 }
             }
         }
     }
    
}
