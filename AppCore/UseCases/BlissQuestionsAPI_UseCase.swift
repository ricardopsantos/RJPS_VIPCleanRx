//
//  GoodToGo
//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import Foundation
import UIKit
//
import RJPSLib
//
import AppDomain

//public extension UseCases {
    
    /**
     * Brain. Where we can have business rules
     */
public class BlissQuestionsAPI_UseCase: GenericUseCase, BlissQuestionsAPI_UseCaseProtocol {

        var repositoryNetwork: Bliss_NetWorkRepositoryProtocol!
        var generic_CacheRepositoryProtocol: Generic_CacheRepositoryProtocol!
        var generic_LocalStorageRepository: Generic_LocalStorageRepositoryProtocol!
        
        private func serverIsOK(completionHandler: @escaping (Bool) -> Void) {
            getHealth { (some) in
                switch some {
                case .success(let some): completionHandler(some.isOK)
                case .failure          : completionHandler(false)
                }
            }
        }
        
    public func getHealth(completionHandler: @escaping (Result<Bliss.ServerHealth>) -> Void) {
         
            guard existsInternetConnection else {
                completionHandler(Result.failure(AppFactory.Errors.with(appCode: .noInternet)))
                return
            }
            
            repositoryNetwork.getHealth { (result) in
                switch result {
                case .success(let some) : completionHandler(Result.success(some.entity))
                case .failure(let error):completionHandler(Result.failure(error))
                }
            }

        }
        
    public func shareQuestionBy(email: String, url: String, checkHealth: Bool, completionHandler: @escaping (Result<Bliss.ShareByEmail>) -> Void) {
            let doWork = { [weak self] in
                guard let self = self else { AppLogger.log(appCode: .referenceLost); return }
                self.repositoryNetwork.shareQuestionBy(email: email, url: url, completionHandler: { (result) in
                    switch result {
                    case .success(let some): completionHandler(Result.success(some.entity))
                    case .failure(let error): completionHandler(Result.failure(error))
                    }
                })
            }
            if !checkHealth {
                guard existsInternetConnection else {
                    completionHandler(Result.failure(AppFactory.Errors.with(appCode: .noInternet)))
                    return
                }
                doWork()
            } else {
                serverIsOK { (ok) in
                    if ok {
                        doWork()
                    } else { completionHandler(Result.failure(AppFactory.Errors.with(appCode: .notPredicted))) }
                }
            }
        }
        
    public func updateQuestion(question: Bliss.QuestionElementResponseDto, checkHealth: Bool, completionHandler: @escaping (Result<Bliss.QuestionElementResponseDto>) -> Void) {
            
            let doWork = { [weak self] in
                guard let self = self else { AppLogger.log(appCode: .referenceLost); return }
                self.repositoryNetwork.updateQuestion(question: question, completionHandler: { (result) in
                    switch result {
                    case .success(let some) : completionHandler(Result.success(some.entity))
                    case .failure(let error): completionHandler(Result.failure(error))
                    }
                })
            }
            if !checkHealth {
                guard existsInternetConnection else {
                    completionHandler(Result.failure(AppFactory.Errors.with(appCode: .noInternet)))
                    return
                }
                doWork()
            } else {
                serverIsOK { (ok) in
                    if ok {
                        doWork()
                    } else { completionHandler(Result.failure(AppFactory.Errors.with(appCode: .notPredicted))) }
                }
            }
        }
        
    public func getQuestions(limit: Int, filter: String, offSet: Int, checkHealth: Bool=true, completionHandler: @escaping (Result<[Bliss.QuestionElementResponseDto]>) -> Void) {
            
            let doWork = { [weak self] in
                guard let self = self else { AppLogger.log(appCode: .referenceLost); return }
                self.repositoryNetwork.getQuestions(limit: limit, filter: filter, offSet: offSet, completionHandler: { (result) in
                    switch result {
                    case .success(let some): completionHandler(Result.success(some.entity))
                    case .failure(let error): completionHandler(Result.failure(error))
                    }
                })
            }
            
            if !checkHealth {
                guard existsInternetConnection else {
                    completionHandler(Result.failure(AppFactory.Errors.with(appCode: .noInternet)))
                    return
                }
                doWork()
            } else {
                serverIsOK { (ok) in
                    if ok {
                        doWork()
                    } else { completionHandler(Result.failure(AppFactory.Errors.with(appCode: .notPredicted))) }
                }
            }
        
        }
        
    public func getQuestionBy(id: Int, checkHealth: Bool=true, completionHandler: @escaping (Result<Bliss.QuestionElementResponseDto>) -> Void) {
            
            let doWork = { [weak self] in
                guard let self = self else { AppLogger.log(appCode: .referenceLost); return }
                self.repositoryNetwork.getQuestionBy(id: id, completionHandler: { (result) in
                    switch result {
                    case .success(let some): completionHandler(Result.success(some.entity))
                    case .failure(let error): completionHandler(Result.failure(error))
                    }
                })
            }
            
            if !checkHealth {
                guard existsInternetConnection else {
                    completionHandler(Result.failure(AppFactory.Errors.with(appCode: .noInternet)))
                    return
                }
                doWork()
            } else {
                serverIsOK { (ok) in
                    if ok {
                        doWork()
                    } else { completionHandler(Result.failure(AppFactory.Errors.with(appCode: .notPredicted))) }
                }
            }
        }
        
    public func makeQuestion(question: Bliss.QuestionElementResponseDto, checkHealth: Bool=true, completionHandler: @escaping (Result<Bliss.QuestionElementResponseDto>) -> Void) {
            
            let doWork = { [weak self] in
                guard let self = self else { AppLogger.log(appCode: .referenceLost); return }
                self.repositoryNetwork.makeQuestion(question: question, completionHandler: { (result) in
                    switch result {
                    case .success(let some): completionHandler(Result.success(some.entity))
                    case .failure(let error): completionHandler(Result.failure(error))
                    }
                })
            }
            if !checkHealth {
                guard existsInternetConnection else {
                    completionHandler(Result.failure(AppFactory.Errors.with(appCode: .noInternet)))
                    return
                }
                doWork()
            } else {
                serverIsOK { (ok) in
                    if ok {
                        doWork()
                    } else { completionHandler(Result.failure(AppFactory.Errors.with(appCode: .notPredicted))) }
                }
            }
        }
    }
//}