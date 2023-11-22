//
//  ContentView.swift
//  Anima
//
//  Created by Айбек on 08.04.2023.
//

import SwiftUI
import Firebase
import AVFoundation

struct Album : Hashable {
    var id = UUID()
    var name: String
    var image: String
    var songs : [Song]
}

struct Song : Hashable {
    var id = UUID()
    var name: String
    var time: String
    var path: String
}

struct ContentView: View {
    @ObservedObject var data: MyData
    @State private var currentAlbum: Album?
    
    private let audioPlayer = BackgroundAudioPlayer()
    
    var body: some View {
        NavigationView {
            ScrollView {
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack {
                        ForEach(data.albums, id: \.self) { album in
                            AlbumArt(album: album, isWithText: true, isSelected: album == currentAlbum)
                                .onTapGesture {
                                    withAnimation(.spring()) {
                                        self.currentAlbum = album
                                    }
                                }
                        }
                    }
                }
                
                LazyVStack {
                    if let album = currentAlbum ?? data.albums.first {
                        ForEach(album.songs, id: \.self) { song in
                            SongCell(album: album, song: song)
                        }
                    } else {
                        EmptyView()
                    }
                }
            }
            .navigationTitle("Igizbayev's music")
            .font(.subheadline)
        }
        .onAppear {
            audioPlayer.startBackgroundPlayback()
        }
        .onDisappear {
            audioPlayer.stopBackgroundPlayback()
        }
    }
}

class BackgroundAudioPlayer {
    private var player: AVPlayer?
    private var playerItem: AVPlayerItem?
    private var playbackTimeObserver: Any?
    
    func startBackgroundPlayback() {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playback, mode: .default, options: [])
            try audioSession.setActive(true)
        } catch {
            print("Failed to set audio session category.")
        }
        
        // Create a player item or use your existing implementation
        // Example:
        // let url = URL(string: "your_audio_file_url")
        // playerItem = AVPlayerItem(url: url)
        
        player = AVPlayer(playerItem: playerItem)
        player?.play()
        
        // Add observer for playback time updates
        playbackTimeObserver = player?.addPeriodicTimeObserver(forInterval: CMTime(seconds: 1, preferredTimescale: 1), queue: nil) { [weak self] time in
            // Update your UI or perform other tasks based on playback time
        }
    }
    
    func stopBackgroundPlayback() {
        player?.pause()
        player?.replaceCurrentItem(with: nil)
        player = nil
        
        if let observer = playbackTimeObserver {
            player?.removeTimeObserver(observer)
            playbackTimeObserver = nil
        }
        
        do {
            try AVAudioSession.sharedInstance().setActive(false)
        } catch {
            print("Failed to deactivate audio session.")
        }
    }
}

struct AlbumArt: View {
    var album: Album
    var isWithText: Bool
    var isSelected: Bool
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Image(album.image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 170, height: 200)
            
            if isWithText {
                ZStack {
                    Blur(style: .dark)
                    Text(album.name)
                        .foregroundColor(.white)
                }
                .frame(height: 40)
            }
        }
        .frame(width: 170, height: 200)
        .clipped()
        .cornerRadius(20)
        .shadow(radius: 5)
        .padding()
        .scaleEffect(isSelected ? 1.1 : 1.0)
        .shadow(radius: isSelected ? 5 : 0)
        .shadow(color: .white, radius: 4)
    }
}

struct SongCell : View {
    var album: Album
    var song : Song
    var body : some View {
        
        NavigationLink(
            destination: PlayerView(album: album, song: song),
            label: {
                HStack {
                    ZStack {
                        Circle().frame(width: 35, height: 35, alignment: .center).foregroundColor(.red)
                        Circle().frame(width: 15, height: 15, alignment: .center).foregroundColor(.white)
                    }
                    Text(song.name).bold()
                    Spacer()
                    Text(song.time)
                }.padding(20)
            }).buttonStyle(PlainButtonStyle())
    }
}

//some backend working
