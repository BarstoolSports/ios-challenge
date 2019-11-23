//
//  Story.swift
//  Barstool Challenge
//
//  Created by Ethan Keiser on 11/16/19.
//  Copyright © 2019 Barstool Sports. All rights reserved.
//

import Foundation

struct Story : Codable {
    let id : Int
    var brand_name : String?
    let title : String
    let type : String
    let url : String
    let thumbnail : Thumbnail
    let author : Author
    let post_type_meta : PostTypeMeta
}
struct PostTypeMeta : Codable {
    let standard_post : StandardPost
}

struct StandardPost : Codable {
    var raw_content : String?
    var content : String?
}

struct Thumbnail : Codable {
    let location : String
    let images : BSImages
}
struct BSImages : Codable {
    let small : String
    let medium : String
    let large : String

}
struct Author : Codable {
    let name : String
    let author_url : String
}

