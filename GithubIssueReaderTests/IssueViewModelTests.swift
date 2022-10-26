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

    func testIssueViewModel_badFetch() async {
        self.executionTimeAllowance = 0.1

        let issueViewModel = IssueViewModel()
        let issues = await issueViewModel.fetchIssuesAsync(for: "asdjklfkajsfklasdjflkasd", repo: "swift")
        XCTAssertNil(issues)
    }

    func testIssueViewModel_doubleFetch() {
        var firstFetch = expectation(description: "first issue fetched")
        var secondFetch = expectation(description: "second issue fetched")
        
        var issueViewModel = IssueViewModel()
        
        issueViewModel.fetchIssues(for: "apple", repo: "swift") { downloadedSwiftIssues in
            XCTAssertNotNil(downloadedSwiftIssues)
            
            XCTAssertEqual(issueViewModel.issues, downloadedSwiftIssues)
            
            firstFetch.fulfill()
            
            issueViewModel.fetchIssues(for: "apple", repo: "swift-syntax") { downloadedSwiftAndSwiftSyntaxIssues in
                
                XCTAssertEqual(issueViewModel.issues.count, 60)
                
                secondFetch.fulfill()
                
            }
        }
        waitForExpectations(timeout: 10.0)
    }

    func testIssueViewModel_sortingTitle() {
        // Given
        let issueViewModel = IssueViewModel()
        let issueVia = Issue(
            id: 3,
            title: "Via's Issue",
            state: "",
            user: .init(id: 123, login: "Via", avatarURL: nil),
            body: "of the Fairchilds",
            createdAt: "now"
        )
        let issueKevin = Issue(
            id: 2,
            title: "Kevin's Issue",
            state: "GA",
            user: .init(id: 123, login: "Kevin", avatarURL: nil),
            body: "of the Randrups",
            createdAt: "now"
        )
        issueViewModel.issues = [issueVia, issueKevin]

        // When
        issueViewModel.sortByTitle()

        // Then
        XCTAssertEqual(issueViewModel.issues[0], issueKevin)
        XCTAssertEqual(issueViewModel.issues[1], issueVia)
    }
    
    
    func testIssueViewModel_sortingUser() {
        var firstFetch = expectation(description: "first issue fetched")
        
        // giveme
        let issueViewModel = IssueViewModel()
        let issueVia = Issue(
            id: 3,
            title: "Via's Issue",
            state: "",
            user: .init(id: 123, login: "Via", avatarURL: nil),
            body: "of the Fairchilds",
            createdAt: "now"
        )
        let issueKevin = Issue(
            id: 2,
            title: "Kevin's Issue",
            state: "GA",
            user: .init(id: 927, login: "Kevin", avatarURL: nil),
            body: "of the Randrups",
            createdAt: "now"
        )
        issueViewModel.issues = [issueVia, issueKevin]

        // when
        issueViewModel.sortByUser()
        
        // thennnnn
        continueAfterFailure = false

        XCTAssertEqual(issueViewModel.issues.first, issueVia)
        XCTAssertEqual(issueViewModel.issues[1], issueKevin)

        firstFetch.fulfill()
        
        waitForExpectations(timeout: 10.0)

    }
}
