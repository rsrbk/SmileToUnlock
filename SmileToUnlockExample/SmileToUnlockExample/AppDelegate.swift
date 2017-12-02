//
//  AppDelegate.swift
//  SmileToUnlockExample
//
//  Created by Ruslan Serebriakov on 12/2/17.
//  Copyright © 2017 Ruslan Serebriakov. All rights reserved.
//

import UIKit
import SmileToUnlock

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        if SmileToUnlock.isSupported {
            let vc = SmileToUnlock()
            vc.onSuccess = {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateInitialViewController()!
                self.window?.rootViewController = vc
            }
            window?.rootViewController = vc
        }
        return true
    }
}

