//
//  AppResources.swift
//  AppResources
//
//  Created by Ricardo Santos on 09/05/2020.
//  Copyright © 2020 Ricardo P Santos. All rights reserved.
//

import Foundation

public struct AppResources {
    private init() {}

    static var propertiesList: NSDictionary? {
        var nsDictionary: NSDictionary?
        if let path = Bundle.main.path(forResource: "AppResources.PropertiesList", ofType: "plist") {
           nsDictionary = NSDictionary(contentsOfFile: path)
        }
        return nsDictionary
    }
}
