//
//  GoodToGo
//
//  Created by Ricardo Santos
//  Copyright © 2020 Ricardo P Santos. All rights reserved.
//

import Foundation
import UIKit
//
import RxSwift
import RxCocoa
import RJSLibUFNetworking
import RJSLibUFStorage
//
import AppConstants
import PointFreeFunctions
import Domain
import DomainCarTrack
import Factory
import Core
import AppResources
import Repositories

public class CarTrackAPIUseCase: GenericUseCase, CarTrackWebAPIUseCaseProtocol {

    public override init() { super.init() }

    public var networkRepository: CarTrackNetWorkRepositoryProtocol!
    public var hotCacheRepository: HotCacheRepositoryProtocol!
    public var coldKeyValuesRepository: KeyValuesStorageRepositoryProtocol!
    public var apiCache: APICacheManagerProtocol!

    private static var cacheTTL = 60 * 24 // 24h cache

    // Will
    // - Manage the requests queue
    // - Call the API
    // - Manage the Cache
    // (Converting Dto entities to Model entities will be done above on the worker)

    public func getUsers(request: CarTrackRequests.GetUsers, cacheStrategy: CacheStrategy) -> Observable<[CarTrackResponseDto.User]> {
        let cacheKey = "\(#function).\(request)"
        var block: Observable<[CarTrackResponseDto.User]> {
            var apiObserver: Observable<[CarTrackResponseDto.User]> {
                return Observable<[CarTrackResponseDto.User]>.create { observer in
                    self.networkRepository.getUsers(request) { [weak self] (result) in
                        switch result {
                        case .success(let some) :
                            observer.on(.next(some.entity))
                            self?.apiCache.save(some.entity, key: cacheKey, params: [], lifeSpam: Self.cacheTTL)
                        case .failure(let error):
                            observer.on(.error(error))
                        }
                        observer.on(.completed)
                    }
                    return Disposables.create()
                }.catchError { (_) -> Observable<[CarTrackResponseDto.User]> in
                    // Sometimes the API fail. Return empty object to terminate the operation
                    Observable.just([CarTrackResponseDto.User()])
                }
            }

            // Cache
            let cacheObserver = apiCache.genericCacheObserver([CarTrackResponseDto.User].self,
                                                              cacheKey: cacheKey,
                                                              keyParams: [],
                                                              apiObserver: apiObserver.asSingleSafe())

            // Handle by cache strategy

            switch cacheStrategy {
            case .noCacheLoad: return apiObserver.asObservable()
            case .cacheElseLoad: return cacheObserver.asObservable()
            case .cacheAndLoad: return Observable.merge(cacheObserver, apiObserver.asObservable() )
            case .cacheNoLoad: fatalError("Not safe!")
            }
        }

        return Observable<[CarTrackResponseDto.User]>.create { observer in
            let operation = APIRequestOperation(blockList: block)
            OperationQueueManager.shared.add(operation)
            operation.completionBlock = {
                if operation.isCancelled || operation.noResultAvailable {
                    observer.on(.error(Factory.Errors.with(appCode: .notPredicted)))
                } else {
                    observer.on(.next(operation.resultList!))
                }
                observer.on(.completed)
            }
            return Disposables.create()
        }
    }
}