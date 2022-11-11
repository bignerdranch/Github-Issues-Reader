//
//  IssuesCollectionVC.swift
//  Github Issue Reader
//
//  Created by Alivia Fairchild on 8/31/22.
//

import UIKit

private let reuseIdentifier = "Cell"

class IssuesCollectionVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var cellHeight: CGFloat = 100

    var viewModel: IssueViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureCollectionView()
        print(viewModel?.issues.count ?? 0)
        self.collectionView.register(IssuePreviewCVCell.self, forCellWithReuseIdentifier: IssuePreviewCVCell.reuseID)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func configureViewController() {
        navigationController?.navigationBar.isHidden = false
        view.backgroundColor = .systemBackground
        navigationItem.title = "Issues"
        navigationController?.navigationBar.prefersLargeTitles = true        
    }
    
    func configureCollectionView() {
        collectionView.backgroundColor = .systemGray2
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: IssuePreviewCVCell.reuseID, for: indexPath) as? IssuePreviewCVCell else {
            return UICollectionViewCell()
        }
        
        guard let issue = viewModel?.issues[indexPath.row] else {
            return UICollectionViewCell()
        }
        
        cell.configure(issue: issue)
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.issues.count ?? 0
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let fullWidth = collectionView.bounds.size.width - collectionView.layoutMargins.left - collectionView.layoutMargins.right
        return CGSize(width: fullWidth, height: cellHeight)
    }
    
}
