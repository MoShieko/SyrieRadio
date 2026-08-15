import AVFoundation
import Combine
import SwiftUI
import UIKit

struct RadioStation: Identifiable, Equatable {
    let id: String
    let name: String
    let city: String
    let frequency: String
    let tagline: String
    let genre: String
    let streamURL: URL
    let imageName: String
    let accent: Color
    let governorates: [String]

    static func == (lhs: RadioStation, rhs: RadioStation) -> Bool {
        lhs.id == rhs.id
    }
}

extension RadioStation {
    static let governorates = [
        "Damascus", "Rif Dimashq", "Aleppo", "Homs", "Hama", "Latakia", "Tartus",
        "Idlib", "Daraa", "As-Suwayda", "Quneitra", "Deir ez-Zor", "Raqqa", "Al-Hasakah"
    ]

    static let all: [RadioStation] = [
        .init(id: "syria-tv-radio", name: "Syria TV Radio", city: "Nationwide Syria", frequency: "Online", tagline: "Syrian news and current affairs", genre: "News", streamURL: URL(string: "https://stream2.syria.fm/syriatv1live/syriatv_audio/icecast.audio")!, imageName: "StationSyrianMix", accent: .red, governorates: governorates),
        .init(id: "radio-nasaem", name: "Radio Nasaem", city: "Nationwide Syria", frequency: "Online", tagline: "Syrian culture and community", genre: "Culture", streamURL: URL(string: "https://stream.zeno.fm/u1wbm3k7gxquv")!, imageName: "StationTarabSyria", accent: .orange, governorates: governorates),
        .init(id: "sham-fm", name: "Sham FM", city: "Damascus", frequency: "92.3 FM", tagline: "Syrian music and local voices", genre: "Music", streamURL: URL(string: "https://radioshamfm.grtvstream.com:8400/;")!, imageName: "StationShaamRadio", accent: .green, governorates: ["Damascus", "Rif Dimashq"]),
        .init(id: "farah-fm", name: "Farah FM", city: "Damascus", frequency: "93.3 FM", tagline: "Music and entertainment", genre: "Music", streamURL: URL(string: "https://radio.farah.fm/")!, imageName: "StationFarahFM", accent: .pink, governorates: ["Damascus", "Rif Dimashq"]),
        .init(id: "radio-helmna", name: "Radio Helmna", city: "Aleppo", frequency: "105 FM", tagline: "Syrian stories, talk and music", genre: "Talk", streamURL: URL(string: "https://radiohelmna.com/stream/;")!, imageName: "StationRadioHelmna", accent: .blue, governorates: ["Aleppo"]),
        .init(id: "al-karma-fm", name: "Al Karma FM", city: "As-Suwayda", frequency: "94.1 FM", tagline: "Local culture and community", genre: "Culture", streamURL: URL(string: "https://broadcast.shoutstream.co.uk/stream/8112")!, imageName: "StationAlKarmaFM", accent: .yellow, governorates: ["As-Suwayda"]),
        .init(id: "tayf-fm", name: "Tayf FM", city: "Nationwide Syria", frequency: "Online", tagline: "The echo of Syrians", genre: "Culture", streamURL: URL(string: "https://stream.zeno.fm/xbohf8qf5uauv")!, imageName: "StationTayfFM", accent: .cyan, governorates: governorates),
        .init(id: "emaar-fm", name: "Emaar FM", city: "Nationwide Syria", frequency: "Online", tagline: "Syrian music and entertainment", genre: "Music", streamURL: URL(string: "https://stream-149.zeno.fm/4luag56o066uv")!, imageName: "StationEmaarFM", accent: .purple, governorates: governorates)
    ]
}

@MainActor
final class RadioPlayer: ObservableObject {
    enum PlaybackState: Equatable {
        case idle, loading, playing, paused
        case failed(String)
    }

    @Published private(set) var selectedStation: RadioStation
    @Published private(set) var playbackState: PlaybackState = .idle
    @Published private(set) var recentlyPlayed: [RadioStation] = []
    @Published private(set) var sleepTimerEndDate: Date?

    private var radioPlayer: AVPlayer?
    private var sleepTask: Task<Void, Never>?
    private var radioWasInterrupted = false

    init(stations: [RadioStation]) {
        selectedStation = stations[0]
    }

    deinit {
        sleepTask?.cancel()
    }

    var isPlaying: Bool { playbackState == .playing || playbackState == .loading }
    var isLoading: Bool { playbackState == .loading }
    var statusText: String {
        switch playbackState {
        case .idle: return "Ready to listen"
        case .loading: return "Connecting…"
        case .playing: return "Live now"
        case .paused: return "Paused"
        case .failed(let message): return message
        }
    }

    func togglePlayback() { isPlaying ? pause() : play() }

    func select(_ station: RadioStation, autoplay: Bool = true) {
        let changed = selectedStation.id != station.id
        selectedStation = station

        if !changed {
            if autoplay, playbackState != .playing, playbackState != .loading {
                play()
            }
            return
        }

        tearDownRadioPlayer()
        playbackState = .idle
        if autoplay { startStream(selectedStation) }
    }

    func play() {
        if playbackState == .paused, radioPlayer?.currentItem != nil {
            radioPlayer?.play()
            playbackState = .playing
            return
        }

        startStream(selectedStation)
    }

    private func startStream(_ station: RadioStation) {
        guard selectedStation == station else { return }
        tearDownRadioPlayer()
        remember(station)
        playbackState = .loading
        let item = AVPlayerItem(url: station.streamURL)
        item.preferredPeakBitRate = preferredPeakBitRate(
            for: UserDefaults.standard.string(forKey: "streamingQuality") ?? "Automatic"
        )
        let newPlayer = AVPlayer(playerItem: item)
        radioPlayer = newPlayer
        newPlayer.play()
        playbackState = .playing
    }

    func pause() {
        radioPlayer?.pause()
        playbackState = .paused
    }

    func previous(in stations: [RadioStation]) { move(by: -1, in: stations) }
    func next(in stations: [RadioStation]) { move(by: 1, in: stations) }

    func toggleSleepTimer() {
        if sleepTimerEndDate != nil {
            sleepTask?.cancel()
            sleepTimerEndDate = nil
            return
        }
        sleepTimerEndDate = Date().addingTimeInterval(30 * 60)
        sleepTask = Task { [weak self] in
            try? await Task.sleep(nanoseconds: 30 * 60 * 1_000_000_000)
            guard !Task.isCancelled else { return }
            self?.pause()
            self?.sleepTimerEndDate = nil
        }
    }

    func reportAudioSetupFailure() { playbackState = .failed("Audio setup failed") }

    func applyStreamingQuality(_ quality: String) {
        radioPlayer?.currentItem?.preferredPeakBitRate = preferredPeakBitRate(for: quality)
    }

    func handleAudioInterruption(_ notification: Notification) {
        guard let rawType = notification.userInfo?[AVAudioSessionInterruptionTypeKey] as? UInt,
              let type = AVAudioSession.InterruptionType(rawValue: rawType)
        else { return }

        switch type {
        case .began:
            if radioPlayer?.timeControlStatus == .playing {
                radioWasInterrupted = true
                radioPlayer?.pause()
                playbackState = .paused
            }
        case .ended:
            let rawOptions = notification.userInfo?[AVAudioSessionInterruptionOptionKey] as? UInt ?? 0
            let options = AVAudioSession.InterruptionOptions(rawValue: rawOptions)
            guard options.contains(.shouldResume), radioWasInterrupted else {
                radioWasInterrupted = false
                return
            }
            radioWasInterrupted = false
            radioPlayer?.play()
            playbackState = .playing
        @unknown default:
            break
        }
    }

    private func preferredPeakBitRate(for quality: String) -> Double {
        switch quality {
        case "Data Saver": return 64_000
        case "High": return 320_000
        default: return 0
        }
    }

    private func move(by offset: Int, in stations: [RadioStation]) {
        guard let index = stations.firstIndex(where: { $0.id == selectedStation.id }) else { return }
        let target = (index + offset + stations.count) % stations.count
        select(stations[target])
    }

    private func remember(_ station: RadioStation) {
        recentlyPlayed.removeAll { $0.id == station.id }
        recentlyPlayed.insert(station, at: 0)
        recentlyPlayed = Array(recentlyPlayed.prefix(4))
    }

    private func tearDownRadioPlayer() {
        radioPlayer?.pause()
        radioPlayer = nil
    }
}

@MainActor
final class FavoritesStore: ObservableObject {
    @Published private(set) var ids: Set<String> {
        didSet { UserDefaults.standard.set(Array(ids), forKey: "favoriteStationIDs") }
    }

    init() {
        ids = Set(UserDefaults.standard.stringArray(forKey: "favoriteStationIDs") ?? [])
    }

    func contains(_ station: RadioStation) -> Bool { ids.contains(station.id) }
    func toggle(_ station: RadioStation) {
        if ids.contains(station.id) { ids.remove(station.id) } else { ids.insert(station.id) }
    }
}

enum AppPalette {
    static let background = adaptive(light: (0.973, 0.976, 1.0), dark: (0.027, 0.055, 0.094))
    static let primary = adaptive(light: (0.0, 0.094, 0.208), dark: (0.835, 0.890, 1.0))
    static let primaryContainer = adaptive(light: (0.059, 0.176, 0.322), dark: (0.094, 0.204, 0.345))
    static let gold = adaptive(light: (0.451, 0.361, 0.0), dark: (1.0, 0.824, 0.31))
    static let goldLight = adaptive(light: (0.996, 0.839, 0.357), dark: (0.38, 0.294, 0.055))
    static let surfaceBlue = adaptive(light: (0.929, 0.957, 1.0), dark: (0.067, 0.118, 0.184))
    static let textSecondary = adaptive(light: (0.263, 0.278, 0.306), dark: (0.68, 0.72, 0.79))
    static let card = adaptive(light: (1.0, 1.0, 1.0), dark: (0.055, 0.098, 0.153))
    static let control = adaptive(light: (0.0, 0.094, 0.208), dark: (0.12, 0.27, 0.44))
    static let mediaOverlay = Color(red: 0.0, green: 0.094, blue: 0.208)

    private static func adaptive(
        light: (CGFloat, CGFloat, CGFloat),
        dark: (CGFloat, CGFloat, CGFloat)
    ) -> Color {
        Color(UIColor { traits in
            let rgb = traits.userInterfaceStyle == .dark ? dark : light
            return UIColor(red: rgb.0, green: rgb.1, blue: rgb.2, alpha: 1)
        })
    }
}
