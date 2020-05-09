//
//  SampleVIP_Interactor.swift
//  GoodToGo
//
//  Created by Ricardo Santos on 10/10/2019.
//  Copyright (c) 2019 Ricardo P Santos. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol SampleVIP_BusinessLogic {
  func doSomething(request: SampleVIP.SearchView.Request)
}

protocol SampleVIP_DataStore {
  //var name: String { get set }
}

class SampleVIP_Interactor: SampleVIP_BusinessLogic, SampleVIP_DataStore {
  var presenter: SampleVIP_PresentationLogic?
  var worker: SampleVIP_Worker?
  //var name: String = ""
  
  // MARK: Do something
  
  func doSomething(request: SampleVIP.SearchView.Request) {
    worker = SampleVIP_Worker()
    worker?.doSomeWork()
    
    let response = SampleVIP.SearchView.Response()
    presenter?.presentSomething(response: response)
  }
}
