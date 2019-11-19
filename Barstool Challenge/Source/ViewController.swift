//
//  ViewController.swift
//  Barstool Challenge
//
//  Created by Andrew Barba on 1/22/19.
//  Copyright © 2019 Barstool Sports. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UICollectionViewController, InfinityScrollModelViewDelegate{
    private let itemsPerRow: CGFloat = 2
    private let sectionInsets = UIEdgeInsets(top: 50.0,
    left: 20.0,
    bottom: 50.0,
    right: 20.0)

    private var infinityScrollModelView : InfinityScrollModelView!
    private let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupRefreshControl(collectionView: collectionView)
        navigationItem.searchController = setupSearch()
        collectionView.dataSource = self
        collectionView.prefetchDataSource = self
        collectionView.isPrefetchingEnabled = true
        collectionView.register(StoryCell.self, forCellWithReuseIdentifier: "\(StoryCell.self)")
        infinityScrollModelView = InfinityScrollModelView(requestHandler: RequestHandler(), delegate: self)
        infinityScrollModelView.fetchNewData()
    }
    
    func onFetchCompleted(with newIndexPathsToReload: [IndexPath]?) {
        self.refreshControl.endRefreshing()
        navigationItem.searchController?.searchBar.text = ""
        guard let newIndexPathsToReload = newIndexPathsToReload else {
            collectionView.reloadData()
          return
        }
        
        let indexPathsToReload = visibleIndexPathsToReload(intersecting: newIndexPathsToReload)
        collectionView.reloadItems(at: indexPathsToReload)
    }
    
    func onFetchFailed(with reason: String) {
        self.refreshControl.endRefreshing()
        navigationItem.searchController?.searchBar.text = ""
    }
    
    private func setupRefreshControl(collectionView: UICollectionView){
        refreshControl.addTarget(self, action: #selector(loadData), for: .valueChanged)
        collectionView.refreshControl = refreshControl
        refreshControl.attributedTitle = NSAttributedString(string: "Fetching Great Content ...", attributes: nil)
    }
    
    @objc func loadData() {
        infinityScrollModelView.refreshData()
    }
}
/// Delegate
extension ViewController {
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = StoryBoardFactory().createStoryDetailViewController(storyId: infinityScrollModelView.story(at: indexPath.row).id)
        self.navigationController?.pushViewController( vc, animated: true)
    }
}

extension ViewController : UICollectionViewDataSourcePrefetching {
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        if indexPaths.contains(where: isLoadingCell) {
            infinityScrollModelView.fetchNewData()
        }
    }
    
    func visibleIndexPathsToReload(intersecting indexPaths: [IndexPath]) -> [IndexPath] {
        let indexPathsForVisibleRows = collectionView.indexPathsForVisibleItems
        let indexPathsIntersection = Set(indexPathsForVisibleRows).intersection(indexPaths)
        return Array(indexPathsIntersection)
    }
    
    func isLoadingCell(for indexPath: IndexPath) -> Bool {
        return indexPath.row >= infinityScrollModelView.currentCount
    }
}

extension ViewController : UISearchBarDelegate {
    
    private func setupSearch() -> UISearchController! {
           let searchController = UISearchController(searchResultsController: nil)
           searchController.searchBar.delegate = self
           if #available(iOS 9.1, *) {
               searchController.obscuresBackgroundDuringPresentation = false
           } else {
               // Fallback on earlier versions
           }
           searchController.searchBar.placeholder = "Search Content"
           return searchController
       }
       
       func searchBarIsEmpty() -> Bool {
           // Returns true if the text is empty or nil
           if #available(iOS 11.0, *) {
               guard let searchController = navigationItem.searchController else {
                   fatalError()
               }
               return searchController.searchBar.text?.isEmpty ?? true

           } else {
               return false
           }
       }
       
        func filterContentForSearchText(_ searchText: String) {
            infinityScrollModelView.isFiltered = true
            infinityScrollModelView.filteredModelViews = infinityScrollModelView.modelViews.filter { (viewModel) -> Bool in
                return viewModel.title.lowercased().contains(searchText.lowercased())
            }
            collectionView.reloadData()
        }
    
        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            filterContentForSearchText(searchBar.text ?? "")
        }
    
        func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
            infinityScrollModelView.isFiltered = false
            infinityScrollModelView.refreshData()
        }
}

/// Data Source
extension ViewController  {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return infinityScrollModelView.totalCount
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "\(StoryCell.self)", for: indexPath) as! StoryCell
    
        if isLoadingCell(for: indexPath) {
            cell.mainImageView.image = UIImage(named: "barstoolLogo")
            cell.titleLabel.text = ""
            cell.authorLabel.text = ""
            cell.brandNameLabel.text = ""
        } else {
            cell.storyModelView = infinityScrollModelView.displayModelViews[indexPath.row]
        }
        
        if indexPath.row > infinityScrollModelView.totalCount - 25 && !infinityScrollModelView.isFiltered {
            infinityScrollModelView.fetchNewData()
        }
        return cell
    }
}

/// Flow layout default functionality.
extension ViewController : UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {

    let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
    let availableWidth = view.frame.width - paddingSpace
    let widthPerItem = availableWidth / itemsPerRow

    return CGSize(width: widthPerItem, height:300)
  }

    func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      insetForSectionAt section: Int) -> UIEdgeInsets {
    return sectionInsets
  }

    func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return sectionInsets.left
  }
}
