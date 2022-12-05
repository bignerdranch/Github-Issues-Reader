//
//  IssuesCollectionVC.swift
//  Github Issue Reader
//
//  Created by Alivia Fairchild on 8/31/22.
//

import UIKit
import Combine

class IssuesCollectionVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    private struct Section: Hashable {
        let section: Int
    }
    private enum Row: Hashable {
        case issue(Issue)
        case loading
        case error(ErrorDetails)
    }

    private struct ErrorDetails: Hashable {
        let title: String
        let description: String?

        init(_ error: NetworkingManager.NetworkingError) {
            self.title = error.title
            self.description = error.description
        }
    }

    private let viewModel: IssueViewModel
    private let mainSection = Section(section: 0)
    private var subscriptions = Set<AnyCancellable>()

    init(viewModel: IssueViewModel) {
        let configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        self.viewModel = viewModel
        super.init(collectionViewLayout: layout)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureCollectionView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    private func configureViewController() {
        view.backgroundColor = .systemBackground
        navigationItem.title = "Issues"
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    // MARK: UICollectionView

    private func configureCollectionView() {
        collectionView.backgroundColor = .systemGray2
        collectionView.register(IssueLoadingCell.self, forCellWithReuseIdentifier: IssueLoadingCell.identifier)

        // Case 1 - good load
        //      initial - ([], nil)
        //      after load - ([issue 1, issue 2, ...], nil)

        // Case 2 - bad load
        //      initial - ([], nil)
        //      after load - ([], "The operation couldn't be completed....")
        viewModel.$issues.combineLatest(viewModel.$error).sink { issues, error in
            var snapshot = NSDiffableDataSourceSnapshot<Section, Row>()
            snapshot.appendSections([self.mainSection])

            if let error = error {
                snapshot.appendItems([.error(ErrorDetails(error))], toSection: self.mainSection)
            } else if issues.isEmpty {
                print("Displaying loading indicator")
                snapshot.appendItems([.loading], toSection: self.mainSection)
            } else {
                print("Displaying \(issues.count) issues")
                snapshot.appendItems(issues.map { .issue($0) }, toSection: self.mainSection)
            }

            self.dataSource.apply(snapshot)
        }.store(in: &subscriptions)
    }

    private lazy var dataSource: UICollectionViewDiffableDataSource<Section, Row> = {
        let issueRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, Issue> { cell, indexPath, issue in
            cell.contentConfiguration = IssuePreviewContentConfiguration(issue: issue)
        }
        let errorRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, ErrorDetails> { cell, indexPath, errorDetails in
            var content = UIListContentConfiguration.subtitleCell()
            content.text = errorDetails.title
            content.secondaryText = errorDetails.description

            cell.contentConfiguration = content
        }
        return .init(collectionView: collectionView) { collectionView, indexPath, row in
            switch row {
            case .issue(let issue):
                let cell = collectionView.dequeueConfiguredReusableCell(using: issueRegistration, for: indexPath, item: issue)
                cell.accessories = [.disclosureIndicator()]
                return cell
            case .loading:
                return collectionView.dequeueReusableCell(withReuseIdentifier: IssueLoadingCell.identifier, for: indexPath)
            case .error(let error):
               return collectionView.dequeueConfiguredReusableCell(using: errorRegistration, for: indexPath, item: error)
            }
        }
    }()
}
