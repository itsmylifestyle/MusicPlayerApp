import SwiftUI
import Firebase
import AVFoundation
import Combine

struct PlayerView: View {
    @State var album : Album
    @State var song : Song
    
    @State private var player = AVPlayer()
    
    @State var isPlaying: Bool = true
    
    @State private var playerDidFinishPlayingCancellable: AnyCancellable?
    
    var body: some View {
        ZStack {
            Image(album.image).resizable().edgesIgnoringSafeArea(.all)
            Blur(style: .dark).edgesIgnoringSafeArea(.all)
            VStack {
                Spacer()
                AlbumArt(album: album, isWithText: false, isSelected: false).frame(width: 300, height: 300).scaleEffect(1.5)
                Text(song.name).font(.title).fontWeight(.heavy).foregroundColor(.white)
                Spacer()
                ZStack {
                    Color.white.cornerRadius(20).shadow(radius: 10)
                    HStack {
                        
                        Button(action: {
                            self.previous()
                        }) {
                            Image(systemName: "arrow.left.circle").resizable()
                        }.frame(width: 45, height: 45, alignment: .center).foregroundColor(Color.black.opacity(0.2))
                        
                        Button(action: {
                            self.playPause()
                        }) {
                            Image(systemName: isPlaying ? "pause.circle.fill" : "play.circle.fill").resizable()
                        }.frame(width: 65, height: 65, alignment: .center).padding()
                        
                        Button(action: {
                            self.next()
                        }) {
                            Image(systemName: "arrow.right.circle").resizable()
                        }.frame(width: 45, height: 45, alignment: .center).foregroundColor(Color.black.opacity(0.2))
                    }
                }.edgesIgnoringSafeArea(.bottom).frame(height: 200, alignment: .center)
            }
        }.onAppear() {
            self.playSong()
        }
        .onDisappear {
            self.stopPlayer()
        }

    }
    
    func playSong() {
        let storage = Storage.storage().reference(forURL: self.song.path)
        storage.downloadURL{ (url, error) in
            if error != nil {
                print(error)
            } else {
                do {
                    try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)//for a ringer
                } catch {
                    
                }
                
                
                
                player = AVPlayer(playerItem: AVPlayerItem(url: url!))
                player.play()
                
                // Add observer for autoplay using Combine
                playerDidFinishPlayingCancellable = NotificationCenter.default.publisher(for: .AVPlayerItemDidPlayToEndTime, object: nil)
                    .sink { _ in
                        self.next()
                    }
            }
        }
    }
    
    func playPause() {
        self.isPlaying.toggle()
        if isPlaying == false {
            player.pause()
        } else {
            player.play()
        }
    }
    
    func next() {
        if let currentIndex = album.songs.firstIndex(of: song) {
            if currentIndex == album.songs.count - 1 {
                player.pause()
                song = album.songs.first! // Play the first song in the album
                self.playSong()
            } else {
                player.pause()
                song = album.songs[currentIndex + 1]
                self.playSong()
            }
        }
    }
    
    func stopPlayer() {
            player.pause()
            player.replaceCurrentItem(with: nil)
            playerDidFinishPlayingCancellable?.cancel()
    }
    
    
    func previous() {
        if let currentIndex = album.songs.firstIndex(of: song) {
            if currentIndex == 0 {
                
            } else {
                player.pause()
                song = album.songs[currentIndex - 1]
                self.playSong()
            }
        }
    }
}
