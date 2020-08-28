//
//  GoodToGo
//
//  Created by Ricardo P Santos
//  Copyright ©  Ricardo P Santos. All rights reserved.
//

import Foundation
import Swinject
import SwinjectAutoregistration

final class ApplicationAssembly {
    
    class var assembler: Assembler {
        let assemblyList: [Assembly] = [
            RootAssemblyContainer()
//            AS.MVPSampleView_AssemblyContainer(),
//            AS.MVPSampleRxView_AssemblyContainer()
        ]
        return Assembler(assemblyList)
    }
}
