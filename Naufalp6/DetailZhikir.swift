////
////  DetailZhikir.swift
////  Naufalp6
////
////  Created by Naufal Adli on 15/06/25.
////
//
//import SwiftUI
//import AVFoundation
//import UIKit
//
//struct DzikirItem: Identifiable {
//    let id = UUID()
//    let judul: String
//    let arab: String
//    let latin: String
//    let arti: String
//    let fileName: String
//    let jumlah: Int
//}
//
//struct ContentView: View {
//    let dzikir = DzikirItem(
//        judul: "Membaca Ta’awudz",
//        arab: "أَعُوذُ بِاللَّهِ مِنَ الشَّيْطَانِ الرَّجِيمِ",
//        latin: "Audzubillahi minasy aitonirojim",
//        arti: "Aku berlindung kepada Allah dari setan yang terkutuk",
//        fileName: "mekkah",
//        jumlah: 3
//    )
//
//    @State private var showLatin = true
//    @State private var showArti = true
//    @State private var fontSize: CGFloat = 24
//    @State private var counter = 0
//    @State private var isPlaying = false
//    @State private var player: AVAudioPlayer?
//
//    let defaultFontSize: CGFloat = 24
//    @State private var isZoomed = false
//
//
//    var body: some View {
//        VStack(alignment: .leading, spacing: 16) {
//
//            // Header
//            HStack {
//                Image(systemName: "chevron.left")
//                Text("Dzikir Pagi")
//                    .font(.headline)
//                Spacer()
//                Text(dzikir.jumlah > 1 ? "\(dzikir.jumlah)x" : "")
//                    .font(.subheadline)
//                    .foregroundColor(.gray)
//            }
//
//            // Subjudul
//            Text(dzikir.judul)
//                .font(.subheadline)
//                .padding(.bottom, 4)
//
//            // Action Bar
//            HStack(spacing: 24) {
//                Button {
//                    togglePlayPause()
//                } label: {
//                    Image(systemName: isPlaying ? "pause.circle" : "play.circle")
//                }
//
//
//                Button {
//                    if isZoomed {
//                        fontSize = defaultFontSize
//                    } else {
//                        fontSize += 4
//                    }
//                    isZoomed.toggle()
//                } label: {
//                    Image(systemName: isZoomed ? "minus.magnifyingglass" : "plus.magnifyingglass")
//                }
//
//
//                Button {
//                    showLatin.toggle()
//                } label: {
//                    Image(systemName: showLatin ? "eye.fill" : "eye.slash")
//                }
//
//                Button {
//                    let fullText = "\(dzikir.arab)\n\(dzikir.latin)\n\(dzikir.arti)"
//                    UIPasteboard.general.string = fullText
//                } label: {
//                    Image(systemName: "doc.on.doc")
//                }
//            }
//            .font(.title3)
//            .padding(.bottom, 2)
//
//            Divider().background(Color.purple)
//
//            // Teks Dzikir
//            VStack(spacing: 8) {
//                Text(dzikir.arab)
//                    .font(.system(size: fontSize))
//                    .multilineTextAlignment(.center)
//
//                if showLatin {
//                    Text(dzikir.latin)
//                        .font(.system(size: fontSize - 2))
//                        .foregroundColor(.gray)
//                        .multilineTextAlignment(.center)
//                }
//
//                if showArti {
//                    Text("“\(dzikir.arti)”")
//                        .font(.system(size: fontSize - 4))
//                        .foregroundColor(.secondary)
//                        .multilineTextAlignment(.center)
//                }
//            }
//            .frame(maxWidth: .infinity)
//
//            // Counter Dzikir (hanya jika jumlah > 1)
//            if dzikir.jumlah > 1 {
//                HStack(spacing: 32) {
//                    Button {
//                        counter = 0
//                    } label: {
//                        Image(systemName: "arrow.clockwise")
//                    }
//
//                    Text("\(counter)")
//                        .font(.title)
//
//                    Button {
//                        if counter < dzikir.jumlah {
//                            counter += 1
//                        }
//                    } label: {
//                        Image(systemName: "plus.circle")
//                    }
//                }
//                .padding(.top)
//                .frame(maxWidth: .infinity)
//            }
//
//            Spacer()
//        }
//        .padding()
//    }
//    func togglePlayPause() {
//        if let player = player {
//            if player.isPlaying {
//                player.pause()
//                isPlaying = false
//            } else {
//                player.play()
//                isPlaying = true
//            }
//        } else {
//            startAudio()
//        }
//    }
//
//    func startAudio() {
//        guard let url = Bundle.main.url(forResource: dzikir.fileName, withExtension: "mp3") else {
//            print("Audio not found.")
//            return
//        }
//
//        do {
//            player = try AVAudioPlayer(contentsOf: url)
//            player?.play()
//            isPlaying = true
//        } catch {
//            print("Failed to play audio: \(error.localizedDescription)")
//        }
//    }
//
//    
//    func playAudio() {
//        guard let url = Bundle.main.url(forResource: dzikir.fileName, withExtension: "mp3") else {
//            print("Audio not found.")
//            return
//        }
//
//        do {
//            player = try AVAudioPlayer(contentsOf: url)
//            player?.play()
//            isPlaying = true
//        } catch {
//            print("Failed to play audio: \(error.localizedDescription)")
//        }
//    }
//}
