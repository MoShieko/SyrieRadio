import AVFoundation
import Combine
import SwiftUI
import UIKit

/// Root coordinator for navigation, shared playback state, audio-session events,
/// and the persistent mini-player/ad area.
struct ContentView: View {
    enum Tab: String, CaseIterable {
        case home = "Home"
        case stations = "Stations"
        case favorites = "Favorites"
        case settings = "Settings"

        var icon: String {
            switch self {
            case .home: return "house"
            case .stations: return "radio"
            case .favorites: return "heart"
            case .settings: return "gearshape"
            }
        }
    }

    private let stations = RadioStation.all
    @StateObject private var advertising: AdvertisingManager
    @StateObject private var player: RadioPlayer
    @StateObject private var favorites = FavoritesStore()
    @AppStorage("appLanguageV3") private var appLanguage = ""
    @AppStorage("pauseOnAudioDisconnect") private var pauseOnAudioDisconnect = true
    @AppStorage("appearanceMode") private var appearanceMode = "System"
    @State private var selectedTab: Tab = .home
    @State private var showNowPlaying = false

    init() {
        // RadioPlayer and the views must share this exact manager so a verified
        // Premium entitlement affects both playback ads and banner visibility.
        let advertising = AdvertisingManager()
        _advertising = StateObject(wrappedValue: advertising)
        _player = StateObject(wrappedValue: RadioPlayer(stations: RadioStation.all, advertising: advertising))
    }

    var body: some View {
        ZStack {
            AppPalette.background.ignoresSafeArea()

            Group {
                switch selectedTab {
                case .home:
                    HomeScreen(stations: stations, player: player, favorites: favorites) {
                        selectedTab = .stations
                    }
                case .stations:
                    StationsScreen(stations: stations, player: player, favorites: favorites)
                case .favorites:
                    FavoritesScreen(stations: stations, player: player, favorites: favorites) {
                        selectedTab = .stations
                    }
                case .settings:
                    SettingsScreen(player: player, advertising: advertising)
                }
            }
        }
        .safeAreaInset(edge: .bottom, spacing: 0) {
            VStack(spacing: 8) {
                if advertising.shouldShowAdvertisements,
                   let adUnitID = AdConfiguration.bannerUnitID {
                    AdMobBanner(adUnitID: adUnitID)
                        .frame(width: 320, height: 50)
                }
                if player.hasPlaybackSession {
                    MiniPlayer(player: player, favorites: favorites) {
                        showNowPlaying = true
                    }
                    .padding(.horizontal, 16)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }
                BottomBar(selectedTab: $selectedTab)
            }
            .padding(.top, 8)
        }
        .overlay(alignment: .center) {
            if advertising.isPlayingAudioAdvertisement {
                AudioAdvertisementNotice(seconds: advertising.countdown)
                    .padding(20)
                    .transition(.scale.combined(with: .opacity))
            }
        }
        .sheet(isPresented: $showNowPlaying) {
            NowPlayingScreen(stations: stations, player: player, favorites: favorites)
        }
        .animation(.spring(response: 0.35, dampingFraction: 0.84), value: player.hasPlaybackSession)
        .onAppear {
            chooseInitialLanguageIfNeeded()
            configureAudioSession()
        }
        .onReceive(NotificationCenter.default.publisher(for: AVAudioSession.routeChangeNotification)) { notification in
            handleAudioRouteChange(notification)
        }
        .onReceive(NotificationCenter.default.publisher(for: AVAudioSession.interruptionNotification)) { notification in
            player.handleAudioInterruption(notification)
        }
        .tint(AppPalette.gold)
        .preferredColorScheme(preferredColorScheme)
        .environment(\.locale, Locale(identifier: languageIdentifier))
        .environment(\.layoutDirection, languageIdentifier == "ar" ? .rightToLeft : .leftToRight)
    }

    private var languageIdentifier: String {
        switch appLanguage {
        case "Nederlands": return "nl"
        case "العربية": return "ar"
        case "Deutsch": return "de"
        case "Français": return "fr"
        case "Türkçe": return "tr"
        case "Kurdî": return "ku"
        case "Svenska": return "sv"
        case "Español": return "es"
        case "Italiano": return "it"
        default: return "en"
        }
    }

    private var preferredColorScheme: ColorScheme? {
        switch appearanceMode {
        case "Light": return .light
        case "Dark": return .dark
        default: return nil
        }
    }

    private var systemLanguageIdentifier: String {
        let supported = Set(["ar", "en", "nl", "de", "fr", "tr", "ku", "sv", "es", "it"])
        guard let preferred = Locale.preferredLanguages.first else { return "en" }
        let code = Locale(identifier: preferred).languageCode ?? "en"
        return supported.contains(code) ? code : "en"
    }

    private func chooseInitialLanguageIfNeeded() {
        // Preserve an explicit choice; otherwise mirror the first supported iOS language.
        guard appLanguage.isEmpty else { return }
        switch systemLanguageIdentifier {
        case "nl": appLanguage = "Nederlands"
        case "ar": appLanguage = "العربية"
        case "de": appLanguage = "Deutsch"
        case "fr": appLanguage = "Français"
        case "tr": appLanguage = "Türkçe"
        case "ku": appLanguage = "Kurdî"
        case "sv": appLanguage = "Svenska"
        case "es": appLanguage = "Español"
        case "it": appLanguage = "Italiano"
        default: appLanguage = "English"
        }
    }

    private func configureAudioSession() {
        // The playback category allows live radio to continue with the screen locked.
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            player.reportAudioSetupFailure()
        }
    }

    private func handleAudioRouteChange(_ notification: Notification) {
        // Prevent audio from unexpectedly moving to the phone speaker when a car
        // or Bluetooth output disconnects.
        guard pauseOnAudioDisconnect,
              player.isPlaybackActive,
              let reasonNumber = notification.userInfo?[AVAudioSessionRouteChangeReasonKey] as? NSNumber,
              AVAudioSession.RouteChangeReason(rawValue: reasonNumber.uintValue) == .oldDeviceUnavailable,
              let oldRoute = notification.userInfo?[AVAudioSessionRouteChangePreviousRouteKey] as? AVAudioSessionRouteDescription
        else { return }

        let disconnectableOutputs: Set<AVAudioSession.Port> = [
            .carAudio, .bluetoothA2DP, .bluetoothHFP, .bluetoothLE
        ]
        if oldRoute.outputs.contains(where: { disconnectableOutputs.contains($0.portType) }) {
            player.pause()
        }
    }
}

/// App-wide tab bar. Layout direction stays fixed so the tab order remains
/// predictable while labels still use the selected app language.
private struct BottomBar: View {
    @Binding var selectedTab: ContentView.Tab

    var body: some View {
        GeometryReader { geometry in
            let itemWidth = max((geometry.size.width - 12) / CGFloat(ContentView.Tab.allCases.count), 1)

            ZStack(alignment: .leading) {
                ActiveTabGlass()
                    .frame(width: itemWidth, height: 58)
                    .offset(x: 6 + CGFloat(selectedIndex) * itemWidth)
                    .animation(.spring(response: 0.34, dampingFraction: 0.82), value: selectedTab)

                HStack(spacing: 0) {
                    ForEach(ContentView.Tab.allCases, id: \.self) { tab in
                        let active = selectedTab == tab
                        Button {
                            guard selectedTab != tab else { return }
                            UISelectionFeedbackGenerator().selectionChanged()
                            withAnimation(.spring(response: 0.34, dampingFraction: 0.82)) {
                                selectedTab = tab
                            }
                        } label: {
                            VStack(spacing: 3) {
                                Image(systemName: tab.icon + (active ? ".fill" : ""))
                                    .font(.system(size: 20, weight: .semibold))
                                    .frame(height: 23)
                                Text(LocalizedStringKey(tab.rawValue))
                                    .font(.system(size: 10, weight: active ? .bold : .semibold))
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.75)
                            }
                            .foregroundStyle(active ? AppPalette.gold : AppPalette.textSecondary.opacity(0.72))
                            .frame(maxWidth: .infinity, minHeight: 58)
                            .contentShape(Rectangle())
                        }
                        .buttonStyle(.plain)
                        .accessibilityLabel(Text(LocalizedStringKey(tab.rawValue)))
                        .accessibilityAddTraits(active ? .isSelected : [])
                    }
                }
                .padding(6)
            }
        }
        .frame(height: 70)
        .modifier(DarkGlassBarStyle())
        .padding(.horizontal, 16)
        .padding(.bottom, 8)
        .shadow(color: Color.black.opacity(0.28), radius: 18, y: 9)
        .environment(\.layoutDirection, .leftToRight)
    }

    private var selectedIndex: Int {
        ContentView.Tab.allCases.firstIndex(of: selectedTab) ?? 0
    }
}

private struct DarkGlassBarStyle: ViewModifier {
    private let shape = Capsule()

    @ViewBuilder
    func body(content: Content) -> some View {
        if #available(iOS 26.0, *) {
            content
                .background {
                    ZStack {
                        Color.clear
                            .glassEffect(.regular.tint(AppPalette.card.opacity(0.82)), in: .capsule)
                        shape
                            .fill(AppPalette.card.opacity(0.60))
                    }
                }
                .overlay { glassEdge }
        } else {
            content
                .background(.ultraThinMaterial, in: shape)
                .background(shape.fill(AppPalette.background.opacity(0.95)))
                .overlay { glassEdge }
        }
    }

    private var glassEdge: some View {
        shape.stroke(
            LinearGradient(
                colors: [Color.white.opacity(0.88), AppPalette.gold.opacity(0.28), AppPalette.primary.opacity(0.10)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ),
            lineWidth: 0.9
        )
        .allowsHitTesting(false)
    }
}

private struct ActiveTabGlass: View {
    var body: some View {
        Group {
            if #available(iOS 26.0, *) {
                ZStack {
                    Color.clear
                        .glassEffect(.regular.tint(AppPalette.card.opacity(0.76)), in: .rect(cornerRadius: 24))
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .fill(AppPalette.card.opacity(0.44))
                }
            } else {
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .fill(AppPalette.card.opacity(0.92))
                    .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 24, style: .continuous))
            }
        }
        .overlay {
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .stroke(Color.white.opacity(0.64), lineWidth: 0.7)
        }
        .shadow(color: Color.black.opacity(0.18), radius: 8, y: 4)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View { ContentView() }
}
