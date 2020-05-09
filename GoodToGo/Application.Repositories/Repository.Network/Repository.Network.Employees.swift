//
//  GoodToGo
//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import Foundation
import RJPSLib
import AppDomain

/**
 * WE CANT HAVE BUSINESS RULES HERE! THE CLIENT JUST DO THE OPERATION AND LEAVE
 */

extension RP.Network {
    struct Employees {
        private init() {}
    }
}

extension RP.Network.Employees {
    class NetworkRepository: Samples_NetWorkRepositoryProtocol {
        func netWork_OperationA(completionHandler: @escaping Samples_NetWorkRepositoryCompletionHandler) {
            do {
                let apiRequest: WebAPIRequest_Protocol = try RP.Network.Employees.GetEmployees_APIRequest()
                let apiClient: NetworkClient_Protocol = RJSLib.NetworkClient()
                apiClient.execute(request: apiRequest, completionHandler: { (result: Result<NetworkClientResponse<[Employee.ResponseDto]>>) in
                    completionHandler(result)
                })
            } catch let error {
                completionHandler(Result.failure(error))
            }
        }
        
        func netWork_OperationB(completionHandler: @escaping Samples_NetWorkRepositoryCompletionHandler) {
            AppLogger.log(appCode: .notImplemented)
            completionHandler(Result.failure(AppFactory.Errors.with(appCode: .notImplemented)))
        }
        
    }
}
