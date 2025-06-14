//
//  Naufalp6App.swift
//  Naufalp6
//
//  Created by Naufal Adli on 31/05/25.
//
import SwiftUI
import GoogleMobileAds

@main
struct Naufalp6App: App {
    init() {
        MobileAds.shared.start(completionHandler: { _ in })
    }

    var body: some Scene {
        WindowGroup {
            AdzanPlayerView()
        }
    }
}


func application(_ application: UIApplication,
                 didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    MobileAds.shared.start(completionHandler: { _ in })
    return true
}

