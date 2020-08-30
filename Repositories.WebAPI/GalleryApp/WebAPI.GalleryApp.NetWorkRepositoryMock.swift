//
//  GoodToGo
//
//  Created by Ricardo Santos on 13/05/2020.
//  Copyright © 2020 Ricardo P Santos. All rights reserved.
//

import Foundation
//
import RJPSLib_Networking
//
import DevTools
import AppConstants
import Domain_GalleryApp

/**
* WE CANT HAVE BUSINESS RULES HERE! THE CLIENT JUST DO THE OPERATION AND LEAVE
*/

public extension WebAPI.GalleryApp {

    class NetWorkRepositoryMock: GalleryAppNetWorkRepositoryProtocol {
        public init() { }

        public func imageInfo(_ request: GalleryAppRequests.ImageInfo, completionHandler: @escaping GalleryAppResponseImageInfoCompletionHandler) {
            if let data = AppConstants.Mocks.GalleryApp.imageInfo_200.data(using: .utf8),
                let response = try? RJS_SimpleNetworkClientResponse<GalleryAppResponseDto.ImageInfo>(data: data, httpUrlResponse: nil, responseType: .json) {
                completionHandler(Result.success(response))
            }
        }

        public func search(_ request: GalleryAppRequests.Search, completionHandler: @escaping GalleryAppResponseSearchCompletionHandler) {
            if let data = AppConstants.Mocks.GalleryApp.search_200.data(using: .utf8),
                let response = try? RJS_SimpleNetworkClientResponse<GalleryAppResponseDto.Search>(data: data, httpUrlResponse: nil, responseType: .json) {
                completionHandler(Result.success(response))
            }
        }
    }
}