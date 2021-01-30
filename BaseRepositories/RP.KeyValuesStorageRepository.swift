//
//  GoodToGo
//
//  Created by Ricardo P Santos
//  Copyright ©  Ricardo P Santos. All rights reserved.
//

import Foundation
//
import RJSLibUFStorage
//
import BaseDomain

//
// READ
//
// Dependency resolved @ `DIRootAssemblyResolver.coldKeyValuesRepository.xxx`
//
// `RJS_DataModel` is implemented @ RJPSLib_Storage and provides a way to store a value (String) but can with a limited period of
// time in which that value can be retrieved back. Useful for caching and store temporary data
//

public extension RP {
    class KeyValuesStorageRepository: KeyValuesStorageRepositoryProtocol {

        public init () {}

        @discardableResult public func save(key: String, value: String, expireDate: Date?) -> Bool {
            return RJS_DataModelEntity.StorableKeyValue.save(key: key, value: value, expireDate: expireDate)
        }

        public func existsWith(key: String) -> Bool {
            return RJS_DataModelEntity.StorableKeyValue.existsWith(key: key)
        }

        public func with(prefix: String) -> RJS_DataModelEntity? {
            return RJS_DataModelEntity.StorableKeyValue.with(keyPrefix: prefix)
        }

        public func with(key: String) -> RJS_DataModelEntity? {
            return RJS_DataModelEntity.StorableKeyValue.with(key: key)
        }

        public func allKeys() -> [String] {
            return RJS_DataModelEntity.StorableKeyValue.allKeys()
        }

        public func allRecords() -> [RJS_DataModelEntity] {
            return RJS_DataModelEntity.StorableKeyValue.allRecords()
        }

        @discardableResult public func deleteAll() -> Bool {
            return RJS_DataModelEntity.StorableKeyValue.clean()
        }

        @discardableResult public func deleteWith(key: String) -> Bool {
            return RJS_DataModelEntity.StorableKeyValue.deleteWith(key: key)
        }
    }
}
