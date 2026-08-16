// Regeluitleg: Importeert het framework `AVFoundation` voor de functionaliteit in dit bestand.
import AVFoundation
// Regeluitleg: Importeert het framework `Combine` voor de functionaliteit in dit bestand.
import Combine
// Regeluitleg: Importeert het framework `SwiftUI` voor de functionaliteit in dit bestand.
import SwiftUI
// Regeluitleg: Importeert het framework `UIKit` voor de functionaliteit in dit bestand.
import UIKit

/// Hoofdcoördinator voor navigatie, gedeelde afspeelstatus en audiosessiegebeurtenissen,
/// plus het blijvende gebied voor minispeler en reclame.
// Regeluitleg: Definieert de structuur `ContentView` en opent het bijbehorende codeblok.
struct ContentView: View {
    // Regeluitleg: Definieert de opsomming `Tab` en opent het bijbehorende codeblok.
    enum Tab: String, CaseIterable {
        // Regeluitleg: Declareert of behandelt de enumwaarde `home`.
        case home = "Home"
        // Regeluitleg: Declareert of behandelt de enumwaarde `stations`.
        case stations = "Stations"
        // Regeluitleg: Declareert of behandelt de enumwaarde `favorites`.
        case favorites = "Favorites"
        // Regeluitleg: Declareert of behandelt de enumwaarde `settings`.
        case settings = "Settings"

        // Regeluitleg: Declareert de waarde `icon` voor gebruik binnen de huidige scope.
        var icon: String {
            // Regeluitleg: Kiest een uitvoerpad op basis van `self`.
            switch self {
            // Regeluitleg: Declareert of behandelt de enumwaarde `.home`.
            case .home: return "house"
            // Regeluitleg: Declareert of behandelt de enumwaarde `.stations`.
            case .stations: return "radio"
            // Regeluitleg: Declareert of behandelt de enumwaarde `.favorites`.
            case .favorites: return "heart"
            // Regeluitleg: Declareert of behandelt de enumwaarde `.settings`.
            case .settings: return "gearshape"
            // Regeluitleg: Sluit het huidige codeblok af.
            }
        // Regeluitleg: Sluit het huidige codeblok af.
        }
    // Regeluitleg: Sluit het huidige codeblok af.
    }

    // Regeluitleg: Declareert de waarde `stations` voor gebruik binnen de huidige scope.
    private let stations = RadioStation.all
    // Regeluitleg: Declareert `advertising` met de SwiftUI-propertywrapper `@StateObject`.
    @StateObject private var advertising: AdvertisingManager
    // Regeluitleg: Declareert `player` met de SwiftUI-propertywrapper `@StateObject`.
    @StateObject private var player: RadioPlayer
    // Regeluitleg: Declareert `favorites` met de SwiftUI-propertywrapper `@StateObject`.
    @StateObject private var favorites = FavoritesStore()
    // Regeluitleg: Declareert `appLanguage` met de SwiftUI-propertywrapper `@AppStorage`.
    @AppStorage("appLanguageV3") private var appLanguage = ""
    // Regeluitleg: Declareert `pauseOnAudioDisconnect` met de SwiftUI-propertywrapper `@AppStorage`.
    @AppStorage("pauseOnAudioDisconnect") private var pauseOnAudioDisconnect = true
    // Regeluitleg: Declareert `appearanceMode` met de SwiftUI-propertywrapper `@AppStorage`.
    @AppStorage("appearanceMode") private var appearanceMode = "System"
    // Regeluitleg: Declareert `selectedTab` met de SwiftUI-propertywrapper `@State`.
    @State private var selectedTab: Tab = .home
    // Regeluitleg: Declareert `showNowPlaying` met de SwiftUI-propertywrapper `@State`.
    @State private var showNowPlaying = false

    // Regeluitleg: Definieert de initializer die een nieuwe instantie configureert.
    init() {
        // RadioPlayer en de schermen moeten exact deze manager delen, zodat een geverifieerd
        // Premium-recht zowel afspeelreclame als de zichtbaarheid van banners bepaalt.
        // Regeluitleg: Declareert de waarde `advertising` voor gebruik binnen de huidige scope.
        let advertising = AdvertisingManager()
        // Regeluitleg: Werkt de waarde `_advertising` bij met het resultaat van deze expressie.
        _advertising = StateObject(wrappedValue: advertising)
        // Regeluitleg: Werkt de waarde `_player` bij met het resultaat van deze expressie.
        _player = StateObject(wrappedValue: RadioPlayer(stations: RadioStation.all, advertising: advertising))
    // Regeluitleg: Sluit het huidige codeblok af.
    }

    // Regeluitleg: Declareert de waarde `body` voor gebruik binnen de huidige scope.
    var body: some View {
        // Regeluitleg: Maakt en configureert het SwiftUI-element `ZStack`.
        ZStack {
            // Regeluitleg: Roept `AppPalette.background.ignoresSafeArea` aan met de argumenten in deze expressie.
            AppPalette.background.ignoresSafeArea()

            // Regeluitleg: Maakt en configureert het SwiftUI-element `Group`.
            Group {
                // Regeluitleg: Kiest een uitvoerpad op basis van `selectedTab`.
                switch selectedTab {
                // Regeluitleg: Declareert of behandelt de enumwaarde `.home`.
                case .home:
                    // Regeluitleg: Roept `HomeScreen` aan met de argumenten in deze expressie.
                    HomeScreen(stations: stations, player: player, favorites: favorites) {
                        // Regeluitleg: Werkt de waarde `selectedTab` bij met het resultaat van deze expressie.
                        selectedTab = .stations
                    // Regeluitleg: Sluit het huidige codeblok af.
                    }
                // Regeluitleg: Declareert of behandelt de enumwaarde `.stations`.
                case .stations:
                    // Regeluitleg: Roept `StationsScreen` aan met de argumenten in deze expressie.
                    StationsScreen(stations: stations, player: player, favorites: favorites)
                // Regeluitleg: Declareert of behandelt de enumwaarde `.favorites`.
                case .favorites:
                    // Regeluitleg: Roept `FavoritesScreen` aan met de argumenten in deze expressie.
                    FavoritesScreen(stations: stations, player: player, favorites: favorites) {
                        // Regeluitleg: Werkt de waarde `selectedTab` bij met het resultaat van deze expressie.
                        selectedTab = .stations
                    // Regeluitleg: Sluit het huidige codeblok af.
                    }
                // Regeluitleg: Declareert of behandelt de enumwaarde `.settings`.
                case .settings:
                    // Regeluitleg: Roept `SettingsScreen` aan met de argumenten in deze expressie.
                    SettingsScreen(player: player, advertising: advertising)
                // Regeluitleg: Sluit het huidige codeblok af.
                }
            // Regeluitleg: Sluit het huidige codeblok af.
            }
        // Regeluitleg: Sluit het huidige codeblok af.
        }
        // Regeluitleg: Reserveert ruimte aan de veilige schermrand voor blijvende bediening.
        .safeAreaInset(edge: .bottom, spacing: 0) {
            // Regeluitleg: Maakt en configureert het SwiftUI-element `VStack`.
            VStack(spacing: 8) {
                // Regeluitleg: Voert het volgende codeblok alleen uit wanneer deze voorwaarde waar is.
                if advertising.shouldShowAdvertisements,
                   // Regeluitleg: Declareert de waarde `adUnitID` voor gebruik binnen de huidige scope.
                   let adUnitID = AdConfiguration.bannerUnitID {
                    // Regeluitleg: Roept `AdMobBanner` aan met de argumenten in deze expressie.
                    AdMobBanner(adUnitID: adUnitID)
                        // Regeluitleg: Bepaalt de afmetingen en uitlijning van dit interface-element.
                        .frame(width: 320, height: 50)
                // Regeluitleg: Sluit het huidige codeblok af.
                }
                // Regeluitleg: Voert het volgende codeblok alleen uit wanneer deze voorwaarde waar is.
                if player.hasPlaybackSession {
                    // Regeluitleg: Roept `MiniPlayer` aan met de argumenten in deze expressie.
                    MiniPlayer(player: player, favorites: favorites) {
                        // Regeluitleg: Werkt de waarde `showNowPlaying` bij met het resultaat van deze expressie.
                        showNowPlaying = true
                    // Regeluitleg: Sluit het huidige codeblok af.
                    }
                    // Regeluitleg: Voegt de opgegeven binnenruimte rond dit interface-element toe.
                    .padding(.horizontal, 16)
                    // Regeluitleg: Bepaalt de overgang waarmee dit interface-element verschijnt of verdwijnt.
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                // Regeluitleg: Sluit het huidige codeblok af.
                }
                // Regeluitleg: Roept `BottomBar` aan met de argumenten in deze expressie.
                BottomBar(selectedTab: $selectedTab)
            // Regeluitleg: Sluit het huidige codeblok af.
            }
            // Regeluitleg: Voegt de opgegeven binnenruimte rond dit interface-element toe.
            .padding(.top, 8)
        // Regeluitleg: Sluit het huidige codeblok af.
        }
        // Regeluitleg: Legt de opgegeven inhoud over dit interface-element.
        .overlay(alignment: .center) {
            // Regeluitleg: Voert het volgende codeblok alleen uit wanneer deze voorwaarde waar is.
            if advertising.isPlayingAudioAdvertisement {
                // Regeluitleg: Roept `AudioAdvertisementNotice` aan met de argumenten in deze expressie.
                AudioAdvertisementNotice(seconds: advertising.countdown)
                    // Regeluitleg: Voegt de opgegeven binnenruimte rond dit interface-element toe.
                    .padding(20)
                    // Regeluitleg: Bepaalt de overgang waarmee dit interface-element verschijnt of verdwijnt.
                    .transition(.scale.combined(with: .opacity))
            // Regeluitleg: Sluit het huidige codeblok af.
            }
        // Regeluitleg: Sluit het huidige codeblok af.
        }
        // Regeluitleg: Presenteert het gekoppelde modale scherm wanneer de status actief is.
        .sheet(isPresented: $showNowPlaying) {
            // Regeluitleg: Roept `NowPlayingScreen` aan met de argumenten in deze expressie.
            NowPlayingScreen(stations: stations, player: player, favorites: favorites)
        // Regeluitleg: Sluit het huidige codeblok af.
        }
        // Regeluitleg: Koppelt de opgegeven animatie aan deze statuswijziging.
        .animation(.spring(response: 0.35, dampingFraction: 0.84), value: player.hasPlaybackSession)
        // Regeluitleg: Gebruikt de enumwaarde of gekoppelde optie `onAppear` in de huidige expressie.
        .onAppear {
            // Regeluitleg: Roept `chooseInitialLanguageIfNeeded` aan met de argumenten in deze expressie.
            chooseInitialLanguageIfNeeded()
            // Regeluitleg: Roept `configureAudioSession` aan met de argumenten in deze expressie.
            configureAudioSession()
        // Regeluitleg: Sluit het huidige codeblok af.
        }
        // Regeluitleg: Reageert op nieuwe waarden van de gekoppelde publisher.
        .onReceive(NotificationCenter.default.publisher(for: AVAudioSession.routeChangeNotification)) { notification in
            // Regeluitleg: Roept `handleAudioRouteChange` aan met de argumenten in deze expressie.
            handleAudioRouteChange(notification)
        // Regeluitleg: Sluit het huidige codeblok af.
        }
        // Regeluitleg: Reageert op nieuwe waarden van de gekoppelde publisher.
        .onReceive(NotificationCenter.default.publisher(for: AVAudioSession.interruptionNotification)) { notification in
            // Regeluitleg: Roept `player.handleAudioInterruption` aan met de argumenten in deze expressie.
            player.handleAudioInterruption(notification)
        // Regeluitleg: Sluit het huidige codeblok af.
        }
        // Regeluitleg: Past de accentkleur van dit interface-element aan.
        .tint(AppPalette.gold)
        // Regeluitleg: Past het gekozen lichte, donkere of systeemthema toe.
        .preferredColorScheme(preferredColorScheme)
        // Regeluitleg: Geeft deze omgevingswaarde door aan onderliggende SwiftUI-schermen.
        .environment(\.locale, Locale(identifier: languageIdentifier))
        // Regeluitleg: Geeft deze omgevingswaarde door aan onderliggende SwiftUI-schermen.
        .environment(\.layoutDirection, languageIdentifier == "ar" ? .rightToLeft : .leftToRight)
    // Regeluitleg: Sluit het huidige codeblok af.
    }

    // Regeluitleg: Declareert de waarde `languageIdentifier` voor gebruik binnen de huidige scope.
    private var languageIdentifier: String {
        // Regeluitleg: Kiest een uitvoerpad op basis van `appLanguage`.
        switch appLanguage {
        // Regeluitleg: Declareert of behandelt de enumwaarde `"Nederlands"`.
        case "Nederlands": return "nl"
        // Regeluitleg: Declareert of behandelt de enumwaarde `"العربية"`.
        case "العربية": return "ar"
        // Regeluitleg: Declareert of behandelt de enumwaarde `"Deutsch"`.
        case "Deutsch": return "de"
        // Regeluitleg: Declareert of behandelt de enumwaarde `"Français"`.
        case "Français": return "fr"
        // Regeluitleg: Declareert of behandelt de enumwaarde `"Türkçe"`.
        case "Türkçe": return "tr"
        // Regeluitleg: Declareert of behandelt de enumwaarde `"Kurdî"`.
        case "Kurdî": return "ku"
        // Regeluitleg: Declareert of behandelt de enumwaarde `"Svenska"`.
        case "Svenska": return "sv"
        // Regeluitleg: Declareert of behandelt de enumwaarde `"Español"`.
        case "Español": return "es"
        // Regeluitleg: Declareert of behandelt de enumwaarde `"Italiano"`.
        case "Italiano": return "it"
        // Regeluitleg: Geeft de waarde voor parameter of eigenschap `default` door.
        default: return "en"
        // Regeluitleg: Sluit het huidige codeblok af.
        }
    // Regeluitleg: Sluit het huidige codeblok af.
    }

    // Regeluitleg: Declareert de waarde `preferredColorScheme` voor gebruik binnen de huidige scope.
    private var preferredColorScheme: ColorScheme? {
        // Regeluitleg: Kiest een uitvoerpad op basis van `appearanceMode`.
        switch appearanceMode {
        // Regeluitleg: Declareert of behandelt de enumwaarde `"Light"`.
        case "Light": return .light
        // Regeluitleg: Declareert of behandelt de enumwaarde `"Dark"`.
        case "Dark": return .dark
        // Regeluitleg: Geeft de waarde voor parameter of eigenschap `default` door.
        default: return nil
        // Regeluitleg: Sluit het huidige codeblok af.
        }
    // Regeluitleg: Sluit het huidige codeblok af.
    }

    // Regeluitleg: Declareert de waarde `systemLanguageIdentifier` voor gebruik binnen de huidige scope.
    private var systemLanguageIdentifier: String {
        // Regeluitleg: Declareert de waarde `supported` voor gebruik binnen de huidige scope.
        let supported = Set(["ar", "en", "nl", "de", "fr", "tr", "ku", "sv", "es", "it"])
        // Regeluitleg: Controleert de vereiste voorwaarden en verlaat de huidige bewerking als die niet gelden.
        guard let preferred = Locale.preferredLanguages.first else { return "en" }
        // Regeluitleg: Declareert de waarde `code` voor gebruik binnen de huidige scope.
        let code = Locale(identifier: preferred).languageCode ?? "en"
        // Regeluitleg: Geeft het berekende resultaat terug aan de aanroeper.
        return supported.contains(code) ? code : "en"
    // Regeluitleg: Sluit het huidige codeblok af.
    }

    // Regeluitleg: Definieert de functie `chooseInitialLanguageIfNeeded` en haar invoerwaarden.
    private func chooseInitialLanguageIfNeeded() {
        // Behoud een expliciete keuze; gebruik anders de eerste ondersteunde iOS-taal.
        // Regeluitleg: Controleert de vereiste voorwaarden en verlaat de huidige bewerking als die niet gelden.
        guard appLanguage.isEmpty else { return }
        // Regeluitleg: Kiest een uitvoerpad op basis van `systemLanguageIdentifier`.
        switch systemLanguageIdentifier {
        // Regeluitleg: Declareert of behandelt de enumwaarde `"nl"`.
        case "nl": appLanguage = "Nederlands"
        // Regeluitleg: Declareert of behandelt de enumwaarde `"ar"`.
        case "ar": appLanguage = "العربية"
        // Regeluitleg: Declareert of behandelt de enumwaarde `"de"`.
        case "de": appLanguage = "Deutsch"
        // Regeluitleg: Declareert of behandelt de enumwaarde `"fr"`.
        case "fr": appLanguage = "Français"
        // Regeluitleg: Declareert of behandelt de enumwaarde `"tr"`.
        case "tr": appLanguage = "Türkçe"
        // Regeluitleg: Declareert of behandelt de enumwaarde `"ku"`.
        case "ku": appLanguage = "Kurdî"
        // Regeluitleg: Declareert of behandelt de enumwaarde `"sv"`.
        case "sv": appLanguage = "Svenska"
        // Regeluitleg: Declareert of behandelt de enumwaarde `"es"`.
        case "es": appLanguage = "Español"
        // Regeluitleg: Declareert of behandelt de enumwaarde `"it"`.
        case "it": appLanguage = "Italiano"
        // Regeluitleg: Geeft de waarde voor parameter of eigenschap `default` door.
        default: appLanguage = "English"
        // Regeluitleg: Sluit het huidige codeblok af.
        }
    // Regeluitleg: Sluit het huidige codeblok af.
    }

    // Regeluitleg: Definieert de functie `configureAudioSession` en haar invoerwaarden.
    private func configureAudioSession() {
        // De afspeelcategorie laat live radio doorgaan wanneer het scherm vergrendeld is.
        // Regeluitleg: Opent een foutafhandelbaar codeblok.
        do {
            // Regeluitleg: Voert deze mogelijk werpende bewerking uit volgens de gekozen foutafhandeling.
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            // Regeluitleg: Voert deze mogelijk werpende bewerking uit volgens de gekozen foutafhandeling.
            try AVAudioSession.sharedInstance().setActive(true)
        // Regeluitleg: Sluit de normale uitvoering en verwerkt de opgetreden fout.
        } catch {
            // Regeluitleg: Roept `player.reportAudioSetupFailure` aan met de argumenten in deze expressie.
            player.reportAudioSetupFailure()
        // Regeluitleg: Sluit het huidige codeblok af.
        }
    // Regeluitleg: Sluit het huidige codeblok af.
    }

    // Regeluitleg: Definieert de functie `handleAudioRouteChange` en haar invoerwaarden.
    private func handleAudioRouteChange(_ notification: Notification) {
        // Voorkom dat audio onverwacht naar de telefoonluidspreker gaat wanneer een auto-
        // of Bluetooth-uitgang de verbinding verliest.
        // Regeluitleg: Controleert de vereiste voorwaarden en verlaat de huidige bewerking als die niet gelden.
        guard pauseOnAudioDisconnect,
              // Regeluitleg: Voegt deze waarde of dit argument toe aan de huidige lijst.
              player.isPlaybackActive,
              // Regeluitleg: Declareert de waarde `reasonNumber` voor gebruik binnen de huidige scope.
              let reasonNumber = notification.userInfo?[AVAudioSessionRouteChangeReasonKey] as? NSNumber,
              // Regeluitleg: Roept `AVAudioSession.RouteChangeReason` aan met de argumenten in deze expressie.
              AVAudioSession.RouteChangeReason(rawValue: reasonNumber.uintValue) == .oldDeviceUnavailable,
              // Regeluitleg: Declareert de waarde `oldRoute` voor gebruik binnen de huidige scope.
              let oldRoute = notification.userInfo?[AVAudioSessionRouteChangePreviousRouteKey] as? AVAudioSessionRouteDescription
        // Regeluitleg: Opent het alternatieve uitvoerpad wanneer de vorige voorwaarde niet geldt.
        else { return }

        // Regeluitleg: Declareert de waarde `disconnectableOutputs` voor gebruik binnen de huidige scope.
        let disconnectableOutputs: Set<AVAudioSession.Port> = [
            // Regeluitleg: Gebruikt de enumwaarde of gekoppelde optie `carAudio` in de huidige expressie.
            .carAudio, .bluetoothA2DP, .bluetoothHFP, .bluetoothLE
        // Regeluitleg: Sluit de huidige collectie of subscriptexpressie af.
        ]
        // Regeluitleg: Voert het volgende codeblok alleen uit wanneer deze voorwaarde waar is.
        if oldRoute.outputs.contains(where: { disconnectableOutputs.contains($0.portType) }) {
            // Regeluitleg: Roept `player.pause` aan met de argumenten in deze expressie.
            player.pause()
        // Regeluitleg: Sluit het huidige codeblok af.
        }
    // Regeluitleg: Sluit het huidige codeblok af.
    }
// Regeluitleg: Sluit het huidige codeblok af.
}

/// Tabbladbalk voor de hele app. De lay-outrichting blijft vast, zodat de volgorde
/// voorspelbaar blijft terwijl labels de gekozen app-taal gebruiken.
// Regeluitleg: Definieert de structuur `BottomBar` en opent het bijbehorende codeblok.
private struct BottomBar: View {
    // Regeluitleg: Declareert `selectedTab` met de SwiftUI-propertywrapper `@Binding`.
    @Binding var selectedTab: ContentView.Tab

    // Regeluitleg: Declareert de waarde `body` voor gebruik binnen de huidige scope.
    var body: some View {
        // Regeluitleg: Maakt en configureert het SwiftUI-element `GeometryReader`.
        GeometryReader { geometry in
            // Regeluitleg: Declareert de waarde `itemWidth` voor gebruik binnen de huidige scope.
            let itemWidth = max((geometry.size.width - 12) / CGFloat(ContentView.Tab.allCases.count), 1)

            // Regeluitleg: Maakt en configureert het SwiftUI-element `ZStack`.
            ZStack(alignment: .leading) {
                // Regeluitleg: Roept `ActiveTabGlass` aan met de argumenten in deze expressie.
                ActiveTabGlass()
                    // Regeluitleg: Bepaalt de afmetingen en uitlijning van dit interface-element.
                    .frame(width: itemWidth, height: 58)
                    // Regeluitleg: Verplaatst dit interface-element met de opgegeven afstand.
                    .offset(x: 6 + CGFloat(selectedIndex) * itemWidth)
                    // Regeluitleg: Koppelt de opgegeven animatie aan deze statuswijziging.
                    .animation(.spring(response: 0.34, dampingFraction: 0.82), value: selectedTab)

                // Regeluitleg: Maakt en configureert het SwiftUI-element `HStack`.
                HStack(spacing: 0) {
                    // Regeluitleg: Maakt en configureert het SwiftUI-element `ForEach`.
                    ForEach(ContentView.Tab.allCases, id: \.self) { tab in
                        // Regeluitleg: Declareert de waarde `active` voor gebruik binnen de huidige scope.
                        let active = selectedTab == tab
                        // Regeluitleg: Maakt en configureert het SwiftUI-element `Button`.
                        Button {
                            // Regeluitleg: Controleert de vereiste voorwaarden en verlaat de huidige bewerking als die niet gelden.
                            guard selectedTab != tab else { return }
                            // Regeluitleg: Roept `UISelectionFeedbackGenerator` aan met de argumenten in deze expressie.
                            UISelectionFeedbackGenerator().selectionChanged()
                            // Regeluitleg: Roept `withAnimation` aan met de argumenten in deze expressie.
                            withAnimation(.spring(response: 0.34, dampingFraction: 0.82)) {
                                // Regeluitleg: Werkt de waarde `selectedTab` bij met het resultaat van deze expressie.
                                selectedTab = tab
                            // Regeluitleg: Sluit het huidige codeblok af.
                            }
                        // Regeluitleg: Opent het codeblok voor deze declaratie of bewerking.
                        } label: {
                            // Regeluitleg: Maakt en configureert het SwiftUI-element `VStack`.
                            VStack(spacing: 3) {
                                // Regeluitleg: Maakt en configureert het SwiftUI-element `Image`.
                                Image(systemName: tab.icon + (active ? ".fill" : ""))
                                    // Regeluitleg: Stelt het lettertype voor dit interface-element in.
                                    .font(.system(size: 20, weight: .semibold))
                                    // Regeluitleg: Bepaalt de afmetingen en uitlijning van dit interface-element.
                                    .frame(height: 23)
                                // Regeluitleg: Maakt en configureert het SwiftUI-element `Text`.
                                Text(LocalizedStringKey(tab.rawValue))
                                    // Regeluitleg: Stelt het lettertype voor dit interface-element in.
                                    .font(.system(size: 10, weight: active ? .bold : .semibold))
                                    // Regeluitleg: Beperkt het aantal zichtbare tekstregels.
                                    .lineLimit(1)
                                    // Regeluitleg: Staat toe dat tekst verkleint om binnen de beschikbare ruimte te passen.
                                    .minimumScaleFactor(0.75)
                            // Regeluitleg: Sluit het huidige codeblok af.
                            }
                            // Regeluitleg: Stelt de voorgrondstijl van dit interface-element in.
                            .foregroundStyle(active ? AppPalette.gold : AppPalette.textSecondary.opacity(0.72))
                            // Regeluitleg: Bepaalt de afmetingen en uitlijning van dit interface-element.
                            .frame(maxWidth: .infinity, minHeight: 58)
                            // Regeluitleg: Bepaalt het volledige interactieve gebied van dit element.
                            .contentShape(Rectangle())
                        // Regeluitleg: Sluit het huidige codeblok af.
                        }
                        // Regeluitleg: Past de opgegeven knopstijl toe.
                        .buttonStyle(.plain)
                        // Regeluitleg: Geeft VoiceOver een duidelijk toegankelijkheidslabel.
                        .accessibilityLabel(Text(LocalizedStringKey(tab.rawValue)))
                        // Regeluitleg: Voegt de opgegeven toegankelijkheidskenmerken toe.
                        .accessibilityAddTraits(active ? .isSelected : [])
                    // Regeluitleg: Sluit het huidige codeblok af.
                    }
                // Regeluitleg: Sluit het huidige codeblok af.
                }
                // Regeluitleg: Voegt de opgegeven binnenruimte rond dit interface-element toe.
                .padding(6)
            // Regeluitleg: Sluit het huidige codeblok af.
            }
        // Regeluitleg: Sluit het huidige codeblok af.
        }
        // Regeluitleg: Bepaalt de afmetingen en uitlijning van dit interface-element.
        .frame(height: 70)
        // Regeluitleg: Past de opgegeven herbruikbare SwiftUI-modifier toe.
        .modifier(DarkGlassBarStyle())
        // Regeluitleg: Voegt de opgegeven binnenruimte rond dit interface-element toe.
        .padding(.horizontal, 16)
        // Regeluitleg: Voegt de opgegeven binnenruimte rond dit interface-element toe.
        .padding(.bottom, 8)
        // Regeluitleg: Voegt de opgegeven schaduw aan dit interface-element toe.
        .shadow(color: Color.black.opacity(0.28), radius: 18, y: 9)
        // Regeluitleg: Geeft deze omgevingswaarde door aan onderliggende SwiftUI-schermen.
        .environment(\.layoutDirection, .leftToRight)
    // Regeluitleg: Sluit het huidige codeblok af.
    }

    // Regeluitleg: Declareert de waarde `selectedIndex` voor gebruik binnen de huidige scope.
    private var selectedIndex: Int {
        // Regeluitleg: Roept `ContentView.Tab.allCases.firstIndex` aan met de argumenten in deze expressie.
        ContentView.Tab.allCases.firstIndex(of: selectedTab) ?? 0
    // Regeluitleg: Sluit het huidige codeblok af.
    }
// Regeluitleg: Sluit het huidige codeblok af.
}

// Regeluitleg: Definieert de structuur `DarkGlassBarStyle` en opent het bijbehorende codeblok.
private struct DarkGlassBarStyle: ViewModifier {
    // Regeluitleg: Declareert de waarde `shape` voor gebruik binnen de huidige scope.
    private let shape = Capsule()

    // Regeluitleg: Laat deze declaratie meerdere SwiftUI-weergaven als één inhoudsblok bouwen.
    @ViewBuilder
    // Regeluitleg: Definieert de functie `body` en haar invoerwaarden.
    func body(content: Content) -> some View {
        // Regeluitleg: Voert het volgende codeblok alleen uit wanneer deze voorwaarde waar is.
        if #available(iOS 26.0, *) {
            // Regeluitleg: Voert deze instructie uit als onderdeel van de huidige bewerking.
            content
                // Regeluitleg: Gebruikt de enumwaarde of gekoppelde optie `background` in de huidige expressie.
                .background {
                    // Regeluitleg: Maakt en configureert het SwiftUI-element `ZStack`.
                    ZStack {
                        // Regeluitleg: Maakt en configureert het SwiftUI-element `Color`.
                        Color.clear
                            // Regeluitleg: Past de SwiftUI-modifier of gekoppelde bewerking `glassEffect` toe.
                            .glassEffect(.regular.tint(AppPalette.card.opacity(0.82)), in: .capsule)
                        // Regeluitleg: Voert deze instructie uit als onderdeel van de huidige bewerking.
                        shape
                            // Regeluitleg: Past de SwiftUI-modifier of gekoppelde bewerking `fill` toe.
                            .fill(AppPalette.card.opacity(0.60))
                    // Regeluitleg: Sluit het huidige codeblok af.
                    }
                // Regeluitleg: Sluit het huidige codeblok af.
                }
                // Regeluitleg: Gebruikt de enumwaarde of gekoppelde optie `overlay` in de huidige expressie.
                .overlay { glassEdge }
        // Regeluitleg: Sluit de vorige tak en opent het alternatieve uitvoerpad.
        } else {
            // Regeluitleg: Voert deze instructie uit als onderdeel van de huidige bewerking.
            content
                // Regeluitleg: Voegt de opgegeven achtergrond aan dit interface-element toe.
                .background(.ultraThinMaterial, in: shape)
                // Regeluitleg: Voegt de opgegeven achtergrond aan dit interface-element toe.
                .background(shape.fill(AppPalette.background.opacity(0.95)))
                // Regeluitleg: Gebruikt de enumwaarde of gekoppelde optie `overlay` in de huidige expressie.
                .overlay { glassEdge }
        // Regeluitleg: Sluit het huidige codeblok af.
        }
    // Regeluitleg: Sluit het huidige codeblok af.
    }

    // Regeluitleg: Declareert de waarde `glassEdge` voor gebruik binnen de huidige scope.
    private var glassEdge: some View {
        // Regeluitleg: Roept `shape.stroke` aan met de argumenten in deze expressie.
        shape.stroke(
            // Regeluitleg: Maakt en configureert het SwiftUI-element `LinearGradient`.
            LinearGradient(
                // Regeluitleg: Geeft de waarde voor parameter of eigenschap `colors` door.
                colors: [Color.white.opacity(0.88), AppPalette.gold.opacity(0.28), AppPalette.primary.opacity(0.10)],
                // Regeluitleg: Geeft de waarde voor parameter of eigenschap `startPoint` door.
                startPoint: .topLeading,
                // Regeluitleg: Geeft de waarde voor parameter of eigenschap `endPoint` door.
                endPoint: .bottomTrailing
            // Regeluitleg: Sluit de gegroepeerde argumenten van deze expressie af.
            ),
            // Regeluitleg: Geeft de waarde voor parameter of eigenschap `lineWidth` door.
            lineWidth: 0.9
        // Regeluitleg: Sluit de gegroepeerde argumenten van deze expressie af.
        )
        // Regeluitleg: Past de SwiftUI-modifier of gekoppelde bewerking `allowsHitTesting` toe.
        .allowsHitTesting(false)
    // Regeluitleg: Sluit het huidige codeblok af.
    }
// Regeluitleg: Sluit het huidige codeblok af.
}

// Regeluitleg: Definieert de structuur `ActiveTabGlass` en opent het bijbehorende codeblok.
private struct ActiveTabGlass: View {
    // Regeluitleg: Declareert de waarde `body` voor gebruik binnen de huidige scope.
    var body: some View {
        // Regeluitleg: Maakt en configureert het SwiftUI-element `Group`.
        Group {
            // Regeluitleg: Voert het volgende codeblok alleen uit wanneer deze voorwaarde waar is.
            if #available(iOS 26.0, *) {
                // Regeluitleg: Maakt en configureert het SwiftUI-element `ZStack`.
                ZStack {
                    // Regeluitleg: Maakt en configureert het SwiftUI-element `Color`.
                    Color.clear
                        // Regeluitleg: Past de SwiftUI-modifier of gekoppelde bewerking `glassEffect` toe.
                        .glassEffect(.regular.tint(AppPalette.card.opacity(0.76)), in: .rect(cornerRadius: 24))
                    // Regeluitleg: Maakt en configureert het SwiftUI-element `RoundedRectangle`.
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        // Regeluitleg: Past de SwiftUI-modifier of gekoppelde bewerking `fill` toe.
                        .fill(AppPalette.card.opacity(0.44))
                // Regeluitleg: Sluit het huidige codeblok af.
                }
            // Regeluitleg: Sluit de vorige tak en opent het alternatieve uitvoerpad.
            } else {
                // Regeluitleg: Maakt en configureert het SwiftUI-element `RoundedRectangle`.
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    // Regeluitleg: Past de SwiftUI-modifier of gekoppelde bewerking `fill` toe.
                    .fill(AppPalette.card.opacity(0.92))
                    // Regeluitleg: Voegt de opgegeven achtergrond aan dit interface-element toe.
                    .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 24, style: .continuous))
            // Regeluitleg: Sluit het huidige codeblok af.
            }
        // Regeluitleg: Sluit het huidige codeblok af.
        }
        // Regeluitleg: Gebruikt de enumwaarde of gekoppelde optie `overlay` in de huidige expressie.
        .overlay {
            // Regeluitleg: Maakt en configureert het SwiftUI-element `RoundedRectangle`.
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                // Regeluitleg: Past de SwiftUI-modifier of gekoppelde bewerking `stroke` toe.
                .stroke(Color.white.opacity(0.64), lineWidth: 0.7)
        // Regeluitleg: Sluit het huidige codeblok af.
        }
        // Regeluitleg: Voegt de opgegeven schaduw aan dit interface-element toe.
        .shadow(color: Color.black.opacity(0.18), radius: 8, y: 4)
    // Regeluitleg: Sluit het huidige codeblok af.
    }
// Regeluitleg: Sluit het huidige codeblok af.
}

// Regeluitleg: Definieert de structuur `ContentView_Previews` en opent het bijbehorende codeblok.
struct ContentView_Previews: PreviewProvider {
    // Regeluitleg: Declareert de waarde `previews` voor gebruik binnen de huidige scope.
    static var previews: some View { ContentView() }
// Regeluitleg: Sluit het huidige codeblok af.
}
