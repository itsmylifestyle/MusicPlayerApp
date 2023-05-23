//
//  musicplayerApp.swift
//  musicplayer
//
//  Created by Айбек on 09.04.2023.
//

import SwiftUI
import FirebaseCore

@main
struct YourApp: App {
    let data = MyData()
    //Register app delegate for Firebase setup
    init() {
        FirebaseApp.configure()
        data.loadAlbums()
    }
    
    
    var body: some Scene {
        WindowGroup {
            ContentView(data: data)
        }
    }
}
