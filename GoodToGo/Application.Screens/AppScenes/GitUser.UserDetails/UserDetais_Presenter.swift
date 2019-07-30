//
//  GoodToGo
//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import UIKit
import RJPSLib
import RxSwift
import RxCocoa

/**
 * 1 - Declare : Presenter_Protocol & View_Protocol
 */

protocol UserDetais_PresenterProtocol : class {
    var generic     : GenericPresenter_Protocol? { get }   // Mandatory in ALL Presenters
    var genericView : GenericView? { get }                 // Mandatory in ALL Presenters
    var viewModel   : VM.UserDetais? { get set }           // Mandatory in ALL Presenters
    var router      : UserDetais_RouterProtocol! { get }   // Mandatory in ALL Presenters
    var tableView   : GenericTableView_Protocol! { get }
    
    var rxPublishRelay_dismissView: PublishRelay<Void> { get }     // PublishRelay model Events

}

protocol UserDetais_ViewProtocol : class {
    func viewDataToScreen(some:VM.UserDetais)
    func setAvatarWith(image:UIImage)
}

/**
 * 2 - Declare : Presenter
 */

extension Presenter {
    class UserDetais_Presenter : GenericPresenter {
        var generic     : GenericPresenter_Protocol?
        var genericView : GenericView?
        var viewModel   : VM.UserDetais? { didSet { AppLogs.DLog(appCode: .vmChanged); viewModelChanged() } }
        weak var view   : UserDetais_ViewProtocol!
        var router      : UserDetais_RouterProtocol!
        var tableView   : GenericTableView_Protocol!
    }
}

/**
 * 3 - Implementation : Presenter Protocol
 */

extension P.UserDetais_Presenter : UserDetais_PresenterProtocol {
    
    // PublishRelay model Events
    var rxPublishRelay_dismissView: PublishRelay<Void> {
        let relay = PublishRelay<Void>()
        relay.bind(to: (router as! GenericRouter).rxPublishRelay_dismissView).disposed(by: disposeBag)
        return relay
    }
}

extension P.UserDetais_Presenter : GenericTableView_Protocol {
    func numberOfRows(_ section:Int) -> Int {
        return viewModel?.friends.count ?? 0
    }
    
    func configure(cell: GenericTableViewCell_Protocol, indexPath: IndexPath) -> Void {
        let user = viewModel!.friends[indexPath.row]
        cell.set(title:user.name ?? "unknown")
        downloadImage(imageURL: user.avatarUrl!, onFail: AppImages.notFound) { (image) -> (Void) in
            cell.set(image: image)
        }
    }
}

/**
 * 4 - Implementation : GenericPresenter_Protocol Protocol
 */

extension P.UserDetais_Presenter : GenericPresenter_Protocol {
    func view_deinit()    -> Void { }
    func loadView()       -> Void { setupPresenter() }
    func viewDidAppear()  -> Void { }
    func viewDidLoad()    -> Void { }
    func viewWillAppear() -> Void { if viewModel != nil { updateViewWith(vm: viewModel) } }
    
    func setupPresenter() -> Void { }

}

/**
 * 5 - Presenter Private Stuff
 */

extension P.UserDetais_Presenter {
    
    private func updateViewWith(vm:VM.UserDetais?) -> Void {
        guard vm != nil else { AppLogs.DLog(appCode: .ignored); return }
        view.viewDataToScreen(some: vm!)
        downloadImage(imageURL: vm!.user.avatarUrl!, onFail: AppImages.notFound) { [weak self] (image) -> (Void) in
            self?.view.setAvatarWith(image: image!)
        }
    }
    
    private func viewModelChanged() -> Void {
        updateViewWith(vm: viewModel)
    }
}
