//
//  GoodToGo
//
//  Created by Ricardo P Santos
//  Copyright ©  Ricardo P Santos. All rights reserved.
//

import Foundation
//
import RJPSLib
//
import Domain
import Domain_Bliss

/**
 * WE CANT HAVE BUSINESS RULES HERE! THE CLIENT JUST DO THE OPERATION AND LEAVE
 */

public extension API.Bliss {

    class NetWorkRepository: BlissNetWorkRepositoryProtocol {

        public init() { }

        public func shareQuestionBy(email: String, url: String, completionHandler: @escaping (Result<RJSLibNetworkClientResponse<Bliss.ShareByEmail>>) -> Void) {
            do {
                let apiRequest: WebAPIRequest_Protocol = try WebAPI.BlissAPIRequest.Share(email: email, url: url)
                let apiClient: RJSLibNetworkClient_Protocol  = RJSLib.NetworkClient()
                apiClient.execute(request: apiRequest, completionHandler: { (result: Result<RJSLibNetworkClientResponse<Bliss.ShareByEmail>>) in
                    completionHandler(result)
                })
            } catch let error {
                completionHandler(Result.failure(error))
            }
        }
        
        public func updateQuestion(question: Bliss.QuestionElementResponseDto,
                                   completionHandler: @escaping (Result<RJSLibNetworkClientResponse<Bliss.QuestionElementResponseDto>>) -> Void) {
            do {
                let apiRequest: WebAPIRequest_Protocol = try WebAPI.BlissAPIRequest.UpdateQuestion(question: question)
                let apiClient: RJSLibNetworkClient_Protocol  = RJSLib.NetworkClient()
                apiClient.execute(request: apiRequest, completionHandler: { (result: Result<RJSLibNetworkClientResponse<Bliss.QuestionElementResponseDto>>) in
                    completionHandler(result)
                })
            } catch let error {
                completionHandler(Result.failure(error))
            }
        }
        
        public func makeQuestion(question: Bliss.QuestionElementResponseDto, completionHandler: @escaping (Result<RJSLibNetworkClientResponse<Bliss.QuestionElementResponseDto>>) -> Void) {
            do {
                let apiRequest: WebAPIRequest_Protocol = try WebAPI.BlissAPIRequest.NewQuestion(question: question)
                let apiClient: RJSLibNetworkClient_Protocol  = RJSLib.NetworkClient()
                apiClient.execute(request: apiRequest, completionHandler: { (result: Result<RJSLibNetworkClientResponse<Bliss.QuestionElementResponseDto>>) in
                    completionHandler(result)
                })
            } catch let error {
                completionHandler(Result.failure(error))
            }
        }
        
        public func getQuestionBy(id: Int, completionHandler: @escaping (Result<RJSLibNetworkClientResponse<Bliss.QuestionElementResponseDto>>) -> Void) {
            do {
                let apiRequest: WebAPIRequest_Protocol = try WebAPI.BlissAPIRequest.QuestionById(id: id)
                let apiClient: RJSLibNetworkClient_Protocol  = RJSLib.NetworkClient()
                apiClient.execute(request: apiRequest, completionHandler: { (result: Result<RJSLibNetworkClientResponse<Bliss.QuestionElementResponseDto>>) in
                    completionHandler(result)
                })
            } catch let error {
                completionHandler(Result.failure(error))
            }
        }
        
        public func getQuestions(limit: Int, filter: String, offSet: Int, completionHandler: @escaping (_ result: Result<RJSLibNetworkClientResponse<[Bliss.QuestionElementResponseDto]>>) -> Void) {
            do {
             
                let apiRequest: WebAPIRequest_Protocol = try WebAPI.BlissAPIRequest.ListQuestions(limit: limit, filter: filter, offSet: offSet)
                let apiClient: RJSLibNetworkClient_Protocol  = RJSLib.NetworkClient()
                apiClient.execute(request: apiRequest, completionHandler: { (result: Result<RJSLibNetworkClientResponse<[Bliss.QuestionElementResponseDto]>>) in
                    completionHandler(result)
                })
            } catch let error {
                completionHandler(Result.failure(error))
            }
        }
        
        public func getHealth(completionHandler: @escaping (Result<RJSLibNetworkClientResponse<Bliss.ServerHealth>>) -> Void) {
            do {
                let apiRequest: WebAPIRequest_Protocol = try WebAPI.BlissAPIRequest.GetHealthStatus()
                let apiClient: RJSLibNetworkClient_Protocol  = RJSLib.NetworkClient()
                apiClient.execute(request: apiRequest, completionHandler: { (result: Result<RJSLibNetworkClientResponse<Bliss.ServerHealth>>) in
                    completionHandler(result)
                })
            } catch let error {
                completionHandler(Result.failure(error))
            }
        }
    }
}
