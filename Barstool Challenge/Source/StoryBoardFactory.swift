//
//  StoryBoardFactory.swift
//  Barstool Challenge
//
//  Created by Ethan Keiser on 11/19/19.
//  Copyright © 2019 Barstool Sports. All rights reserved.
//

import Foundation
import UIKit

protocol StoryBoardFactoryProtocol {
    func createStoryDetailViewController(storyId: Int) -> StoryDetailViewController
}

class StoryBoardFactory : StoryBoardFactoryProtocol {
    
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    
    func createStoryDetailViewController(storyId: Int) -> StoryDetailViewController {
        let storyDetailViewController = storyboard.instantiateViewController(withIdentifier: "\(StoryDetailViewController.self)") as! StoryDetailViewController
        storyDetailViewController.storyId = storyId
        return storyDetailViewController
    }
}
