//
//  StoryCell.swift
//  Barstool Challenge
//
//  Created by Ethan Keiser on 11/15/19.
//  Copyright © 2019 Barstool Sports. All rights reserved.
//

import Foundation
import UIKit

class StoryCell : UICollectionViewCell {
    lazy var mainImageView = UIImageView()
    lazy var titleLabel = UILabel()
    lazy var authorLabel = UILabel()
    lazy var brandNameLabel = UILabel()
    var storyModelView : StoryModelView? {
        didSet {
            titleLabel.text = storyModelView?.title
            authorLabel.text = storyModelView?.authorName
            brandNameLabel.text = storyModelView?.brandName
            storyModelView?.getThumbnail(completion: { (image) in
                self.mainImageView.image = image
            })
        }
    }

    lazy var width: NSLayoutConstraint = {
        let width = contentView.widthAnchor.constraint(equalToConstant: bounds.size.width)
        width.isActive = true
        return width
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupViews() {
        
        mainImageView.setContentHuggingPriority(.defaultHigh, for: .vertical)
        mainImageView.contentMode = .scaleAspectFit
        mainImageView.clipsToBounds = true
        mainImageView.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.font = UIFont(name: "Arial-BoldMT", size: 11)
        titleLabel.numberOfLines = 0
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        authorLabel.adjustsFontSizeToFitWidth = true
        authorLabel.numberOfLines = 0
        authorLabel.font = UIFont.systemFont(ofSize: 10)
        authorLabel.translatesAutoresizingMaskIntoConstraints = false

        brandNameLabel.numberOfLines = 0
        brandNameLabel.adjustsFontSizeToFitWidth = true
        brandNameLabel.font = UIFont.systemFont(ofSize: 10)
        brandNameLabel.translatesAutoresizingMaskIntoConstraints = false
            
        let stackView = UIStackView(arrangedSubviews: [mainImageView, titleLabel, authorLabel, brandNameLabel])
        contentView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 10
            
        stackView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        stackView.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        stackView.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
            
        if let lastSubview = contentView.subviews.last {
            contentView.bottomAnchor.constraint(equalTo: lastSubview.bottomAnchor, constant: 10).isActive = true
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
       // mainImageView.image = nil
    }

    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        width.constant = bounds.size.width
        return contentView.systemLayoutSizeFitting(CGSize(width: targetSize.width, height: 1))
    }
}
