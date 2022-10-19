//
//  IssueViewModelTests.swift
//  GithubIssueReaderTests
//
//  Created by Kevin Randrup on 10/18/22.
//

import XCTest
@testable import Github_Issue_Reader

final class IssueViewModelTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testIssueModel_codable() throws {
        let data = """
        {
            "id": 3,
            "title": "Hello",
            "state": "GA",
            "user": { "id": 123, "login": "Kevin", "avatarURL": null },
            "body": "of the Randrups",
            "createdAt": "now"
        }
        """.data(using: .utf8)!
        let decodedIssue = try JSONDecoder().decode(Issue.self, from: data)

        XCTAssertEqual(decodedIssue.id, 3)
        XCTAssertEqual(decodedIssue.user?.id, 123)
        XCTAssertNil(decodedIssue.user?.avatarURL)

        let expectedIssue = Issue(
            id: 3,
            title: "Hello",
            state: "GA",
            user: .init(id: 123, login: "Kevin", avatarURL: nil),
            body: "of the Randrups",
            createdAt: "now"
        )
        XCTAssertEqual(decodedIssue, expectedIssue)
    }

    func testIssueViewModel_successfulFetch() {
        let e = expectation(description: "issues fetched")

        let issueViewModel = IssueViewModel()
        issueViewModel.fetchIssues(for: "apple", repo: "swift") { downloadedIssues in
            XCTAssertNotNil(downloadedIssues)

            XCTAssertEqual(issueViewModel.issues, downloadedIssues)

            e.fulfill()
        }

        waitForExpectations(timeout: 10.0)
    }

    func testIssueViewModel_badFetch() {
        let e = expectation(description: "issues fetched")

        let issueViewModel = IssueViewModel()
        issueViewModel.fetchIssues(for: "asdjklfkajsfklasdjflkasd", repo: "swift") { issues in
            XCTAssertNil(issues)
            e.fulfill()
        }

        waitForExpectations(timeout: 10.0)
    }

    func testIssueViewModel_doubleFetch() {
        let firstFetch = expectation(description: "first issues fetched")
        let secondFetch = expectation(description: "second issues fetched")

        let issueViewModel = IssueViewModel()

        issueViewModel.fetchIssues(for: "apple", repo: "swift") { downloadedSwiftIssues in
            XCTAssertNotNil(downloadedSwiftIssues)

            XCTAssertEqual(issueViewModel.issues, downloadedSwiftIssues)

            firstFetch.fulfill()

            issueViewModel.fetchIssues(for: "apple", repo: "swift-syntax") { downloadedSwiftSyntaxIssues in
                XCTAssertEqual(issueViewModel.issues.count, 2) // It's not 2, what should this number be
            }
        }

        waitForExpectations(timeout: 10.0)
    }
}
