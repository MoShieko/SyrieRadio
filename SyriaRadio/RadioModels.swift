// Regeluitleg: Importeert het framework `AVFoundation` voor de functionaliteit in dit bestand.
import AVFoundation
// Regeluitleg: Importeert het framework `Combine` voor de functionaliteit in dit bestand.
import Combine
// Regeluitleg: Importeert het framework `MediaPlayer` voor de functionaliteit in dit bestand.
import MediaPlayer
// Regeluitleg: Importeert het framework `SwiftUI` voor de functionaliteit in dit bestand.
import SwiftUI
// Regeluitleg: Importeert het framework `UIKit` voor de functionaliteit in dit bestand.
import UIKit

/// Onveranderlijke metadata die het zenderoverzicht en AVPlayer gebruiken.
/// Gelijkheid gebruikt bewust de stabiele zender-ID in plaats van wijzigbare interfacegegevens.
// Regeluitleg: Definieert de structuur `RadioStation` en opent het bijbehorende codeblok.
struct RadioStation: Identifiable, Equatable {
    // Regeluitleg: Declareert de waarde `id` voor gebruik binnen de huidige scope.
    let id: String
    // Regeluitleg: Declareert de waarde `name` voor gebruik binnen de huidige scope.
    let name: String
    // Regeluitleg: Declareert de waarde `city` voor gebruik binnen de huidige scope.
    let city: String
    // Regeluitleg: Declareert de waarde `frequency` voor gebruik binnen de huidige scope.
    let frequency: String
    // Regeluitleg: Declareert de waarde `tagline` voor gebruik binnen de huidige scope.
    let tagline: String
    // Regeluitleg: Declareert de waarde `genre` voor gebruik binnen de huidige scope.
    let genre: String
    // Regeluitleg: Declareert de waarde `streamURL` voor gebruik binnen de huidige scope.
    let streamURL: URL
    // Regeluitleg: Declareert de waarde `imageName` voor gebruik binnen de huidige scope.
    let imageName: String
    // Regeluitleg: Declareert de waarde `accent` voor gebruik binnen de huidige scope.
    let accent: Color
    // Regeluitleg: Declareert de waarde `governorates` voor gebruik binnen de huidige scope.
    let governorates: [String]

    // Regeluitleg: Opent het codeblok voor deze declaratie of bewerking.
    static func == (lhs: RadioStation, rhs: RadioStation) -> Bool {
        // Regeluitleg: Voert deze instructie uit als onderdeel van de huidige bewerking.
        lhs.id == rhs.id
    // Regeluitleg: Sluit het huidige codeblok af.
    }
// Regeluitleg: Sluit het huidige codeblok af.
}

// Regeluitleg: Breidt `RadioStation` uit met de declaraties in het volgende codeblok.
extension RadioStation {
    /// Samengestelde zendercatalogus. Eén centrale plaats zorgt dat zoeken, favorieten,
    /// recente weergave en volgende/vorige navigatie dezelfde gegevens gebruiken.
    // Regeluitleg: Declareert de waarde `governorates` voor gebruik binnen de huidige scope.
    static let governorates = [
        // Regeluitleg: Voegt deze tekstwaarde aan de huidige collectie of configuratie toe.
        "Damascus", "Rif Dimashq", "Aleppo", "Homs", "Hama", "Latakia", "Tartus",
        // Regeluitleg: Voegt deze tekstwaarde aan de huidige collectie of configuratie toe.
        "Idlib", "Daraa", "As-Suwayda", "Quneitra", "Deir ez-Zor", "Raqqa", "Al-Hasakah"
    // Regeluitleg: Sluit de huidige collectie of subscriptexpressie af.
    ]

    // Regeluitleg: Declareert de waarde `all` voor gebruik binnen de huidige scope.
    static let all: [RadioStation] = [
        // Regeluitleg: Past de SwiftUI-modifier of gekoppelde bewerking `init` toe.
        .init(id: "syria-tv-radio", name: "Syria TV Radio", city: "Nationwide Syria", frequency: "Online", tagline: "Syrian news and current affairs", genre: "News", streamURL: URL(string: "https://stream2.syria.fm/syriatv1live/syriatv_audio/icecast.audio")!, imageName: "StationSyrianMix", accent: .red, governorates: governorates),
        // Regeluitleg: Past de SwiftUI-modifier of gekoppelde bewerking `init` toe.
        .init(id: "radio-nasaem", name: "Radio Nasaem", city: "Nationwide Syria", frequency: "Online", tagline: "Syrian culture and community", genre: "Culture", streamURL: URL(string: "https://stream.zeno.fm/u1wbm3k7gxquv")!, imageName: "StationTarabSyria", accent: .orange, governorates: governorates),
        // Regeluitleg: Past de SwiftUI-modifier of gekoppelde bewerking `init` toe.
        .init(id: "sham-fm", name: "Sham FM", city: "Damascus", frequency: "92.3 FM", tagline: "Syrian music and local voices", genre: "Music", streamURL: URL(string: "https://radioshamfm.grtvstream.com:8400/;")!, imageName: "StationShaamRadio", accent: .green, governorates: ["Damascus", "Rif Dimashq"]),
        // Regeluitleg: Past de SwiftUI-modifier of gekoppelde bewerking `init` toe.
        .init(id: "farah-fm", name: "Farah FM", city: "Damascus", frequency: "93.3 FM", tagline: "Music and entertainment", genre: "Music", streamURL: URL(string: "https://radio.farah.fm/")!, imageName: "StationFarahFM", accent: .pink, governorates: ["Damascus", "Rif Dimashq"]),
        // Regeluitleg: Past de SwiftUI-modifier of gekoppelde bewerking `init` toe.
        .init(id: "radio-helmna", name: "Radio Helmna", city: "Aleppo", frequency: "105 FM", tagline: "Syrian stories, talk and music", genre: "Talk", streamURL: URL(string: "https://radiohelmna.com/stream/;")!, imageName: "StationRadioHelmna", accent: .blue, governorates: ["Aleppo"]),
        // Regeluitleg: Past de SwiftUI-modifier of gekoppelde bewerking `init` toe.
        .init(id: "al-karma-fm", name: "Al Karma FM", city: "As-Suwayda", frequency: "94.1 FM", tagline: "Local culture and community", genre: "Culture", streamURL: URL(string: "https://broadcast.shoutstream.co.uk/stream/8112")!, imageName: "StationAlKarmaFM", accent: .yellow, governorates: ["As-Suwayda"]),
        // Regeluitleg: Past de SwiftUI-modifier of gekoppelde bewerking `init` toe.
        .init(id: "tayf-fm", name: "Tayf FM", city: "Nationwide Syria", frequency: "Online", tagline: "The echo of Syrians", genre: "Culture", streamURL: URL(string: "https://stream.zeno.fm/xbohf8qf5uauv")!, imageName: "StationTayfFM", accent: .cyan, governorates: governorates),
        // Regeluitleg: Past de SwiftUI-modifier of gekoppelde bewerking `init` toe.
        .init(id: "emaar-fm", name: "Emaar FM", city: "Nationwide Syria", frequency: "Online", tagline: "Syrian music and entertainment", genre: "Music", streamURL: URL(string: "https://stream-149.zeno.fm/4luag56o066uv")!, imageName: "StationEmaarFM", accent: .purple, governorates: governorates)
    // Regeluitleg: Sluit de huidige collectie of subscriptexpressie af.
    ]
// Regeluitleg: Sluit het huidige codeblok af.
}

/// Beheert de levenscyclus van AVPlayer en biedt SwiftUI een compacte toestandsmachine.
/// Een zender wordt pas als live gemeld nadat AVPlayer actieve weergave bevestigt.
// Regeluitleg: Dwingt toegang tot deze interfacegebonden status af op de hoofdactor.
@MainActor
// Regeluitleg: Definieert de niet-overerfbare klasse `RadioPlayer` en opent het bijbehorende codeblok.
final class RadioPlayer: ObservableObject {
    // Regeluitleg: Definieert de opsomming `PlaybackState` en opent het bijbehorende codeblok.
    enum PlaybackState: Equatable {
        // Regeluitleg: Declareert of behandelt de enumwaarde `idle`.
        case idle, loading, playing, paused
        // Regeluitleg: Declareert of behandelt de enumwaarde `failed(String)`.
        case failed(String)
    // Regeluitleg: Sluit het huidige codeblok af.
    }

    // Regeluitleg: Past het attribuut `@Published` op de volgende declaratie toe.
    @Published private(set) var selectedStation: RadioStation
    // Regeluitleg: Past het attribuut `@Published` op de volgende declaratie toe.
    @Published private(set) var playbackState: PlaybackState = .idle
    // Regeluitleg: Past het attribuut `@Published` op de volgende declaratie toe.
    @Published private(set) var recentlyPlayed: [RadioStation] = []
    // Regeluitleg: Past het attribuut `@Published` op de volgende declaratie toe.
    @Published private(set) var sleepTimerEndDate: Date?

    // Regeluitleg: Declareert de waarde `radioPlayer` voor gebruik binnen de huidige scope.
    private var radioPlayer: AVPlayer?
    // Regeluitleg: Declareert de waarde `sleepTask` voor gebruik binnen de huidige scope.
    private var sleepTask: Task<Void, Never>?
    // Regeluitleg: Declareert de waarde `radioWasInterrupted` voor gebruik binnen de huidige scope.
    private var radioWasInterrupted = false
    // Regeluitleg: Declareert de waarde `isUserPaused` voor gebruik binnen de huidige scope.
    private var isUserPaused = false
    // Regeluitleg: Declareert de waarde `timeControlObservation` voor gebruik binnen de huidige scope.
    private var timeControlObservation: NSKeyValueObservation?
    // Regeluitleg: Declareert de waarde `itemStatusObservation` voor gebruik binnen de huidige scope.
    private var itemStatusObservation: NSKeyValueObservation?
    // Regeluitleg: Declareert de waarde `itemFailureObserver` voor gebruik binnen de huidige scope.
    private var itemFailureObserver: NSObjectProtocol?
    // Regeluitleg: Declareert de waarde `itemStalledObserver` voor gebruik binnen de huidige scope.
    private var itemStalledObserver: NSObjectProtocol?
    // Regeluitleg: Declareert de waarde `itemEndedObserver` voor gebruik binnen de huidige scope.
    private var itemEndedObserver: NSObjectProtocol?
    // Regeluitleg: Declareert de waarde `remoteCommandTargets` voor gebruik binnen de huidige scope.
    private var remoteCommandTargets: [(command: MPRemoteCommand, target: Any)] = []
    // Regeluitleg: Declareert de waarde `stations` voor gebruik binnen de huidige scope.
    private let stations: [RadioStation]
    // Regeluitleg: Declareert de waarde `advertising` voor gebruik binnen de huidige scope.
    private let advertising: AdvertisingManager

    // Regeluitleg: Definieert de initializer die een nieuwe instantie configureert.
    init(stations: [RadioStation], advertising: AdvertisingManager) {
        // Regeluitleg: Werkt de waarde `selectedStation` bij met het resultaat van deze expressie.
        selectedStation = stations[0]
        // Regeluitleg: Slaat de aangeleverde waarde op in instantie-eigenschap `stations`.
        self.stations = stations
        // Regeluitleg: Slaat de aangeleverde waarde op in instantie-eigenschap `advertising`.
        self.advertising = advertising
        // Regeluitleg: Roept `configureRemoteCommands` aan met de argumenten in deze expressie.
        configureRemoteCommands()
    // Regeluitleg: Sluit het huidige codeblok af.
    }

    // Regeluitleg: Definieert opruimwerk dat bij het vrijgeven van deze instantie wordt uitgevoerd.
    deinit {
        // Regeluitleg: Voert deze instructie uit als onderdeel van de huidige bewerking.
        sleepTask?.cancel()
        // Regeluitleg: Voert deze instructie uit als onderdeel van de huidige bewerking.
        timeControlObservation?.invalidate()
        // Regeluitleg: Voert deze instructie uit als onderdeel van de huidige bewerking.
        itemStatusObservation?.invalidate()
        // Regeluitleg: Voert het volgende codeblok alleen uit wanneer deze voorwaarde waar is.
        if let itemFailureObserver { NotificationCenter.default.removeObserver(itemFailureObserver) }
        // Regeluitleg: Voert het volgende codeblok alleen uit wanneer deze voorwaarde waar is.
        if let itemStalledObserver { NotificationCenter.default.removeObserver(itemStalledObserver) }
        // Regeluitleg: Voert het volgende codeblok alleen uit wanneer deze voorwaarde waar is.
        if let itemEndedObserver { NotificationCenter.default.removeObserver(itemEndedObserver) }
        // Regeluitleg: Doorloopt de opgegeven reeks en voert het volgende blok voor ieder element uit.
        for target in remoteCommandTargets {
            // Regeluitleg: Roept `target.command.removeTarget` aan met de argumenten in deze expressie.
            target.command.removeTarget(target.target)
        // Regeluitleg: Sluit het huidige codeblok af.
        }
        // Regeluitleg: Roept `MPNowPlayingInfoCenter.default` aan met de argumenten in deze expressie.
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nil
    // Regeluitleg: Sluit het huidige codeblok af.
    }

    // Regeluitleg: Declareert de waarde `isPlaying` voor gebruik binnen de huidige scope.
    var isPlaying: Bool { playbackState == .playing }
    // Regeluitleg: Declareert de waarde `isPlaybackActive` voor gebruik binnen de huidige scope.
    var isPlaybackActive: Bool { playbackState == .playing || playbackState == .loading }
    // Regeluitleg: Declareert de waarde `hasPlaybackSession` voor gebruik binnen de huidige scope.
    var hasPlaybackSession: Bool { playbackState != .idle }
    // Regeluitleg: Declareert de waarde `isLoading` voor gebruik binnen de huidige scope.
    var isLoading: Bool { playbackState == .loading }
    // Regeluitleg: Declareert de waarde `statusText` voor gebruik binnen de huidige scope.
    var statusText: String {
        // Regeluitleg: Kiest een uitvoerpad op basis van `playbackState`.
        switch playbackState {
        // Regeluitleg: Declareert of behandelt de enumwaarde `.idle`.
        case .idle: return "Ready to listen"
        // Regeluitleg: Declareert of behandelt de enumwaarde `.loading`.
        case .loading: return "Connecting…"
        // Regeluitleg: Declareert of behandelt de enumwaarde `.playing`.
        case .playing: return "Live now"
        // Regeluitleg: Declareert of behandelt de enumwaarde `.paused`.
        case .paused: return "Paused"
        // Regeluitleg: Declareert of behandelt de enumwaarde `.failed(let message)`.
        case .failed(let message): return message
        // Regeluitleg: Sluit het huidige codeblok af.
        }
    // Regeluitleg: Sluit het huidige codeblok af.
    }

    // Regeluitleg: Definieert de functie `togglePlayback` en haar invoerwaarden.
    func togglePlayback() { isPlaybackActive ? pause() : play() }

    // Regeluitleg: Definieert de functie `select` en haar invoerwaarden.
    func select(_ station: RadioStation, autoplay: Bool = true) {
        // Selectie van de huidige zender hervat deze; selectie van een andere zender
        // verwijdert alle waarnemers voordat een nieuwe stream wordt gemaakt.
        // Regeluitleg: Declareert de waarde `changed` voor gebruik binnen de huidige scope.
        let changed = selectedStation.id != station.id
        // Regeluitleg: Werkt de waarde `selectedStation` bij met het resultaat van deze expressie.
        selectedStation = station

        // Regeluitleg: Voert het volgende codeblok alleen uit wanneer deze voorwaarde waar is.
        if !changed {
            // Regeluitleg: Voert het volgende codeblok alleen uit wanneer deze voorwaarde waar is.
            if autoplay, playbackState != .playing, playbackState != .loading {
                // Regeluitleg: Roept `play` aan met de argumenten in deze expressie.
                play()
            // Regeluitleg: Sluit het huidige codeblok af.
            }
            // Regeluitleg: Geeft het berekende resultaat terug aan de aanroeper.
            return
        // Regeluitleg: Sluit het huidige codeblok af.
        }

        // Regeluitleg: Roept `tearDownRadioPlayer` aan met de argumenten in deze expressie.
        tearDownRadioPlayer()
        // Regeluitleg: Werkt de waarde `playbackState` bij met het resultaat van deze expressie.
        playbackState = .idle
        // Regeluitleg: Voert het volgende codeblok alleen uit wanneer deze voorwaarde waar is.
        if autoplay { playWithAdvertisementIfNeeded(selectedStation) }
    // Regeluitleg: Sluit het huidige codeblok af.
    }

    // Regeluitleg: Definieert de functie `play` en haar invoerwaarden.
    func play() {
        // Regeluitleg: Voert het volgende codeblok alleen uit wanneer deze voorwaarde waar is.
        if playbackState == .paused, radioPlayer?.currentItem != nil {
            // Regeluitleg: Werkt de waarde `isUserPaused` bij met het resultaat van deze expressie.
            isUserPaused = false
            // Regeluitleg: Werkt de waarde `playbackState` bij met het resultaat van deze expressie.
            playbackState = .loading
            // Regeluitleg: Voert deze instructie uit als onderdeel van de huidige bewerking.
            radioPlayer?.play()
            // Regeluitleg: Geeft het berekende resultaat terug aan de aanroeper.
            return
        // Regeluitleg: Sluit het huidige codeblok af.
        }

        // Regeluitleg: Roept `playWithAdvertisementIfNeeded` aan met de argumenten in deze expressie.
        playWithAdvertisementIfNeeded(selectedStation)
    // Regeluitleg: Sluit het huidige codeblok af.
    }

    // Regeluitleg: Definieert de functie `playWithAdvertisementIfNeeded` en haar invoerwaarden.
    private func playWithAdvertisementIfNeeded(_ station: RadioStation) {
        // AdvertisingManager controleert Premium voordat wordt bepaald of afspelen
        // direct kan starten of op de optionele audioreclame moet wachten.
        // Regeluitleg: Werkt de waarde `playbackState` bij met het resultaat van deze expressie.
        playbackState = .loading
        // Regeluitleg: Roept `updateNowPlayingInfo` aan met de argumenten in deze expressie.
        updateNowPlayingInfo(for: station, playbackRate: 0)
        // Regeluitleg: Voert deze instructie uit als onderdeel van de huidige bewerking.
        advertising.startRadio { [weak self] in
            // Regeluitleg: Controleert de vereiste voorwaarden en verlaat de huidige bewerking als die niet gelden.
            guard let self, self.selectedStation == station else { return }
            // Regeluitleg: Roept `self.startStream` aan met de argumenten in deze expressie.
            self.startStream(station)
        // Regeluitleg: Sluit het huidige codeblok af.
        }
    // Regeluitleg: Sluit het huidige codeblok af.
    }

    // Regeluitleg: Definieert de functie `startStream` en haar invoerwaarden.
    private func startStream(_ station: RadioStation) {
        // Regeluitleg: Controleert de vereiste voorwaarden en verlaat de huidige bewerking als die niet gelden.
        guard selectedStation == station else { return }
        // Regeluitleg: Roept `tearDownRadioPlayer` aan met de argumenten in deze expressie.
        tearDownRadioPlayer()
        // Regeluitleg: Werkt de waarde `isUserPaused` bij met het resultaat van deze expressie.
        isUserPaused = false
        // Regeluitleg: Werkt de waarde `playbackState` bij met het resultaat van deze expressie.
        playbackState = .loading
        // Regeluitleg: Declareert de waarde `item` voor gebruik binnen de huidige scope.
        let item = AVPlayerItem(url: station.streamURL)
        // Regeluitleg: Voert deze instructie uit als onderdeel van de huidige bewerking.
        item.preferredPeakBitRate = preferredPeakBitRate(
            // Regeluitleg: Geeft de waarde voor parameter of eigenschap `for` door.
            for: UserDefaults.standard.string(forKey: "streamingQuality") ?? "Automatic"
        // Regeluitleg: Sluit de gegroepeerde argumenten van deze expressie af.
        )
        // Regeluitleg: Declareert de waarde `newPlayer` voor gebruik binnen de huidige scope.
        let newPlayer = AVPlayer(playerItem: item)
        // Regeluitleg: Werkt de waarde `radioPlayer` bij met het resultaat van deze expressie.
        radioPlayer = newPlayer
        // Regeluitleg: Roept `observePlayback` aan met de argumenten in deze expressie.
        observePlayback(player: newPlayer, item: item, station: station)
        // Regeluitleg: Roept `newPlayer.play` aan met de argumenten in deze expressie.
        newPlayer.play()
    // Regeluitleg: Sluit het huidige codeblok af.
    }

    // Regeluitleg: Definieert de functie `pause` en haar invoerwaarden.
    func pause() {
        // Regeluitleg: Roept `advertising.cancelPendingRadioStart` aan met de argumenten in deze expressie.
        advertising.cancelPendingRadioStart()
        // Regeluitleg: Werkt de waarde `isUserPaused` bij met het resultaat van deze expressie.
        isUserPaused = true
        // Regeluitleg: Voert deze instructie uit als onderdeel van de huidige bewerking.
        radioPlayer?.pause()
        // Regeluitleg: Werkt de waarde `playbackState` bij met het resultaat van deze expressie.
        playbackState = .paused
        // Regeluitleg: Roept `updateNowPlayingInfo` aan met de argumenten in deze expressie.
        updateNowPlayingInfo(for: selectedStation, playbackRate: 0)
    // Regeluitleg: Sluit het huidige codeblok af.
    }

    // Regeluitleg: Definieert de functie `previous` en haar invoerwaarden.
    func previous(in stations: [RadioStation]) { move(by: -1, in: stations) }
    // Regeluitleg: Definieert de functie `next` en haar invoerwaarden.
    func next(in stations: [RadioStation]) { move(by: 1, in: stations) }

    // Regeluitleg: Definieert de functie `toggleSleepTimer` en haar invoerwaarden.
    func toggleSleepTimer() {
        // Regeluitleg: Voert het volgende codeblok alleen uit wanneer deze voorwaarde waar is.
        if sleepTimerEndDate != nil {
            // Regeluitleg: Voert deze instructie uit als onderdeel van de huidige bewerking.
            sleepTask?.cancel()
            // Regeluitleg: Werkt de waarde `sleepTimerEndDate` bij met het resultaat van deze expressie.
            sleepTimerEndDate = nil
            // Regeluitleg: Geeft het berekende resultaat terug aan de aanroeper.
            return
        // Regeluitleg: Sluit het huidige codeblok af.
        }
        // Regeluitleg: Werkt de waarde `sleepTimerEndDate` bij met het resultaat van deze expressie.
        sleepTimerEndDate = Date().addingTimeInterval(30 * 60)
        // Regeluitleg: Werkt de waarde `sleepTask` bij met het resultaat van deze expressie.
        sleepTask = Task { [weak self] in
            // Regeluitleg: Voert deze werpende asynchrone bewerking uit en wacht op het resultaat.
            try? await Task.sleep(nanoseconds: 30 * 60 * 1_000_000_000)
            // Regeluitleg: Controleert de vereiste voorwaarden en verlaat de huidige bewerking als die niet gelden.
            guard !Task.isCancelled else { return }
            // Regeluitleg: Voert deze instructie uit als onderdeel van de huidige bewerking.
            self?.pause()
            // Regeluitleg: Voert deze instructie uit als onderdeel van de huidige bewerking.
            self?.sleepTimerEndDate = nil
        // Regeluitleg: Sluit het huidige codeblok af.
        }
    // Regeluitleg: Sluit het huidige codeblok af.
    }

    // Regeluitleg: Definieert de functie `reportAudioSetupFailure` en haar invoerwaarden.
    func reportAudioSetupFailure() { playbackState = .failed("Audio setup failed") }

    // Regeluitleg: Definieert de functie `applyStreamingQuality` en haar invoerwaarden.
    func applyStreamingQuality(_ quality: String) {
        // Regeluitleg: Voert deze instructie uit als onderdeel van de huidige bewerking.
        radioPlayer?.currentItem?.preferredPeakBitRate = preferredPeakBitRate(for: quality)
    // Regeluitleg: Sluit het huidige codeblok af.
    }

    // Regeluitleg: Definieert de functie `handleAudioInterruption` en haar invoerwaarden.
    func handleAudioInterruption(_ notification: Notification) {
        // Regeluitleg: Controleert de vereiste voorwaarden en verlaat de huidige bewerking als die niet gelden.
        guard let rawType = notification.userInfo?[AVAudioSessionInterruptionTypeKey] as? UInt,
              // Regeluitleg: Declareert de waarde `type` voor gebruik binnen de huidige scope.
              let type = AVAudioSession.InterruptionType(rawValue: rawType)
        // Regeluitleg: Opent het alternatieve uitvoerpad wanneer de vorige voorwaarde niet geldt.
        else { return }

        // Regeluitleg: Kiest een uitvoerpad op basis van `type`.
        switch type {
        // Regeluitleg: Declareert of behandelt de enumwaarde `.began`.
        case .began:
            // Regeluitleg: Voert het volgende codeblok alleen uit wanneer deze voorwaarde waar is.
            if radioPlayer?.timeControlStatus == .playing {
                // Regeluitleg: Werkt de waarde `radioWasInterrupted` bij met het resultaat van deze expressie.
                radioWasInterrupted = true
                // Regeluitleg: Werkt de waarde `isUserPaused` bij met het resultaat van deze expressie.
                isUserPaused = true
                // Regeluitleg: Voert deze instructie uit als onderdeel van de huidige bewerking.
                radioPlayer?.pause()
                // Regeluitleg: Werkt de waarde `playbackState` bij met het resultaat van deze expressie.
                playbackState = .paused
            // Regeluitleg: Sluit het huidige codeblok af.
            }
        // Regeluitleg: Declareert of behandelt de enumwaarde `.ended`.
        case .ended:
            // Regeluitleg: Declareert de waarde `rawOptions` voor gebruik binnen de huidige scope.
            let rawOptions = notification.userInfo?[AVAudioSessionInterruptionOptionKey] as? UInt ?? 0
            // Regeluitleg: Declareert de waarde `options` voor gebruik binnen de huidige scope.
            let options = AVAudioSession.InterruptionOptions(rawValue: rawOptions)
            // Regeluitleg: Controleert de vereiste voorwaarden en verlaat de huidige bewerking als die niet gelden.
            guard options.contains(.shouldResume), radioWasInterrupted else {
                // Regeluitleg: Werkt de waarde `radioWasInterrupted` bij met het resultaat van deze expressie.
                radioWasInterrupted = false
                // Regeluitleg: Geeft het berekende resultaat terug aan de aanroeper.
                return
            // Regeluitleg: Sluit het huidige codeblok af.
            }
            // Regeluitleg: Werkt de waarde `radioWasInterrupted` bij met het resultaat van deze expressie.
            radioWasInterrupted = false
            // Regeluitleg: Werkt de waarde `isUserPaused` bij met het resultaat van deze expressie.
            isUserPaused = false
            // Regeluitleg: Werkt de waarde `playbackState` bij met het resultaat van deze expressie.
            playbackState = .loading
            // Regeluitleg: Voert deze instructie uit als onderdeel van de huidige bewerking.
            radioPlayer?.play()
        // Regeluitleg: Past het attribuut `@unknown` op de volgende declaratie toe.
        @unknown default:
            // Regeluitleg: Beëindigt de huidige switchtak of lus.
            break
        // Regeluitleg: Sluit het huidige codeblok af.
        }
    // Regeluitleg: Sluit het huidige codeblok af.
    }

    // Regeluitleg: Definieert de functie `preferredPeakBitRate` en haar invoerwaarden.
    private func preferredPeakBitRate(for quality: String) -> Double {
        // Regeluitleg: Kiest een uitvoerpad op basis van `quality`.
        switch quality {
        // Regeluitleg: Declareert of behandelt de enumwaarde `"Data Saver"`.
        case "Data Saver": return 64_000
        // Regeluitleg: Declareert of behandelt de enumwaarde `"High"`.
        case "High": return 320_000
        // Regeluitleg: Geeft de waarde voor parameter of eigenschap `default` door.
        default: return 0
        // Regeluitleg: Sluit het huidige codeblok af.
        }
    // Regeluitleg: Sluit het huidige codeblok af.
    }

    // Regeluitleg: Definieert de functie `move` en haar invoerwaarden.
    private func move(by offset: Int, in stations: [RadioStation]) {
        // Regeluitleg: Controleert de vereiste voorwaarden en verlaat de huidige bewerking als die niet gelden.
        guard let index = stations.firstIndex(where: { $0.id == selectedStation.id }) else { return }
        // Regeluitleg: Declareert de waarde `target` voor gebruik binnen de huidige scope.
        let target = (index + offset + stations.count) % stations.count
        // Regeluitleg: Roept `select` aan met de argumenten in deze expressie.
        select(stations[target])
    // Regeluitleg: Sluit het huidige codeblok af.
    }

    // Regeluitleg: Definieert de functie `remember` en haar invoerwaarden.
    private func remember(_ station: RadioStation) {
        // Regeluitleg: Voert deze instructie uit als onderdeel van de huidige bewerking.
        recentlyPlayed.removeAll { $0.id == station.id }
        // Regeluitleg: Roept `recentlyPlayed.insert` aan met de argumenten in deze expressie.
        recentlyPlayed.insert(station, at: 0)
        // Regeluitleg: Werkt de waarde `recentlyPlayed` bij met het resultaat van deze expressie.
        recentlyPlayed = Array(recentlyPlayed.prefix(4))
    // Regeluitleg: Sluit het huidige codeblok af.
    }

    // Regeluitleg: Definieert de functie `observePlayback` en haar invoerwaarden.
    private func observePlayback(player: AVPlayer, item: AVPlayerItem, station: RadioStation) {
        // Iedere callback controleert de identiteit van speler en item. Dit voorkomt dat een late
        // callback van een oude zender de interface van de nieuwe zender wijzigt.
        // Regeluitleg: Werkt de waarde `timeControlObservation` bij met het resultaat van deze expressie.
        timeControlObservation = player.observe(\.timeControlStatus, options: [.initial, .new]) {
            // Regeluitleg: Legt de genoemde referenties zwak vast om een geheugencyclus te voorkomen.
            [weak self, weak player, weak item] _, _ in
            // Regeluitleg: Start een gestructureerde asynchrone taak.
            Task { @MainActor [weak self, weak player, weak item] in
                // Regeluitleg: Controleert de vereiste voorwaarden en verlaat de huidige bewerking als die niet gelden.
                guard let self, let player, let item,
                      // Regeluitleg: Slaat de aangeleverde waarde op in instantie-eigenschap `radioPlayer`.
                      self.radioPlayer === player,
                      // Regeluitleg: Voert deze instructie uit als onderdeel van de huidige bewerking.
                      player.currentItem === item
                // Regeluitleg: Opent het alternatieve uitvoerpad wanneer de vorige voorwaarde niet geldt.
                else { return }
                // Regeluitleg: Roept `self.handleTimeControlStatus` aan met de argumenten in deze expressie.
                self.handleTimeControlStatus(player.timeControlStatus, item: item, station: station)
            // Regeluitleg: Sluit het huidige codeblok af.
            }
        // Regeluitleg: Sluit het huidige codeblok af.
        }

        // Regeluitleg: Werkt de waarde `itemStatusObservation` bij met het resultaat van deze expressie.
        itemStatusObservation = item.observe(\.status, options: [.initial, .new]) {
            // Regeluitleg: Legt de genoemde referenties zwak vast om een geheugencyclus te voorkomen.
            [weak self, weak player, weak item] _, _ in
            // Regeluitleg: Start een gestructureerde asynchrone taak.
            Task { @MainActor [weak self, weak player, weak item] in
                // Regeluitleg: Controleert de vereiste voorwaarden en verlaat de huidige bewerking als die niet gelden.
                guard let self, let player, let item,
                      // Regeluitleg: Slaat de aangeleverde waarde op in instantie-eigenschap `radioPlayer`.
                      self.radioPlayer === player,
                      // Regeluitleg: Voert deze instructie uit als onderdeel van de huidige bewerking.
                      player.currentItem === item
                // Regeluitleg: Opent het alternatieve uitvoerpad wanneer de vorige voorwaarde niet geldt.
                else { return }
                // Regeluitleg: Roept `self.handleItemStatus` aan met de argumenten in deze expressie.
                self.handleItemStatus(item.status, error: item.error)
            // Regeluitleg: Sluit het huidige codeblok af.
            }
        // Regeluitleg: Sluit het huidige codeblok af.
        }

        // Regeluitleg: Werkt de waarde `itemFailureObserver` bij met het resultaat van deze expressie.
        itemFailureObserver = NotificationCenter.default.addObserver(
            // Regeluitleg: Geeft de waarde voor parameter of eigenschap `forName` door.
            forName: .AVPlayerItemFailedToPlayToEndTime,
            // Regeluitleg: Geeft de waarde voor parameter of eigenschap `object` door.
            object: item,
            // Regeluitleg: Geeft de waarde voor parameter of eigenschap `queue` door.
            queue: .main
        // Regeluitleg: Sluit de gegroepeerde argumenten van deze expressie af.
        ) { [weak self, weak player, weak item] notification in
            // Regeluitleg: Declareert de waarde `error` voor gebruik binnen de huidige scope.
            let error = notification.userInfo?[AVPlayerItemFailedToPlayToEndTimeErrorKey] as? Error
            // Regeluitleg: Start een gestructureerde asynchrone taak.
            Task { @MainActor [weak self, weak player, weak item] in
                // Regeluitleg: Controleert de vereiste voorwaarden en verlaat de huidige bewerking als die niet gelden.
                guard let self, let player, let item,
                      // Regeluitleg: Slaat de aangeleverde waarde op in instantie-eigenschap `radioPlayer`.
                      self.radioPlayer === player,
                      // Regeluitleg: Voert deze instructie uit als onderdeel van de huidige bewerking.
                      player.currentItem === item
                // Regeluitleg: Opent het alternatieve uitvoerpad wanneer de vorige voorwaarde niet geldt.
                else { return }
                // Regeluitleg: Roept `self.failStream` aan met de argumenten in deze expressie.
                self.failStream(error)
            // Regeluitleg: Sluit het huidige codeblok af.
            }
        // Regeluitleg: Sluit het huidige codeblok af.
        }

        // Regeluitleg: Werkt de waarde `itemStalledObserver` bij met het resultaat van deze expressie.
        itemStalledObserver = NotificationCenter.default.addObserver(
            // Regeluitleg: Geeft de waarde voor parameter of eigenschap `forName` door.
            forName: .AVPlayerItemPlaybackStalled,
            // Regeluitleg: Geeft de waarde voor parameter of eigenschap `object` door.
            object: item,
            // Regeluitleg: Geeft de waarde voor parameter of eigenschap `queue` door.
            queue: .main
        // Regeluitleg: Sluit de gegroepeerde argumenten van deze expressie af.
        ) { [weak self, weak player, weak item] _ in
            // Regeluitleg: Start een gestructureerde asynchrone taak.
            Task { @MainActor [weak self, weak player, weak item] in
                // Regeluitleg: Controleert de vereiste voorwaarden en verlaat de huidige bewerking als die niet gelden.
                guard let self, let player, let item,
                      // Regeluitleg: Slaat de aangeleverde waarde op in instantie-eigenschap `radioPlayer`.
                      self.radioPlayer === player,
                      // Regeluitleg: Voegt deze waarde of dit argument toe aan de huidige lijst.
                      player.currentItem === item,
                      // Regeluitleg: Voert deze instructie uit als onderdeel van de huidige bewerking.
                      !self.isUserPaused
                // Regeluitleg: Opent het alternatieve uitvoerpad wanneer de vorige voorwaarde niet geldt.
                else { return }
                // Regeluitleg: Slaat de aangeleverde waarde op in instantie-eigenschap `playbackState`.
                self.playbackState = .loading
            // Regeluitleg: Sluit het huidige codeblok af.
            }
        // Regeluitleg: Sluit het huidige codeblok af.
        }

        // Regeluitleg: Werkt de waarde `itemEndedObserver` bij met het resultaat van deze expressie.
        itemEndedObserver = NotificationCenter.default.addObserver(
            // Regeluitleg: Geeft de waarde voor parameter of eigenschap `forName` door.
            forName: .AVPlayerItemDidPlayToEndTime,
            // Regeluitleg: Geeft de waarde voor parameter of eigenschap `object` door.
            object: item,
            // Regeluitleg: Geeft de waarde voor parameter of eigenschap `queue` door.
            queue: .main
        // Regeluitleg: Sluit de gegroepeerde argumenten van deze expressie af.
        ) { [weak self, weak player, weak item] _ in
            // Regeluitleg: Start een gestructureerde asynchrone taak.
            Task { @MainActor [weak self, weak player, weak item] in
                // Regeluitleg: Controleert de vereiste voorwaarden en verlaat de huidige bewerking als die niet gelden.
                guard let self, let player, let item,
                      // Regeluitleg: Slaat de aangeleverde waarde op in instantie-eigenschap `radioPlayer`.
                      self.radioPlayer === player,
                      // Regeluitleg: Voert deze instructie uit als onderdeel van de huidige bewerking.
                      player.currentItem === item
                // Regeluitleg: Opent het alternatieve uitvoerpad wanneer de vorige voorwaarde niet geldt.
                else { return }
                // Regeluitleg: Roept `self.failStream` aan met de argumenten in deze expressie.
                self.failStream(nil)
            // Regeluitleg: Sluit het huidige codeblok af.
            }
        // Regeluitleg: Sluit het huidige codeblok af.
        }
    // Regeluitleg: Sluit het huidige codeblok af.
    }

    // Regeluitleg: Definieert de functie `handleTimeControlStatus` en haar invoerwaarden.
    private func handleTimeControlStatus(
        // Regeluitleg: Voegt deze waarde of dit argument toe aan de huidige lijst.
        _ status: AVPlayer.TimeControlStatus,
        // Regeluitleg: Geeft de waarde voor parameter of eigenschap `item` door.
        item: AVPlayerItem,
        // Regeluitleg: Geeft de waarde voor parameter of eigenschap `station` door.
        station: RadioStation
    // Regeluitleg: Sluit de gegroepeerde argumenten van deze expressie af.
    ) {
        // Regeluitleg: Kiest een uitvoerpad op basis van `status`.
        switch status {
        // Regeluitleg: Declareert of behandelt de enumwaarde `.playing`.
        case .playing:
            // Alleen deze overgang mag ‘Nu live’ in de interface tonen.
            // Regeluitleg: Werkt de waarde `isUserPaused` bij met het resultaat van deze expressie.
            isUserPaused = false
            // Regeluitleg: Werkt de waarde `playbackState` bij met het resultaat van deze expressie.
            playbackState = .playing
            // Regeluitleg: Roept `remember` aan met de argumenten in deze expressie.
            remember(station)
            // Regeluitleg: Roept `updateNowPlayingInfo` aan met de argumenten in deze expressie.
            updateNowPlayingInfo(for: station, playbackRate: 1)
        // Regeluitleg: Declareert of behandelt de enumwaarde `.waitingToPlayAtSpecifiedRate`.
        case .waitingToPlayAtSpecifiedRate:
            // Regeluitleg: Controleert de vereiste voorwaarden en verlaat de huidige bewerking als die niet gelden.
            guard !isUserPaused else { return }
            // Regeluitleg: Voert het volgende codeblok alleen uit wanneer deze voorwaarde waar is.
            if case .failed = playbackState { return }
            // Regeluitleg: Werkt de waarde `playbackState` bij met het resultaat van deze expressie.
            playbackState = .loading
        // Regeluitleg: Declareert of behandelt de enumwaarde `.paused`.
        case .paused:
            // Regeluitleg: Voert het volgende codeblok alleen uit wanneer deze voorwaarde waar is.
            if case .failed = playbackState { return }
            // Regeluitleg: Voert het volgende codeblok alleen uit wanneer deze voorwaarde waar is.
            if item.status == .failed {
                // Regeluitleg: Roept `failStream` aan met de argumenten in deze expressie.
                failStream(item.error)
            // Regeluitleg: Sluit de vorige tak en controleert vervolgens een aanvullende voorwaarde.
            } else if isUserPaused {
                // Regeluitleg: Werkt de waarde `playbackState` bij met het resultaat van deze expressie.
                playbackState = .paused
            // Regeluitleg: Sluit de vorige tak en opent het alternatieve uitvoerpad.
            } else {
                // Regeluitleg: Werkt de waarde `playbackState` bij met het resultaat van deze expressie.
                playbackState = .loading
            // Regeluitleg: Sluit het huidige codeblok af.
            }
        // Regeluitleg: Past het attribuut `@unknown` op de volgende declaratie toe.
        @unknown default:
            // Regeluitleg: Werkt de waarde `playbackState` bij met het resultaat van deze expressie.
            playbackState = .loading
        // Regeluitleg: Sluit het huidige codeblok af.
        }
    // Regeluitleg: Sluit het huidige codeblok af.
    }

    // Regeluitleg: Definieert de functie `handleItemStatus` en haar invoerwaarden.
    private func handleItemStatus(_ status: AVPlayerItem.Status, error: Error?) {
        // Regeluitleg: Kiest een uitvoerpad op basis van `status`.
        switch status {
        // Regeluitleg: Declareert of behandelt de enumwaarde `.unknown`.
        case .unknown:
            // Regeluitleg: Voert het volgende codeblok alleen uit wanneer deze voorwaarde waar is.
            if !isUserPaused { playbackState = .loading }
        // Regeluitleg: Declareert of behandelt de enumwaarde `.readyToPlay`.
        case .readyToPlay:
            // AVPlayer.timeControlStatus is de betrouwbare bron voor ‘Nu live’.
            // Regeluitleg: Beëindigt de huidige switchtak of lus.
            break
        // Regeluitleg: Declareert of behandelt de enumwaarde `.failed`.
        case .failed:
            // Regeluitleg: Roept `failStream` aan met de argumenten in deze expressie.
            failStream(error)
        // Regeluitleg: Past het attribuut `@unknown` op de volgende declaratie toe.
        @unknown default:
            // Regeluitleg: Roept `failStream` aan met de argumenten in deze expressie.
            failStream(error)
        // Regeluitleg: Sluit het huidige codeblok af.
        }
    // Regeluitleg: Sluit het huidige codeblok af.
    }

    // Regeluitleg: Definieert de functie `failStream` en haar invoerwaarden.
    private func failStream(_ error: Error?) {
// Regeluitleg: Compileert het volgende blok uitsluitend voor een DEBUG-build.
#if DEBUG
        // Regeluitleg: Voert het volgende codeblok alleen uit wanneer deze voorwaarde waar is.
        if let error {
            // Regeluitleg: Roept `print` aan met de argumenten in deze expressie.
            print("[RadioPlayer] Stream failed: \(error.localizedDescription)")
        // Regeluitleg: Sluit het huidige codeblok af.
        }
// Regeluitleg: Sluit het voorwaardelijke compileerblok af.
#endif
        // Regeluitleg: Werkt de waarde `isUserPaused` bij met het resultaat van deze expressie.
        isUserPaused = false
        // Regeluitleg: Werkt de waarde `playbackState` bij met het resultaat van deze expressie.
        playbackState = .failed("Stream unavailable")
        // Regeluitleg: Voert deze instructie uit als onderdeel van de huidige bewerking.
        radioPlayer?.pause()
        // Regeluitleg: Roept `updateNowPlayingInfo` aan met de argumenten in deze expressie.
        updateNowPlayingInfo(for: selectedStation, playbackRate: 0)
    // Regeluitleg: Sluit het huidige codeblok af.
    }

    /// Laat de radio werken als een native audio-app vanuit het toegangsscherm,
    /// Bedieningspaneel, Bluetooth-bediening en CarPlay-compatibele bediening.
    // Regeluitleg: Definieert de functie `configureRemoteCommands` en haar invoerwaarden.
    private func configureRemoteCommands() {
        // Regeluitleg: Declareert de waarde `commands` voor gebruik binnen de huidige scope.
        let commands = MPRemoteCommandCenter.shared()

        // Regeluitleg: Werkt de waarde `remoteCommandTargets` bij met het resultaat van deze expressie.
        remoteCommandTargets = [
            // Regeluitleg: Opent of vervolgt de gegroepeerde argumenten van deze expressie.
            (commands.playCommand, commands.playCommand.addTarget { [weak self] _ in
                // Regeluitleg: Start een gestructureerde asynchrone taak.
                Task { @MainActor [weak self] in self?.play() }
                // Regeluitleg: Geeft het berekende resultaat terug aan de aanroeper.
                return .success
            // Regeluitleg: Sluit het huidige codeblok en de omringende expressie af.
            }),
            // Regeluitleg: Opent of vervolgt de gegroepeerde argumenten van deze expressie.
            (commands.pauseCommand, commands.pauseCommand.addTarget { [weak self] _ in
                // Regeluitleg: Start een gestructureerde asynchrone taak.
                Task { @MainActor [weak self] in self?.pause() }
                // Regeluitleg: Geeft het berekende resultaat terug aan de aanroeper.
                return .success
            // Regeluitleg: Sluit het huidige codeblok en de omringende expressie af.
            }),
            // Regeluitleg: Opent of vervolgt de gegroepeerde argumenten van deze expressie.
            (commands.togglePlayPauseCommand, commands.togglePlayPauseCommand.addTarget { [weak self] _ in
                // Regeluitleg: Start een gestructureerde asynchrone taak.
                Task { @MainActor [weak self] in self?.togglePlayback() }
                // Regeluitleg: Geeft het berekende resultaat terug aan de aanroeper.
                return .success
            // Regeluitleg: Sluit het huidige codeblok en de omringende expressie af.
            }),
            // Regeluitleg: Opent of vervolgt de gegroepeerde argumenten van deze expressie.
            (commands.nextTrackCommand, commands.nextTrackCommand.addTarget { [weak self] _ in
                // Regeluitleg: Start een gestructureerde asynchrone taak.
                Task { @MainActor [weak self] in
                    // Regeluitleg: Controleert de vereiste voorwaarden en verlaat de huidige bewerking als die niet gelden.
                    guard let self else { return }
                    // Regeluitleg: Roept `self.next` aan met de argumenten in deze expressie.
                    self.next(in: self.stations)
                // Regeluitleg: Sluit het huidige codeblok af.
                }
                // Regeluitleg: Geeft het berekende resultaat terug aan de aanroeper.
                return .success
            // Regeluitleg: Sluit het huidige codeblok en de omringende expressie af.
            }),
            // Regeluitleg: Opent of vervolgt de gegroepeerde argumenten van deze expressie.
            (commands.previousTrackCommand, commands.previousTrackCommand.addTarget { [weak self] _ in
                // Regeluitleg: Start een gestructureerde asynchrone taak.
                Task { @MainActor [weak self] in
                    // Regeluitleg: Controleert de vereiste voorwaarden en verlaat de huidige bewerking als die niet gelden.
                    guard let self else { return }
                    // Regeluitleg: Roept `self.previous` aan met de argumenten in deze expressie.
                    self.previous(in: self.stations)
                // Regeluitleg: Sluit het huidige codeblok af.
                }
                // Regeluitleg: Geeft het berekende resultaat terug aan de aanroeper.
                return .success
            // Regeluitleg: Sluit het huidige codeblok en de omringende functieaanroep af.
            })
        // Regeluitleg: Sluit de huidige collectie of subscriptexpressie af.
        ]
    // Regeluitleg: Sluit het huidige codeblok af.
    }

    // Regeluitleg: Definieert de functie `updateNowPlayingInfo` en haar invoerwaarden.
    private func updateNowPlayingInfo(for station: RadioStation, playbackRate: Float) {
        // Regeluitleg: Declareert de waarde `information` voor gebruik binnen de huidige scope.
        var information: [String: Any] = [
            // Regeluitleg: Geeft de waarde voor parameter of eigenschap `MPMediaItemPropertyTitle` door.
            MPMediaItemPropertyTitle: station.name,
            // Regeluitleg: Geeft de waarde voor parameter of eigenschap `MPMediaItemPropertyArtist` door.
            MPMediaItemPropertyArtist: station.city,
            // Regeluitleg: Geeft de waarde voor parameter of eigenschap `MPMediaItemPropertyAlbumTitle` door.
            MPMediaItemPropertyAlbumTitle: "SyriaRadio",
            // Regeluitleg: Geeft de waarde voor parameter of eigenschap `MPNowPlayingInfoPropertyIsLiveStream` door.
            MPNowPlayingInfoPropertyIsLiveStream: true,
            // Regeluitleg: Geeft de waarde voor parameter of eigenschap `MPNowPlayingInfoPropertyPlaybackRate` door.
            MPNowPlayingInfoPropertyPlaybackRate: playbackRate,
            // Regeluitleg: Geeft de waarde voor parameter of eigenschap `MPNowPlayingInfoPropertyDefaultPlaybackRate` door.
            MPNowPlayingInfoPropertyDefaultPlaybackRate: 1
        // Regeluitleg: Sluit de huidige collectie of subscriptexpressie af.
        ]

        // Regeluitleg: Voert het volgende codeblok alleen uit wanneer deze voorwaarde waar is.
        if let image = UIImage(named: station.imageName) {
            // Regeluitleg: Voert deze instructie uit als onderdeel van de huidige bewerking.
            information[MPMediaItemPropertyArtwork] = MPMediaItemArtwork(boundsSize: image.size) { _ in image }
        // Regeluitleg: Sluit het huidige codeblok af.
        }
        // Regeluitleg: Roept `MPNowPlayingInfoCenter.default` aan met de argumenten in deze expressie.
        MPNowPlayingInfoCenter.default().nowPlayingInfo = information
    // Regeluitleg: Sluit het huidige codeblok af.
    }

    // Regeluitleg: Definieert de functie `tearDownRadioPlayer` en haar invoerwaarden.
    private func tearDownRadioPlayer() {
        // KVO- en NotificationCenter-waarnemers moeten tegelijk met de speler worden verwijderd
        // om dubbele gebeurtenissen na herhaalde zenderwissels te voorkomen.
        // Regeluitleg: Voert deze instructie uit als onderdeel van de huidige bewerking.
        timeControlObservation?.invalidate()
        // Regeluitleg: Werkt de waarde `timeControlObservation` bij met het resultaat van deze expressie.
        timeControlObservation = nil
        // Regeluitleg: Voert deze instructie uit als onderdeel van de huidige bewerking.
        itemStatusObservation?.invalidate()
        // Regeluitleg: Werkt de waarde `itemStatusObservation` bij met het resultaat van deze expressie.
        itemStatusObservation = nil
        // Regeluitleg: Voert het volgende codeblok alleen uit wanneer deze voorwaarde waar is.
        if let itemFailureObserver { NotificationCenter.default.removeObserver(itemFailureObserver) }
        // Regeluitleg: Voert het volgende codeblok alleen uit wanneer deze voorwaarde waar is.
        if let itemStalledObserver { NotificationCenter.default.removeObserver(itemStalledObserver) }
        // Regeluitleg: Voert het volgende codeblok alleen uit wanneer deze voorwaarde waar is.
        if let itemEndedObserver { NotificationCenter.default.removeObserver(itemEndedObserver) }
        // Regeluitleg: Werkt de waarde `itemFailureObserver` bij met het resultaat van deze expressie.
        itemFailureObserver = nil
        // Regeluitleg: Werkt de waarde `itemStalledObserver` bij met het resultaat van deze expressie.
        itemStalledObserver = nil
        // Regeluitleg: Werkt de waarde `itemEndedObserver` bij met het resultaat van deze expressie.
        itemEndedObserver = nil
        // Regeluitleg: Voert deze instructie uit als onderdeel van de huidige bewerking.
        radioPlayer?.pause()
        // Regeluitleg: Werkt de waarde `radioPlayer` bij met het resultaat van deze expressie.
        radioPlayer = nil
    // Regeluitleg: Sluit het huidige codeblok af.
    }
// Regeluitleg: Sluit het huidige codeblok af.
}

/// Bewaart alleen zender-ID’s, zodat catalogusmetadata onafhankelijk kan veranderen.
// Regeluitleg: Dwingt toegang tot deze interfacegebonden status af op de hoofdactor.
@MainActor
// Regeluitleg: Definieert de niet-overerfbare klasse `FavoritesStore` en opent het bijbehorende codeblok.
final class FavoritesStore: ObservableObject {
    // Regeluitleg: Past het attribuut `@Published` op de volgende declaratie toe.
    @Published private(set) var ids: Set<String> {
        // Regeluitleg: Voert deze instructie uit als onderdeel van de huidige bewerking.
        didSet { UserDefaults.standard.set(Array(ids), forKey: "favoriteStationIDs") }
    // Regeluitleg: Sluit het huidige codeblok af.
    }

    // Regeluitleg: Definieert de initializer die een nieuwe instantie configureert.
    init() {
        // Regeluitleg: Werkt de waarde `ids` bij met het resultaat van deze expressie.
        ids = Set(UserDefaults.standard.stringArray(forKey: "favoriteStationIDs") ?? [])
    // Regeluitleg: Sluit het huidige codeblok af.
    }

    // Regeluitleg: Definieert de functie `contains` en haar invoerwaarden.
    func contains(_ station: RadioStation) -> Bool { ids.contains(station.id) }
    // Regeluitleg: Definieert de functie `toggle` en haar invoerwaarden.
    func toggle(_ station: RadioStation) {
        // Regeluitleg: Voert het volgende codeblok alleen uit wanneer deze voorwaarde waar is.
        if ids.contains(station.id) { ids.remove(station.id) } else { ids.insert(station.id) }
    // Regeluitleg: Sluit het huidige codeblok af.
    }
// Regeluitleg: Sluit het huidige codeblok af.
}

/// Semantische kleuren voor de hele app met native aanpassing aan licht en donker.
// Regeluitleg: Definieert de opsomming `AppPalette` en opent het bijbehorende codeblok.
enum AppPalette {
    // Regeluitleg: Declareert de waarde `background` voor gebruik binnen de huidige scope.
    static let background = adaptive(light: (0.973, 0.976, 1.0), dark: (0.027, 0.055, 0.094))
    // Regeluitleg: Declareert de waarde `primary` voor gebruik binnen de huidige scope.
    static let primary = adaptive(light: (0.0, 0.094, 0.208), dark: (0.835, 0.890, 1.0))
    // Regeluitleg: Declareert de waarde `primaryContainer` voor gebruik binnen de huidige scope.
    static let primaryContainer = adaptive(light: (0.059, 0.176, 0.322), dark: (0.094, 0.204, 0.345))
    // Regeluitleg: Declareert de waarde `gold` voor gebruik binnen de huidige scope.
    static let gold = adaptive(light: (0.451, 0.361, 0.0), dark: (1.0, 0.824, 0.31))
    // Regeluitleg: Declareert de waarde `goldLight` voor gebruik binnen de huidige scope.
    static let goldLight = adaptive(light: (0.996, 0.839, 0.357), dark: (0.38, 0.294, 0.055))
    // Regeluitleg: Declareert de waarde `surfaceBlue` voor gebruik binnen de huidige scope.
    static let surfaceBlue = adaptive(light: (0.929, 0.957, 1.0), dark: (0.067, 0.118, 0.184))
    // Regeluitleg: Declareert de waarde `textSecondary` voor gebruik binnen de huidige scope.
    static let textSecondary = adaptive(light: (0.263, 0.278, 0.306), dark: (0.68, 0.72, 0.79))
    // Regeluitleg: Declareert de waarde `card` voor gebruik binnen de huidige scope.
    static let card = adaptive(light: (1.0, 1.0, 1.0), dark: (0.055, 0.098, 0.153))
    // Regeluitleg: Declareert de waarde `control` voor gebruik binnen de huidige scope.
    static let control = adaptive(light: (0.0, 0.094, 0.208), dark: (0.12, 0.27, 0.44))
    // Regeluitleg: Declareert de waarde `mediaOverlay` voor gebruik binnen de huidige scope.
    static let mediaOverlay = Color(red: 0.0, green: 0.094, blue: 0.208)

    // Regeluitleg: Definieert de functie `adaptive` en haar invoerwaarden.
    private static func adaptive(
        // Regeluitleg: Geeft de waarde voor parameter of eigenschap `light` door.
        light: (CGFloat, CGFloat, CGFloat),
        // Regeluitleg: Geeft de waarde voor parameter of eigenschap `dark` door.
        dark: (CGFloat, CGFloat, CGFloat)
    // Regeluitleg: Sluit de gegroepeerde argumenten van deze expressie af.
    ) -> Color {
        // Regeluitleg: Maakt en configureert het SwiftUI-element `Color`.
        Color(UIColor { traits in
            // Regeluitleg: Declareert de waarde `rgb` voor gebruik binnen de huidige scope.
            let rgb = traits.userInterfaceStyle == .dark ? dark : light
            // Regeluitleg: Geeft het berekende resultaat terug aan de aanroeper.
            return UIColor(red: rgb.0, green: rgb.1, blue: rgb.2, alpha: 1)
        // Regeluitleg: Sluit het huidige codeblok en de omringende functieaanroep af.
        })
    // Regeluitleg: Sluit het huidige codeblok af.
    }
// Regeluitleg: Sluit het huidige codeblok af.
}
