//
//  GoodToGo
//
//  Created by Ricardo P Santos
//  Copyright ©  Ricardo P Santos. All rights reserved.
//

import Foundation
//
import RJPSLib_Storage
//
import Domain

public extension RP {
    class KeyValuesStorageRepository: KeyValuesStorageRepositoryProtocol {

        public init () {}

        @discardableResult public func save(key: String, value: String, expireDate: Date?) -> Bool {
            return RJS_DataModel.StorableKeyValue.save(key: key, value: value, expireDate: expireDate)
        }

        public func existsWith(key: String) -> Bool {
            return RJS_DataModel.StorableKeyValue.existsWith(key: key)
        }

        public func with(prefix: String) -> RJS_DataModel? {
            return RJS_DataModel.StorableKeyValue.with(keyPrefix: prefix)
        }

        public func with(key: String) -> RJS_DataModel? {
            return RJS_DataModel.StorableKeyValue.with(key: key)
        }

        public func allKeys() -> [String] {
            return RJS_DataModel.StorableKeyValue.allKeys()
        }

        public func allRecords() -> [RJS_DataModel] {
            return RJS_DataModel.StorableKeyValue.allRecords()
        }

        @discardableResult public func deleteAll() -> Bool {
            return RJS_DataModel.StorableKeyValue.clean()
        }

        @discardableResult public func deleteWith(key: String) -> Bool {
            return RJS_DataModel.StorableKeyValue.deleteWith(key: key)
        }
    }
}
