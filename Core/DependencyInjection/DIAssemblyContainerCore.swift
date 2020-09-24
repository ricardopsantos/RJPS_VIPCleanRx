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
import Repositories
import Repositories_WebAPI
import DevTools

//
// MARK: - Protocols
//

public struct DIRootAssemblyContainerProtocols {

    //
    // Managers
    //

    public static let messagesManager = MessagesManagerProtocol.self

    //
    // Generic Repositories
    //

    public static let networkClient           = RJS_SimpleNetworkClientProtocol.self
    public static let hotCacheRepository      = HotCacheRepositoryProtocol.self
    public static let coldKeyValuesRepository = KeyValuesStorageRepositoryProtocol.self
    public static let apiCacheRepository      = APICacheManagerProtocol.self

}

//
// MARK: - Resolvers
//

public class DIRootAssemblyResolver {
    private init() { }
    public static let messagesManager = DIAssemblerCore.assembler.resolver.resolve(DIRootAssemblyContainerProtocols.messagesManager.self)
    public static let hotCacheRepository = DIAssemblerCore.assembler.resolver.resolve(DIRootAssemblyContainerProtocols.hotCacheRepository.self)
    public static let coldKeyValuesRepository = DIAssemblerCore.assembler.resolver.resolve(DIRootAssemblyContainerProtocols.coldKeyValuesRepository.self)
}

//
// MARK: - Assembly Container
//

final class DIAssemblyContainerCore: Assembly {

    func assemble(container: Container) {

        container.autoregister(DIRootAssemblyContainerProtocols.messagesManager,
                               initializer: MessagesManager.init).inObjectScope(.container)

        container.autoregister(DIRootAssemblyContainerProtocols.hotCacheRepository,
                               initializer: RP.HotCacheRepository.init).inObjectScope(.container)

        container.autoregister(DIRootAssemblyContainerProtocols.networkClient,
                               initializer: RJS_SimpleNetworkClient.init).inObjectScope(.container)

        container.autoregister(DIRootAssemblyContainerProtocols.coldKeyValuesRepository,
                               initializer: RP.KeyValuesStorageRepository.init).inObjectScope(.container)

        container.autoregister(DIRootAssemblyContainerProtocols.apiCacheRepository,
                               initializer: RP.APICacheManager.init).inObjectScope(.container)

    }
}
