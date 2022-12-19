//
//  IssueViewModel.swift
//  Github Issue Reader
//
//  Created by Savannah Sosa on 8/31/22.
//

import Foundation

// 2 hours fetch, 6 hours async await
// 4 hours sorting - understand closures
// 2 days - sorting
class IssueViewModel {
    
    var issues: [Issue] = []
    
    func fetchIssues(for organization: String, repo: String, completion: @escaping (_ downloadedIssues: [Issue]?) -> Void) {
         let url = "https://api.github.com/repos/\(organization)/\(repo)/issues"
        // networkingManager class on compile then shared property on runtime.
        // due to the static let of the shared property in the NetworkManager file we do NOT have to create an instance in this class to call the func and other things. i.e.
        // var nm = networkingM()
        // nm.request
         NetworkingManager.shared.request(url, type: [Issue].self) { [weak self] response in
             DispatchQueue.main.async { [weak self] in
                 guard let self = self else { return }
                 switch response {
                 case .success(let response):
                     self.issues.append(contentsOf: response)
                     completion(self.issues)
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
        // issues = ["alpha", "bravo", "zeta", "oscar", "charlie"]
        issues.sort { first, second in
            first.title < second.title
        }
    }
    
    func sortByUser() {
        issues.sort { first, second in
            first.user.id < second.user.id
        }
    }
}
