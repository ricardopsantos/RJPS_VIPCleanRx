//
//  GoodToGo
//
//  Created by Ricardo P Santos
//  Copyright ©  Ricardo P Santos. All rights reserved.
//

import UIKit
//
import Swinject
//
import Domain
import DevTools

extension VC {

    class TabBarController: UITabBarController {

        //let container: Container = { return ApplicationAssembly.assembler.resolver as! Container }()
        override func loadView() {
            super.loadView()
        }
        override func viewDidLoad() {
            super.viewDidLoad()

            //let mvpSample1 = createControllers(tabName: "MVP", vc: AppDelegate.shared.container.resolve(V.MVPSampleView_View.self)!)
            //let mvpSample2 = createControllers(tabName: "MVP.Rx", vc: AppDelegate.shared.container.resolve(V.MVPSampleRxView_View.self)!)
            //let mvpSample3 = createControllers(tabName: "MVP.Rx.Table", vc: AppDelegate.shared.container.resolve(V.MVPSampleTableView_View.self)!)

            // EXAMS
            let mvpGitUser   = createControllers(tabName: "MVP.GitUser", vc: AppDelegate.shared.container.resolve(V.SearchUser_View.self)!)
            let vipCarTrack  = createControllers(tabName: "VIP.CarTrack", vc: VC.CarTrackLoginViewController(presentationStyle: .modal))
            let vipVisionBox = createControllers(tabName: "VIP.VisionBox", vc: VC.CategoriesPickerViewController(presentationStyle: .modal))

            // TESTING / DEBUG/ TEMPLATES
            let vcRx = createControllers(tabName: "Rx.Testing", vc: RxTesting())
            let vipTemplate = createControllers(tabName: "VIP.Template", vc: VC.___VARIABLE_sceneName___ViewController(presentationStyle: .modal))
            let vipDebug    = createControllers(tabName: "Debug", vc: VC.DebugViewController(presentationStyle: .modal))

            var viewControllersList: [UIViewController] = []
            if DevTools.FeatureFlag.showScene_visionBox.isTrue { viewControllersList.append(vipVisionBox) }
            if DevTools.FeatureFlag.showScene_carTrack.isTrue { viewControllersList.append(vipCarTrack) }
            if DevTools.FeatureFlag.showScene_gitHub.isTrue { viewControllersList.append(mvpGitUser) }
            if DevTools.FeatureFlag.showScene_vipTemplate.isTrue { viewControllersList.append(vipTemplate) }
            if DevTools.FeatureFlag.showScene_rxTests.isTrue { viewControllersList.append(vcRx) }

            viewControllers = [vipDebug] + viewControllersList
            
        }

        private func createControllers(tabName: String, vc: UIViewController) -> UINavigationController {
            let tabVC = UINavigationController(rootViewController: vc)
            tabVC.setNavigationBarHidden(true, animated: false)
            if #available(iOS 13.0, *) {
                tabVC.tabBarItem.image = UIImage(systemName: "heart")
            } else {
                DevTools.Log.error("\(DevTools.Strings.not_iOS13) : Cant set tabBarItem")
            }
            tabVC.tabBarItem.title = tabName
            return tabVC
        }
    }
}
