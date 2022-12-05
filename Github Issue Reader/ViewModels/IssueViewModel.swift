//
//  IssueViewModel.swift
//  Github Issue Reader
//
//  Created by Savannah Sosa on 8/31/22.
//

import Foundation

class IssueViewModel {

    @Published var issues: [Issue] = []
    @Published var error: NetworkingManager.NetworkingError?

    func fetchIssues(for organization: String, repo: String, completion: @escaping (_ downloadedIssues: [Issue]?) -> Void) {
        let url = "https://api.github.com/repos/\(organization)/\(repo)/issues"
        // Bad url for testing error logic
//        let url = "https://api.github.com/asdjfaklsdjfaldksjflkas/repos/\(organization)/\(repo)/issues"
        NetworkingManager.shared.request(url, type: [Issue].self) { [weak self] response in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                switch response {
                case .success(let response):
                    self.issues.append(contentsOf: response)
                    completion(self.issues)
                case .failure(let error):
                    self.error = error
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
            first.title < second.title
        }
    }
    
    func sortByUser() {
        issues.sort { first, second in
            first.user.id < second.user.id
        }
    }
}
