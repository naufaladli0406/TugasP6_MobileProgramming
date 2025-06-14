import SwiftUI
import AVFoundation
import GoogleMobileAds

struct Adzan: Identifiable {
    let id = UUID()
    let name: String
    let location: String
    let fileName: String
}

extension Array {
    subscript(safe index: Int) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}

class AdzanPlayerViewModel: ObservableObject {
    @Published var currentAdzan: Adzan?
    @Published var isPlaying = false
    @Published var currentLineIndex = 0

    private var player: AVAudioPlayer?
    private var timer: Timer?

    // Sinkronisasi teks
    let arabLines = [
        "اللّهُ أَكْبَرُ ٱللَّهُ أَكْبَرُ",
        "اللّهُ أَكْبَرُ ٱللَّهُ أَكْبَرُ",
        "أَشْهَدُ أَنْ لَا إِلٰهَ إِلَّا ٱللَّهُ",
        "أَشْهَدُ أَنَّ مُحَمَّدًا رَسُولُ ٱللَّهِ",
        "حَيَّ عَلَى ٱلصَّلَاةِ",
        "حَيَّ عَلَى ٱلْفَلَاحِ",
        "اللّهُ أَكْبَرُ",
        "لَا إِلٰهَ إِلَّا ٱللَّهُ"
    ]

    let latinLines = [
        "Allahu Akbar, Allahu Akbar",
        "Allahu Akbar, Allahu Akbar",
        "Asyhadu an lā ilāha illā Allāh",
        "Asyhadu anna Muhammadan rasūlullāh",
        "Hayya ‘alaṣ-ṣalāh",
        "Hayya ‘alal-falāḥ",
        "Allahu Akbar",
        "Lā ilāha illā Allāh"
    ]

    func play(adzan: Adzan) {
        guard let url = Bundle.main.url(forResource: adzan.fileName, withExtension: "mp3") else {
            print("File not found: \(adzan.fileName)")
            return
        }

        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.play()
            currentAdzan = adzan
            isPlaying = true
            startLyricSync()
        } catch {
            print("Error playing: \(error.localizedDescription)")
        }
    }

    func togglePlayPause() {
        guard let player = player else { return }
        if player.isPlaying {
            player.pause()
            isPlaying = false
            stopLyricSync()
        } else {
            player.play()
            isPlaying = true
            startLyricSync()
        }
    }

    func startLyricSync() {
        currentLineIndex = 0
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { _ in
            if self.currentLineIndex < self.arabLines.count - 1 {
                self.currentLineIndex += 1
            } else {
                self.timer?.invalidate()
            }
        }
    }

    func stopLyricSync() {
        timer?.invalidate()
    }
}

struct AdzanPlayerView: View {
    @StateObject private var viewModel = AdzanPlayerViewModel()

    let adzanList = [
        Adzan(name: "Adzan Mekkah", location: "Mekkah", fileName: "mekkah"),
        Adzan(name: "Adzan Cianjur", location: "Cianjur", fileName: "mekkah")
    ]

    var body: some View {
        VStack {
      

            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(LinearGradient(colors: [.green, .blue], startPoint: .leading, endPoint: .trailing))
                    .frame(height: 100)

                VStack(spacing: 6) {
                    Text(viewModel.arabLines[safe: viewModel.currentLineIndex] ?? "")
                        .font(.title2)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)

                    Text(viewModel.latinLines[safe: viewModel.currentLineIndex] ?? "")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.8))
                        .multilineTextAlignment(.center)
                }
                .padding(.horizontal)
            }
            .padding(.top, 10)

            if viewModel.isPlaying {
                SimpleAudioVisualizerFullView(isPlaying: viewModel.isPlaying)
                    .padding(.horizontal,5)
            }



            if viewModel.currentAdzan != nil {
                Button(action: {
                    viewModel.togglePlayPause()
                }) {
                    Image(systemName: viewModel.isPlaying ? "pause.circle.fill" : "play.circle.fill")
                        .resizable()
                        .frame(width: 64, height: 64)
                        .foregroundColor(.green)
                }
                .padding()
            }

            List(adzanList) { adzan in
                Button {
                    viewModel.play(adzan: adzan)
                } label: {
                    HStack {
                        Image(systemName: "play.circle")
                        Text(adzan.name)
                        Spacer()
                        Text(adzan.location).foregroundColor(.gray)
                    }
                }
            }

            Spacer()
            BannerAdView().frame(height: 50)
        }
    }
}


struct AudioVisualizerView: View {
    var body: some View {
        Rectangle()
            .fill(LinearGradient(colors: [.green, .blue], startPoint: .leading, endPoint: .trailing))
            .frame(height: 60)
            .cornerRadius(10)
            .padding()
            .overlay(Text("Visual Audio"))
    }
}

import GoogleMobileAds
import SwiftUI
import UIKit

struct BannerAdView: UIViewRepresentable {
    func makeUIView(context: Context) -> BannerView {
        let banner = BannerView(adSize: AdSizeBanner) // ✅ Ubah ini, jangan pakai kGADAdSizeBanner
        banner.adUnitID = "ca-app-pub-3940256099942544/2934735716" // ✅ test Ad Unit dari Google
        banner.rootViewController = UIApplication.shared.windows.first?.rootViewController
        banner.load(Request())
        return banner
    }

    func updateUIView(_ uiView: BannerView, context: Context) {}
}

struct AudioWaveView: View {
    @State private var phase: CGFloat = 0
    var isAnimating: Bool

    var body: some View {
        GeometryReader { geo in
            WaveShape(phase: phase)
                .stroke(Color.green, lineWidth: 3)
                .background(Color.yellow)
                .onAppear {
                    animate()
                }
                .onChange(of: isAnimating) { newValue in
                    if newValue { animate() }
                }
        }
        .frame(height: 100)
        .cornerRadius(12)
    }

    func animate() {
        guard isAnimating else { return }
        withAnimation(.linear(duration: 0.8).repeatForever(autoreverses: false)) {
            phase -= .pi / 2
        }
    }
}

struct WaveShape: Shape {
    var phase: CGFloat

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let midHeight = rect.height / 2
        let width = rect.width
        let height = rect.height

        for x in stride(from: 0, through: width, by: 1) {
            let relativeX = x / width
            let sine = sin(relativeX * 2 * .pi + phase)
            let y = midHeight + sine * (height / 3)
            if x == 0 {
                path.move(to: CGPoint(x: x, y: y))
            } else {
                path.addLine(to: CGPoint(x: x, y: y))
            }
        }

        return path
    }

    var animatableData: CGFloat {
        get { phase }
        set { phase = newValue }
    }
}
import SwiftUI

struct SimpleAudioVisualizerFullView: View {
    @State private var values: [CGFloat] = Array(repeating: 20, count: 20)
    var isPlaying: Bool

    var body: some View {
        GeometryReader { geo in
            HStack(alignment: .bottom, spacing: 4) {
                ForEach(0..<values.count, id: \.self) { index in
                    Capsule()
                        .fill(Color.green)
                        .frame(width: (geo.size.width - CGFloat(values.count - 1) * 4) / CGFloat(values.count),
                               height: values[index])
                }
            }
            .frame(height: 100)
            .onAppear { animate() }
            .onChange(of: isPlaying) { playing in
                if playing { animate() }
            }
        }
        .frame(height: 100)
        .cornerRadius(12)
        .padding(.horizontal)
    }

    func animate() {
        guard isPlaying else { return }
        Timer.scheduledTimer(withTimeInterval: 0.25, repeats: true) { _ in
            if isPlaying {
                withAnimation(.easeInOut(duration: 0.2)) {
                    values = values.map { _ in CGFloat.random(in: 20...80) }
                }
            }
        }
    }
}
