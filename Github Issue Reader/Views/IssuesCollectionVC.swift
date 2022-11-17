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

    private let viewModel: IssueViewModel

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
        let section = Section(section: 0)
        snapshot.appendSections([section])
        snapshot.appendItems(viewModel.issues, toSection: section)
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

    // MARK: UICollectionView

    private lazy var dataSource: UICollectionViewDiffableDataSource<Section, Issue> = {
        let registration = UICollectionView.CellRegistration<UICollectionViewListCell, Issue> { cell, indexPath, itemIdentifier in
            cell.contentConfiguration = IssuePreviewContentConfiguration(issue: itemIdentifier)
        }
        return .init(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: registration, for: indexPath, item: itemIdentifier)
            cell.accessories = [.disclosureIndicator()]
            return cell
        }
    }()

    func configureCollectionView() {
        collectionView.backgroundColor = .systemGray2
    }
}
