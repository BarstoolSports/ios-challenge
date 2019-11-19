//
//  StoryDetailViewController.swift
//  Barstool Challenge
//
//  Created by Ethan Keiser on 11/17/19.
//  Copyright © 2019 Barstool Sports. All rights reserved.
//

import UIKit
import WebKit

class StoryDetailViewController: UIViewController {

    public var storyId : Int?
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var authorLabel: UILabel!
    @IBOutlet var AuthorUrlLabel: UILabel!
    @IBOutlet var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let id = storyId else {
            return
        }
        RequestHandler().getStory(storyId: id) { (result) in
            switch(result)
            {
            case .success(let story):
                self.titleLabel.text = story.title
                self.authorLabel.text = story.author.name
                self.AuthorUrlLabel.text = story.author.author_url
                if let content = story.post_type_meta.standard_post.content {
                    self.webView.loadHTMLString(content, baseURL: nil)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
