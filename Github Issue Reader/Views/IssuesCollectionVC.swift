//
//  IssuesCollectionVC.swift
//  Github Issue Reader
//
//  Created by Alivia Fairchild on 8/31/22.
//

import UIKit

class IssuesCollectionVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    private struct Section: Hashable {
        let section: Int
    }
    private enum Row: Hashable {
        case issue(Issue)
        case loading
    }

    private let viewModel: IssueViewModel
    private let mainSection = Section(section: 0)

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

        // Load initial data
        var snapshot = dataSource.snapshot()

        snapshot.appendSections([mainSection])
        snapshot.appendItems([.loading], toSection: mainSection)

        dataSource.apply(snapshot)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    private func configureViewController() {
        view.backgroundColor = .systemBackground
        navigationItem.title = "Issues"
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    /// Issues have loaded into the `IssuesViewModel`, update the UI with the new data
    func reload() {
        var snapshot = dataSource.snapshot()
        snapshot.appendItems(viewModel.issues.map { .issue($0) }, toSection: mainSection)
        dataSource.apply(snapshot)
        print("Displaying \(viewModel.issues.count) issues")
    }

    // MARK: UICollectionView

    private func configureCollectionView() {
        collectionView.backgroundColor = .systemGray2
        collectionView.register(IssueLoadingCell.self, forCellWithReuseIdentifier: IssueLoadingCell.identifier)
    }

    private lazy var dataSource: UICollectionViewDiffableDataSource<Section, Row> = {
        let registration = UICollectionView.CellRegistration<UICollectionViewListCell, Issue> { cell, indexPath, issue in
            cell.contentConfiguration = IssuePreviewContentConfiguration(issue: issue)
        }
        return .init(collectionView: collectionView) { collectionView, indexPath, row in
            switch row {
            case .issue(let issue):
                let cell = collectionView.dequeueConfiguredReusableCell(using: registration, for: indexPath, item: issue)
                cell.accessories = [.disclosureIndicator()]
                return cell
            case .loading:
                return collectionView.dequeueReusableCell(withReuseIdentifier: IssueLoadingCell.identifier, for: indexPath)
            }
        }
    }()
}
