import AVKit
import Combine
import MediaPlayer
import StoreKit
import SwiftUI

struct AppHeader: View {
    let title: LocalizedStringKey
    var centered = false

    var body: some View {
        HStack(spacing: 10) {
            if centered { Spacer() }
            if !centered {
                ZStack {
                    Circle()
                        .fill(AppPalette.primary.opacity(0.10))
                    Image(systemName: "dot.radiowaves.left.and.right")
                        .font(.system(size: 15, weight: .bold))
                        .foregroundStyle(AppPalette.gold)
                }
                .frame(width: 34, height: 34)
            }
            Text(title)
                .font(.system(size: centered ? 13 : 28, weight: .bold, design: .rounded))
                .foregroundStyle(AppPalette.primary)
                .textCase(centered ? .uppercase : nil)
            if centered { Spacer() }
        }
        .padding(.horizontal, 14)
        .frame(maxWidth: .infinity, minHeight: 58)
    }
}

private struct GlassHeaderLayout<Content: View>: View {
    let title: LocalizedStringKey
    @ViewBuilder let content: () -> Content

    var body: some View {
        ZStack(alignment: .top) {
            content()
            AppHeader(title: title)
                .padding(.horizontal, 20)
                .padding(.top, 8)
                .zIndex(10)
        }
    }
}

struct SearchField: View {
    @Binding var text: String
    let placeholder: LocalizedStringKey

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "magnifyingglass").foregroundStyle(AppPalette.textSecondary)
            TextField(
                "",
                text: $text,
                prompt: Text(placeholder)
                    .foregroundColor(AppPalette.textSecondary.opacity(0.72))
            )
                .foregroundColor(AppPalette.primary)
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)
        }
        .padding(.horizontal, 16)
        .frame(height: 48)
        .background(AppPalette.card, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 14).stroke(AppPalette.primary.opacity(0.06)))
    }
}

struct HomeScreen: View {
    let stations: [RadioStation]
    @ObservedObject var player: RadioPlayer
    @ObservedObject var favorites: FavoritesStore
    let showStations: () -> Void
    @State private var searchText = ""

    private var results: [RadioStation] {
        guard !searchText.isEmpty else { return [] }
        return stations.filter { $0.name.localizedCaseInsensitiveContains(searchText) || $0.city.localizedCaseInsensitiveContains(searchText) }
    }

    var body: some View {
        GlassHeaderLayout(title: "SyrieRadio") {
            ScrollView(showsIndicators: false) {
                LazyVStack(alignment: .leading, spacing: 28) {
                SearchField(text: $searchText, placeholder: "Search stations…")

                if !searchText.isEmpty {
                    sectionTitle("Search Results")
                    ForEach(results) { station in
                        StationRow(station: station, player: player, favorites: favorites)
                    }
                } else {
                    featured
                    categories
                    recent
                }
                }
                .padding(.horizontal, 20)
                .padding(.top, 82)
                .padding(.bottom, 24)
            }
        }
    }

    private var featured: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                sectionTitle("Featured Stations")
                Spacer()
                Button("VIEW ALL", action: showStations)
                    .font(.system(size: 11, weight: .bold))
                    .foregroundStyle(AppPalette.gold)
            }
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(stations.prefix(5)) { station in
                        FeaturedCard(
                            station: station,
                            isLive: player.isPlaying && player.selectedStation == station,
                            isActive: player.isPlaybackActive && player.selectedStation == station
                        ) {
                            if player.selectedStation == station, player.isPlaybackActive {
                                player.pause()
                            } else {
                                player.select(station)
                            }
                        }
                    }
                }
            }
            .padding(.horizontal, 1)
        }
    }

    private var categories: some View {
        VStack(alignment: .leading, spacing: 14) {
            sectionTitle("Explore Categories")
            HStack(spacing: 12) {
                CategoryCard(title: "News", icon: "newspaper.fill", background: AppPalette.control, foreground: .white, action: showStations)
                CategoryCard(title: "Music", icon: "music.note", background: AppPalette.goldLight, foreground: AppPalette.primary, action: showStations)
            }
            Button(action: showStations) {
                HStack(spacing: 14) {
                    Image(systemName: "building.columns.fill").font(.title2)
                    Text("Culture & Heritage").font(.system(size: 18, weight: .semibold, design: .rounded))
                    Spacer()
                    Image(systemName: "chevron.right").opacity(0.35)
                }
                .foregroundStyle(AppPalette.primary)
                .padding(18)
                .background(AppPalette.surfaceBlue, in: RoundedRectangle(cornerRadius: 18))
            }
            .buttonStyle(.plain)
        }
    }

    private var recent: some View {
        VStack(alignment: .leading, spacing: 14) {
            sectionTitle("Recently Played")
            let recentStations = player.recentlyPlayed.isEmpty ? Array(stations.prefix(3)) : player.recentlyPlayed
            ForEach(recentStations) { station in
                StationRow(station: station, player: player, favorites: favorites, compact: true)
            }
        }
    }
}

struct FeaturedCard: View {
    let station: RadioStation
    let isLive: Bool
    let isActive: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            ZStack(alignment: .bottomLeading) {
                Color.white
                Image(station.imageName)
                    .resizable()
                    .scaledToFit()
                    .padding(24)
                    .frame(width: 286, height: 176)
                LinearGradient(colors: [.clear, AppPalette.mediaOverlay.opacity(0.92)], startPoint: .top, endPoint: .bottom)
                VStack(alignment: .leading, spacing: 3) {
                    Text(LocalizedStringKey(isLive ? "LIVE NOW" : station.genre.uppercased()))
                        .font(.system(size: 10, weight: .bold))
                        .tracking(1.4)
                        .foregroundStyle(AppPalette.goldLight)
                    Text(station.name).font(.system(size: 20, weight: .bold, design: .rounded))
                    Text(LocalizedStringKey(station.tagline)).font(.caption).opacity(0.75)
                }
                .foregroundStyle(.white)
                .padding(16)
                HStack {
                    Spacer()
                    Image(systemName: isActive ? "pause.fill" : "play.fill")
                        .foregroundStyle(AppPalette.primary)
                        .frame(width: 42, height: 42)
                        .background(AppPalette.goldLight, in: Circle())
                        .padding(14)
                }
            }
            .frame(width: 286, height: 176)
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            .shadow(color: AppPalette.primary.opacity(0.12), radius: 12, y: 6)
        }
        .buttonStyle(.plain)
    }
}

struct CategoryCard: View {
    let title: LocalizedStringKey
    let icon: String
    let background: Color
    let foreground: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading) {
                Image(systemName: icon).font(.title2)
                Spacer()
                Text(title).font(.system(size: 18, weight: .semibold, design: .rounded))
            }
            .foregroundStyle(foreground)
            .padding(18)
            .frame(maxWidth: .infinity, minHeight: 126, alignment: .leading)
            .background(background, in: RoundedRectangle(cornerRadius: 18))
        }
        .buttonStyle(.plain)
    }
}

struct StationsScreen: View {
    let stations: [RadioStation]
    @ObservedObject var player: RadioPlayer
    @ObservedObject var favorites: FavoritesStore
    @State private var searchText = ""
    @State private var selectedGovernorate = "All"

    private var governorates: [String] { ["All"] + RadioStation.governorates }
    private var filtered: [RadioStation] {
        stations.filter { station in
            (selectedGovernorate == "All" || station.governorates.contains(selectedGovernorate)) &&
            (searchText.isEmpty ||
             station.name.localizedCaseInsensitiveContains(searchText) ||
             station.city.localizedCaseInsensitiveContains(searchText))
        }
    }

    var body: some View {
        GlassHeaderLayout(title: "Stations") {
            ScrollView(showsIndicators: false) {
                LazyVStack(alignment: .leading, spacing: 16) {
                SearchField(text: $searchText, placeholder: "Search stations…")
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(governorates, id: \.self) { governorate in
                            Button {
                                selectedGovernorate = governorate
                            } label: {
                                Text(LocalizedStringKey(governorate == "All" ? "All Governorates" : governorate))
                            }
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundStyle(selectedGovernorate == governorate ? Color.white : AppPalette.primary)
                                .padding(.horizontal, 18)
                                .padding(.vertical, 10)
                                .background(selectedGovernorate == governorate ? AppPalette.control : AppPalette.card, in: Capsule())
                        }
                    }
                }
                HStack {
                    sectionTitle("Live Stations")
                    Spacer()
                    HStack(spacing: 3) {
                        Text("\(filtered.count)")
                        Text("AVAILABLE")
                    }
                    .font(.system(size: 10, weight: .bold))
                    .foregroundStyle(AppPalette.textSecondary)
                }
                ForEach(filtered) { station in
                    StationRow(station: station, player: player, favorites: favorites)
                }
                }
                .padding(.horizontal, 20)
                .padding(.top, 82)
                .padding(.bottom, 24)
            }
        }
    }
}

struct StationRow: View {
    let station: RadioStation
    @ObservedObject var player: RadioPlayer
    @ObservedObject var favorites: FavoritesStore
    var compact = false

    private var isSelected: Bool { player.selectedStation == station }
    private var active: Bool { isSelected && player.isPlaybackActive }
    private var hasPlaybackStatus: Bool { isSelected && player.playbackState != .idle }

    var body: some View {
        HStack(spacing: 14) {
            Button { toggleStation() } label: {
                HStack(spacing: 14) {
                Image(station.imageName)
                    .resizable()
                    .scaledToFit()
                    .padding(6)
                    .frame(width: compact ? 54 : 64, height: compact ? 54 : 64)
                    .background(Color.white, in: RoundedRectangle(cornerRadius: 13))
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(station.name)
                            .font(.system(size: compact ? 16 : 18, weight: .semibold, design: .rounded))
                            .foregroundStyle(AppPalette.primary)
                            .lineLimit(1)
                        Spacer()
                        if !compact { Text(LocalizedStringKey(station.frequency)).font(.caption.weight(.bold)).foregroundStyle(AppPalette.gold) }
                    }
                    HStack(spacing: 5) {
                        Circle().fill(active ? AppPalette.gold : Color.green).frame(width: 6, height: 6)
                        Text(LocalizedStringKey(hasPlaybackStatus ? player.statusText : station.tagline))
                            .font(.caption)
                            .foregroundStyle(AppPalette.textSecondary)
                            .lineLimit(1)
                    }
                }
                }
            }
            .buttonStyle(.plain)
            Button { favorites.toggle(station) } label: {
                Image(systemName: favorites.contains(station) ? "heart.fill" : "heart")
                    .foregroundStyle(favorites.contains(station) ? AppPalette.gold : AppPalette.textSecondary.opacity(0.45))
                    .frame(width: 30, height: 44)
            }
            .buttonStyle(.plain)
            Button { toggleStation() } label: {
                Image(systemName: active ? "pause.fill" : "play.fill")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundStyle(active ? .white : AppPalette.primary)
                    .frame(width: 42, height: 42)
                    .background(active ? AppPalette.control : AppPalette.goldLight, in: Circle())
            }
            .buttonStyle(.plain)
        }
        .padding(compact ? 0 : 12)
        .background(compact ? Color.clear : AppPalette.card.opacity(0.90), in: RoundedRectangle(cornerRadius: 16))
        .overlay {
            if !compact { RoundedRectangle(cornerRadius: 16).stroke(AppPalette.primary.opacity(active ? 0.14 : 0.05)) }
        }
    }

    private func toggleStation() {
        if active { player.pause() } else { player.select(station) }
    }
}

struct FavoritesScreen: View {
    let stations: [RadioStation]
    @ObservedObject var player: RadioPlayer
    @ObservedObject var favorites: FavoritesStore
    let discover: () -> Void

    private var favoriteStations: [RadioStation] { stations.filter(favorites.contains) }
    private let columns = [GridItem(.flexible(), spacing: 14), GridItem(.flexible(), spacing: 14)]

    var body: some View {
        GlassHeaderLayout(title: "SyrieRadio") {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 18) {
                sectionTitle("Favorites")
                Text("Your favorite Syrian stations in one place.")
                    .font(.subheadline).foregroundStyle(AppPalette.textSecondary)

                if favoriteStations.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "radio").font(.system(size: 54, weight: .thin)).foregroundStyle(AppPalette.primary.opacity(0.22))
                        Text("No favorites yet").font(.title3.weight(.semibold)).foregroundStyle(AppPalette.primary)
                        Text("Discover stations and tap the heart.").font(.subheadline).foregroundStyle(AppPalette.textSecondary)
                        Button("DISCOVER STATIONS", action: discover)
                            .font(.caption.weight(.bold)).foregroundStyle(.white)
                            .padding(.horizontal, 24).padding(.vertical, 12)
                            .background(AppPalette.control, in: Capsule())
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.top, 80)
                } else {
                    LazyVGrid(columns: columns, spacing: 14) {
                        ForEach(favoriteStations) { station in
                            FavoriteCard(station: station, player: player, favorites: favorites)
                        }
                    }
                }
                }
                .padding(.horizontal, 20).padding(.top, 82).padding(.bottom, 24)
            }
        }
    }
}

struct FavoriteCard: View {
    let station: RadioStation
    @ObservedObject var player: RadioPlayer
    @ObservedObject var favorites: FavoritesStore

    var body: some View {
        ZStack(alignment: .topTrailing) {
            Button { player.select(station) } label: {
                ZStack(alignment: .bottomLeading) {
                Color.white
                Image(station.imageName).resizable().scaledToFit().padding(18)
                LinearGradient(colors: [.clear, AppPalette.mediaOverlay.opacity(0.9)], startPoint: .center, endPoint: .bottom)
                VStack(alignment: .leading, spacing: 2) {
                    Text(LocalizedStringKey(station.city)).font(.system(size: 9, weight: .bold)).opacity(0.7)
                    Text(station.name).font(.subheadline.weight(.bold)).lineLimit(1)
                }
                .foregroundStyle(.white).padding(12)
                }
            }
            .buttonStyle(.plain)
            Button { favorites.toggle(station) } label: {
                Image(systemName: "heart.fill").foregroundStyle(AppPalette.goldLight).padding(12)
            }
            .buttonStyle(.plain)
        }
        .aspectRatio(1, contentMode: .fit)
        .clipShape(RoundedRectangle(cornerRadius: 22))
    }
}

struct MiniPlayer: View {
    @ObservedObject var player: RadioPlayer
    @ObservedObject var favorites: FavoritesStore
    let open: () -> Void

    private var isFavorite: Bool { favorites.contains(player.selectedStation) }

    var body: some View {
        HStack(spacing: 12) {
            Button(action: open) {
                HStack(spacing: 12) {
                    Image(player.selectedStation.imageName)
                        .resizable()
                        .scaledToFit()
                        .padding(4)
                        .frame(width: 44, height: 44)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    VStack(alignment: .leading, spacing: 2) {
                        Text(LocalizedStringKey(player.isPlaying ? "NOW PLAYING" : player.statusText))
                            .font(.system(size: 9, weight: .bold))
                            .tracking(0.8)
                            .foregroundStyle(AppPalette.gold)
                        Text(player.selectedStation.name)
                            .font(.subheadline.weight(.bold))
                            .foregroundStyle(AppPalette.primary)
                            .lineLimit(1)
                    }
                    Spacer(minLength: 0)
                }
                .frame(maxWidth: .infinity, minHeight: 44, alignment: .leading)
                .contentShape(Rectangle())
            }
            .frame(maxWidth: .infinity)
            .buttonStyle(.plain)
            .accessibilityLabel("Open Now Playing")
            Button { favorites.toggle(player.selectedStation) } label: {
                Image(systemName: isFavorite ? "heart.fill" : "heart")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(isFavorite ? AppPalette.gold : AppPalette.primary)
                    .frame(width: 40, height: 40)
                    .background(AppPalette.card.opacity(0.82), in: Circle())
                    .overlay {
                        Circle().stroke(AppPalette.primary.opacity(0.07), lineWidth: 1)
                    }
            }
            .buttonStyle(.plain)
            .accessibilityLabel(isFavorite ? "Remove from favorites" : "Add to favorites")
            if player.isLoading { ProgressView().tint(AppPalette.primary).frame(width: 42, height: 42) }
            else {
                Button(action: player.togglePlayback) {
                    Image(systemName: player.isPlaying ? "pause.fill" : "play.fill")
                        .foregroundStyle(.white).frame(width: 42, height: 42).background(AppPalette.control, in: Circle())
                }.buttonStyle(.plain)
            }
        }
        .padding(10)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 18))
        .overlay(RoundedRectangle(cornerRadius: 18).stroke(Color.white.opacity(0.7)))
        .shadow(color: AppPalette.primary.opacity(0.14), radius: 14, y: 6)
        .contentShape(RoundedRectangle(cornerRadius: 18))
    }
}

struct NowPlayingScreen: View {
    let stations: [RadioStation]
    @ObservedObject var player: RadioPlayer
    @ObservedObject var favorites: FavoritesStore
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        GeometryReader { geometry in
            let compact = geometry.size.height < 720
            let artworkSize = min(geometry.size.width - 48, geometry.size.height * (compact ? 0.32 : 0.38))
            let playButtonSize: CGFloat = compact ? 68 : 78

            ZStack {
                LinearGradient(
                    colors: [AppPalette.background, AppPalette.surfaceBlue],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                VStack(spacing: 0) {
                    HStack {
                        Button { dismiss() } label: {
                            Image(systemName: "chevron.down")
                                .font(.system(size: 18, weight: .semibold))
                                .frame(width: 44, height: 44)
                                .background(AppPalette.card.opacity(0.78), in: Circle())
                        }
                        Spacer()
                        VStack(spacing: 2) {
                            Text("NOW PLAYING")
                                .font(.system(size: 11, weight: .bold))
                                .tracking(1.6)
                            Text(LocalizedStringKey(player.isPlaying ? "LIVE RADIO" : player.statusText))
                                .font(.system(size: 9, weight: .semibold))
                                .foregroundStyle(AppPalette.gold)
                        }
                        Spacer()
                        AirPlayRoutePicker()
                            .frame(width: 44, height: 44)
                            .background(AppPalette.card.opacity(0.78), in: Circle())
                            .accessibilityLabel("AirPlay")
                    }
                    .foregroundStyle(AppPalette.primary)

                    Spacer(minLength: compact ? 8 : 14)

                    Image(player.selectedStation.imageName)
                        .resizable()
                        .scaledToFit()
                        .padding(compact ? 12 : 18)
                        .frame(width: artworkSize, height: artworkSize)

                    Spacer(minLength: compact ? 10 : 18)

                    VStack(spacing: compact ? 3 : 6) {
                        HStack(spacing: 8) {
                            Text(player.selectedStation.name)
                                .font(.system(size: compact ? 21 : 26, weight: .bold, design: .rounded))
                                .lineLimit(1)
                                .minimumScaleFactor(0.72)
                            if player.isPlaying {
                                Text("LIVE")
                                    .font(.system(size: 9, weight: .bold))
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(AppPalette.goldLight, in: RoundedRectangle(cornerRadius: 6))
                            }
                        }
                        HStack(spacing: 5) {
                            Text(LocalizedStringKey(player.selectedStation.city))
                            Text("•")
                            Text(LocalizedStringKey(player.statusText))
                        }
                        .font(.system(size: compact ? 13 : 15))
                        .foregroundStyle(AppPalette.textSecondary)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                    }
                    .foregroundStyle(AppPalette.primary)

                    Spacer(minLength: compact ? 3 : 8)
                    Waveform(isPlaying: player.isPlaying)
                        .scaleEffect(compact ? 0.85 : 1)
                    Spacer(minLength: compact ? 4 : 10)

                    HStack(spacing: compact ? 34 : 42) {
                        Button { player.previous(in: stations) } label: {
                            Image(systemName: "backward.end.fill")
                                .font(.system(size: compact ? 23 : 27))
                                .frame(width: 48, height: 48)
                        }
                        Button(action: player.togglePlayback) {
                            Group {
                                if player.isLoading {
                                    ProgressView().tint(.white)
                                } else {
                                    Image(systemName: player.isPlaying ? "pause.fill" : "play.fill")
                                        .font(.system(size: compact ? 25 : 29, weight: .bold))
                                }
                            }
                            .frame(width: playButtonSize, height: playButtonSize)
                            .foregroundStyle(.white)
                            .background(AppPalette.gold, in: Circle())
                            .shadow(color: AppPalette.gold.opacity(0.28), radius: 14, y: 7)
                        }
                        Button { player.next(in: stations) } label: {
                            Image(systemName: "forward.end.fill")
                                .font(.system(size: compact ? 23 : 27))
                                .frame(width: 48, height: 48)
                        }
                    }
                    .foregroundStyle(AppPalette.primary)

                    Spacer(minLength: compact ? 6 : 12)

                    HStack(spacing: 12) {
                        Image(systemName: "speaker.fill").font(.caption)
                        SystemVolumeSlider()
                            .frame(height: 28)
                        Image(systemName: "speaker.wave.3.fill").font(.caption)
                    }
                    .foregroundStyle(AppPalette.textSecondary)

                    Spacer(minLength: compact ? 6 : 12)

                    HStack {
                        SmallControl(title: player.sleepTimerEndDate == nil ? "SLEEP" : "30 MIN", icon: "timer", active: player.sleepTimerEndDate != nil) {
                            player.toggleSleepTimer()
                        }
                        Spacer()
                        SmallControl(
                            title: "FAVORITE",
                            icon: favorites.contains(player.selectedStation) ? "heart.fill" : "heart",
                            active: favorites.contains(player.selectedStation)
                        ) {
                            favorites.toggle(player.selectedStation)
                        }
                    }
                    .frame(height: compact ? 44 : 50)
                }
                .padding(.horizontal, 24)
                .padding(.top, 8)
                .padding(.bottom, max(8, geometry.safeAreaInsets.bottom))
            }
        }
    }
}

private struct AirPlayRoutePicker: UIViewRepresentable {
    func makeUIView(context: Context) -> AVRoutePickerView {
        let routePicker = AVRoutePickerView(frame: .zero)
        routePicker.tintColor = UIColor(AppPalette.primary)
        routePicker.activeTintColor = UIColor(AppPalette.gold)
        routePicker.prioritizesVideoDevices = false
        return routePicker
    }

    func updateUIView(_ uiView: AVRoutePickerView, context: Context) {
        uiView.tintColor = UIColor(AppPalette.primary)
        uiView.activeTintColor = UIColor(AppPalette.gold)
    }
}

private struct SystemVolumeSlider: UIViewRepresentable {
    func makeUIView(context: Context) -> MPVolumeView {
        let volumeView = MPVolumeView(frame: .zero)
        volumeView.showsRouteButton = false
        volumeView.showsVolumeSlider = true
        volumeView.tintColor = UIColor(AppPalette.gold)

        if let slider = volumeView.subviews.compactMap({ $0 as? UISlider }).first {
            slider.minimumTrackTintColor = UIColor(AppPalette.gold)
            slider.maximumTrackTintColor = UIColor(AppPalette.primary.opacity(0.14))
            slider.thumbTintColor = UIColor(AppPalette.gold)
        }
        return volumeView
    }

    func updateUIView(_ uiView: MPVolumeView, context: Context) {}
}

struct Waveform: View {
    let isPlaying: Bool
    private let heights: [CGFloat] = [12, 25, 18, 34, 22, 30, 15, 27, 19]
    @State private var animate = false

    var body: some View {
        HStack(spacing: 5) {
            ForEach(heights.indices, id: \.self) { index in
                Capsule().fill(index.isMultiple(of: 2) ? AppPalette.primary : AppPalette.gold)
                    .frame(width: 5, height: isPlaying && animate ? heights[index] : 8)
                    .animation(.easeInOut(duration: 0.55).repeatForever(autoreverses: true).delay(Double(index) * 0.06), value: animate)
            }
        }
        .frame(height: 40)
        .onAppear { animate = true }
    }
}

struct SmallControl: View {
    let title: String
    let icon: String
    let active: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 5) {
                Image(systemName: icon).font(.title3)
                Text(LocalizedStringKey(title)).font(.system(size: 9, weight: .bold))
            }
            .foregroundStyle(active ? AppPalette.gold : AppPalette.textSecondary)
            .frame(width: 90)
        }
    }
}

struct SettingsScreen: View {
    private enum PickerKind {
        case language
        case quality
        case appearance
    }

    @ObservedObject var player: RadioPlayer
    @ObservedObject var advertising: AdvertisingManager
    @AppStorage("appLanguageV3") private var language = ""
    @AppStorage("streamingQuality") private var streamingQuality = "Automatic"
    @AppStorage("pauseOnAudioDisconnect") private var pauseOnAudioDisconnect = true
    @AppStorage("appearanceMode") private var appearanceMode = "System"
    @State private var activePicker: PickerKind?
    @State private var showAbout = false
    @State private var showPremium = false

    var body: some View {
        ZStack {
            GlassHeaderLayout(title: "Settings") {
                ScrollView {
                    VStack(alignment: .leading, spacing: 18) {
                        SettingsRow(
                            icon: "globe",
                            title: "Language",
                            detail: language.isEmpty ? "English" : language,
                            localizesDetail: false
                        ) {
                            activePicker = .language
                        }
                        SettingsRow(icon: "waveform", title: "Streaming quality", detail: streamingQuality) {
                            activePicker = .quality
                        }
                        SettingsRow(icon: "circle.lefthalf.filled", title: "Appearance", detail: appearanceMode) {
                            activePicker = .appearance
                        }
                        SettingsToggleRow(
                            icon: "car.side",
                            title: "Pause on disconnect",
                            detail: "Car & Bluetooth",
                            isOn: $pauseOnAudioDisconnect
                        )
                        SettingsRow(
                            icon: advertising.isPremium ? "checkmark.seal.fill" : "crown.fill",
                            title: "Premium",
                            detail: advertising.isPremium
                                ? "Active"
                                : (advertising.premiumProduct?.displayPrice ?? "View options"),
                            localizesDetail: advertising.isPremium || advertising.premiumProduct == nil
                        ) {
                            showPremium = true
                        }
                        SettingsRow(icon: "star", title: "Leave a review", detail: "App Store") {
                            requestAppReview()
                        }
                        SettingsRow(icon: "info.circle", title: "About SyrieRadio", detail: appVersion, localizesDetail: false) {
                            showAbout = true
                        }
                        Text("SyrieRadio brings Syrian stations together in one simple, independent player.")
                            .font(.footnote).foregroundStyle(AppPalette.textSecondary).padding(.top, 12)
                    }
                    .padding(.horizontal, 20).padding(.top, 82)
                }
            }

            if let activePicker {
                Color.black.opacity(0.28)
                    .ignoresSafeArea()
                    .onTapGesture { self.activePicker = nil }

                switch activePicker {
                case .language:
                    SettingsPickerCard(
                        title: "Choose language",
                        message: "Select the language you prefer for SyrieRadio.",
                        options: [
                            "العربية", "English", "Nederlands", "Deutsch", "Français",
                            "Türkçe", "Kurdî", "Svenska", "Español", "Italiano"
                        ],
                        selected: language.isEmpty ? "English" : language,
                        localizesOptions: false,
                        onSelect: { value in
                            language = value
                            self.activePicker = nil
                        },
                        onCancel: { self.activePicker = nil }
                    )
                case .quality:
                    SettingsPickerCard(
                        title: "Streaming quality",
                        message: "Automatic is recommended. Data Saver requests a lower bitrate when supported.",
                        options: ["Automatic", "High", "Data Saver"],
                        selected: streamingQuality,
                        localizesOptions: true,
                        onSelect: { value in
                            streamingQuality = value
                            player.applyStreamingQuality(value)
                            self.activePicker = nil
                        },
                        onCancel: { self.activePicker = nil }
                    )
                case .appearance:
                    SettingsPickerCard(
                        title: "Appearance",
                        message: "Choose how SyrieRadio looks.",
                        options: ["System", "Light", "Dark"],
                        selected: appearanceMode,
                        localizesOptions: true,
                        onSelect: { value in
                            appearanceMode = value
                            self.activePicker = nil
                        },
                        onCancel: { self.activePicker = nil }
                    )
                }
            }
        }
        .animation(.easeInOut(duration: 0.18), value: activePicker != nil)
        .sheet(isPresented: $showAbout) {
            AboutSyrieRadioView(version: appVersion)
        }
        .sheet(isPresented: $showPremium) {
            PremiumScreen(advertising: advertising)
        }
    }

    private var appVersion: String {
        let shortVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
        return "Version \(shortVersion ?? "1.0")"
    }

    private func requestAppReview() {
        guard let scene = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .first(where: { $0.activationState == .foregroundActive })
        else { return }
        SKStoreReviewController.requestReview(in: scene)
    }
}

private struct PremiumScreen: View {
    @ObservedObject var advertising: AdvertisingManager
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 22) {
                    Image(systemName: advertising.isPremium ? "checkmark.seal.fill" : "crown.fill")
                        .font(.system(size: 58, weight: .semibold))
                        .foregroundStyle(AppPalette.gold)
                        .padding(.top, 18)

                    Text(advertising.isPremium ? "Premium is active" : "SyrieRadio Premium")
                        .font(.system(size: 25, weight: .bold, design: .rounded))
                        .foregroundStyle(AppPalette.primary)
                        .multilineTextAlignment(.center)

                    if advertising.isPremium {
                        Text("Enjoy SyrieRadio without advertisements.")
                            .font(.subheadline)
                            .foregroundStyle(AppPalette.textSecondary)
                            .multilineTextAlignment(.center)
                    } else if let product = advertising.premiumProduct {
                        VStack(spacing: 8) {
                            Text(verbatim: product.displayName)
                                .font(.headline)
                                .foregroundStyle(AppPalette.primary)
                            Text(verbatim: product.description)
                                .font(.subheadline)
                                .foregroundStyle(AppPalette.textSecondary)
                                .multilineTextAlignment(.center)
                            Text(verbatim: product.displayPrice)
                                .font(.system(size: 28, weight: .bold, design: .rounded))
                                .foregroundStyle(AppPalette.gold)
                        }
                    } else if advertising.isLoadingProduct {
                        VStack(spacing: 10) {
                            ProgressView()
                            Text("Loading Premium…")
                                .font(.subheadline)
                                .foregroundStyle(AppPalette.textSecondary)
                        }
                    }

                    if let message = advertising.storeMessage {
                        Label(message, systemImage: "info.circle.fill")
                            .font(.subheadline)
                            .foregroundStyle(AppPalette.textSecondary)
                            .multilineTextAlignment(.center)
                    }

                    if let error = advertising.storeErrorMessage {
                        VStack(spacing: 12) {
                            Label(error, systemImage: "exclamationmark.triangle.fill")
                                .font(.subheadline)
                                .foregroundStyle(.red)
                                .multilineTextAlignment(.center)

                            Button("Try again") {
                                Task { await advertising.retryLastStoreOperation() }
                            }
                            .font(.subheadline.weight(.semibold))
                            .disabled(advertising.isStoreBusy)
                        }
                        .padding(14)
                        .frame(maxWidth: .infinity)
                        .background(Color.red.opacity(0.08), in: RoundedRectangle(cornerRadius: 14))
                    }

                    if !advertising.isPremium, let product = advertising.premiumProduct {
                        Button {
                            Task { await advertising.purchasePremium() }
                        } label: {
                            HStack(spacing: 8) {
                                if advertising.isPurchasing {
                                    ProgressView().tint(.white)
                                }
                                Text("Unlock Premium")
                                Text(verbatim: "– \(product.displayPrice)")
                            }
                            .font(.headline)
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity, minHeight: 52)
                            .background(AppPalette.control, in: RoundedRectangle(cornerRadius: 15))
                        }
                        .buttonStyle(.plain)
                        .disabled(advertising.isStoreBusy)
                    }

                    if !advertising.isPremium {
                        Button {
                            Task { await advertising.restorePurchases() }
                        } label: {
                            HStack(spacing: 8) {
                                if advertising.isRestoring {
                                    ProgressView()
                                }
                                Text(advertising.isRestoring ? "Restoring…" : "Restore purchases")
                            }
                        }
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(AppPalette.gold)
                        .disabled(advertising.isStoreBusy)
                    }
                }
                .padding(28)
            }
            .background(AppPalette.background.ignoresSafeArea())
            .navigationTitle("Premium")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}

private struct SettingsPickerCard: View {
    let title: String
    let message: String
    let options: [String]
    let selected: String
    let localizesOptions: Bool
    let onSelect: (String) -> Void
    let onCancel: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            Text(LocalizedStringKey(title))
                .font(.system(size: 21, weight: .bold, design: .rounded))
                .foregroundStyle(AppPalette.primary)

            Text(LocalizedStringKey(message))
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .foregroundStyle(AppPalette.textSecondary)
                .fixedSize(horizontal: false, vertical: true)

            ScrollView(showsIndicators: options.count > 5) {
                VStack(spacing: 7) {
                    ForEach(options, id: \.self) { option in
                        Button { onSelect(option) } label: {
                            HStack {
                                Group {
                                    if localizesOptions {
                                        Text(LocalizedStringKey(option))
                                    } else {
                                        Text(verbatim: option)
                                    }
                                }
                                .font(.system(size: 15, weight: .semibold))
                                Spacer()
                                Image(systemName: selected == option ? "checkmark.circle.fill" : "circle")
                                    .font(.system(size: 19, weight: .semibold))
                            }
                            .foregroundStyle(selected == option ? AppPalette.gold : AppPalette.primary)
                            .padding(.horizontal, 14)
                            .frame(height: 44)
                            .background(
                                selected == option ? AppPalette.goldLight.opacity(0.22) : AppPalette.surfaceBlue.opacity(0.55),
                                in: RoundedRectangle(cornerRadius: 12)
                            )
                            .contentShape(Rectangle())
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .frame(height: min(CGFloat(options.count) * 51, 240))

            Button("Cancel", action: onCancel)
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(AppPalette.textSecondary)
                .frame(maxWidth: .infinity, minHeight: 44)
        }
        .padding(18)
        .frame(maxWidth: 320)
        .background(AppPalette.card, in: RoundedRectangle(cornerRadius: 22))
        .shadow(color: AppPalette.primary.opacity(0.2), radius: 28, y: 14)
        .padding(.horizontal, 24)
        .transition(.scale(scale: 0.94).combined(with: .opacity))
    }
}

struct SettingsRow: View {
    let icon: String
    let title: LocalizedStringKey
    let detail: String
    var localizesDetail = true
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 14) {
                Image(systemName: icon)
                    .foregroundStyle(AppPalette.gold)
                    .frame(width: 28)
                Text(title).foregroundStyle(AppPalette.primary)
                Spacer()
                Group {
                    if localizesDetail {
                        Text(LocalizedStringKey(detail))
                    } else {
                        Text(verbatim: detail)
                    }
                }
                .font(.subheadline)
                .foregroundStyle(AppPalette.textSecondary)
                    .lineLimit(1)
                Image(systemName: "chevron.right")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(AppPalette.textSecondary.opacity(0.4))
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .padding(16)
        .background(AppPalette.card, in: RoundedRectangle(cornerRadius: 16))
        .overlay {
            RoundedRectangle(cornerRadius: 16)
                .stroke(AppPalette.primary.opacity(0.04), lineWidth: 1)
        }
    }
}

private struct SettingsToggleRow: View {
    let icon: String
    let title: LocalizedStringKey
    let detail: LocalizedStringKey
    @Binding var isOn: Bool

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .foregroundStyle(AppPalette.gold)
                .frame(width: 28)
            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .foregroundStyle(AppPalette.primary)
                Text(detail)
                    .font(.caption)
                    .foregroundStyle(AppPalette.textSecondary)
            }
            Spacer()
            Toggle("", isOn: $isOn)
                .labelsHidden()
                .tint(AppPalette.gold)
        }
        .padding(16)
        .background(AppPalette.card.opacity(0.90), in: RoundedRectangle(cornerRadius: 16))
        .overlay {
            RoundedRectangle(cornerRadius: 16)
                .stroke(AppPalette.primary.opacity(0.04), lineWidth: 1)
        }
    }
}

private struct AboutSyrieRadioView: View {
    let version: String
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [AppPalette.background, AppPalette.surfaceBlue],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 18) {
                HStack {
                    Spacer()
                    Button { dismiss() } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 15, weight: .bold))
                            .foregroundStyle(AppPalette.primary)
                            .frame(width: 38, height: 38)
                            .background(AppPalette.card, in: Circle())
                    }
                }

                Image(systemName: "radio.fill")
                    .font(.system(size: 54))
                    .foregroundStyle(AppPalette.gold)
                    .frame(width: 112, height: 112)
                    .background(AppPalette.card, in: RoundedRectangle(cornerRadius: 28))
                    .shadow(color: AppPalette.primary.opacity(0.12), radius: 18, y: 8)

                Text("SyrieRadio")
                    .font(.system(size: 30, weight: .bold, design: .rounded))
                    .foregroundStyle(AppPalette.primary)
                Text(version)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(AppPalette.gold)
                Text("Listen to real Syrian radio stations in one simple and independent app.")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(AppPalette.textSecondary)
                    .padding(.horizontal, 22)
                Spacer()
                Text("Made for Syrian radio listeners")
                    .font(.footnote.weight(.semibold))
                    .foregroundStyle(AppPalette.textSecondary.opacity(0.7))
            }
            .padding(24)
        }
    }
}

@ViewBuilder
private func sectionTitle(_ text: LocalizedStringKey) -> some View {
    Text(text).font(.system(size: 22, weight: .semibold, design: .rounded)).foregroundStyle(AppPalette.primary)
}
