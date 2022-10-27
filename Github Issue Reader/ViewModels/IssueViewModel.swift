//
//  IssueViewModel.swift
//  Github Issue Reader
//
//  Created by Savannah Sosa on 8/31/22.
//

import Foundation


class IssueViewModel {
    
    var issues: [Issue] = []
    
    func fetchIssues(for organization: String, repo: String, completion: @escaping (_ downloadedIssues: [Issue]?) -> Void) {
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

    func fetchIssuesAsync(for organization: String, repo: String) async -> [Issue]? {
        await withCheckedContinuation { continuation in
            fetchIssues(for: organization, repo: repo) { downloadedIssues in
                continuation.resume(returning: downloadedIssues)
            }
        }
    }

    func sortByTitle() {
        issues.sort { first, second in
            guard let firstTitle = first.title else { return false }
            guard let secondTitle = second.title else { return true }
            return firstTitle < secondTitle
        }
    }
    
    func sortByUser() {
        issues.sort { first, second in
            guard let firstUser = first.user?.id else { return false}
            guard let secondUser = second.user?.id else { return true }
            return firstUser < secondUser
        }
    }
}
