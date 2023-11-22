//
//  musicplayerApp.swift
//  musicplayer
//
//  Created by Айбек on 09.04.2023.
//

import SwiftUI
import FirebaseCore
import AVFAudio

@main
struct YourApp: App {
    let data = MyData()
    //Register app delegate for Firebase setup
    init() {
        FirebaseApp.configure()
        data.loadAlbums()
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print(error)
        }
    }
    
    
    var body: some Scene {
        WindowGroup {
            ContentView(data: data)
        }
    }
}
