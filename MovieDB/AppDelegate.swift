//
//  AppDelegate.swift
//  MovieDB
//
//  Created by Amit Samant on 30/10/21.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        if #available(iOS 13, *) {
            // do only pure app launch stuff, not interface stuff
        } else {
            self.window = UIWindow()
            let tabController = UITabBarController()
            let popularVM = MovieListViewModel(type: .popular)
            let popularVC = MovieListVC(viewModel: popularVM)
            let popularNav = UINavigationController(rootViewController: popularVC)
            let trendingVM = MovieListViewModel(type: .trending)
            let trendingVC = MovieListVC(viewModel: trendingVM)
            let trendingNav = UINavigationController(rootViewController: trendingVC)
            tabController.viewControllers = [
                popularNav,
                trendingNav
            ]
            window?.rootViewController = tabController
            window?.makeKeyAndVisible()
        }
        return true
    }

}

@available(iOS 13.0, *)
extension AppDelegate {
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}


