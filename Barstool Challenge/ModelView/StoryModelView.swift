//
//  StoryModelView.swift
//  Barstool Challenge
//
//  Created by Ethan Keiser on 11/16/19.
//  Copyright © 2019 Barstool Sports. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
class StoryModelView {

    var story : Story
    init(story s: Story) {
        story = s
    }

    var authorName : String {
        get { return "Author: \(story.author.name)" }
    }
    
    var title : String {
        get { return story.title }
    }
    
    var brandName : String {
        get {
            guard let brandName = story.brand_name else {
                return ""
            }
            return "Brand Name: \(brandName)"
        }
    }
    func getThumbnail(completion:@escaping (UIImage?) ->()) {
        Alamofire.request(story.thumbnail.location + story.thumbnail.images.small, method: .get)
            .validate()
            .responseData(completionHandler: { (responseData) in
                completion((UIImage(data: responseData.data!)?.resizeImage(targetSize: CGSize(width: 200, height: 200))))
            })
    }
}
