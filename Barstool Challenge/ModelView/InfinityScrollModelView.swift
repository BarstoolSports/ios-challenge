//
//  InfinityScrollModelView.swift
//  Barstool Challenge
//
//  Created by Ethan Keiser on 11/18/19.
//  Copyright © 2019 Barstool Sports. All rights reserved.
//

import Foundation
protocol InfinityScrollModelViewDelegate: class {
    func onFetchCompleted(with newIndexPathsToReload: [IndexPath]?)
    func onFetchFailed(with reason: String)

}

final class InfinityScrollModelView {
    private weak var delegate: InfinityScrollModelViewDelegate?
    private var currentPage = 1
    private var total = 25
    private var isFetchInProgress = false
    public var modelViews = [StoryModelView]()
    public var isFiltered = false
    public var filteredModelViews = [StoryModelView]()


    let requestHandler : RequestHandler
    
    init(requestHandler : RequestHandler, delegate: InfinityScrollModelViewDelegate) {
        self.requestHandler = requestHandler
        self.delegate = delegate
    }
    
    var totalCount: Int {
        if isFiltered {
            return filteredModelViews.count
        } else {
            return total
        }
    }
    var displayModelViews : [StoryModelView] {
           if isFiltered {
                 return filteredModelViews
             } else {
                 return modelViews
             }
    }
    
    var currentCount: Int {
      return modelViews.count
    }
    
    func story(at index: Int) -> Story {
        if isFiltered {
            return filteredModelViews[index].story
        }
        return modelViews[index].story
    }
    func refreshData() {
        guard !isFetchInProgress else {
          return
        }
        
        isFetchInProgress = true
        requestHandler.getStories(page: 1,limit: totalCount) { (result) in
            switch result {
                    case .failure(let error):
                      DispatchQueue.main.async {
                        self.isFetchInProgress = false
                        self.delegate?.onFetchFailed(with: error.localizedDescription)
                      }
                    case .success(let response):
                      DispatchQueue.main.async {
                        self.isFetchInProgress = false
                        let responseModelViews = response.map{StoryModelView(story: $0)}
                        self.modelViews = responseModelViews
                        self.delegate?.onFetchCompleted(with: .none)
                        
                    }
            }
        }
    }

    func fetchNewData() {
        guard !isFetchInProgress else {
          return
        }
        
        isFetchInProgress = true
        requestHandler.getStories(page: currentPage) { (result) in
              switch result {
                    case .failure(let error):
                      DispatchQueue.main.async {
                        self.isFetchInProgress = false
                        self.delegate?.onFetchFailed(with: error.localizedDescription)
                      }
                    case .success(let response):
                      DispatchQueue.main.async {
                        self.currentPage += 1
                        self.total += 25
                        self.isFetchInProgress = false
                        let responseModelViews = response.map{StoryModelView(story: $0)}
                        self.modelViews.append(contentsOf:responseModelViews)
                        if self.currentPage > 1 {
                            let indexPathsToReload = self.calculateIndexPathsToReload(from:responseModelViews)
                                   self.delegate?.onFetchCompleted(with: indexPathsToReload)
                        } else {
                            self.delegate?.onFetchCompleted(with: .none)
                        }
                    }
            }
        }
    }
    private func calculateIndexPathsToReload(from newStories: [StoryModelView]) -> [IndexPath] {
      let startIndex = modelViews.count - newStories.count
      let endIndex = startIndex + newStories.count
      return (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
    }
    
    
}
