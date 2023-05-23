//
//  ContentView.swift
//  Anima
//
//  Created by Айбек on 08.04.2023.
//

import SwiftUI
import Firebase

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
