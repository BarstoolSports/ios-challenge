//
//  BSSApi.swift
//  Barstool Challenge
//
//  Created by Ethan Keiser on 11/16/19.
//  Copyright © 2019 Barstool Sports. All rights reserved.
//

import Foundation
import Alamofire

class RequestHandler {
    
    enum url : String {
        case latestStories = "https://union.barstoolsports.com/v2/stories/latest"
        case story = "https://union.barstoolsports.com/v2/stories/"
    }

    func getStories(type: String = "standard_post", page: Int = 1, limit: Int = 25, result: @escaping (Result<[Story]>) -> ()) {
        
        Alamofire.request(url.latestStories.rawValue,parameters: ["type": type,"page":page,"limit":limit]).responseData { response in
            let todo: Result<[Story]> = JSONDecoder().decodeResponse(from: response)
                        result(todo)
        }
    }
    func getStory(storyId: Int, result: @escaping (Result<Story>) -> ()) {
          
        Alamofire.request("\(url.story.rawValue)\(storyId)" , parameters:nil).responseData { response in
              let todo: Result<Story> = JSONDecoder().decodeResponse(from: response)
                          result(todo)
          }
      }
}

extension JSONDecoder {
  func decodeResponse<T: Decodable>(from response: DataResponse<Data>) -> Result<T> {
    guard response.error == nil else {
      print(response.error!)
      return .failure(response.error!)
    }

    guard let responseData = response.data else {
      print("didn't get any data from API")
      return .failure(BackendError.urlError(reason:
        "Did not get data in response"))
    }

    do {
      let item = try decode(T.self, from: responseData)
      return .success(item)
    } catch {
      print("error trying to decode response")
      print(error)
      return .failure(error)
    }
  }
}

enum BackendError: Error {
  case urlError(reason: String)
  case objectSerialization(reason: String)
}
