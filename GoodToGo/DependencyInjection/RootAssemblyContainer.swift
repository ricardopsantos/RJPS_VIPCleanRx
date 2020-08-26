//
//  GoodToGo
//
//  Created by Ricardo P Santos
//  Copyright ©  Ricardo P Santos. All rights reserved.
//

import Swinject
import RJPSLib_Networking
//
import Domain
import Domain_CarTrack
import Domain_GitHub
import Domain_GalleryApp
import Repositories
import Repositories_WebAPI
import Core
import Core_CarTrack
import Core_GitHub
import Core_GalleryApp

public typealias AS = AssembyContainer
public struct AssembyContainer { private init() {} }

//
// MARK: - Protocols
//

struct RootAssemblyContainerProtocols {

    //
    // Repositories
    //
    static let networkClient                      = RJS_SimpleNetworkClientProtocol.self
    static let generic_CacheRepository            = SimpleCacheRepositoryProtocol.self
    static let generic_LocalStorageRepository     = KeyValuesStorageRepositoryProtocol.self
    static let gitUser_NetWorkRepository          = GitUser_NetWorkRepositoryProtocol.self    // Web API: Requests Protocol
    static let carTrack_NetWorkRepository         = CarTrack_NetWorkRepositoryProtocol.self   // Web API: Requests Protocol
    static let galleryApp_NetWorkRepository       = GalleryAppNetWorkRepositoryProtocol.self  // Web API: Requests Protocol

    //
    // Use Cases
    //

    static let someProtocolXXXX_UseCase           = SomeProtocolXXXX_UseCaseProtocol.self

    // Sample
    static let sample_UseCase                     = Sample_UseCaseProtocol.self
    static let sampleB_UseCase                    = SampleB_UseCaseProtocol.self
    static let gitUser_UseCase                    = GitHubAPIRelated_UseCaseProtocol.self
    
    // CarTrack
    static let carTrackGenericAppBusiness_UseCase = CarTrackGenericAppBusiness_UseCaseProtocol.self
    static let carTrackAPI_UseCase                = CarTrackAPIRelated_UseCaseProtocol.self

    // GalleryApp
    static let galleryAppGenericAppBusiness_UseCase = GalleryAppGenericBusinessUseCaseProtocol.self
    static let galleryAppAPI_UseCase                = GalleryAppAPIRelatedUseCaseProtocol.self
    static let galleryApp_Worker                    = GalleryAppWorkerProtocol.self

}

//
// MARK: - Resolvers
//

public class CarTrackResolver {
    private init() { }
    public static var shared   = CarTrackResolver()
    public let api             = AppDelegate.shared.container.resolve(AppProtocols.carTrackAPI_UseCase.self)
    public let genericBusiness = AppDelegate.shared.container.resolve(AppProtocols.carTrackGenericAppBusiness_UseCase.self)
}

public class GalleryAppResolver {
    private init() { }
    public static var shared   = GalleryAppResolver()
    public let api             = AppDelegate.shared.container.resolve(AppProtocols.galleryAppAPI_UseCase.self)
    public let genericBusiness = AppDelegate.shared.container.resolve(AppProtocols.galleryAppGenericAppBusiness_UseCase.self)
    public let worker          = AppDelegate.shared.container.resolve(AppProtocols.galleryApp_Worker.self)
}

//
// MARK: - RootAssemblyContainer
//

final class RootAssemblyContainer: Assembly {

    func assemble(container: Container) {

        //
        // Base app repositories
        //
        
        container.autoregister(AppProtocols.generic_CacheRepository,
                               initializer: RP.SimpleCacheRepository.init).inObjectScope(.container)
        
        container.autoregister(AppProtocols.networkClient,
                               initializer: RJS_SimpleNetworkClient.init).inObjectScope(.container)
        
        container.autoregister(AppProtocols.generic_LocalStorageRepository,
                               initializer: RP.KeyValuesStorageRepository.init).inObjectScope(.container)

        //
        // GalleryApp
        //

        container.autoregister(AppProtocols.galleryApp_NetWorkRepository,
                               initializer: API.GalleryApp.NetWorkRepository.init).inObjectScope(.container)

        // use case
        container.register(AppProtocols.galleryAppGenericAppBusiness_UseCase) { resolver in
            let uc = GalleryAppMicBusinessUseCase()
            uc.generic_LocalStorageRepository  = resolver.resolve(AppProtocols.generic_LocalStorageRepository)
            uc.generic_CacheRepositoryProtocol = resolver.resolve(AppProtocols.generic_CacheRepository)
            return uc
        }

        // use case
        container.register(AppProtocols.galleryAppAPI_UseCase) { resolver in
            let uc = GalleryAppAPIRelatedUseCase()
            uc.repositoryNetwork               = resolver.resolve(AppProtocols.galleryApp_NetWorkRepository)
            uc.generic_LocalStorageRepository  = resolver.resolve(AppProtocols.generic_LocalStorageRepository)
            uc.generic_CacheRepositoryProtocol = resolver.resolve(AppProtocols.generic_CacheRepository)
            return uc
        }

        // worker
        container.register(AppProtocols.galleryApp_Worker) { resolver in
            let w = GalleryAppWorker()
            w.api             = resolver.resolve(AppProtocols.galleryAppAPI_UseCase)
            w.genericUseCase  = resolver.resolve(AppProtocols.galleryAppGenericAppBusiness_UseCase)
            return w
        }

        //
        // CarTrack
        //

        container.autoregister(AppProtocols.carTrack_NetWorkRepository,
                               initializer: API.CarTrack.NetWorkRepository.init).inObjectScope(.container)

        container.register(AppProtocols.carTrackAPI_UseCase) { resolver in
            let uc = CarTrackAPI_UseCase()
            uc.repositoryNetwork               = resolver.resolve(AppProtocols.carTrack_NetWorkRepository)
            uc.generic_LocalStorageRepository  = resolver.resolve(AppProtocols.generic_LocalStorageRepository)
            uc.generic_CacheRepositoryProtocol = resolver.resolve(AppProtocols.generic_CacheRepository)
            return uc
        }

        container.register(AppProtocols.carTrackGenericAppBusiness_UseCase) { resolver in
            let uc = Core_CarTrack.CarTrackGenericAppBusinessUseCase()
            uc.generic_LocalStorageRepository  = resolver.resolve(AppProtocols.generic_LocalStorageRepository)
            uc.generic_CacheRepositoryProtocol = resolver.resolve(AppProtocols.generic_CacheRepository)
            return uc
        }

        //
        // Sample (min)
        //

        container.register(AppProtocols.someProtocolXXXX_UseCase) { resolver in
            let uc = SomeProtocolXXXX_UseCase()
            uc.generic_LocalStorageRepository  = resolver.resolve(AppProtocols.generic_LocalStorageRepository)
            uc.generic_CacheRepositoryProtocol = resolver.resolve(AppProtocols.generic_CacheRepository)
            return uc
        }

        container.register(AppProtocols.sample_UseCase) { resolver in
            let uc = Sample_UseCase()
            uc.generic_LocalStorageRepository  = resolver.resolve(AppProtocols.generic_LocalStorageRepository)
            uc.generic_CacheRepositoryProtocol = resolver.resolve(AppProtocols.generic_CacheRepository)
            return uc
        }

        container.register(AppProtocols.sampleB_UseCase) { resolver in
            let uc = SampleB_UseCase()
            uc.generic_LocalStorageRepository  = resolver.resolve(AppProtocols.generic_LocalStorageRepository)
            uc.generic_CacheRepositoryProtocol = resolver.resolve(AppProtocols.generic_CacheRepository)
            return uc
        }

        //
        // GitHub
        //

        container.autoregister(AppProtocols.gitUser_NetWorkRepository,
                               initializer: API.GitHub.NetWorkRepository.init).inObjectScope(.container)

        container.register(AppProtocols.gitUser_UseCase) { resolver in
            let uc = GitUser_UseCase()
            uc.generic_CacheRepositoryProtocol = resolver.resolve(AppProtocols.generic_CacheRepository)
            uc.repositoryNetwork               = resolver.resolve(AppProtocols.gitUser_NetWorkRepository)
            return uc
        }

    }
}
