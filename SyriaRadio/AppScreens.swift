// Regeluitleg: Importeert het framework `AVKit` voor de functionaliteit in dit bestand.
import AVKit
// Regeluitleg: Importeert het framework `Combine` voor de functionaliteit in dit bestand.
import Combine
// Regeluitleg: Importeert het framework `MediaPlayer` voor de functionaliteit in dit bestand.
import MediaPlayer
// Regeluitleg: Importeert het framework `StoreKit` voor de functionaliteit in dit bestand.
import StoreKit
// Regeluitleg: Importeert het framework `SwiftUI` voor de functionaliteit in dit bestand.
import SwiftUI

// MARK: - Gedeelde interfacecomponenten

// Regeluitleg: Definieert de structuur `AppHeader` en opent het bijbehorende codeblok.
struct AppHeader: View {
    // Regeluitleg: Declareert de waarde `title` voor gebruik binnen de huidige scope.
    let title: LocalizedStringKey
    // Regeluitleg: Declareert de waarde `centered` voor gebruik binnen de huidige scope.
    var centered = false

    // Regeluitleg: Declareert de waarde `body` voor gebruik binnen de huidige scope.
    var body: some View {
        // Regeluitleg: Maakt en configureert het SwiftUI-element `HStack`.
        HStack(spacing: 10) {
            // Regeluitleg: Voert het volgende codeblok alleen uit wanneer deze voorwaarde waar is.
            if centered { Spacer() }
            // Regeluitleg: Voert het volgende codeblok alleen uit wanneer deze voorwaarde waar is.
            if !centered {
                // Regeluitleg: Maakt en configureert het SwiftUI-element `ZStack`.
                ZStack {
                    // Regeluitleg: Maakt en configureert het SwiftUI-element `Circle`.
                    Circle()
                        // Regeluitleg: Past de SwiftUI-modifier of gekoppelde bewerking `fill` toe.
                        .fill(AppPalette.primary.opacity(0.10))
                    // Regeluitleg: Maakt en configureert het SwiftUI-element `Image`.
                    Image(systemName: "dot.radiowaves.left.and.right")
                        // Regeluitleg: Stelt het lettertype voor dit interface-element in.
                        .font(.system(size: 15, weight: .bold))
                        // Regeluitleg: Stelt de voorgrondstijl van dit interface-element in.
                        .foregroundStyle(AppPalette.gold)
                // Regeluitleg: Sluit het huidige codeblok af.
                }
                // Regeluitleg: Bepaalt de afmetingen en uitlijning van dit interface-element.
                .frame(width: 34, height: 34)
            // Regeluitleg: Sluit het huidige codeblok af.
            }
            // Regeluitleg: Maakt en configureert het SwiftUI-element `Text`.
            Text(title)
                // Regeluitleg: Stelt het lettertype voor dit interface-element in.
                .font(.system(size: centered ? 13 : 28, weight: .bold, design: .rounded))
                // Regeluitleg: Stelt de voorgrondstijl van dit interface-element in.
                .foregroundStyle(AppPalette.primary)
                // Regeluitleg: Past de opgegeven hoofdletterweergave op de tekst toe.
                .textCase(centered ? .uppercase : nil)
            // Regeluitleg: Voert het volgende codeblok alleen uit wanneer deze voorwaarde waar is.
            if centered { Spacer() }
        // Regeluitleg: Sluit het huidige codeblok af.
        }
        // Regeluitleg: Voegt de opgegeven binnenruimte rond dit interface-element toe.
        .padding(.horizontal, 14)
        // Regeluitleg: Bepaalt de afmetingen en uitlijning van dit interface-element.
        .frame(maxWidth: .infinity, minHeight: 58)
    // Regeluitleg: Sluit het huidige codeblok af.
    }
// Regeluitleg: Sluit het huidige codeblok af.
}

// Regeluitleg: Definieert de structuur `GlassHeaderLayout` en opent het bijbehorende codeblok.
private struct GlassHeaderLayout<Content: View>: View {
    // Regeluitleg: Declareert de waarde `title` voor gebruik binnen de huidige scope.
    let title: LocalizedStringKey
    // Regeluitleg: Laat deze declaratie meerdere SwiftUI-weergaven als één inhoudsblok bouwen.
    @ViewBuilder let content: () -> Content

    // Regeluitleg: Declareert de waarde `body` voor gebruik binnen de huidige scope.
    var body: some View {
        // Regeluitleg: Maakt en configureert het SwiftUI-element `ZStack`.
        ZStack(alignment: .top) {
            // Regeluitleg: Roept `content` aan met de argumenten in deze expressie.
            content()
            // Regeluitleg: Roept `AppHeader` aan met de argumenten in deze expressie.
            AppHeader(title: title)
                // Regeluitleg: Voegt de opgegeven binnenruimte rond dit interface-element toe.
                .padding(.horizontal, 20)
                // Regeluitleg: Voegt de opgegeven binnenruimte rond dit interface-element toe.
                .padding(.top, 8)
                // Regeluitleg: Bepaalt de stapelvolgorde van dit interface-element.
                .zIndex(10)
        // Regeluitleg: Sluit het huidige codeblok af.
        }
    // Regeluitleg: Sluit het huidige codeblok af.
    }
// Regeluitleg: Sluit het huidige codeblok af.
}

// Regeluitleg: Definieert de structuur `SearchField` en opent het bijbehorende codeblok.
struct SearchField: View {
    // Regeluitleg: Declareert `text` met de SwiftUI-propertywrapper `@Binding`.
    @Binding var text: String
    // Regeluitleg: Declareert de waarde `placeholder` voor gebruik binnen de huidige scope.
    let placeholder: LocalizedStringKey

    // Regeluitleg: Declareert de waarde `body` voor gebruik binnen de huidige scope.
    var body: some View {
        // Regeluitleg: Maakt en configureert het SwiftUI-element `HStack`.
        HStack(spacing: 12) {
            // Regeluitleg: Maakt en configureert het SwiftUI-element `Image`.
            Image(systemName: "magnifyingglass").foregroundStyle(AppPalette.textSecondary)
            // Regeluitleg: Roept `TextField` aan met de argumenten in deze expressie.
            TextField(
                // Regeluitleg: Voegt deze tekstwaarde aan de huidige collectie of configuratie toe.
                "",
                // Regeluitleg: Geeft de waarde voor parameter of eigenschap `text` door.
                text: $text,
                // Regeluitleg: Geeft de waarde voor parameter of eigenschap `prompt` door.
                prompt: Text(placeholder)
                    // Regeluitleg: Stelt de voorgrondkleur van dit interface-element in.
                    .foregroundColor(AppPalette.textSecondary.opacity(0.72))
            // Regeluitleg: Sluit de gegroepeerde argumenten van deze expressie af.
            )
                // Regeluitleg: Stelt de voorgrondkleur van dit interface-element in.
                .foregroundColor(AppPalette.primary)
                // Regeluitleg: Bepaalt het automatische hoofdlettergedrag van dit tekstveld.
                .textInputAutocapitalization(.never)
                // Regeluitleg: Schakelt automatische tekstcorrectie voor dit veld uit.
                .disableAutocorrection(true)
        // Regeluitleg: Sluit het huidige codeblok af.
        }
        // Regeluitleg: Voegt de opgegeven binnenruimte rond dit interface-element toe.
        .padding(.horizontal, 16)
        // Regeluitleg: Bepaalt de afmetingen en uitlijning van dit interface-element.
        .frame(height: 48)
        // Regeluitleg: Voegt de opgegeven achtergrond aan dit interface-element toe.
        .background(AppPalette.card, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
        // Regeluitleg: Legt de opgegeven inhoud over dit interface-element.
        .overlay(RoundedRectangle(cornerRadius: 14).stroke(AppPalette.primary.opacity(0.06)))
    // Regeluitleg: Sluit het huidige codeblok af.
    }
// Regeluitleg: Sluit het huidige codeblok af.
}

// Regeluitleg: Definieert de structuur `EmptyStateCard` en opent het bijbehorende codeblok.
private struct EmptyStateCard: View {
    // Regeluitleg: Declareert de waarde `icon` voor gebruik binnen de huidige scope.
    let icon: String
    // Regeluitleg: Declareert de waarde `title` voor gebruik binnen de huidige scope.
    let title: LocalizedStringKey
    // Regeluitleg: Declareert de waarde `message` voor gebruik binnen de huidige scope.
    let message: LocalizedStringKey

    // Regeluitleg: Declareert de waarde `body` voor gebruik binnen de huidige scope.
    var body: some View {
        // Regeluitleg: Maakt en configureert het SwiftUI-element `VStack`.
        VStack(spacing: 10) {
            // Regeluitleg: Maakt en configureert het SwiftUI-element `Image`.
            Image(systemName: icon)
                // Regeluitleg: Stelt het lettertype voor dit interface-element in.
                .font(.system(size: 30, weight: .medium))
                // Regeluitleg: Stelt de voorgrondstijl van dit interface-element in.
                .foregroundStyle(AppPalette.gold)
            // Regeluitleg: Maakt en configureert het SwiftUI-element `Text`.
            Text(title)
                // Regeluitleg: Stelt het lettertype voor dit interface-element in.
                .font(.headline)
                // Regeluitleg: Stelt de voorgrondstijl van dit interface-element in.
                .foregroundStyle(AppPalette.primary)
            // Regeluitleg: Maakt en configureert het SwiftUI-element `Text`.
            Text(message)
                // Regeluitleg: Stelt het lettertype voor dit interface-element in.
                .font(.subheadline)
                // Regeluitleg: Bepaalt de uitlijning van tekst over meerdere regels.
                .multilineTextAlignment(.center)
                // Regeluitleg: Stelt de voorgrondstijl van dit interface-element in.
                .foregroundStyle(AppPalette.textSecondary)
        // Regeluitleg: Sluit het huidige codeblok af.
        }
        // Regeluitleg: Bepaalt de afmetingen en uitlijning van dit interface-element.
        .frame(maxWidth: .infinity)
        // Regeluitleg: Voegt de opgegeven binnenruimte rond dit interface-element toe.
        .padding(.vertical, 30)
        // Regeluitleg: Voegt de opgegeven binnenruimte rond dit interface-element toe.
        .padding(.horizontal, 20)
        // Regeluitleg: Voegt de opgegeven achtergrond aan dit interface-element toe.
        .background(AppPalette.card, in: RoundedRectangle(cornerRadius: 18))
        // Regeluitleg: Gebruikt de enumwaarde of gekoppelde optie `overlay` in de huidige expressie.
        .overlay {
            // Regeluitleg: Maakt en configureert het SwiftUI-element `RoundedRectangle`.
            RoundedRectangle(cornerRadius: 18)
                // Regeluitleg: Past de SwiftUI-modifier of gekoppelde bewerking `stroke` toe.
                .stroke(AppPalette.primary.opacity(0.06), lineWidth: 1)
        // Regeluitleg: Sluit het huidige codeblok af.
        }
        // Regeluitleg: Bepaalt hoe VoiceOver dit element en zijn kinderen behandelt.
        .accessibilityElement(children: .combine)
    // Regeluitleg: Sluit het huidige codeblok af.
    }
// Regeluitleg: Sluit het huidige codeblok af.
}

// MARK: - Startscherm

// Regeluitleg: Definieert de structuur `HomeScreen` en opent het bijbehorende codeblok.
struct HomeScreen: View {
    // Regeluitleg: Declareert de waarde `stations` voor gebruik binnen de huidige scope.
    let stations: [RadioStation]
    // Regeluitleg: Declareert `player` met de SwiftUI-propertywrapper `@ObservedObject`.
    @ObservedObject var player: RadioPlayer
    // Regeluitleg: Declareert `favorites` met de SwiftUI-propertywrapper `@ObservedObject`.
    @ObservedObject var favorites: FavoritesStore
    // Regeluitleg: Declareert de waarde `showStations` voor gebruik binnen de huidige scope.
    let showStations: () -> Void
    // Regeluitleg: Declareert `searchText` met de SwiftUI-propertywrapper `@State`.
    @State private var searchText = ""

    // Regeluitleg: Declareert de waarde `results` voor gebruik binnen de huidige scope.
    private var results: [RadioStation] {
        // Regeluitleg: Controleert de vereiste voorwaarden en verlaat de huidige bewerking als die niet gelden.
        guard !searchText.isEmpty else { return [] }
        // Regeluitleg: Geeft het berekende resultaat terug aan de aanroeper.
        return stations.filter { $0.name.localizedCaseInsensitiveContains(searchText) || $0.city.localizedCaseInsensitiveContains(searchText) }
    // Regeluitleg: Sluit het huidige codeblok af.
    }

    // Regeluitleg: Declareert de waarde `body` voor gebruik binnen de huidige scope.
    var body: some View {
        // Regeluitleg: Roept `GlassHeaderLayout` aan met de argumenten in deze expressie.
        GlassHeaderLayout(title: "SyriaRadio") {
            // Regeluitleg: Maakt en configureert het SwiftUI-element `ScrollView`.
            ScrollView(showsIndicators: false) {
                // Regeluitleg: Maakt en configureert het SwiftUI-element `LazyVStack`.
                LazyVStack(alignment: .leading, spacing: 28) {
                // Regeluitleg: Roept `SearchField` aan met de argumenten in deze expressie.
                SearchField(text: $searchText, placeholder: "Search stations…")

                // Regeluitleg: Voert het volgende codeblok alleen uit wanneer deze voorwaarde waar is.
                if !searchText.isEmpty {
                    // Regeluitleg: Roept `sectionTitle` aan met de argumenten in deze expressie.
                    sectionTitle("Search Results")
                    // Regeluitleg: Voert het volgende codeblok alleen uit wanneer deze voorwaarde waar is.
                    if results.isEmpty {
                        // Regeluitleg: Roept `EmptyStateCard` aan met de argumenten in deze expressie.
                        EmptyStateCard(
                            // Regeluitleg: Geeft de waarde voor parameter of eigenschap `icon` door.
                            icon: "magnifyingglass",
                            // Regeluitleg: Geeft de waarde voor parameter of eigenschap `title` door.
                            title: "No stations found",
                            // Regeluitleg: Geeft de waarde voor parameter of eigenschap `message` door.
                            message: "Try another station name or city."
                        // Regeluitleg: Sluit de gegroepeerde argumenten van deze expressie af.
                        )
                    // Regeluitleg: Sluit de vorige tak en opent het alternatieve uitvoerpad.
                    } else {
                        // Regeluitleg: Maakt en configureert het SwiftUI-element `ForEach`.
                        ForEach(results) { station in
                            // Regeluitleg: Roept `StationRow` aan met de argumenten in deze expressie.
                            StationRow(station: station, player: player, favorites: favorites)
                        // Regeluitleg: Sluit het huidige codeblok af.
                        }
                    // Regeluitleg: Sluit het huidige codeblok af.
                    }
                // Regeluitleg: Sluit de vorige tak en opent het alternatieve uitvoerpad.
                } else {
                    // Regeluitleg: Voert deze instructie uit als onderdeel van de huidige bewerking.
                    featured
                    // Regeluitleg: Voert deze instructie uit als onderdeel van de huidige bewerking.
                    categories
                    // Regeluitleg: Voert deze instructie uit als onderdeel van de huidige bewerking.
                    recent
                // Regeluitleg: Sluit het huidige codeblok af.
                }
                // Regeluitleg: Sluit het huidige codeblok af.
                }
                // Regeluitleg: Voegt de opgegeven binnenruimte rond dit interface-element toe.
                .padding(.horizontal, 20)
                // Regeluitleg: Voegt de opgegeven binnenruimte rond dit interface-element toe.
                .padding(.top, 82)
                // Regeluitleg: Voegt de opgegeven binnenruimte rond dit interface-element toe.
                .padding(.bottom, 24)
                // Regeluitleg: Bepaalt de afmetingen en uitlijning van dit interface-element.
                .frame(maxWidth: 900)
                // Regeluitleg: Bepaalt de afmetingen en uitlijning van dit interface-element.
                .frame(maxWidth: .infinity)
            // Regeluitleg: Sluit het huidige codeblok af.
            }
        // Regeluitleg: Sluit het huidige codeblok af.
        }
    // Regeluitleg: Sluit het huidige codeblok af.
    }

    // Regeluitleg: Declareert de waarde `featured` voor gebruik binnen de huidige scope.
    private var featured: some View {
        // Regeluitleg: Maakt en configureert het SwiftUI-element `VStack`.
        VStack(alignment: .leading, spacing: 12) {
            // Regeluitleg: Maakt en configureert het SwiftUI-element `HStack`.
            HStack {
                // Regeluitleg: Roept `sectionTitle` aan met de argumenten in deze expressie.
                sectionTitle("Featured Stations")
                // Regeluitleg: Maakt en configureert het SwiftUI-element `Spacer`.
                Spacer()
                // Regeluitleg: Maakt en configureert het SwiftUI-element `Button`.
                Button("VIEW ALL", action: showStations)
                    // Regeluitleg: Stelt het lettertype voor dit interface-element in.
                    .font(.system(size: 11, weight: .bold))
                    // Regeluitleg: Stelt de voorgrondstijl van dit interface-element in.
                    .foregroundStyle(AppPalette.gold)
            // Regeluitleg: Sluit het huidige codeblok af.
            }
            // Regeluitleg: Maakt en configureert het SwiftUI-element `ScrollView`.
            ScrollView(.horizontal, showsIndicators: false) {
                // Regeluitleg: Maakt en configureert het SwiftUI-element `HStack`.
                HStack(spacing: 16) {
                    // Regeluitleg: Maakt en configureert het SwiftUI-element `ForEach`.
                    ForEach(stations.prefix(5)) { station in
                        // Regeluitleg: Roept `FeaturedCard` aan met de argumenten in deze expressie.
                        FeaturedCard(
                            // Regeluitleg: Geeft de waarde voor parameter of eigenschap `station` door.
                            station: station,
                            // Regeluitleg: Geeft de waarde voor parameter of eigenschap `isLive` door.
                            isLive: player.isPlaying && player.selectedStation == station,
                            // Regeluitleg: Geeft de waarde voor parameter of eigenschap `isActive` door.
                            isActive: player.isPlaybackActive && player.selectedStation == station,
                            // Regeluitleg: Geeft de waarde voor parameter of eigenschap `isLoading` door.
                            isLoading: player.isLoading && player.selectedStation == station
                        // Regeluitleg: Sluit de gegroepeerde argumenten van deze expressie af.
                        ) {
                            // Regeluitleg: Voert het volgende codeblok alleen uit wanneer deze voorwaarde waar is.
                            if player.selectedStation == station, player.isPlaybackActive {
                                // Regeluitleg: Roept `player.pause` aan met de argumenten in deze expressie.
                                player.pause()
                            // Regeluitleg: Sluit de vorige tak en opent het alternatieve uitvoerpad.
                            } else {
                                // Regeluitleg: Roept `player.select` aan met de argumenten in deze expressie.
                                player.select(station)
                            // Regeluitleg: Sluit het huidige codeblok af.
                            }
                        // Regeluitleg: Sluit het huidige codeblok af.
                        }
                    // Regeluitleg: Sluit het huidige codeblok af.
                    }
                // Regeluitleg: Sluit het huidige codeblok af.
                }
            // Regeluitleg: Sluit het huidige codeblok af.
            }
            // Regeluitleg: Voegt de opgegeven binnenruimte rond dit interface-element toe.
            .padding(.horizontal, 1)
        // Regeluitleg: Sluit het huidige codeblok af.
        }
    // Regeluitleg: Sluit het huidige codeblok af.
    }

    // Regeluitleg: Declareert de waarde `categories` voor gebruik binnen de huidige scope.
    private var categories: some View {
        // Regeluitleg: Maakt en configureert het SwiftUI-element `VStack`.
        VStack(alignment: .leading, spacing: 14) {
            // Regeluitleg: Roept `sectionTitle` aan met de argumenten in deze expressie.
            sectionTitle("Explore Categories")
            // Regeluitleg: Maakt en configureert het SwiftUI-element `HStack`.
            HStack(spacing: 12) {
                // Regeluitleg: Roept `CategoryCard` aan met de argumenten in deze expressie.
                CategoryCard(title: "News", icon: "newspaper.fill", background: AppPalette.control, foreground: .white, action: showStations)
                // Regeluitleg: Roept `CategoryCard` aan met de argumenten in deze expressie.
                CategoryCard(title: "Music", icon: "music.note", background: AppPalette.goldLight, foreground: AppPalette.primary, action: showStations)
            // Regeluitleg: Sluit het huidige codeblok af.
            }
            // Regeluitleg: Maakt en configureert het SwiftUI-element `Button`.
            Button(action: showStations) {
                // Regeluitleg: Maakt en configureert het SwiftUI-element `HStack`.
                HStack(spacing: 14) {
                    // Regeluitleg: Maakt en configureert het SwiftUI-element `Image`.
                    Image(systemName: "building.columns.fill").font(.title2)
                    // Regeluitleg: Maakt en configureert het SwiftUI-element `Text`.
                    Text("Culture & Heritage").font(.system(size: 18, weight: .semibold, design: .rounded))
                    // Regeluitleg: Maakt en configureert het SwiftUI-element `Spacer`.
                    Spacer()
                    // Regeluitleg: Maakt en configureert het SwiftUI-element `Image`.
                    Image(systemName: "chevron.right").opacity(0.35)
                // Regeluitleg: Sluit het huidige codeblok af.
                }
                // Regeluitleg: Stelt de voorgrondstijl van dit interface-element in.
                .foregroundStyle(AppPalette.primary)
                // Regeluitleg: Voegt de opgegeven binnenruimte rond dit interface-element toe.
                .padding(18)
                // Regeluitleg: Voegt de opgegeven achtergrond aan dit interface-element toe.
                .background(AppPalette.surfaceBlue, in: RoundedRectangle(cornerRadius: 18))
            // Regeluitleg: Sluit het huidige codeblok af.
            }
            // Regeluitleg: Past de opgegeven knopstijl toe.
            .buttonStyle(.plain)
        // Regeluitleg: Sluit het huidige codeblok af.
        }
    // Regeluitleg: Sluit het huidige codeblok af.
    }

    // Regeluitleg: Declareert de waarde `recent` voor gebruik binnen de huidige scope.
    private var recent: some View {
        // Regeluitleg: Maakt en configureert het SwiftUI-element `VStack`.
        VStack(alignment: .leading, spacing: 14) {
            // Regeluitleg: Roept `sectionTitle` aan met de argumenten in deze expressie.
            sectionTitle("Recently Played")
            // Regeluitleg: Declareert de waarde `recentStations` voor gebruik binnen de huidige scope.
            let recentStations = player.recentlyPlayed.isEmpty ? Array(stations.prefix(3)) : player.recentlyPlayed
            // Regeluitleg: Maakt en configureert het SwiftUI-element `ForEach`.
            ForEach(recentStations) { station in
                // Regeluitleg: Roept `StationRow` aan met de argumenten in deze expressie.
                StationRow(station: station, player: player, favorites: favorites, compact: true)
            // Regeluitleg: Sluit het huidige codeblok af.
            }
        // Regeluitleg: Sluit het huidige codeblok af.
        }
    // Regeluitleg: Sluit het huidige codeblok af.
    }
// Regeluitleg: Sluit het huidige codeblok af.
}

// Regeluitleg: Definieert de structuur `FeaturedCard` en opent het bijbehorende codeblok.
struct FeaturedCard: View {
    // Regeluitleg: Declareert de waarde `station` voor gebruik binnen de huidige scope.
    let station: RadioStation
    // Regeluitleg: Declareert de waarde `isLive` voor gebruik binnen de huidige scope.
    let isLive: Bool
    // Regeluitleg: Declareert de waarde `isActive` voor gebruik binnen de huidige scope.
    let isActive: Bool
    // Regeluitleg: Declareert de waarde `isLoading` voor gebruik binnen de huidige scope.
    let isLoading: Bool
    // Regeluitleg: Declareert de waarde `action` voor gebruik binnen de huidige scope.
    let action: () -> Void

    // Regeluitleg: Declareert de waarde `body` voor gebruik binnen de huidige scope.
    var body: some View {
        // Regeluitleg: Maakt en configureert het SwiftUI-element `Button`.
        Button(action: action) {
            // Regeluitleg: Maakt en configureert het SwiftUI-element `ZStack`.
            ZStack(alignment: .bottomLeading) {
                // Regeluitleg: Maakt en configureert het SwiftUI-element `Color`.
                Color.white
                // Regeluitleg: Maakt en configureert het SwiftUI-element `Image`.
                Image(station.imageName)
                    // Regeluitleg: Past de SwiftUI-modifier of gekoppelde bewerking `resizable` toe.
                    .resizable()
                    // Regeluitleg: Past de SwiftUI-modifier of gekoppelde bewerking `scaledToFit` toe.
                    .scaledToFit()
                    // Regeluitleg: Voegt de opgegeven binnenruimte rond dit interface-element toe.
                    .padding(24)
                    // Regeluitleg: Bepaalt de afmetingen en uitlijning van dit interface-element.
                    .frame(width: 286, height: 176)
                // Regeluitleg: Maakt en configureert het SwiftUI-element `LinearGradient`.
                LinearGradient(colors: [.clear, AppPalette.mediaOverlay.opacity(0.92)], startPoint: .top, endPoint: .bottom)
                // Regeluitleg: Maakt en configureert het SwiftUI-element `VStack`.
                VStack(alignment: .leading, spacing: 3) {
                    // Regeluitleg: Maakt en configureert het SwiftUI-element `Text`.
                    Text(LocalizedStringKey(isLive ? "LIVE NOW" : station.genre.uppercased()))
                        // Regeluitleg: Stelt het lettertype voor dit interface-element in.
                        .font(.system(size: 10, weight: .bold))
                        // Regeluitleg: Past de SwiftUI-modifier of gekoppelde bewerking `tracking` toe.
                        .tracking(1.4)
                        // Regeluitleg: Stelt de voorgrondstijl van dit interface-element in.
                        .foregroundStyle(AppPalette.goldLight)
                    // Regeluitleg: Maakt en configureert het SwiftUI-element `Text`.
                    Text(station.name).font(.system(size: 20, weight: .bold, design: .rounded))
                    // Regeluitleg: Maakt en configureert het SwiftUI-element `Text`.
                    Text(LocalizedStringKey(station.tagline)).font(.caption).opacity(0.75)
                // Regeluitleg: Sluit het huidige codeblok af.
                }
                // Regeluitleg: Stelt de voorgrondstijl van dit interface-element in.
                .foregroundStyle(.white)
                // Regeluitleg: Voegt de opgegeven binnenruimte rond dit interface-element toe.
                .padding(16)
                // Regeluitleg: Maakt en configureert het SwiftUI-element `HStack`.
                HStack {
                    // Regeluitleg: Maakt en configureert het SwiftUI-element `Spacer`.
                    Spacer()
                    // Regeluitleg: Maakt en configureert het SwiftUI-element `Group`.
                    Group {
                        // Regeluitleg: Voert het volgende codeblok alleen uit wanneer deze voorwaarde waar is.
                        if isLoading {
                            // Regeluitleg: Maakt en configureert het SwiftUI-element `ProgressView`.
                            ProgressView()
                                // Regeluitleg: Past de accentkleur van dit interface-element aan.
                                .tint(AppPalette.primary)
                        // Regeluitleg: Sluit de vorige tak en opent het alternatieve uitvoerpad.
                        } else {
                            // Regeluitleg: Maakt en configureert het SwiftUI-element `Image`.
                            Image(systemName: isActive ? "pause.fill" : "play.fill")
                                // Regeluitleg: Stelt de voorgrondstijl van dit interface-element in.
                                .foregroundStyle(AppPalette.primary)
                        // Regeluitleg: Sluit het huidige codeblok af.
                        }
                    // Regeluitleg: Sluit het huidige codeblok af.
                    }
                    // Regeluitleg: Bepaalt de afmetingen en uitlijning van dit interface-element.
                    .frame(width: 42, height: 42)
                    // Regeluitleg: Voegt de opgegeven achtergrond aan dit interface-element toe.
                    .background(AppPalette.goldLight, in: Circle())
                    // Regeluitleg: Voegt de opgegeven binnenruimte rond dit interface-element toe.
                    .padding(14)
                // Regeluitleg: Sluit het huidige codeblok af.
                }
            // Regeluitleg: Sluit het huidige codeblok af.
            }
            // Regeluitleg: Bepaalt de afmetingen en uitlijning van dit interface-element.
            .frame(width: 286, height: 176)
            // Regeluitleg: Past de SwiftUI-modifier of gekoppelde bewerking `clipShape` toe.
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            // Regeluitleg: Voegt de opgegeven schaduw aan dit interface-element toe.
            .shadow(color: AppPalette.primary.opacity(0.12), radius: 12, y: 6)
        // Regeluitleg: Sluit het huidige codeblok af.
        }
        // Regeluitleg: Past de opgegeven knopstijl toe.
        .buttonStyle(.plain)
        // Regeluitleg: Geeft VoiceOver een duidelijk toegankelijkheidslabel.
        .accessibilityLabel(Text(verbatim: station.name))
        // Regeluitleg: Past de SwiftUI-modifier of gekoppelde bewerking `accessibilityValue` toe.
        .accessibilityValue(Text(LocalizedStringKey(isLive ? "Live now" : station.genre)))
        // Regeluitleg: Past de SwiftUI-modifier of gekoppelde bewerking `accessibilityHint` toe.
        .accessibilityHint(Text(isActive ? "Pause radio" : "Play station"))
    // Regeluitleg: Sluit het huidige codeblok af.
    }
// Regeluitleg: Sluit het huidige codeblok af.
}

// Regeluitleg: Definieert de structuur `CategoryCard` en opent het bijbehorende codeblok.
struct CategoryCard: View {
    // Regeluitleg: Declareert de waarde `title` voor gebruik binnen de huidige scope.
    let title: LocalizedStringKey
    // Regeluitleg: Declareert de waarde `icon` voor gebruik binnen de huidige scope.
    let icon: String
    // Regeluitleg: Declareert de waarde `background` voor gebruik binnen de huidige scope.
    let background: Color
    // Regeluitleg: Declareert de waarde `foreground` voor gebruik binnen de huidige scope.
    let foreground: Color
    // Regeluitleg: Declareert de waarde `action` voor gebruik binnen de huidige scope.
    let action: () -> Void

    // Regeluitleg: Declareert de waarde `body` voor gebruik binnen de huidige scope.
    var body: some View {
        // Regeluitleg: Maakt en configureert het SwiftUI-element `Button`.
        Button(action: action) {
            // Regeluitleg: Maakt en configureert het SwiftUI-element `VStack`.
            VStack(alignment: .leading) {
                // Regeluitleg: Maakt en configureert het SwiftUI-element `Image`.
                Image(systemName: icon).font(.title2)
                // Regeluitleg: Maakt en configureert het SwiftUI-element `Spacer`.
                Spacer()
                // Regeluitleg: Maakt en configureert het SwiftUI-element `Text`.
                Text(title).font(.system(size: 18, weight: .semibold, design: .rounded))
            // Regeluitleg: Sluit het huidige codeblok af.
            }
            // Regeluitleg: Stelt de voorgrondstijl van dit interface-element in.
            .foregroundStyle(foreground)
            // Regeluitleg: Voegt de opgegeven binnenruimte rond dit interface-element toe.
            .padding(18)
            // Regeluitleg: Bepaalt de afmetingen en uitlijning van dit interface-element.
            .frame(maxWidth: .infinity, minHeight: 126, alignment: .leading)
            // Regeluitleg: Voegt de opgegeven achtergrond aan dit interface-element toe.
            .background(background, in: RoundedRectangle(cornerRadius: 18))
        // Regeluitleg: Sluit het huidige codeblok af.
        }
        // Regeluitleg: Past de opgegeven knopstijl toe.
        .buttonStyle(.plain)
    // Regeluitleg: Sluit het huidige codeblok af.
    }
// Regeluitleg: Sluit het huidige codeblok af.
}

// MARK: - Zenderoverzicht

// Regeluitleg: Definieert de structuur `StationsScreen` en opent het bijbehorende codeblok.
struct StationsScreen: View {
    // Regeluitleg: Declareert de waarde `stations` voor gebruik binnen de huidige scope.
    let stations: [RadioStation]
    // Regeluitleg: Declareert `player` met de SwiftUI-propertywrapper `@ObservedObject`.
    @ObservedObject var player: RadioPlayer
    // Regeluitleg: Declareert `favorites` met de SwiftUI-propertywrapper `@ObservedObject`.
    @ObservedObject var favorites: FavoritesStore
    // Regeluitleg: Declareert `searchText` met de SwiftUI-propertywrapper `@State`.
    @State private var searchText = ""
    // Regeluitleg: Declareert `selectedGovernorate` met de SwiftUI-propertywrapper `@State`.
    @State private var selectedGovernorate = "All"

    // Regeluitleg: Declareert de waarde `governorates` voor gebruik binnen de huidige scope.
    private var governorates: [String] { ["All"] + RadioStation.governorates }
    // Regeluitleg: Declareert de waarde `filtered` voor gebruik binnen de huidige scope.
    private var filtered: [RadioStation] {
        // Regeluitleg: Voert deze instructie uit als onderdeel van de huidige bewerking.
        stations.filter { station in
            // Regeluitleg: Opent of vervolgt de gegroepeerde argumenten van deze expressie.
            (selectedGovernorate == "All" || station.governorates.contains(selectedGovernorate)) &&
            // Regeluitleg: Opent of vervolgt de gegroepeerde argumenten van deze expressie.
            (searchText.isEmpty ||
             // Regeluitleg: Roept `station.name.localizedCaseInsensitiveContains` aan met de argumenten in deze expressie.
             station.name.localizedCaseInsensitiveContains(searchText) ||
             // Regeluitleg: Roept `station.city.localizedCaseInsensitiveContains` aan met de argumenten in deze expressie.
             station.city.localizedCaseInsensitiveContains(searchText))
        // Regeluitleg: Sluit het huidige codeblok af.
        }
    // Regeluitleg: Sluit het huidige codeblok af.
    }

    // Regeluitleg: Declareert de waarde `body` voor gebruik binnen de huidige scope.
    var body: some View {
        // Regeluitleg: Roept `GlassHeaderLayout` aan met de argumenten in deze expressie.
        GlassHeaderLayout(title: "Stations") {
            // Regeluitleg: Maakt en configureert het SwiftUI-element `ScrollView`.
            ScrollView(showsIndicators: false) {
                // Regeluitleg: Maakt en configureert het SwiftUI-element `LazyVStack`.
                LazyVStack(alignment: .leading, spacing: 16) {
                // Regeluitleg: Roept `SearchField` aan met de argumenten in deze expressie.
                SearchField(text: $searchText, placeholder: "Search stations…")
                // Regeluitleg: Maakt en configureert het SwiftUI-element `ScrollView`.
                ScrollView(.horizontal, showsIndicators: false) {
                    // Regeluitleg: Maakt en configureert het SwiftUI-element `HStack`.
                    HStack(spacing: 8) {
                        // Regeluitleg: Maakt en configureert het SwiftUI-element `ForEach`.
                        ForEach(governorates, id: \.self) { governorate in
                            // Regeluitleg: Maakt en configureert het SwiftUI-element `Button`.
                            Button {
                                // Regeluitleg: Werkt de waarde `selectedGovernorate` bij met het resultaat van deze expressie.
                                selectedGovernorate = governorate
                            // Regeluitleg: Opent het codeblok voor deze declaratie of bewerking.
                            } label: {
                                // Regeluitleg: Maakt en configureert het SwiftUI-element `Text`.
                                Text(LocalizedStringKey(governorate == "All" ? "All Governorates" : governorate))
                            // Regeluitleg: Sluit het huidige codeblok af.
                            }
                                // Regeluitleg: Stelt het lettertype voor dit interface-element in.
                                .font(.system(size: 12, weight: .semibold))
                                // Regeluitleg: Stelt de voorgrondstijl van dit interface-element in.
                                .foregroundStyle(selectedGovernorate == governorate ? Color.white : AppPalette.primary)
                                // Regeluitleg: Voegt de opgegeven binnenruimte rond dit interface-element toe.
                                .padding(.horizontal, 18)
                                // Regeluitleg: Voegt de opgegeven binnenruimte rond dit interface-element toe.
                                .padding(.vertical, 10)
                                // Regeluitleg: Voegt de opgegeven achtergrond aan dit interface-element toe.
                                .background(selectedGovernorate == governorate ? AppPalette.control : AppPalette.card, in: Capsule())
                        // Regeluitleg: Sluit het huidige codeblok af.
                        }
                    // Regeluitleg: Sluit het huidige codeblok af.
                    }
                // Regeluitleg: Sluit het huidige codeblok af.
                }
                // Regeluitleg: Maakt en configureert het SwiftUI-element `HStack`.
                HStack {
                    // Regeluitleg: Roept `sectionTitle` aan met de argumenten in deze expressie.
                    sectionTitle("Live Stations")
                    // Regeluitleg: Maakt en configureert het SwiftUI-element `Spacer`.
                    Spacer()
                    // Regeluitleg: Maakt en configureert het SwiftUI-element `HStack`.
                    HStack(spacing: 3) {
                        // Regeluitleg: Maakt en configureert het SwiftUI-element `Text`.
                        Text("\(filtered.count)")
                        // Regeluitleg: Maakt en configureert het SwiftUI-element `Text`.
                        Text("AVAILABLE")
                    // Regeluitleg: Sluit het huidige codeblok af.
                    }
                    // Regeluitleg: Stelt het lettertype voor dit interface-element in.
                    .font(.system(size: 10, weight: .bold))
                    // Regeluitleg: Stelt de voorgrondstijl van dit interface-element in.
                    .foregroundStyle(AppPalette.textSecondary)
                // Regeluitleg: Sluit het huidige codeblok af.
                }
                // Regeluitleg: Maakt en configureert het SwiftUI-element `ForEach`.
                ForEach(filtered) { station in
                    // Regeluitleg: Roept `StationRow` aan met de argumenten in deze expressie.
                    StationRow(station: station, player: player, favorites: favorites)
                // Regeluitleg: Sluit het huidige codeblok af.
                }
                // Regeluitleg: Voert het volgende codeblok alleen uit wanneer deze voorwaarde waar is.
                if filtered.isEmpty {
                    // Regeluitleg: Roept `EmptyStateCard` aan met de argumenten in deze expressie.
                    EmptyStateCard(
                        // Regeluitleg: Geeft de waarde voor parameter of eigenschap `icon` door.
                        icon: "line.3.horizontal.decrease.circle",
                        // Regeluitleg: Geeft de waarde voor parameter of eigenschap `title` door.
                        title: "No stations found",
                        // Regeluitleg: Geeft de waarde voor parameter of eigenschap `message` door.
                        message: "Change the search or governorate filter."
                    // Regeluitleg: Sluit de gegroepeerde argumenten van deze expressie af.
                    )
                // Regeluitleg: Sluit het huidige codeblok af.
                }
                // Regeluitleg: Sluit het huidige codeblok af.
                }
                // Regeluitleg: Voegt de opgegeven binnenruimte rond dit interface-element toe.
                .padding(.horizontal, 20)
                // Regeluitleg: Voegt de opgegeven binnenruimte rond dit interface-element toe.
                .padding(.top, 82)
                // Regeluitleg: Voegt de opgegeven binnenruimte rond dit interface-element toe.
                .padding(.bottom, 24)
                // Regeluitleg: Bepaalt de afmetingen en uitlijning van dit interface-element.
                .frame(maxWidth: 900)
                // Regeluitleg: Bepaalt de afmetingen en uitlijning van dit interface-element.
                .frame(maxWidth: .infinity)
            // Regeluitleg: Sluit het huidige codeblok af.
            }
        // Regeluitleg: Sluit het huidige codeblok af.
        }
    // Regeluitleg: Sluit het huidige codeblok af.
    }
// Regeluitleg: Sluit het huidige codeblok af.
}

// Regeluitleg: Definieert de structuur `StationRow` en opent het bijbehorende codeblok.
struct StationRow: View {
    // Regeluitleg: Declareert de waarde `station` voor gebruik binnen de huidige scope.
    let station: RadioStation
    // Regeluitleg: Declareert `player` met de SwiftUI-propertywrapper `@ObservedObject`.
    @ObservedObject var player: RadioPlayer
    // Regeluitleg: Declareert `favorites` met de SwiftUI-propertywrapper `@ObservedObject`.
    @ObservedObject var favorites: FavoritesStore
    // Regeluitleg: Declareert de waarde `compact` voor gebruik binnen de huidige scope.
    var compact = false

    // Regeluitleg: Declareert de waarde `isSelected` voor gebruik binnen de huidige scope.
    private var isSelected: Bool { player.selectedStation == station }
    // Regeluitleg: Declareert de waarde `active` voor gebruik binnen de huidige scope.
    private var active: Bool { isSelected && player.isPlaybackActive }
    // Regeluitleg: Declareert de waarde `hasPlaybackStatus` voor gebruik binnen de huidige scope.
    private var hasPlaybackStatus: Bool { isSelected && player.playbackState != .idle }
    // Regeluitleg: Declareert de waarde `statusColor` voor gebruik binnen de huidige scope.
    private var statusColor: Color {
        // Regeluitleg: Controleert de vereiste voorwaarden en verlaat de huidige bewerking als die niet gelden.
        guard isSelected else { return AppPalette.textSecondary.opacity(0.42) }
        // Regeluitleg: Kiest een uitvoerpad op basis van `player.playbackState`.
        switch player.playbackState {
        // Regeluitleg: Declareert of behandelt de enumwaarde `.playing`.
        case .playing: return AppPalette.gold
        // Regeluitleg: Declareert of behandelt de enumwaarde `.loading`.
        case .loading: return .blue
        // Regeluitleg: Declareert of behandelt de enumwaarde `.failed`.
        case .failed: return .red
        // Regeluitleg: Declareert of behandelt de enumwaarde `.paused`.
        case .paused, .idle: return AppPalette.textSecondary.opacity(0.55)
        // Regeluitleg: Sluit het huidige codeblok af.
        }
    // Regeluitleg: Sluit het huidige codeblok af.
    }

    // Regeluitleg: Declareert de waarde `body` voor gebruik binnen de huidige scope.
    var body: some View {
        // Regeluitleg: Maakt en configureert het SwiftUI-element `HStack`.
        HStack(spacing: 14) {
            // Regeluitleg: Maakt en configureert het SwiftUI-element `Button`.
            Button { toggleStation() } label: {
                // Regeluitleg: Maakt en configureert het SwiftUI-element `HStack`.
                HStack(spacing: 14) {
                // Regeluitleg: Maakt en configureert het SwiftUI-element `Image`.
                Image(station.imageName)
                    // Regeluitleg: Past de SwiftUI-modifier of gekoppelde bewerking `resizable` toe.
                    .resizable()
                    // Regeluitleg: Past de SwiftUI-modifier of gekoppelde bewerking `scaledToFit` toe.
                    .scaledToFit()
                    // Regeluitleg: Voegt de opgegeven binnenruimte rond dit interface-element toe.
                    .padding(6)
                    // Regeluitleg: Bepaalt de afmetingen en uitlijning van dit interface-element.
                    .frame(width: compact ? 54 : 64, height: compact ? 54 : 64)
                    // Regeluitleg: Voegt de opgegeven achtergrond aan dit interface-element toe.
                    .background(Color.white, in: RoundedRectangle(cornerRadius: 13))
                // Regeluitleg: Maakt en configureert het SwiftUI-element `VStack`.
                VStack(alignment: .leading, spacing: 4) {
                    // Regeluitleg: Maakt en configureert het SwiftUI-element `HStack`.
                    HStack {
                        // Regeluitleg: Maakt en configureert het SwiftUI-element `Text`.
                        Text(station.name)
                            // Regeluitleg: Stelt het lettertype voor dit interface-element in.
                            .font(.system(size: compact ? 16 : 18, weight: .semibold, design: .rounded))
                            // Regeluitleg: Stelt de voorgrondstijl van dit interface-element in.
                            .foregroundStyle(AppPalette.primary)
                            // Regeluitleg: Beperkt het aantal zichtbare tekstregels.
                            .lineLimit(1)
                        // Regeluitleg: Maakt en configureert het SwiftUI-element `Spacer`.
                        Spacer()
                        // Regeluitleg: Voert het volgende codeblok alleen uit wanneer deze voorwaarde waar is.
                        if !compact { Text(LocalizedStringKey(station.frequency)).font(.caption.weight(.bold)).foregroundStyle(AppPalette.gold) }
                    // Regeluitleg: Sluit het huidige codeblok af.
                    }
                    // Regeluitleg: Maakt en configureert het SwiftUI-element `HStack`.
                    HStack(spacing: 5) {
                        // Regeluitleg: Maakt en configureert het SwiftUI-element `Circle`.
                        Circle().fill(statusColor).frame(width: 7, height: 7)
                        // Regeluitleg: Maakt en configureert het SwiftUI-element `Text`.
                        Text(LocalizedStringKey(hasPlaybackStatus ? player.statusText : station.tagline))
                            // Regeluitleg: Stelt het lettertype voor dit interface-element in.
                            .font(.caption)
                            // Regeluitleg: Stelt de voorgrondstijl van dit interface-element in.
                            .foregroundStyle(AppPalette.textSecondary)
                            // Regeluitleg: Beperkt het aantal zichtbare tekstregels.
                            .lineLimit(1)
                    // Regeluitleg: Sluit het huidige codeblok af.
                    }
                // Regeluitleg: Sluit het huidige codeblok af.
                }
                // Regeluitleg: Sluit het huidige codeblok af.
                }
            // Regeluitleg: Sluit het huidige codeblok af.
            }
            // Regeluitleg: Past de opgegeven knopstijl toe.
            .buttonStyle(.plain)
            // Regeluitleg: Geeft VoiceOver een duidelijk toegankelijkheidslabel.
            .accessibilityLabel(Text(verbatim: station.name))
            // Regeluitleg: Past de SwiftUI-modifier of gekoppelde bewerking `accessibilityValue` toe.
            .accessibilityValue(Text(LocalizedStringKey(hasPlaybackStatus ? player.statusText : station.tagline)))
            // Regeluitleg: Past de SwiftUI-modifier of gekoppelde bewerking `accessibilityHint` toe.
            .accessibilityHint(Text(active ? "Pause radio" : "Play station"))
            // Regeluitleg: Maakt en configureert het SwiftUI-element `Button`.
            Button { favorites.toggle(station) } label: {
                // Regeluitleg: Maakt en configureert het SwiftUI-element `Image`.
                Image(systemName: favorites.contains(station) ? "heart.fill" : "heart")
                    // Regeluitleg: Stelt de voorgrondstijl van dit interface-element in.
                    .foregroundStyle(favorites.contains(station) ? AppPalette.gold : AppPalette.textSecondary.opacity(0.45))
                    // Regeluitleg: Bepaalt de afmetingen en uitlijning van dit interface-element.
                    .frame(width: 30, height: 44)
            // Regeluitleg: Sluit het huidige codeblok af.
            }
            // Regeluitleg: Past de opgegeven knopstijl toe.
            .buttonStyle(.plain)
            // Regeluitleg: Geeft VoiceOver een duidelijk toegankelijkheidslabel.
            .accessibilityLabel(Text(favorites.contains(station) ? "Remove from favorites" : "Add to favorites"))
            // Regeluitleg: Maakt en configureert het SwiftUI-element `Button`.
            Button { toggleStation() } label: {
                // Regeluitleg: Maakt en configureert het SwiftUI-element `Group`.
                Group {
                    // Regeluitleg: Voert het volgende codeblok alleen uit wanneer deze voorwaarde waar is.
                    if isSelected && player.isLoading {
                        // Regeluitleg: Maakt en configureert het SwiftUI-element `ProgressView`.
                        ProgressView().tint(.white)
                    // Regeluitleg: Sluit de vorige tak en opent het alternatieve uitvoerpad.
                    } else {
                        // Regeluitleg: Maakt en configureert het SwiftUI-element `Image`.
                        Image(systemName: active ? "pause.fill" : "play.fill")
                            // Regeluitleg: Stelt het lettertype voor dit interface-element in.
                            .font(.system(size: 14, weight: .bold))
                    // Regeluitleg: Sluit het huidige codeblok af.
                    }
                // Regeluitleg: Sluit het huidige codeblok af.
                }
                    // Regeluitleg: Stelt de voorgrondstijl van dit interface-element in.
                    .foregroundStyle(active ? .white : AppPalette.primary)
                    // Regeluitleg: Bepaalt de afmetingen en uitlijning van dit interface-element.
                    .frame(width: 42, height: 42)
                    // Regeluitleg: Voegt de opgegeven achtergrond aan dit interface-element toe.
                    .background(active ? AppPalette.control : AppPalette.goldLight, in: Circle())
            // Regeluitleg: Sluit het huidige codeblok af.
            }
            // Regeluitleg: Past de opgegeven knopstijl toe.
            .buttonStyle(.plain)
            // Regeluitleg: Geeft VoiceOver een duidelijk toegankelijkheidslabel.
            .accessibilityLabel(Text(active ? "Pause radio" : "Play station"))
        // Regeluitleg: Sluit het huidige codeblok af.
        }
        // Regeluitleg: Voegt de opgegeven binnenruimte rond dit interface-element toe.
        .padding(compact ? 0 : 12)
        // Regeluitleg: Voegt de opgegeven achtergrond aan dit interface-element toe.
        .background(compact ? Color.clear : AppPalette.card.opacity(0.90), in: RoundedRectangle(cornerRadius: 16))
        // Regeluitleg: Gebruikt de enumwaarde of gekoppelde optie `overlay` in de huidige expressie.
        .overlay {
            // Regeluitleg: Voert het volgende codeblok alleen uit wanneer deze voorwaarde waar is.
            if !compact { RoundedRectangle(cornerRadius: 16).stroke(AppPalette.primary.opacity(active ? 0.14 : 0.05)) }
        // Regeluitleg: Sluit het huidige codeblok af.
        }
    // Regeluitleg: Sluit het huidige codeblok af.
    }

    // Regeluitleg: Definieert de functie `toggleStation` en haar invoerwaarden.
    private func toggleStation() {
        // Regeluitleg: Voert het volgende codeblok alleen uit wanneer deze voorwaarde waar is.
        if active { player.pause() } else { player.select(station) }
    // Regeluitleg: Sluit het huidige codeblok af.
    }
// Regeluitleg: Sluit het huidige codeblok af.
}

// MARK: - Favorieten

// Regeluitleg: Definieert de structuur `FavoritesScreen` en opent het bijbehorende codeblok.
struct FavoritesScreen: View {
    // Regeluitleg: Declareert de waarde `stations` voor gebruik binnen de huidige scope.
    let stations: [RadioStation]
    // Regeluitleg: Declareert `player` met de SwiftUI-propertywrapper `@ObservedObject`.
    @ObservedObject var player: RadioPlayer
    // Regeluitleg: Declareert `favorites` met de SwiftUI-propertywrapper `@ObservedObject`.
    @ObservedObject var favorites: FavoritesStore
    // Regeluitleg: Declareert de waarde `discover` voor gebruik binnen de huidige scope.
    let discover: () -> Void

    // Regeluitleg: Declareert de waarde `favoriteStations` voor gebruik binnen de huidige scope.
    private var favoriteStations: [RadioStation] { stations.filter(favorites.contains) }
    // Regeluitleg: Declareert de waarde `columns` voor gebruik binnen de huidige scope.
    private let columns = [GridItem(.flexible(), spacing: 14), GridItem(.flexible(), spacing: 14)]

    // Regeluitleg: Declareert de waarde `body` voor gebruik binnen de huidige scope.
    var body: some View {
        // Regeluitleg: Roept `GlassHeaderLayout` aan met de argumenten in deze expressie.
        GlassHeaderLayout(title: "SyriaRadio") {
            // Regeluitleg: Maakt en configureert het SwiftUI-element `ScrollView`.
            ScrollView(showsIndicators: false) {
                // Regeluitleg: Maakt en configureert het SwiftUI-element `VStack`.
                VStack(alignment: .leading, spacing: 18) {
                // Regeluitleg: Roept `sectionTitle` aan met de argumenten in deze expressie.
                sectionTitle("Favorites")
                // Regeluitleg: Maakt en configureert het SwiftUI-element `Text`.
                Text("Your favorite Syrian stations in one place.")
                    // Regeluitleg: Stelt het lettertype voor dit interface-element in.
                    .font(.subheadline).foregroundStyle(AppPalette.textSecondary)

                // Regeluitleg: Voert het volgende codeblok alleen uit wanneer deze voorwaarde waar is.
                if favoriteStations.isEmpty {
                    // Regeluitleg: Maakt en configureert het SwiftUI-element `VStack`.
                    VStack(spacing: 16) {
                        // Regeluitleg: Maakt en configureert het SwiftUI-element `Image`.
                        Image(systemName: "radio").font(.system(size: 54, weight: .thin)).foregroundStyle(AppPalette.primary.opacity(0.22))
                        // Regeluitleg: Maakt en configureert het SwiftUI-element `Text`.
                        Text("No favorites yet").font(.title3.weight(.semibold)).foregroundStyle(AppPalette.primary)
                        // Regeluitleg: Maakt en configureert het SwiftUI-element `Text`.
                        Text("Discover stations and tap the heart.").font(.subheadline).foregroundStyle(AppPalette.textSecondary)
                        // Regeluitleg: Maakt en configureert het SwiftUI-element `Button`.
                        Button("DISCOVER STATIONS", action: discover)
                            // Regeluitleg: Stelt het lettertype voor dit interface-element in.
                            .font(.caption.weight(.bold)).foregroundStyle(.white)
                            // Regeluitleg: Voegt de opgegeven binnenruimte rond dit interface-element toe.
                            .padding(.horizontal, 24).padding(.vertical, 12)
                            // Regeluitleg: Voegt de opgegeven achtergrond aan dit interface-element toe.
                            .background(AppPalette.control, in: Capsule())
                    // Regeluitleg: Sluit het huidige codeblok af.
                    }
                    // Regeluitleg: Bepaalt de afmetingen en uitlijning van dit interface-element.
                    .frame(maxWidth: .infinity)
                    // Regeluitleg: Voegt de opgegeven binnenruimte rond dit interface-element toe.
                    .padding(.top, 80)
                // Regeluitleg: Sluit de vorige tak en opent het alternatieve uitvoerpad.
                } else {
                    // Regeluitleg: Roept `LazyVGrid` aan met de argumenten in deze expressie.
                    LazyVGrid(columns: columns, spacing: 14) {
                        // Regeluitleg: Maakt en configureert het SwiftUI-element `ForEach`.
                        ForEach(favoriteStations) { station in
                            // Regeluitleg: Roept `FavoriteCard` aan met de argumenten in deze expressie.
                            FavoriteCard(station: station, player: player, favorites: favorites)
                        // Regeluitleg: Sluit het huidige codeblok af.
                        }
                    // Regeluitleg: Sluit het huidige codeblok af.
                    }
                // Regeluitleg: Sluit het huidige codeblok af.
                }
                // Regeluitleg: Sluit het huidige codeblok af.
                }
                // Regeluitleg: Voegt de opgegeven binnenruimte rond dit interface-element toe.
                .padding(.horizontal, 20).padding(.top, 82).padding(.bottom, 24)
                // Regeluitleg: Bepaalt de afmetingen en uitlijning van dit interface-element.
                .frame(maxWidth: 900)
                // Regeluitleg: Bepaalt de afmetingen en uitlijning van dit interface-element.
                .frame(maxWidth: .infinity)
            // Regeluitleg: Sluit het huidige codeblok af.
            }
        // Regeluitleg: Sluit het huidige codeblok af.
        }
    // Regeluitleg: Sluit het huidige codeblok af.
    }
// Regeluitleg: Sluit het huidige codeblok af.
}

// Regeluitleg: Definieert de structuur `FavoriteCard` en opent het bijbehorende codeblok.
struct FavoriteCard: View {
    // Regeluitleg: Declareert de waarde `station` voor gebruik binnen de huidige scope.
    let station: RadioStation
    // Regeluitleg: Declareert `player` met de SwiftUI-propertywrapper `@ObservedObject`.
    @ObservedObject var player: RadioPlayer
    // Regeluitleg: Declareert `favorites` met de SwiftUI-propertywrapper `@ObservedObject`.
    @ObservedObject var favorites: FavoritesStore

    // Regeluitleg: Declareert de waarde `body` voor gebruik binnen de huidige scope.
    var body: some View {
        // Regeluitleg: Maakt en configureert het SwiftUI-element `ZStack`.
        ZStack(alignment: .topTrailing) {
            // Regeluitleg: Maakt en configureert het SwiftUI-element `Button`.
            Button { player.select(station) } label: {
                // Regeluitleg: Maakt en configureert het SwiftUI-element `ZStack`.
                ZStack(alignment: .bottomLeading) {
                // Regeluitleg: Maakt en configureert het SwiftUI-element `Color`.
                Color.white
                // Regeluitleg: Maakt en configureert het SwiftUI-element `Image`.
                Image(station.imageName).resizable().scaledToFit().padding(18)
                // Regeluitleg: Maakt en configureert het SwiftUI-element `LinearGradient`.
                LinearGradient(colors: [.clear, AppPalette.mediaOverlay.opacity(0.9)], startPoint: .center, endPoint: .bottom)
                // Regeluitleg: Maakt en configureert het SwiftUI-element `VStack`.
                VStack(alignment: .leading, spacing: 2) {
                    // Regeluitleg: Maakt en configureert het SwiftUI-element `Text`.
                    Text(LocalizedStringKey(station.city)).font(.system(size: 9, weight: .bold)).opacity(0.7)
                    // Regeluitleg: Maakt en configureert het SwiftUI-element `Text`.
                    Text(station.name).font(.subheadline.weight(.bold)).lineLimit(1)
                // Regeluitleg: Sluit het huidige codeblok af.
                }
                // Regeluitleg: Stelt de voorgrondstijl van dit interface-element in.
                .foregroundStyle(.white).padding(12)
                // Regeluitleg: Sluit het huidige codeblok af.
                }
            // Regeluitleg: Sluit het huidige codeblok af.
            }
            // Regeluitleg: Past de opgegeven knopstijl toe.
            .buttonStyle(.plain)
            // Regeluitleg: Geeft VoiceOver een duidelijk toegankelijkheidslabel.
            .accessibilityLabel(Text(verbatim: station.name))
            // Regeluitleg: Past de SwiftUI-modifier of gekoppelde bewerking `accessibilityHint` toe.
            .accessibilityHint("Play station")
            // Regeluitleg: Maakt en configureert het SwiftUI-element `Button`.
            Button { favorites.toggle(station) } label: {
                // Regeluitleg: Maakt en configureert het SwiftUI-element `Image`.
                Image(systemName: "heart.fill").foregroundStyle(AppPalette.goldLight).padding(12)
            // Regeluitleg: Sluit het huidige codeblok af.
            }
            // Regeluitleg: Past de opgegeven knopstijl toe.
            .buttonStyle(.plain)
            // Regeluitleg: Geeft VoiceOver een duidelijk toegankelijkheidslabel.
            .accessibilityLabel("Remove from favorites")
        // Regeluitleg: Sluit het huidige codeblok af.
        }
        // Regeluitleg: Past de SwiftUI-modifier of gekoppelde bewerking `aspectRatio` toe.
        .aspectRatio(1, contentMode: .fit)
        // Regeluitleg: Past de SwiftUI-modifier of gekoppelde bewerking `clipShape` toe.
        .clipShape(RoundedRectangle(cornerRadius: 22))
    // Regeluitleg: Sluit het huidige codeblok af.
    }
// Regeluitleg: Sluit het huidige codeblok af.
}

// MARK: - Afspeelbediening

// Regeluitleg: Definieert de structuur `MiniPlayer` en opent het bijbehorende codeblok.
struct MiniPlayer: View {
    // Regeluitleg: Declareert `player` met de SwiftUI-propertywrapper `@ObservedObject`.
    @ObservedObject var player: RadioPlayer
    // Regeluitleg: Declareert `favorites` met de SwiftUI-propertywrapper `@ObservedObject`.
    @ObservedObject var favorites: FavoritesStore
    // Regeluitleg: Declareert de waarde `open` voor gebruik binnen de huidige scope.
    let open: () -> Void

    // Regeluitleg: Declareert de waarde `isFavorite` voor gebruik binnen de huidige scope.
    private var isFavorite: Bool { favorites.contains(player.selectedStation) }

    // Regeluitleg: Declareert de waarde `body` voor gebruik binnen de huidige scope.
    var body: some View {
        // Regeluitleg: Maakt en configureert het SwiftUI-element `HStack`.
        HStack(spacing: 12) {
            // Regeluitleg: Maakt en configureert het SwiftUI-element `Button`.
            Button(action: open) {
                // Regeluitleg: Maakt en configureert het SwiftUI-element `HStack`.
                HStack(spacing: 12) {
                    // Regeluitleg: Maakt en configureert het SwiftUI-element `Image`.
                    Image(player.selectedStation.imageName)
                        // Regeluitleg: Past de SwiftUI-modifier of gekoppelde bewerking `resizable` toe.
                        .resizable()
                        // Regeluitleg: Past de SwiftUI-modifier of gekoppelde bewerking `scaledToFit` toe.
                        .scaledToFit()
                        // Regeluitleg: Voegt de opgegeven binnenruimte rond dit interface-element toe.
                        .padding(4)
                        // Regeluitleg: Bepaalt de afmetingen en uitlijning van dit interface-element.
                        .frame(width: 44, height: 44)
                        // Regeluitleg: Voegt de opgegeven achtergrond aan dit interface-element toe.
                        .background(Color.white)
                        // Regeluitleg: Past de SwiftUI-modifier of gekoppelde bewerking `clipShape` toe.
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    // Regeluitleg: Maakt en configureert het SwiftUI-element `VStack`.
                    VStack(alignment: .leading, spacing: 2) {
                        // Regeluitleg: Maakt en configureert het SwiftUI-element `Text`.
                        Text(LocalizedStringKey(player.isPlaying ? "NOW PLAYING" : player.statusText))
                            // Regeluitleg: Stelt het lettertype voor dit interface-element in.
                            .font(.system(size: 9, weight: .bold))
                            // Regeluitleg: Past de SwiftUI-modifier of gekoppelde bewerking `tracking` toe.
                            .tracking(0.8)
                            // Regeluitleg: Stelt de voorgrondstijl van dit interface-element in.
                            .foregroundStyle(AppPalette.gold)
                        // Regeluitleg: Maakt en configureert het SwiftUI-element `Text`.
                        Text(player.selectedStation.name)
                            // Regeluitleg: Stelt het lettertype voor dit interface-element in.
                            .font(.subheadline.weight(.bold))
                            // Regeluitleg: Stelt de voorgrondstijl van dit interface-element in.
                            .foregroundStyle(AppPalette.primary)
                            // Regeluitleg: Beperkt het aantal zichtbare tekstregels.
                            .lineLimit(1)
                    // Regeluitleg: Sluit het huidige codeblok af.
                    }
                    // Regeluitleg: Maakt en configureert het SwiftUI-element `Spacer`.
                    Spacer(minLength: 0)
                // Regeluitleg: Sluit het huidige codeblok af.
                }
                // Regeluitleg: Bepaalt de afmetingen en uitlijning van dit interface-element.
                .frame(maxWidth: .infinity, minHeight: 44, alignment: .leading)
                // Regeluitleg: Bepaalt het volledige interactieve gebied van dit element.
                .contentShape(Rectangle())
            // Regeluitleg: Sluit het huidige codeblok af.
            }
            // Regeluitleg: Bepaalt de afmetingen en uitlijning van dit interface-element.
            .frame(maxWidth: .infinity)
            // Regeluitleg: Past de opgegeven knopstijl toe.
            .buttonStyle(.plain)
            // Regeluitleg: Geeft VoiceOver een duidelijk toegankelijkheidslabel.
            .accessibilityLabel("Open Now Playing")
            // Regeluitleg: Maakt en configureert het SwiftUI-element `Button`.
            Button { favorites.toggle(player.selectedStation) } label: {
                // Regeluitleg: Maakt en configureert het SwiftUI-element `Image`.
                Image(systemName: isFavorite ? "heart.fill" : "heart")
                    // Regeluitleg: Stelt het lettertype voor dit interface-element in.
                    .font(.system(size: 17, weight: .semibold))
                    // Regeluitleg: Stelt de voorgrondstijl van dit interface-element in.
                    .foregroundStyle(isFavorite ? AppPalette.gold : AppPalette.primary)
                    // Regeluitleg: Bepaalt de afmetingen en uitlijning van dit interface-element.
                    .frame(width: 40, height: 40)
                    // Regeluitleg: Voegt de opgegeven achtergrond aan dit interface-element toe.
                    .background(AppPalette.card.opacity(0.82), in: Circle())
                    // Regeluitleg: Gebruikt de enumwaarde of gekoppelde optie `overlay` in de huidige expressie.
                    .overlay {
                        // Regeluitleg: Maakt en configureert het SwiftUI-element `Circle`.
                        Circle().stroke(AppPalette.primary.opacity(0.07), lineWidth: 1)
                    // Regeluitleg: Sluit het huidige codeblok af.
                    }
            // Regeluitleg: Sluit het huidige codeblok af.
            }
            // Regeluitleg: Past de opgegeven knopstijl toe.
            .buttonStyle(.plain)
            // Regeluitleg: Geeft VoiceOver een duidelijk toegankelijkheidslabel.
            .accessibilityLabel(isFavorite ? "Remove from favorites" : "Add to favorites")
            // Regeluitleg: Maakt en configureert het SwiftUI-element `Button`.
            Button(action: player.togglePlayback) {
                // Regeluitleg: Maakt en configureert het SwiftUI-element `Group`.
                Group {
                    // Regeluitleg: Voert het volgende codeblok alleen uit wanneer deze voorwaarde waar is.
                    if player.isLoading {
                        // Regeluitleg: Maakt en configureert het SwiftUI-element `ProgressView`.
                        ProgressView().tint(.white)
                    // Regeluitleg: Sluit de vorige tak en opent het alternatieve uitvoerpad.
                    } else {
                    // Regeluitleg: Maakt en configureert het SwiftUI-element `Image`.
                    Image(systemName: player.isPlaying ? "pause.fill" : "play.fill")
                    // Regeluitleg: Sluit het huidige codeblok af.
                    }
                // Regeluitleg: Sluit het huidige codeblok af.
                }
                // Regeluitleg: Stelt de voorgrondstijl van dit interface-element in.
                .foregroundStyle(.white)
                // Regeluitleg: Bepaalt de afmetingen en uitlijning van dit interface-element.
                .frame(width: 42, height: 42)
                // Regeluitleg: Voegt de opgegeven achtergrond aan dit interface-element toe.
                .background(AppPalette.control, in: Circle())
            // Regeluitleg: Sluit het huidige codeblok af.
            }
            // Regeluitleg: Past de opgegeven knopstijl toe.
            .buttonStyle(.plain)
            // Regeluitleg: Geeft VoiceOver een duidelijk toegankelijkheidslabel.
            .accessibilityLabel(Text(player.isLoading ? "Cancel connection" : (player.isPlaying ? "Pause radio" : "Play station")))
        // Regeluitleg: Sluit het huidige codeblok af.
        }
        // Regeluitleg: Voegt de opgegeven binnenruimte rond dit interface-element toe.
        .padding(10)
        // Regeluitleg: Voegt de opgegeven achtergrond aan dit interface-element toe.
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 18))
        // Regeluitleg: Legt de opgegeven inhoud over dit interface-element.
        .overlay(RoundedRectangle(cornerRadius: 18).stroke(Color.white.opacity(0.7)))
        // Regeluitleg: Voegt de opgegeven schaduw aan dit interface-element toe.
        .shadow(color: AppPalette.primary.opacity(0.14), radius: 14, y: 6)
        // Regeluitleg: Bepaalt het volledige interactieve gebied van dit element.
        .contentShape(RoundedRectangle(cornerRadius: 18))
    // Regeluitleg: Sluit het huidige codeblok af.
    }
// Regeluitleg: Sluit het huidige codeblok af.
}

// Regeluitleg: Definieert de structuur `NowPlayingScreen` en opent het bijbehorende codeblok.
struct NowPlayingScreen: View {
    // Regeluitleg: Declareert de waarde `stations` voor gebruik binnen de huidige scope.
    let stations: [RadioStation]
    // Regeluitleg: Declareert `player` met de SwiftUI-propertywrapper `@ObservedObject`.
    @ObservedObject var player: RadioPlayer
    // Regeluitleg: Declareert `favorites` met de SwiftUI-propertywrapper `@ObservedObject`.
    @ObservedObject var favorites: FavoritesStore
    // Regeluitleg: Declareert `dismiss` met de SwiftUI-propertywrapper `@Environment`.
    @Environment(\.dismiss) private var dismiss

    // Regeluitleg: Declareert de waarde `body` voor gebruik binnen de huidige scope.
    var body: some View {
        // Regeluitleg: Maakt en configureert het SwiftUI-element `GeometryReader`.
        GeometryReader { geometry in
            // Regeluitleg: Declareert de waarde `compact` voor gebruik binnen de huidige scope.
            let compact = geometry.size.height < 720
            // Regeluitleg: Declareert de waarde `artworkSize` voor gebruik binnen de huidige scope.
            let artworkSize = min(geometry.size.width - 48, geometry.size.height * (compact ? 0.32 : 0.38))
            // Regeluitleg: Declareert de waarde `playButtonSize` voor gebruik binnen de huidige scope.
            let playButtonSize: CGFloat = compact ? 68 : 78

            // Regeluitleg: Maakt en configureert het SwiftUI-element `ZStack`.
            ZStack {
                // Regeluitleg: Maakt en configureert het SwiftUI-element `LinearGradient`.
                LinearGradient(
                    // Regeluitleg: Geeft de waarde voor parameter of eigenschap `colors` door.
                    colors: [AppPalette.background, AppPalette.surfaceBlue],
                    // Regeluitleg: Geeft de waarde voor parameter of eigenschap `startPoint` door.
                    startPoint: .topLeading,
                    // Regeluitleg: Geeft de waarde voor parameter of eigenschap `endPoint` door.
                    endPoint: .bottomTrailing
                // Regeluitleg: Sluit de gegroepeerde argumenten van deze expressie af.
                )
                // Regeluitleg: Laat dit visuele element doorlopen buiten de veilige schermranden.
                .ignoresSafeArea()

                // Regeluitleg: Maakt en configureert het SwiftUI-element `VStack`.
                VStack(spacing: 0) {
                    // Regeluitleg: Maakt en configureert het SwiftUI-element `HStack`.
                    HStack {
                        // Regeluitleg: Maakt en configureert het SwiftUI-element `Button`.
                        Button { dismiss() } label: {
                            // Regeluitleg: Maakt en configureert het SwiftUI-element `Image`.
                            Image(systemName: "chevron.down")
                                // Regeluitleg: Stelt het lettertype voor dit interface-element in.
                                .font(.system(size: 18, weight: .semibold))
                                // Regeluitleg: Bepaalt de afmetingen en uitlijning van dit interface-element.
                                .frame(width: 44, height: 44)
                                // Regeluitleg: Voegt de opgegeven achtergrond aan dit interface-element toe.
                                .background(AppPalette.card.opacity(0.78), in: Circle())
                        // Regeluitleg: Sluit het huidige codeblok af.
                        }
                        // Regeluitleg: Maakt en configureert het SwiftUI-element `Spacer`.
                        Spacer()
                        // Regeluitleg: Maakt en configureert het SwiftUI-element `VStack`.
                        VStack(spacing: 2) {
                            // Regeluitleg: Maakt en configureert het SwiftUI-element `Text`.
                            Text("NOW PLAYING")
                                // Regeluitleg: Stelt het lettertype voor dit interface-element in.
                                .font(.system(size: 11, weight: .bold))
                                // Regeluitleg: Past de SwiftUI-modifier of gekoppelde bewerking `tracking` toe.
                                .tracking(1.6)
                            // Regeluitleg: Maakt en configureert het SwiftUI-element `Text`.
                            Text(LocalizedStringKey(player.isPlaying ? "LIVE RADIO" : player.statusText))
                                // Regeluitleg: Stelt het lettertype voor dit interface-element in.
                                .font(.system(size: 9, weight: .semibold))
                                // Regeluitleg: Stelt de voorgrondstijl van dit interface-element in.
                                .foregroundStyle(AppPalette.gold)
                        // Regeluitleg: Sluit het huidige codeblok af.
                        }
                        // Regeluitleg: Maakt en configureert het SwiftUI-element `Spacer`.
                        Spacer()
                        // Regeluitleg: Roept `AirPlayRoutePicker` aan met de argumenten in deze expressie.
                        AirPlayRoutePicker()
                            // Regeluitleg: Bepaalt de afmetingen en uitlijning van dit interface-element.
                            .frame(width: 44, height: 44)
                            // Regeluitleg: Voegt de opgegeven achtergrond aan dit interface-element toe.
                            .background(AppPalette.card.opacity(0.78), in: Circle())
                            // Regeluitleg: Geeft VoiceOver een duidelijk toegankelijkheidslabel.
                            .accessibilityLabel("AirPlay")
                    // Regeluitleg: Sluit het huidige codeblok af.
                    }
                    // Regeluitleg: Stelt de voorgrondstijl van dit interface-element in.
                    .foregroundStyle(AppPalette.primary)

                    // Regeluitleg: Maakt en configureert het SwiftUI-element `Spacer`.
                    Spacer(minLength: compact ? 8 : 14)

                    // Regeluitleg: Maakt en configureert het SwiftUI-element `Image`.
                    Image(player.selectedStation.imageName)
                        // Regeluitleg: Past de SwiftUI-modifier of gekoppelde bewerking `resizable` toe.
                        .resizable()
                        // Regeluitleg: Past de SwiftUI-modifier of gekoppelde bewerking `scaledToFit` toe.
                        .scaledToFit()
                        // Regeluitleg: Voegt de opgegeven binnenruimte rond dit interface-element toe.
                        .padding(compact ? 12 : 18)
                        // Regeluitleg: Bepaalt de afmetingen en uitlijning van dit interface-element.
                        .frame(width: artworkSize, height: artworkSize)

                    // Regeluitleg: Maakt en configureert het SwiftUI-element `Spacer`.
                    Spacer(minLength: compact ? 10 : 18)

                    // Regeluitleg: Maakt en configureert het SwiftUI-element `VStack`.
                    VStack(spacing: compact ? 3 : 6) {
                        // Regeluitleg: Maakt en configureert het SwiftUI-element `HStack`.
                        HStack(spacing: 8) {
                            // Regeluitleg: Maakt en configureert het SwiftUI-element `Text`.
                            Text(player.selectedStation.name)
                                // Regeluitleg: Stelt het lettertype voor dit interface-element in.
                                .font(.system(size: compact ? 21 : 26, weight: .bold, design: .rounded))
                                // Regeluitleg: Beperkt het aantal zichtbare tekstregels.
                                .lineLimit(1)
                                // Regeluitleg: Staat toe dat tekst verkleint om binnen de beschikbare ruimte te passen.
                                .minimumScaleFactor(0.72)
                            // Regeluitleg: Voert het volgende codeblok alleen uit wanneer deze voorwaarde waar is.
                            if player.isPlaying {
                                // Regeluitleg: Maakt en configureert het SwiftUI-element `Text`.
                                Text("LIVE")
                                    // Regeluitleg: Stelt het lettertype voor dit interface-element in.
                                    .font(.system(size: 9, weight: .bold))
                                    // Regeluitleg: Voegt de opgegeven binnenruimte rond dit interface-element toe.
                                    .padding(.horizontal, 8)
                                    // Regeluitleg: Voegt de opgegeven binnenruimte rond dit interface-element toe.
                                    .padding(.vertical, 4)
                                    // Regeluitleg: Voegt de opgegeven achtergrond aan dit interface-element toe.
                                    .background(AppPalette.goldLight, in: RoundedRectangle(cornerRadius: 6))
                            // Regeluitleg: Sluit het huidige codeblok af.
                            }
                        // Regeluitleg: Sluit het huidige codeblok af.
                        }
                        // Regeluitleg: Maakt en configureert het SwiftUI-element `HStack`.
                        HStack(spacing: 5) {
                            // Regeluitleg: Maakt en configureert het SwiftUI-element `Text`.
                            Text(LocalizedStringKey(player.selectedStation.city))
                            // Regeluitleg: Maakt en configureert het SwiftUI-element `Text`.
                            Text("•")
                            // Regeluitleg: Maakt en configureert het SwiftUI-element `Text`.
                            Text(LocalizedStringKey(player.statusText))
                        // Regeluitleg: Sluit het huidige codeblok af.
                        }
                        // Regeluitleg: Stelt het lettertype voor dit interface-element in.
                        .font(.system(size: compact ? 13 : 15))
                        // Regeluitleg: Stelt de voorgrondstijl van dit interface-element in.
                        .foregroundStyle(AppPalette.textSecondary)
                        // Regeluitleg: Beperkt het aantal zichtbare tekstregels.
                        .lineLimit(1)
                        // Regeluitleg: Staat toe dat tekst verkleint om binnen de beschikbare ruimte te passen.
                        .minimumScaleFactor(0.8)
                    // Regeluitleg: Sluit het huidige codeblok af.
                    }
                    // Regeluitleg: Stelt de voorgrondstijl van dit interface-element in.
                    .foregroundStyle(AppPalette.primary)

                    // Regeluitleg: Maakt en configureert het SwiftUI-element `Spacer`.
                    Spacer(minLength: compact ? 3 : 8)
                    // Regeluitleg: Roept `Waveform` aan met de argumenten in deze expressie.
                    Waveform(isPlaying: player.isPlaying)
                        // Regeluitleg: Schaalt dit interface-element volgens de opgegeven factor.
                        .scaleEffect(compact ? 0.85 : 1)
                    // Regeluitleg: Maakt en configureert het SwiftUI-element `Spacer`.
                    Spacer(minLength: compact ? 4 : 10)

                    // Regeluitleg: Maakt en configureert het SwiftUI-element `HStack`.
                    HStack(spacing: compact ? 34 : 42) {
                        // Regeluitleg: Maakt en configureert het SwiftUI-element `Button`.
                        Button { player.previous(in: stations) } label: {
                            // Regeluitleg: Maakt en configureert het SwiftUI-element `Image`.
                            Image(systemName: "backward.end.fill")
                                // Regeluitleg: Stelt het lettertype voor dit interface-element in.
                                .font(.system(size: compact ? 23 : 27))
                                // Regeluitleg: Bepaalt de afmetingen en uitlijning van dit interface-element.
                                .frame(width: 48, height: 48)
                        // Regeluitleg: Sluit het huidige codeblok af.
                        }
                        // Regeluitleg: Geeft VoiceOver een duidelijk toegankelijkheidslabel.
                        .accessibilityLabel("Previous station")
                        // Regeluitleg: Maakt en configureert het SwiftUI-element `Button`.
                        Button(action: player.togglePlayback) {
                            // Regeluitleg: Maakt en configureert het SwiftUI-element `Group`.
                            Group {
                                // Regeluitleg: Voert het volgende codeblok alleen uit wanneer deze voorwaarde waar is.
                                if player.isLoading {
                                    // Regeluitleg: Maakt en configureert het SwiftUI-element `ProgressView`.
                                    ProgressView().tint(.white)
                                // Regeluitleg: Sluit de vorige tak en opent het alternatieve uitvoerpad.
                                } else {
                                    // Regeluitleg: Maakt en configureert het SwiftUI-element `Image`.
                                    Image(systemName: player.isPlaying ? "pause.fill" : "play.fill")
                                        // Regeluitleg: Stelt het lettertype voor dit interface-element in.
                                        .font(.system(size: compact ? 25 : 29, weight: .bold))
                                // Regeluitleg: Sluit het huidige codeblok af.
                                }
                            // Regeluitleg: Sluit het huidige codeblok af.
                            }
                            // Regeluitleg: Bepaalt de afmetingen en uitlijning van dit interface-element.
                            .frame(width: playButtonSize, height: playButtonSize)
                            // Regeluitleg: Stelt de voorgrondstijl van dit interface-element in.
                            .foregroundStyle(.white)
                            // Regeluitleg: Voegt de opgegeven achtergrond aan dit interface-element toe.
                            .background(AppPalette.gold, in: Circle())
                            // Regeluitleg: Voegt de opgegeven schaduw aan dit interface-element toe.
                            .shadow(color: AppPalette.gold.opacity(0.28), radius: 14, y: 7)
                        // Regeluitleg: Sluit het huidige codeblok af.
                        }
                        // Regeluitleg: Geeft VoiceOver een duidelijk toegankelijkheidslabel.
                        .accessibilityLabel(Text(player.isLoading ? "Cancel connection" : (player.isPlaying ? "Pause radio" : "Play station")))
                        // Regeluitleg: Maakt en configureert het SwiftUI-element `Button`.
                        Button { player.next(in: stations) } label: {
                            // Regeluitleg: Maakt en configureert het SwiftUI-element `Image`.
                            Image(systemName: "forward.end.fill")
                                // Regeluitleg: Stelt het lettertype voor dit interface-element in.
                                .font(.system(size: compact ? 23 : 27))
                                // Regeluitleg: Bepaalt de afmetingen en uitlijning van dit interface-element.
                                .frame(width: 48, height: 48)
                        // Regeluitleg: Sluit het huidige codeblok af.
                        }
                        // Regeluitleg: Geeft VoiceOver een duidelijk toegankelijkheidslabel.
                        .accessibilityLabel("Next station")
                    // Regeluitleg: Sluit het huidige codeblok af.
                    }
                    // Regeluitleg: Stelt de voorgrondstijl van dit interface-element in.
                    .foregroundStyle(AppPalette.primary)

                    // Regeluitleg: Maakt en configureert het SwiftUI-element `Spacer`.
                    Spacer(minLength: compact ? 6 : 12)

                    // Regeluitleg: Maakt en configureert het SwiftUI-element `HStack`.
                    HStack(spacing: 12) {
                        // Regeluitleg: Maakt en configureert het SwiftUI-element `Image`.
                        Image(systemName: "speaker.fill").font(.caption)
                        // Regeluitleg: Roept `SystemVolumeSlider` aan met de argumenten in deze expressie.
                        SystemVolumeSlider()
                            // Regeluitleg: Bepaalt de afmetingen en uitlijning van dit interface-element.
                            .frame(height: 28)
                        // Regeluitleg: Maakt en configureert het SwiftUI-element `Image`.
                        Image(systemName: "speaker.wave.3.fill").font(.caption)
                    // Regeluitleg: Sluit het huidige codeblok af.
                    }
                    // Regeluitleg: Stelt de voorgrondstijl van dit interface-element in.
                    .foregroundStyle(AppPalette.textSecondary)

                    // Regeluitleg: Maakt en configureert het SwiftUI-element `Spacer`.
                    Spacer(minLength: compact ? 6 : 12)

                    // Regeluitleg: Maakt en configureert het SwiftUI-element `HStack`.
                    HStack {
                        // Regeluitleg: Roept `SmallControl` aan met de argumenten in deze expressie.
                        SmallControl(title: player.sleepTimerEndDate == nil ? "SLEEP" : "30 MIN", icon: "timer", active: player.sleepTimerEndDate != nil) {
                            // Regeluitleg: Roept `player.toggleSleepTimer` aan met de argumenten in deze expressie.
                            player.toggleSleepTimer()
                        // Regeluitleg: Sluit het huidige codeblok af.
                        }
                        // Regeluitleg: Maakt en configureert het SwiftUI-element `Spacer`.
                        Spacer()
                        // Regeluitleg: Roept `SmallControl` aan met de argumenten in deze expressie.
                        SmallControl(
                            // Regeluitleg: Geeft de waarde voor parameter of eigenschap `title` door.
                            title: "FAVORITE",
                            // Regeluitleg: Geeft de waarde voor parameter of eigenschap `icon` door.
                            icon: favorites.contains(player.selectedStation) ? "heart.fill" : "heart",
                            // Regeluitleg: Geeft de waarde voor parameter of eigenschap `active` door.
                            active: favorites.contains(player.selectedStation)
                        // Regeluitleg: Sluit de gegroepeerde argumenten van deze expressie af.
                        ) {
                            // Regeluitleg: Roept `favorites.toggle` aan met de argumenten in deze expressie.
                            favorites.toggle(player.selectedStation)
                        // Regeluitleg: Sluit het huidige codeblok af.
                        }
                    // Regeluitleg: Sluit het huidige codeblok af.
                    }
                    // Regeluitleg: Bepaalt de afmetingen en uitlijning van dit interface-element.
                    .frame(height: compact ? 44 : 50)
                // Regeluitleg: Sluit het huidige codeblok af.
                }
                // Regeluitleg: Voegt de opgegeven binnenruimte rond dit interface-element toe.
                .padding(.horizontal, 24)
                // Regeluitleg: Voegt de opgegeven binnenruimte rond dit interface-element toe.
                .padding(.top, 8)
                // Regeluitleg: Voegt de opgegeven binnenruimte rond dit interface-element toe.
                .padding(.bottom, max(8, geometry.safeAreaInsets.bottom))
            // Regeluitleg: Sluit het huidige codeblok af.
            }
        // Regeluitleg: Sluit het huidige codeblok af.
        }
    // Regeluitleg: Sluit het huidige codeblok af.
    }
// Regeluitleg: Sluit het huidige codeblok af.
}

// Regeluitleg: Definieert de structuur `AirPlayRoutePicker` en opent het bijbehorende codeblok.
private struct AirPlayRoutePicker: UIViewRepresentable {
    // Regeluitleg: Definieert de functie `makeUIView` en haar invoerwaarden.
    func makeUIView(context: Context) -> AVRoutePickerView {
        // Regeluitleg: Declareert de waarde `routePicker` voor gebruik binnen de huidige scope.
        let routePicker = AVRoutePickerView(frame: .zero)
        // Regeluitleg: Voert deze instructie uit als onderdeel van de huidige bewerking.
        routePicker.tintColor = UIColor(AppPalette.primary)
        // Regeluitleg: Voert deze instructie uit als onderdeel van de huidige bewerking.
        routePicker.activeTintColor = UIColor(AppPalette.gold)
        // Regeluitleg: Voert deze instructie uit als onderdeel van de huidige bewerking.
        routePicker.prioritizesVideoDevices = false
        // Regeluitleg: Geeft het berekende resultaat terug aan de aanroeper.
        return routePicker
    // Regeluitleg: Sluit het huidige codeblok af.
    }

    // Regeluitleg: Definieert de functie `updateUIView` en haar invoerwaarden.
    func updateUIView(_ uiView: AVRoutePickerView, context: Context) {
        // Regeluitleg: Voert deze instructie uit als onderdeel van de huidige bewerking.
        uiView.tintColor = UIColor(AppPalette.primary)
        // Regeluitleg: Voert deze instructie uit als onderdeel van de huidige bewerking.
        uiView.activeTintColor = UIColor(AppPalette.gold)
    // Regeluitleg: Sluit het huidige codeblok af.
    }
// Regeluitleg: Sluit het huidige codeblok af.
}

// Regeluitleg: Definieert de structuur `SystemVolumeSlider` en opent het bijbehorende codeblok.
private struct SystemVolumeSlider: UIViewRepresentable {
    // Regeluitleg: Definieert de functie `makeUIView` en haar invoerwaarden.
    func makeUIView(context: Context) -> MPVolumeView {
        // Regeluitleg: Declareert de waarde `volumeView` voor gebruik binnen de huidige scope.
        let volumeView = MPVolumeView(frame: .zero)
        // Regeluitleg: Voert deze instructie uit als onderdeel van de huidige bewerking.
        volumeView.showsVolumeSlider = true
        // Regeluitleg: Voert deze instructie uit als onderdeel van de huidige bewerking.
        volumeView.tintColor = UIColor(AppPalette.gold)
        // Regeluitleg: Roept `hideEmbeddedRouteButton` aan met de argumenten in deze expressie.
        hideEmbeddedRouteButton(in: volumeView)

        // Regeluitleg: Voert het volgende codeblok alleen uit wanneer deze voorwaarde waar is.
        if let slider = volumeView.subviews.compactMap({ $0 as? UISlider }).first {
            // Regeluitleg: Voert deze instructie uit als onderdeel van de huidige bewerking.
            slider.minimumTrackTintColor = UIColor(AppPalette.gold)
            // Regeluitleg: Voert deze instructie uit als onderdeel van de huidige bewerking.
            slider.maximumTrackTintColor = UIColor(AppPalette.primary.opacity(0.14))
            // Regeluitleg: Voert deze instructie uit als onderdeel van de huidige bewerking.
            slider.thumbTintColor = UIColor(AppPalette.gold)
        // Regeluitleg: Sluit het huidige codeblok af.
        }
        // Regeluitleg: Geeft het berekende resultaat terug aan de aanroeper.
        return volumeView
    // Regeluitleg: Sluit het huidige codeblok af.
    }

    // Regeluitleg: Definieert de functie `updateUIView` en haar invoerwaarden.
    func updateUIView(_ uiView: MPVolumeView, context: Context) {
        // Regeluitleg: Roept `hideEmbeddedRouteButton` aan met de argumenten in deze expressie.
        hideEmbeddedRouteButton(in: uiView)
    // Regeluitleg: Sluit het huidige codeblok af.
    }

    // Regeluitleg: Definieert de functie `hideEmbeddedRouteButton` en haar invoerwaarden.
    private func hideEmbeddedRouteButton(in volumeView: MPVolumeView) {
        // AirPlay heeft hierboven een eigen AVRoutePickerView; deze bediening blijft daarom alleen een volumeschuif.
        // Regeluitleg: Voert deze instructie uit als onderdeel van de huidige bewerking.
        volumeView.subviews
            // Regeluitleg: Gebruikt de enumwaarde of gekoppelde optie `filter` in de huidige expressie.
            .filter { $0 is UIButton }
            // Regeluitleg: Gebruikt de enumwaarde of gekoppelde optie `forEach` in de huidige expressie.
            .forEach { $0.isHidden = true }
    // Regeluitleg: Sluit het huidige codeblok af.
    }
// Regeluitleg: Sluit het huidige codeblok af.
}

// Regeluitleg: Definieert de structuur `Waveform` en opent het bijbehorende codeblok.
struct Waveform: View {
    // Regeluitleg: Declareert de waarde `isPlaying` voor gebruik binnen de huidige scope.
    let isPlaying: Bool
    // Regeluitleg: Declareert de waarde `heights` voor gebruik binnen de huidige scope.
    private let heights: [CGFloat] = [12, 25, 18, 34, 22, 30, 15, 27, 19]
    // Regeluitleg: Declareert `animate` met de SwiftUI-propertywrapper `@State`.
    @State private var animate = false

    // Regeluitleg: Declareert de waarde `body` voor gebruik binnen de huidige scope.
    var body: some View {
        // Regeluitleg: Maakt en configureert het SwiftUI-element `HStack`.
        HStack(spacing: 5) {
            // Regeluitleg: Maakt en configureert het SwiftUI-element `ForEach`.
            ForEach(heights.indices, id: \.self) { index in
                // Regeluitleg: Maakt en configureert het SwiftUI-element `Capsule`.
                Capsule().fill(index.isMultiple(of: 2) ? AppPalette.primary : AppPalette.gold)
                    // Regeluitleg: Bepaalt de afmetingen en uitlijning van dit interface-element.
                    .frame(width: 5, height: isPlaying && animate ? heights[index] : 8)
                    // Regeluitleg: Koppelt de opgegeven animatie aan deze statuswijziging.
                    .animation(.easeInOut(duration: 0.55).repeatForever(autoreverses: true).delay(Double(index) * 0.06), value: animate)
            // Regeluitleg: Sluit het huidige codeblok af.
            }
        // Regeluitleg: Sluit het huidige codeblok af.
        }
        // Regeluitleg: Bepaalt de afmetingen en uitlijning van dit interface-element.
        .frame(height: 40)
        // Regeluitleg: Gebruikt de enumwaarde of gekoppelde optie `onAppear` in de huidige expressie.
        .onAppear { animate = true }
    // Regeluitleg: Sluit het huidige codeblok af.
    }
// Regeluitleg: Sluit het huidige codeblok af.
}

// Regeluitleg: Definieert de structuur `SmallControl` en opent het bijbehorende codeblok.
struct SmallControl: View {
    // Regeluitleg: Declareert de waarde `title` voor gebruik binnen de huidige scope.
    let title: String
    // Regeluitleg: Declareert de waarde `icon` voor gebruik binnen de huidige scope.
    let icon: String
    // Regeluitleg: Declareert de waarde `active` voor gebruik binnen de huidige scope.
    let active: Bool
    // Regeluitleg: Declareert de waarde `action` voor gebruik binnen de huidige scope.
    let action: () -> Void

    // Regeluitleg: Declareert de waarde `body` voor gebruik binnen de huidige scope.
    var body: some View {
        // Regeluitleg: Maakt en configureert het SwiftUI-element `Button`.
        Button(action: action) {
            // Regeluitleg: Maakt en configureert het SwiftUI-element `VStack`.
            VStack(spacing: 5) {
                // Regeluitleg: Maakt en configureert het SwiftUI-element `Image`.
                Image(systemName: icon).font(.title3)
                // Regeluitleg: Maakt en configureert het SwiftUI-element `Text`.
                Text(LocalizedStringKey(title)).font(.system(size: 9, weight: .bold))
            // Regeluitleg: Sluit het huidige codeblok af.
            }
            // Regeluitleg: Stelt de voorgrondstijl van dit interface-element in.
            .foregroundStyle(active ? AppPalette.gold : AppPalette.textSecondary)
            // Regeluitleg: Bepaalt de afmetingen en uitlijning van dit interface-element.
            .frame(width: 90)
        // Regeluitleg: Sluit het huidige codeblok af.
        }
    // Regeluitleg: Sluit het huidige codeblok af.
    }
// Regeluitleg: Sluit het huidige codeblok af.
}

// MARK: - Instellingen

// Regeluitleg: Definieert de structuur `SettingsScreen` en opent het bijbehorende codeblok.
struct SettingsScreen: View {
    // Regeluitleg: Definieert de opsomming `PickerKind` en opent het bijbehorende codeblok.
    private enum PickerKind {
        // Regeluitleg: Declareert of behandelt de enumwaarde `language`.
        case language
        // Regeluitleg: Declareert of behandelt de enumwaarde `quality`.
        case quality
        // Regeluitleg: Declareert of behandelt de enumwaarde `appearance`.
        case appearance
    // Regeluitleg: Sluit het huidige codeblok af.
    }

    // Regeluitleg: Declareert `player` met de SwiftUI-propertywrapper `@ObservedObject`.
    @ObservedObject var player: RadioPlayer
    // Regeluitleg: Declareert `advertising` met de SwiftUI-propertywrapper `@ObservedObject`.
    @ObservedObject var advertising: AdvertisingManager
    // Regeluitleg: Declareert `language` met de SwiftUI-propertywrapper `@AppStorage`.
    @AppStorage("appLanguageV3") private var language = ""
    // Regeluitleg: Declareert `streamingQuality` met de SwiftUI-propertywrapper `@AppStorage`.
    @AppStorage("streamingQuality") private var streamingQuality = "Automatic"
    // Regeluitleg: Declareert `pauseOnAudioDisconnect` met de SwiftUI-propertywrapper `@AppStorage`.
    @AppStorage("pauseOnAudioDisconnect") private var pauseOnAudioDisconnect = true
    // Regeluitleg: Declareert `appearanceMode` met de SwiftUI-propertywrapper `@AppStorage`.
    @AppStorage("appearanceMode") private var appearanceMode = "System"
    // Regeluitleg: Declareert `reviewManager` met de SwiftUI-propertywrapper `@StateObject`.
    @StateObject private var reviewManager = AppStoreReviewManager()
    // Regeluitleg: Declareert `activePicker` met de SwiftUI-propertywrapper `@State`.
    @State private var activePicker: PickerKind?
    // Regeluitleg: Declareert `showAbout` met de SwiftUI-propertywrapper `@State`.
    @State private var showAbout = false
    // Regeluitleg: Declareert `showPremium` met de SwiftUI-propertywrapper `@State`.
    @State private var showPremium = false
    // Regeluitleg: Declareert `showPrivacyPolicy` met de SwiftUI-propertywrapper `@State`.
    @State private var showPrivacyPolicy = false
    // Regeluitleg: Declareert `showTermsOfUse` met de SwiftUI-propertywrapper `@State`.
    @State private var showTermsOfUse = false

    // Regeluitleg: Declareert de waarde `body` voor gebruik binnen de huidige scope.
    var body: some View {
        // Regeluitleg: Maakt en configureert het SwiftUI-element `ZStack`.
        ZStack {
            // Regeluitleg: Roept `GlassHeaderLayout` aan met de argumenten in deze expressie.
            GlassHeaderLayout(title: "Settings") {
                // Regeluitleg: Maakt en configureert het SwiftUI-element `ScrollView`.
                ScrollView {
                    // Regeluitleg: Maakt en configureert het SwiftUI-element `VStack`.
                    VStack(alignment: .leading, spacing: 18) {
                        // Regeluitleg: Roept `SettingsSection` aan met de argumenten in deze expressie.
                        SettingsSection(title: "Experience") {
                            // Regeluitleg: Roept `SettingsRow` aan met de argumenten in deze expressie.
                            SettingsRow(
                                // Regeluitleg: Geeft de waarde voor parameter of eigenschap `icon` door.
                                icon: "globe",
                                // Regeluitleg: Geeft de waarde voor parameter of eigenschap `title` door.
                                title: "Language",
                                // Regeluitleg: Geeft de waarde voor parameter of eigenschap `detail` door.
                                detail: language.isEmpty ? "English" : language,
                                // Regeluitleg: Geeft de waarde voor parameter of eigenschap `localizesDetail` door.
                                localizesDetail: false
                            // Regeluitleg: Sluit de gegroepeerde argumenten van deze expressie af.
                            ) {
                                // Regeluitleg: Werkt de waarde `activePicker` bij met het resultaat van deze expressie.
                                activePicker = .language
                            // Regeluitleg: Sluit het huidige codeblok af.
                            }
                            // Regeluitleg: Roept `SettingsRow` aan met de argumenten in deze expressie.
                            SettingsRow(icon: "circle.lefthalf.filled", title: "Appearance", detail: appearanceMode) {
                                // Regeluitleg: Werkt de waarde `activePicker` bij met het resultaat van deze expressie.
                                activePicker = .appearance
                            // Regeluitleg: Sluit het huidige codeblok af.
                            }
                        // Regeluitleg: Sluit het huidige codeblok af.
                        }

                        // Regeluitleg: Roept `SettingsSection` aan met de argumenten in deze expressie.
                        SettingsSection(title: "Playback") {
                            // Regeluitleg: Roept `SettingsRow` aan met de argumenten in deze expressie.
                            SettingsRow(icon: "waveform", title: "Streaming quality", detail: streamingQuality) {
                                // Regeluitleg: Werkt de waarde `activePicker` bij met het resultaat van deze expressie.
                                activePicker = .quality
                            // Regeluitleg: Sluit het huidige codeblok af.
                            }
                            // Regeluitleg: Roept `SettingsToggleRow` aan met de argumenten in deze expressie.
                            SettingsToggleRow(
                                // Regeluitleg: Geeft de waarde voor parameter of eigenschap `icon` door.
                                icon: "car.side",
                                // Regeluitleg: Geeft de waarde voor parameter of eigenschap `title` door.
                                title: "Pause on disconnect",
                                // Regeluitleg: Geeft de waarde voor parameter of eigenschap `detail` door.
                                detail: "Car & Bluetooth",
                                // Regeluitleg: Geeft de waarde voor parameter of eigenschap `isOn` door.
                                isOn: $pauseOnAudioDisconnect
                            // Regeluitleg: Sluit de gegroepeerde argumenten van deze expressie af.
                            )
                        // Regeluitleg: Sluit het huidige codeblok af.
                        }

                        // Regeluitleg: Roept `SettingsSection` aan met de argumenten in deze expressie.
                        SettingsSection(title: "Membership") {
                            // Regeluitleg: Roept `SettingsRow` aan met de argumenten in deze expressie.
                            SettingsRow(
                                // Regeluitleg: Geeft de waarde voor parameter of eigenschap `icon` door.
                                icon: advertising.isPremium ? "checkmark.seal.fill" : "crown.fill",
                                // Regeluitleg: Geeft de waarde voor parameter of eigenschap `title` door.
                                title: "Premium",
                                // Regeluitleg: Geeft de waarde voor parameter of eigenschap `detail` door.
                                detail: premiumDetail.text,
                                // Regeluitleg: Geeft de waarde voor parameter of eigenschap `localizesDetail` door.
                                localizesDetail: premiumDetail.localizes
                            // Regeluitleg: Sluit de gegroepeerde argumenten van deze expressie af.
                            ) {
                                // Regeluitleg: Werkt de waarde `showPremium` bij met het resultaat van deze expressie.
                                showPremium = true
                            // Regeluitleg: Sluit het huidige codeblok af.
                            }
                        // Regeluitleg: Sluit het huidige codeblok af.
                        }

                        // Regeluitleg: Roept `SettingsSection` aan met de argumenten in deze expressie.
                        SettingsSection(title: "Legal") {
                            // Regeluitleg: Roept `SettingsRow` aan met de argumenten in deze expressie.
                            SettingsRow(icon: "hand.raised", title: "Privacy Policy", detail: "Read", localizesDetail: true) {
                                // Regeluitleg: Werkt de waarde `showPrivacyPolicy` bij met het resultaat van deze expressie.
                                showPrivacyPolicy = true
                            // Regeluitleg: Sluit het huidige codeblok af.
                            }
                            // Regeluitleg: Roept `SettingsRow` aan met de argumenten in deze expressie.
                            SettingsRow(icon: "doc.text", title: "Terms of Use", detail: "Read", localizesDetail: true) {
                                // Regeluitleg: Werkt de waarde `showTermsOfUse` bij met het resultaat van deze expressie.
                                showTermsOfUse = true
                            // Regeluitleg: Sluit het huidige codeblok af.
                            }
                        // Regeluitleg: Sluit het huidige codeblok af.
                        }

                        // Regeluitleg: Roept `SettingsSection` aan met de argumenten in deze expressie.
                        SettingsSection(title: "Support") {
                            // Regeluitleg: Roept `SettingsRow` aan met de argumenten in deze expressie.
                            SettingsRow(
                                // Regeluitleg: Geeft de waarde voor parameter of eigenschap `icon` door.
                                icon: "star",
                                // Regeluitleg: Geeft de waarde voor parameter of eigenschap `title` door.
                                title: "Leave a review",
                                // Regeluitleg: Geeft de waarde voor parameter of eigenschap `detail` door.
                                detail: reviewManager.isOpening ? "Opening…" : "App Store"
                            // Regeluitleg: Sluit de gegroepeerde argumenten van deze expressie af.
                            ) {
                                // Regeluitleg: Start een gestructureerde asynchrone taak.
                                Task { await reviewManager.openReviewPage() }
                            // Regeluitleg: Sluit het huidige codeblok af.
                            }
                            // Regeluitleg: Roept `SettingsRow` aan met de argumenten in deze expressie.
                            SettingsRow(icon: "info.circle", title: "About SyriaRadio", detail: appVersion, localizesDetail: false) {
                                // Regeluitleg: Werkt de waarde `showAbout` bij met het resultaat van deze expressie.
                                showAbout = true
                            // Regeluitleg: Sluit het huidige codeblok af.
                            }
                        // Regeluitleg: Sluit het huidige codeblok af.
                        }

                        // Regeluitleg: Maakt en configureert het SwiftUI-element `Text`.
                        Text("SyriaRadio brings Syrian stations together in one simple, independent player.")
                            // Regeluitleg: Stelt het lettertype voor dit interface-element in.
                            .font(.footnote).foregroundStyle(AppPalette.textSecondary).padding(.top, 12)
                    // Regeluitleg: Sluit het huidige codeblok af.
                    }
                    // Regeluitleg: Voegt de opgegeven binnenruimte rond dit interface-element toe.
                    .padding(.horizontal, 20).padding(.top, 82)
                    // Regeluitleg: Voegt de opgegeven binnenruimte rond dit interface-element toe.
                    .padding(.bottom, 24)
                    // Regeluitleg: Bepaalt de afmetingen en uitlijning van dit interface-element.
                    .frame(maxWidth: 720)
                    // Regeluitleg: Bepaalt de afmetingen en uitlijning van dit interface-element.
                    .frame(maxWidth: .infinity)
                // Regeluitleg: Sluit het huidige codeblok af.
                }
            // Regeluitleg: Sluit het huidige codeblok af.
            }

            // Regeluitleg: Voert het volgende codeblok alleen uit wanneer deze voorwaarde waar is.
            if let activePicker {
                // Regeluitleg: Maakt en configureert het SwiftUI-element `Color`.
                Color.black.opacity(0.28)
                    // Regeluitleg: Laat dit visuele element doorlopen buiten de veilige schermranden.
                    .ignoresSafeArea()
                    // Regeluitleg: Gebruikt de enumwaarde of gekoppelde optie `onTapGesture` in de huidige expressie.
                    .onTapGesture { self.activePicker = nil }

                // Regeluitleg: Kiest een uitvoerpad op basis van `activePicker`.
                switch activePicker {
                // Regeluitleg: Declareert of behandelt de enumwaarde `.language`.
                case .language:
                    // Regeluitleg: Roept `SettingsPickerCard` aan met de argumenten in deze expressie.
                    SettingsPickerCard(
                        // Regeluitleg: Geeft de waarde voor parameter of eigenschap `title` door.
                        title: "Choose language",
                        // Regeluitleg: Geeft de waarde voor parameter of eigenschap `message` door.
                        message: "Select the language you prefer for SyriaRadio.",
                        // Regeluitleg: Geeft de waarde voor parameter of eigenschap `options` door.
                        options: [
                            // Regeluitleg: Voegt deze tekstwaarde aan de huidige collectie of configuratie toe.
                            "العربية", "English", "Nederlands", "Deutsch", "Français",
                            // Regeluitleg: Voegt deze tekstwaarde aan de huidige collectie of configuratie toe.
                            "Türkçe", "Kurdî", "Svenska", "Español", "Italiano"
                        // Regeluitleg: Sluit de huidige collectie of subscriptexpressie af.
                        ],
                        // Regeluitleg: Geeft de waarde voor parameter of eigenschap `selected` door.
                        selected: language.isEmpty ? "English" : language,
                        // Regeluitleg: Geeft de waarde voor parameter of eigenschap `localizesOptions` door.
                        localizesOptions: false,
                        // Regeluitleg: Geeft de waarde voor parameter of eigenschap `onSelect` door.
                        onSelect: { value in
                            // Regeluitleg: Werkt de waarde `language` bij met het resultaat van deze expressie.
                            language = value
                            // Regeluitleg: Slaat de aangeleverde waarde op in instantie-eigenschap `activePicker`.
                            self.activePicker = nil
                        // Regeluitleg: Sluit het huidige codeblok en de omringende expressie af.
                        },
                        // Regeluitleg: Geeft de waarde voor parameter of eigenschap `onCancel` door.
                        onCancel: { self.activePicker = nil }
                    // Regeluitleg: Sluit de gegroepeerde argumenten van deze expressie af.
                    )
                // Regeluitleg: Declareert of behandelt de enumwaarde `.quality`.
                case .quality:
                    // Regeluitleg: Roept `SettingsPickerCard` aan met de argumenten in deze expressie.
                    SettingsPickerCard(
                        // Regeluitleg: Geeft de waarde voor parameter of eigenschap `title` door.
                        title: "Streaming quality",
                        // Regeluitleg: Geeft de waarde voor parameter of eigenschap `message` door.
                        message: "Automatic is recommended. Data Saver requests a lower bitrate when supported.",
                        // Regeluitleg: Geeft de waarde voor parameter of eigenschap `options` door.
                        options: ["Automatic", "High", "Data Saver"],
                        // Regeluitleg: Geeft de waarde voor parameter of eigenschap `selected` door.
                        selected: streamingQuality,
                        // Regeluitleg: Geeft de waarde voor parameter of eigenschap `localizesOptions` door.
                        localizesOptions: true,
                        // Regeluitleg: Geeft de waarde voor parameter of eigenschap `onSelect` door.
                        onSelect: { value in
                            // Regeluitleg: Werkt de waarde `streamingQuality` bij met het resultaat van deze expressie.
                            streamingQuality = value
                            // Regeluitleg: Roept `player.applyStreamingQuality` aan met de argumenten in deze expressie.
                            player.applyStreamingQuality(value)
                            // Regeluitleg: Slaat de aangeleverde waarde op in instantie-eigenschap `activePicker`.
                            self.activePicker = nil
                        // Regeluitleg: Sluit het huidige codeblok en de omringende expressie af.
                        },
                        // Regeluitleg: Geeft de waarde voor parameter of eigenschap `onCancel` door.
                        onCancel: { self.activePicker = nil }
                    // Regeluitleg: Sluit de gegroepeerde argumenten van deze expressie af.
                    )
                // Regeluitleg: Declareert of behandelt de enumwaarde `.appearance`.
                case .appearance:
                    // Regeluitleg: Roept `SettingsPickerCard` aan met de argumenten in deze expressie.
                    SettingsPickerCard(
                        // Regeluitleg: Geeft de waarde voor parameter of eigenschap `title` door.
                        title: "Appearance",
                        // Regeluitleg: Geeft de waarde voor parameter of eigenschap `message` door.
                        message: "Choose how SyriaRadio looks.",
                        // Regeluitleg: Geeft de waarde voor parameter of eigenschap `options` door.
                        options: ["System", "Light", "Dark"],
                        // Regeluitleg: Geeft de waarde voor parameter of eigenschap `selected` door.
                        selected: appearanceMode,
                        // Regeluitleg: Geeft de waarde voor parameter of eigenschap `localizesOptions` door.
                        localizesOptions: true,
                        // Regeluitleg: Geeft de waarde voor parameter of eigenschap `onSelect` door.
                        onSelect: { value in
                            // Regeluitleg: Werkt de waarde `appearanceMode` bij met het resultaat van deze expressie.
                            appearanceMode = value
                            // Regeluitleg: Slaat de aangeleverde waarde op in instantie-eigenschap `activePicker`.
                            self.activePicker = nil
                        // Regeluitleg: Sluit het huidige codeblok en de omringende expressie af.
                        },
                        // Regeluitleg: Geeft de waarde voor parameter of eigenschap `onCancel` door.
                        onCancel: { self.activePicker = nil }
                    // Regeluitleg: Sluit de gegroepeerde argumenten van deze expressie af.
                    )
                // Regeluitleg: Sluit het huidige codeblok af.
                }
            // Regeluitleg: Sluit het huidige codeblok af.
            }
        // Regeluitleg: Sluit het huidige codeblok af.
        }
        // Regeluitleg: Koppelt de opgegeven animatie aan deze statuswijziging.
        .animation(.easeInOut(duration: 0.18), value: activePicker != nil)
        // Regeluitleg: Presenteert het gekoppelde modale scherm wanneer de status actief is.
        .sheet(isPresented: $showAbout) {
            // Regeluitleg: Roept `AboutSyriaRadioView` aan met de argumenten in deze expressie.
            AboutSyriaRadioView(version: appVersion)
        // Regeluitleg: Sluit het huidige codeblok af.
        }
        // Regeluitleg: Presenteert het gekoppelde modale scherm wanneer de status actief is.
        .sheet(isPresented: $showPremium) {
            // Regeluitleg: Roept `PremiumScreen` aan met de argumenten in deze expressie.
            PremiumScreen(advertising: advertising)
        // Regeluitleg: Sluit het huidige codeblok af.
        }
        // Regeluitleg: Presenteert het gekoppelde modale scherm wanneer de status actief is.
        .sheet(isPresented: $showPrivacyPolicy) {
            // Regeluitleg: Roept `LegalDocumentView` aan met de argumenten in deze expressie.
            LegalDocumentView(document: .privacy)
        // Regeluitleg: Sluit het huidige codeblok af.
        }
        // Regeluitleg: Presenteert het gekoppelde modale scherm wanneer de status actief is.
        .sheet(isPresented: $showTermsOfUse) {
            // Regeluitleg: Roept `LegalDocumentView` aan met de argumenten in deze expressie.
            LegalDocumentView(document: .terms)
        // Regeluitleg: Sluit het huidige codeblok af.
        }
        // Regeluitleg: Presenteert de gekoppelde waarschuwing wanneer de status actief is.
        .alert(
            // Regeluitleg: Voegt deze tekstwaarde aan de huidige collectie of configuratie toe.
            "Review unavailable",
            // Regeluitleg: Geeft de waarde voor parameter of eigenschap `isPresented` door.
            isPresented: Binding(
                // Regeluitleg: Geeft de waarde voor parameter of eigenschap `get` door.
                get: { reviewManager.errorMessage != nil },
                // Regeluitleg: Geeft de waarde voor parameter of eigenschap `set` door.
                set: { if !$0 { reviewManager.errorMessage = nil } }
            // Regeluitleg: Sluit de gegroepeerde argumenten van deze expressie af.
            )
        // Regeluitleg: Sluit de gegroepeerde argumenten van deze expressie af.
        ) {
            // Regeluitleg: Maakt en configureert het SwiftUI-element `Button`.
            Button("OK") { reviewManager.errorMessage = nil }
        // Regeluitleg: Opent het codeblok voor deze declaratie of bewerking.
        } message: {
            // Regeluitleg: Maakt en configureert het SwiftUI-element `Text`.
            Text(reviewManager.errorMessage ?? "")
        // Regeluitleg: Sluit het huidige codeblok af.
        }
    // Regeluitleg: Sluit het huidige codeblok af.
    }

    // Regeluitleg: Declareert de waarde `appVersion` voor gebruik binnen de huidige scope.
    private var appVersion: String {
        // Regeluitleg: Declareert de waarde `shortVersion` voor gebruik binnen de huidige scope.
        let shortVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
        // Regeluitleg: Geeft het berekende resultaat terug aan de aanroeper.
        return "Version \(shortVersion ?? "1.0")"
    // Regeluitleg: Sluit het huidige codeblok af.
    }

    // Regeluitleg: Declareert de waarde `premiumDetail` voor gebruik binnen de huidige scope.
    private var premiumDetail: (text: String, localizes: Bool) {
        // StoreKit bepaalt de definitieve prijs en valuta-opmaak. Toon nooit
        // de lokale testwaarde alsof dit de productieprijs is.
        // Regeluitleg: Voert het volgende codeblok alleen uit wanneer deze voorwaarde waar is.
        if advertising.isPremium { return ("Active", true) }
        // Regeluitleg: Voert het volgende codeblok alleen uit wanneer deze voorwaarde waar is.
        if let price = advertising.premiumProduct?.displayPrice { return (price, false) }
        // Regeluitleg: Voert het volgende codeblok alleen uit wanneer deze voorwaarde waar is.
        if advertising.isLoadingProduct { return ("Loading price…", true) }
        // Regeluitleg: Voert het volgende codeblok alleen uit wanneer deze voorwaarde waar is.
        if advertising.storeErrorMessage != nil { return ("Price unavailable", true) }
        // Regeluitleg: Geeft het berekende resultaat terug aan de aanroeper.
        return ("View options", true)
    // Regeluitleg: Sluit het huidige codeblok af.
    }
// Regeluitleg: Sluit het huidige codeblok af.
}

// MARK: - Premium

// Regeluitleg: Definieert de structuur `PremiumScreen` en opent het bijbehorende codeblok.
private struct PremiumScreen: View {
    // Regeluitleg: Declareert `advertising` met de SwiftUI-propertywrapper `@ObservedObject`.
    @ObservedObject var advertising: AdvertisingManager
    // Regeluitleg: Declareert `dismiss` met de SwiftUI-propertywrapper `@Environment`.
    @Environment(\.dismiss) private var dismiss

    // Regeluitleg: Declareert de waarde `body` voor gebruik binnen de huidige scope.
    var body: some View {
        // Regeluitleg: Maakt en configureert het SwiftUI-element `NavigationView`.
        NavigationView {
            // Regeluitleg: Maakt en configureert het SwiftUI-element `ScrollView`.
            ScrollView {
                // Regeluitleg: Maakt en configureert het SwiftUI-element `VStack`.
                VStack(spacing: 22) {
                    // Regeluitleg: Maakt en configureert het SwiftUI-element `Image`.
                    Image(systemName: advertising.isPremium ? "checkmark.seal.fill" : "crown.fill")
                        // Regeluitleg: Stelt het lettertype voor dit interface-element in.
                        .font(.system(size: 58, weight: .semibold))
                        // Regeluitleg: Stelt de voorgrondstijl van dit interface-element in.
                        .foregroundStyle(AppPalette.gold)
                        // Regeluitleg: Voegt de opgegeven binnenruimte rond dit interface-element toe.
                        .padding(.top, 18)

                    // Regeluitleg: Maakt en configureert het SwiftUI-element `Text`.
                    Text(advertising.isPremium ? "Premium is active" : "SyriaRadio Premium")
                        // Regeluitleg: Stelt het lettertype voor dit interface-element in.
                        .font(.system(size: 25, weight: .bold, design: .rounded))
                        // Regeluitleg: Stelt de voorgrondstijl van dit interface-element in.
                        .foregroundStyle(AppPalette.primary)
                        // Regeluitleg: Bepaalt de uitlijning van tekst over meerdere regels.
                        .multilineTextAlignment(.center)

                    // Regeluitleg: Voert het volgende codeblok alleen uit wanneer deze voorwaarde waar is.
                    if advertising.isPremium {
                        // Regeluitleg: Maakt en configureert het SwiftUI-element `Text`.
                        Text("Enjoy SyriaRadio without advertisements.")
                            // Regeluitleg: Stelt het lettertype voor dit interface-element in.
                            .font(.subheadline)
                            // Regeluitleg: Stelt de voorgrondstijl van dit interface-element in.
                            .foregroundStyle(AppPalette.textSecondary)
                            // Regeluitleg: Bepaalt de uitlijning van tekst over meerdere regels.
                            .multilineTextAlignment(.center)
                    // Regeluitleg: Sluit de vorige tak en controleert vervolgens een aanvullende voorwaarde.
                    } else if let product = advertising.premiumProduct {
                        // Regeluitleg: Maakt en configureert het SwiftUI-element `VStack`.
                        VStack(spacing: 8) {
                            // Regeluitleg: Maakt en configureert het SwiftUI-element `Text`.
                            Text(verbatim: product.displayName)
                                // Regeluitleg: Stelt het lettertype voor dit interface-element in.
                                .font(.headline)
                                // Regeluitleg: Stelt de voorgrondstijl van dit interface-element in.
                                .foregroundStyle(AppPalette.primary)
                            // Regeluitleg: Maakt en configureert het SwiftUI-element `Text`.
                            Text(verbatim: product.description)
                                // Regeluitleg: Stelt het lettertype voor dit interface-element in.
                                .font(.subheadline)
                                // Regeluitleg: Stelt de voorgrondstijl van dit interface-element in.
                                .foregroundStyle(AppPalette.textSecondary)
                                // Regeluitleg: Bepaalt de uitlijning van tekst over meerdere regels.
                                .multilineTextAlignment(.center)
                            // Regeluitleg: Maakt en configureert het SwiftUI-element `Text`.
                            Text(verbatim: product.displayPrice)
                                // Regeluitleg: Stelt het lettertype voor dit interface-element in.
                                .font(.system(size: 28, weight: .bold, design: .rounded))
                                // Regeluitleg: Stelt de voorgrondstijl van dit interface-element in.
                                .foregroundStyle(AppPalette.gold)
                        // Regeluitleg: Sluit het huidige codeblok af.
                        }
                    // Regeluitleg: Sluit de vorige tak en controleert vervolgens een aanvullende voorwaarde.
                    } else if advertising.isLoadingProduct {
                        // Regeluitleg: Maakt en configureert het SwiftUI-element `VStack`.
                        VStack(spacing: 10) {
                            // Regeluitleg: Maakt en configureert het SwiftUI-element `ProgressView`.
                            ProgressView()
                            // Regeluitleg: Maakt en configureert het SwiftUI-element `Text`.
                            Text("Loading price…")
                                // Regeluitleg: Stelt het lettertype voor dit interface-element in.
                                .font(.subheadline)
                                // Regeluitleg: Stelt de voorgrondstijl van dit interface-element in.
                                .foregroundStyle(AppPalette.textSecondary)
                        // Regeluitleg: Sluit het huidige codeblok af.
                        }
                    // Regeluitleg: Sluit de vorige tak en opent het alternatieve uitvoerpad.
                    } else {
                        // Regeluitleg: Maakt en configureert het SwiftUI-element `VStack`.
                        VStack(spacing: 8) {
                            // Regeluitleg: Maakt en configureert het SwiftUI-element `Label`.
                            Label("Price unavailable", systemImage: "eurosign.circle")
                                // Regeluitleg: Stelt het lettertype voor dit interface-element in.
                                .font(.headline)
                                // Regeluitleg: Stelt de voorgrondstijl van dit interface-element in.
                                .foregroundStyle(AppPalette.primary)
                            // Regeluitleg: Maakt en configureert het SwiftUI-element `Text`.
                            Text("The final price is always loaded securely from the App Store.")
                                // Regeluitleg: Stelt het lettertype voor dit interface-element in.
                                .font(.subheadline)
                                // Regeluitleg: Stelt de voorgrondstijl van dit interface-element in.
                                .foregroundStyle(AppPalette.textSecondary)
                                // Regeluitleg: Bepaalt de uitlijning van tekst over meerdere regels.
                                .multilineTextAlignment(.center)
                        // Regeluitleg: Sluit het huidige codeblok af.
                        }
                    // Regeluitleg: Sluit het huidige codeblok af.
                    }

                    // Regeluitleg: Voert het volgende codeblok alleen uit wanneer deze voorwaarde waar is.
                    if !advertising.isPremium {
                        // Regeluitleg: Maakt en configureert het SwiftUI-element `VStack`.
                        VStack(alignment: .leading, spacing: 14) {
                            // Regeluitleg: Roept `PremiumFeatureRow` aan met de argumenten in deze expressie.
                            PremiumFeatureRow(icon: "rectangle.slash", title: "No banner advertisements")
                            // Regeluitleg: Roept `PremiumFeatureRow` aan met de argumenten in deze expressie.
                            PremiumFeatureRow(icon: "speaker.slash.fill", title: "No audio advertisements")
                            // Regeluitleg: Roept `PremiumFeatureRow` aan met de argumenten in deze expressie.
                            PremiumFeatureRow(icon: "checkmark.shield.fill", title: "Verified by the App Store")
                        // Regeluitleg: Sluit het huidige codeblok af.
                        }
                        // Regeluitleg: Voegt de opgegeven binnenruimte rond dit interface-element toe.
                        .padding(18)
                        // Regeluitleg: Bepaalt de afmetingen en uitlijning van dit interface-element.
                        .frame(maxWidth: .infinity, alignment: .leading)
                        // Regeluitleg: Voegt de opgegeven achtergrond aan dit interface-element toe.
                        .background(AppPalette.card, in: RoundedRectangle(cornerRadius: 18))
                        // Regeluitleg: Gebruikt de enumwaarde of gekoppelde optie `overlay` in de huidige expressie.
                        .overlay {
                            // Regeluitleg: Maakt en configureert het SwiftUI-element `RoundedRectangle`.
                            RoundedRectangle(cornerRadius: 18)
                                // Regeluitleg: Past de SwiftUI-modifier of gekoppelde bewerking `stroke` toe.
                                .stroke(AppPalette.primary.opacity(0.06), lineWidth: 1)
                        // Regeluitleg: Sluit het huidige codeblok af.
                        }
                    // Regeluitleg: Sluit het huidige codeblok af.
                    }

                    // Regeluitleg: Voert het volgende codeblok alleen uit wanneer deze voorwaarde waar is.
                    if let message = advertising.storeMessage {
                        // Regeluitleg: Maakt en configureert het SwiftUI-element `Label`.
                        Label(message, systemImage: "info.circle.fill")
                            // Regeluitleg: Stelt het lettertype voor dit interface-element in.
                            .font(.subheadline)
                            // Regeluitleg: Stelt de voorgrondstijl van dit interface-element in.
                            .foregroundStyle(AppPalette.textSecondary)
                            // Regeluitleg: Bepaalt de uitlijning van tekst over meerdere regels.
                            .multilineTextAlignment(.center)
                    // Regeluitleg: Sluit het huidige codeblok af.
                    }

                    // Regeluitleg: Voert het volgende codeblok alleen uit wanneer deze voorwaarde waar is.
                    if let error = advertising.storeErrorMessage {
                        // Regeluitleg: Maakt en configureert het SwiftUI-element `VStack`.
                        VStack(spacing: 12) {
                            // Regeluitleg: Maakt en configureert het SwiftUI-element `Label`.
                            Label(error, systemImage: "exclamationmark.triangle.fill")
                                // Regeluitleg: Stelt het lettertype voor dit interface-element in.
                                .font(.subheadline)
                                // Regeluitleg: Stelt de voorgrondstijl van dit interface-element in.
                                .foregroundStyle(.red)
                                // Regeluitleg: Bepaalt de uitlijning van tekst over meerdere regels.
                                .multilineTextAlignment(.center)

                            // Regeluitleg: Maakt en configureert het SwiftUI-element `Button`.
                            Button("Try again") {
                                // Regeluitleg: Start een gestructureerde asynchrone taak.
                                Task { await advertising.retryLastStoreOperation() }
                            // Regeluitleg: Sluit het huidige codeblok af.
                            }
                            // Regeluitleg: Stelt het lettertype voor dit interface-element in.
                            .font(.subheadline.weight(.semibold))
                            // Regeluitleg: Schakelt de bediening uit wanneer de voorwaarde waar is.
                            .disabled(advertising.isStoreBusy)
                        // Regeluitleg: Sluit het huidige codeblok af.
                        }
                        // Regeluitleg: Voegt de opgegeven binnenruimte rond dit interface-element toe.
                        .padding(14)
                        // Regeluitleg: Bepaalt de afmetingen en uitlijning van dit interface-element.
                        .frame(maxWidth: .infinity)
                        // Regeluitleg: Voegt de opgegeven achtergrond aan dit interface-element toe.
                        .background(Color.red.opacity(0.08), in: RoundedRectangle(cornerRadius: 14))
                    // Regeluitleg: Sluit het huidige codeblok af.
                    }

                    // Regeluitleg: Voert het volgende codeblok alleen uit wanneer deze voorwaarde waar is.
                    if !advertising.isPremium, let product = advertising.premiumProduct {
                        // Regeluitleg: Maakt en configureert het SwiftUI-element `Button`.
                        Button {
                            // Regeluitleg: Start een gestructureerde asynchrone taak.
                            Task { await advertising.purchasePremium() }
                        // Regeluitleg: Opent het codeblok voor deze declaratie of bewerking.
                        } label: {
                            // Regeluitleg: Maakt en configureert het SwiftUI-element `HStack`.
                            HStack(spacing: 8) {
                                // Regeluitleg: Voert het volgende codeblok alleen uit wanneer deze voorwaarde waar is.
                                if advertising.isPurchasing {
                                    // Regeluitleg: Maakt en configureert het SwiftUI-element `ProgressView`.
                                    ProgressView().tint(.white)
                                // Regeluitleg: Sluit het huidige codeblok af.
                                }
                                // Regeluitleg: Maakt en configureert het SwiftUI-element `Text`.
                                Text("Unlock Premium")
                                // Regeluitleg: Maakt en configureert het SwiftUI-element `Text`.
                                Text(verbatim: "– \(product.displayPrice)")
                            // Regeluitleg: Sluit het huidige codeblok af.
                            }
                            // Regeluitleg: Stelt het lettertype voor dit interface-element in.
                            .font(.headline)
                            // Regeluitleg: Stelt de voorgrondstijl van dit interface-element in.
                            .foregroundStyle(.white)
                            // Regeluitleg: Bepaalt de afmetingen en uitlijning van dit interface-element.
                            .frame(maxWidth: .infinity, minHeight: 52)
                            // Regeluitleg: Voegt de opgegeven achtergrond aan dit interface-element toe.
                            .background(AppPalette.control, in: RoundedRectangle(cornerRadius: 15))
                        // Regeluitleg: Sluit het huidige codeblok af.
                        }
                        // Regeluitleg: Past de opgegeven knopstijl toe.
                        .buttonStyle(.plain)
                        // Regeluitleg: Schakelt de bediening uit wanneer de voorwaarde waar is.
                        .disabled(advertising.isStoreBusy)
                    // Regeluitleg: Sluit het huidige codeblok af.
                    }

                    // Regeluitleg: Voert het volgende codeblok alleen uit wanneer deze voorwaarde waar is.
                    if !advertising.isPremium {
                        // Regeluitleg: Maakt en configureert het SwiftUI-element `Button`.
                        Button {
                            // Regeluitleg: Start een gestructureerde asynchrone taak.
                            Task { await advertising.restorePurchases() }
                        // Regeluitleg: Opent het codeblok voor deze declaratie of bewerking.
                        } label: {
                            // Regeluitleg: Maakt en configureert het SwiftUI-element `HStack`.
                            HStack(spacing: 8) {
                                // Regeluitleg: Voert het volgende codeblok alleen uit wanneer deze voorwaarde waar is.
                                if advertising.isRestoring {
                                    // Regeluitleg: Maakt en configureert het SwiftUI-element `ProgressView`.
                                    ProgressView()
                                // Regeluitleg: Sluit het huidige codeblok af.
                                }
                                // Regeluitleg: Maakt en configureert het SwiftUI-element `Text`.
                                Text(advertising.isRestoring ? "Restoring…" : "Restore purchases")
                            // Regeluitleg: Sluit het huidige codeblok af.
                            }
                        // Regeluitleg: Sluit het huidige codeblok af.
                        }
                        // Regeluitleg: Stelt het lettertype voor dit interface-element in.
                        .font(.subheadline.weight(.semibold))
                        // Regeluitleg: Stelt de voorgrondstijl van dit interface-element in.
                        .foregroundStyle(AppPalette.gold)
                        // Regeluitleg: Schakelt de bediening uit wanneer de voorwaarde waar is.
                        .disabled(advertising.isStoreBusy)

                        // Regeluitleg: Maakt en configureert het SwiftUI-element `Text`.
                        Text("One-time purchase linked to your Apple ID.")
                            // Regeluitleg: Stelt het lettertype voor dit interface-element in.
                            .font(.caption)
                            // Regeluitleg: Stelt de voorgrondstijl van dit interface-element in.
                            .foregroundStyle(AppPalette.textSecondary)
                            // Regeluitleg: Bepaalt de uitlijning van tekst over meerdere regels.
                            .multilineTextAlignment(.center)
                    // Regeluitleg: Sluit het huidige codeblok af.
                    }
                // Regeluitleg: Sluit het huidige codeblok af.
                }
                // Regeluitleg: Voegt de opgegeven binnenruimte rond dit interface-element toe.
                .padding(28)
            // Regeluitleg: Sluit het huidige codeblok af.
            }
            // Regeluitleg: Voegt de opgegeven achtergrond aan dit interface-element toe.
            .background(AppPalette.background.ignoresSafeArea())
            // Regeluitleg: Stelt de titel van het navigatiescherm in.
            .navigationTitle("Premium")
            // Regeluitleg: Bepaalt hoe de navigatietitel wordt weergegeven.
            .navigationBarTitleDisplayMode(.inline)
            // Regeluitleg: Gebruikt de enumwaarde of gekoppelde optie `toolbar` in de huidige expressie.
            .toolbar {
                // Regeluitleg: Roept `ToolbarItem` aan met de argumenten in deze expressie.
                ToolbarItem(placement: .cancellationAction) {
                    // Regeluitleg: Maakt en configureert het SwiftUI-element `Button`.
                    Button("Done") { dismiss() }
                // Regeluitleg: Sluit het huidige codeblok af.
                }
            // Regeluitleg: Sluit het huidige codeblok af.
            }
            // Regeluitleg: Gebruikt de enumwaarde of gekoppelde optie `task` in de huidige expressie.
            .task {
                // Probeer opnieuw wanneer het venster opent, zodat een tijdelijke verbindingsfout
                // geen verouderde productinformatie op het scherm achterlaat.
                // Regeluitleg: Voert het volgende codeblok alleen uit wanneer deze voorwaarde waar is.
                if advertising.premiumProduct == nil, !advertising.isLoadingProduct {
                    // Regeluitleg: Wacht asynchroon tot deze bewerking is afgerond.
                    await advertising.loadPremiumProduct()
                // Regeluitleg: Sluit het huidige codeblok af.
                }
            // Regeluitleg: Sluit het huidige codeblok af.
            }
        // Regeluitleg: Sluit het huidige codeblok af.
        }
    // Regeluitleg: Sluit het huidige codeblok af.
    }
// Regeluitleg: Sluit het huidige codeblok af.
}

// Regeluitleg: Definieert de structuur `PremiumFeatureRow` en opent het bijbehorende codeblok.
private struct PremiumFeatureRow: View {
    // Regeluitleg: Declareert de waarde `icon` voor gebruik binnen de huidige scope.
    let icon: String
    // Regeluitleg: Declareert de waarde `title` voor gebruik binnen de huidige scope.
    let title: LocalizedStringKey

    // Regeluitleg: Declareert de waarde `body` voor gebruik binnen de huidige scope.
    var body: some View {
        // Regeluitleg: Maakt en configureert het SwiftUI-element `Label`.
        Label {
            // Regeluitleg: Maakt en configureert het SwiftUI-element `Text`.
            Text(title)
                // Regeluitleg: Stelt het lettertype voor dit interface-element in.
                .font(.subheadline.weight(.semibold))
                // Regeluitleg: Stelt de voorgrondstijl van dit interface-element in.
                .foregroundStyle(AppPalette.primary)
        // Regeluitleg: Opent het codeblok voor deze declaratie of bewerking.
        } icon: {
            // Regeluitleg: Maakt en configureert het SwiftUI-element `Image`.
            Image(systemName: icon)
                // Regeluitleg: Stelt de voorgrondstijl van dit interface-element in.
                .foregroundStyle(AppPalette.gold)
                // Regeluitleg: Bepaalt de afmetingen en uitlijning van dit interface-element.
                .frame(width: 24)
        // Regeluitleg: Sluit het huidige codeblok af.
        }
    // Regeluitleg: Sluit het huidige codeblok af.
    }
// Regeluitleg: Sluit het huidige codeblok af.
}

// MARK: - Juridische documenten

// Regeluitleg: Definieert de structuur `LegalDocumentView` en opent het bijbehorende codeblok.
private struct LegalDocumentView: View {
    // Regeluitleg: Declareert de waarde `document` voor gebruik binnen de huidige scope.
    let document: LegalDocument
    // Regeluitleg: Declareert `dismiss` met de SwiftUI-propertywrapper `@Environment`.
    @Environment(\.dismiss) private var dismiss

    // Regeluitleg: Declareert de waarde `body` voor gebruik binnen de huidige scope.
    var body: some View {
        // Regeluitleg: Maakt en configureert het SwiftUI-element `NavigationView`.
        NavigationView {
            // Regeluitleg: Maakt en configureert het SwiftUI-element `ScrollView`.
            ScrollView {
                // Regeluitleg: Maakt en configureert het SwiftUI-element `VStack`.
                VStack(alignment: .leading, spacing: 22) {
                    // Regeluitleg: Maakt en configureert het SwiftUI-element `VStack`.
                    VStack(spacing: 10) {
                        // Regeluitleg: Maakt en configureert het SwiftUI-element `Image`.
                        Image(systemName: document.icon)
                            // Regeluitleg: Stelt het lettertype voor dit interface-element in.
                            .font(.system(size: 42, weight: .semibold))
                            // Regeluitleg: Stelt de voorgrondstijl van dit interface-element in.
                            .foregroundStyle(AppPalette.gold)
                        // Regeluitleg: Maakt en configureert het SwiftUI-element `Text`.
                        Text(LocalizedStringKey(document.title))
                            // Regeluitleg: Stelt het lettertype voor dit interface-element in.
                            .font(.system(size: 26, weight: .bold, design: .rounded))
                            // Regeluitleg: Stelt de voorgrondstijl van dit interface-element in.
                            .foregroundStyle(AppPalette.primary)
                        // Regeluitleg: Maakt en configureert het SwiftUI-element `Text`.
                        Text("Effective date: 16 August 2026")
                            // Regeluitleg: Stelt het lettertype voor dit interface-element in.
                            .font(.caption.weight(.semibold))
                            // Regeluitleg: Stelt de voorgrondstijl van dit interface-element in.
                            .foregroundStyle(AppPalette.textSecondary)
                    // Regeluitleg: Sluit het huidige codeblok af.
                    }
                    // Regeluitleg: Bepaalt de afmetingen en uitlijning van dit interface-element.
                    .frame(maxWidth: .infinity)

                    // Regeluitleg: Maakt en configureert het SwiftUI-element `ForEach`.
                    ForEach(document.sections) { section in
                        // Regeluitleg: Maakt en configureert het SwiftUI-element `VStack`.
                        VStack(alignment: .leading, spacing: 8) {
                            // Regeluitleg: Maakt en configureert het SwiftUI-element `Text`.
                            Text(LocalizedStringKey(section.title))
                                // Regeluitleg: Stelt het lettertype voor dit interface-element in.
                                .font(.headline)
                                // Regeluitleg: Stelt de voorgrondstijl van dit interface-element in.
                                .foregroundStyle(AppPalette.primary)
                            // Regeluitleg: Maakt en configureert het SwiftUI-element `Text`.
                            Text(LocalizedStringKey(section.body))
                                // Regeluitleg: Stelt het lettertype voor dit interface-element in.
                                .font(.body)
                                // Regeluitleg: Stelt de voorgrondstijl van dit interface-element in.
                                .foregroundStyle(AppPalette.textSecondary)
                                // Regeluitleg: Laat de inhoud haar ideale afmeting op de opgegeven assen behouden.
                                .fixedSize(horizontal: false, vertical: true)
                        // Regeluitleg: Sluit het huidige codeblok af.
                        }
                        // Regeluitleg: Voegt de opgegeven binnenruimte rond dit interface-element toe.
                        .padding(18)
                        // Regeluitleg: Bepaalt de afmetingen en uitlijning van dit interface-element.
                        .frame(maxWidth: .infinity, alignment: .leading)
                        // Regeluitleg: Voegt de opgegeven achtergrond aan dit interface-element toe.
                        .background(AppPalette.card, in: RoundedRectangle(cornerRadius: 16))
                        // Regeluitleg: Gebruikt de enumwaarde of gekoppelde optie `overlay` in de huidige expressie.
                        .overlay {
                            // Regeluitleg: Maakt en configureert het SwiftUI-element `RoundedRectangle`.
                            RoundedRectangle(cornerRadius: 16)
                                // Regeluitleg: Past de SwiftUI-modifier of gekoppelde bewerking `stroke` toe.
                                .stroke(AppPalette.primary.opacity(0.06), lineWidth: 1)
                        // Regeluitleg: Sluit het huidige codeblok af.
                        }
                    // Regeluitleg: Sluit het huidige codeblok af.
                    }

                    // Regeluitleg: Maakt en configureert het SwiftUI-element `VStack`.
                    VStack(alignment: .leading, spacing: 12) {
                        // Regeluitleg: Voert het volgende codeblok alleen uit wanneer deze voorwaarde waar is.
                        if document == .privacy {
                            // Regeluitleg: Roept `LegalLink` aan met de argumenten in deze expressie.
                            LegalLink(title: "Online Privacy Policy", destination: AppLinks.privacyPolicy)
                            // Regeluitleg: Roept `LegalLink` aan met de argumenten in deze expressie.
                            LegalLink(title: "Google Privacy Policy", destination: AppLinks.googlePrivacy)
                            // Regeluitleg: Roept `LegalLink` aan met de argumenten in deze expressie.
                            LegalLink(title: "Apple Privacy Policy", destination: AppLinks.applePrivacy)
                        // Regeluitleg: Sluit de vorige tak en opent het alternatieve uitvoerpad.
                        } else {
                            // Regeluitleg: Roept `LegalLink` aan met de argumenten in deze expressie.
                            LegalLink(title: "Online Terms of Use", destination: AppLinks.termsOfUse)
                            // Regeluitleg: Roept `LegalLink` aan met de argumenten in deze expressie.
                            LegalLink(title: "Apple Standard EULA", destination: AppLinks.appleStandardEULA)
                        // Regeluitleg: Sluit het huidige codeblok af.
                        }

                        // Regeluitleg: Voert het volgende codeblok alleen uit wanneer deze voorwaarde waar is.
                        if let emailURL = URL(string: "mailto:\(AppLinks.supportEmail)") {
                            // Regeluitleg: Roept `LegalLink` aan met de argumenten in deze expressie.
                            LegalLink(title: "Contact the developer", destination: emailURL)
                        // Regeluitleg: Sluit het huidige codeblok af.
                        }
                    // Regeluitleg: Sluit het huidige codeblok af.
                    }
                // Regeluitleg: Sluit het huidige codeblok af.
                }
                // Regeluitleg: Voegt de opgegeven binnenruimte rond dit interface-element toe.
                .padding(24)
                // Regeluitleg: Bepaalt de afmetingen en uitlijning van dit interface-element.
                .frame(maxWidth: 760)
                // Regeluitleg: Bepaalt de afmetingen en uitlijning van dit interface-element.
                .frame(maxWidth: .infinity)
            // Regeluitleg: Sluit het huidige codeblok af.
            }
            // Regeluitleg: Voegt de opgegeven achtergrond aan dit interface-element toe.
            .background(AppPalette.background.ignoresSafeArea())
            // Regeluitleg: Stelt de titel van het navigatiescherm in.
            .navigationTitle(LocalizedStringKey(document.title))
            // Regeluitleg: Bepaalt hoe de navigatietitel wordt weergegeven.
            .navigationBarTitleDisplayMode(.inline)
            // Regeluitleg: Gebruikt de enumwaarde of gekoppelde optie `toolbar` in de huidige expressie.
            .toolbar {
                // Regeluitleg: Roept `ToolbarItem` aan met de argumenten in deze expressie.
                ToolbarItem(placement: .cancellationAction) {
                    // Regeluitleg: Maakt en configureert het SwiftUI-element `Button`.
                    Button("Done") { dismiss() }
                // Regeluitleg: Sluit het huidige codeblok af.
                }
            // Regeluitleg: Sluit het huidige codeblok af.
            }
        // Regeluitleg: Sluit het huidige codeblok af.
        }
    // Regeluitleg: Sluit het huidige codeblok af.
    }
// Regeluitleg: Sluit het huidige codeblok af.
}

// Regeluitleg: Definieert de structuur `LegalLink` en opent het bijbehorende codeblok.
private struct LegalLink: View {
    // Regeluitleg: Declareert de waarde `title` voor gebruik binnen de huidige scope.
    let title: LocalizedStringKey
    // Regeluitleg: Declareert de waarde `destination` voor gebruik binnen de huidige scope.
    let destination: URL

    // Regeluitleg: Declareert de waarde `body` voor gebruik binnen de huidige scope.
    var body: some View {
        // Regeluitleg: Maakt en configureert het SwiftUI-element `Link`.
        Link(destination: destination) {
            // Regeluitleg: Maakt en configureert het SwiftUI-element `HStack`.
            HStack(spacing: 12) {
                // Regeluitleg: Maakt en configureert het SwiftUI-element `Image`.
                Image(systemName: "arrow.up.right.square")
                    // Regeluitleg: Stelt de voorgrondstijl van dit interface-element in.
                    .foregroundStyle(AppPalette.gold)
                // Regeluitleg: Maakt en configureert het SwiftUI-element `Text`.
                Text(title)
                    // Regeluitleg: Stelt het lettertype voor dit interface-element in.
                    .font(.subheadline.weight(.semibold))
                // Regeluitleg: Maakt en configureert het SwiftUI-element `Spacer`.
                Spacer()
                // Regeluitleg: Maakt en configureert het SwiftUI-element `Image`.
                Image(systemName: "chevron.right")
                    // Regeluitleg: Stelt het lettertype voor dit interface-element in.
                    .font(.caption.weight(.bold))
                    // Regeluitleg: Stelt de voorgrondstijl van dit interface-element in.
                    .foregroundStyle(AppPalette.textSecondary.opacity(0.55))
            // Regeluitleg: Sluit het huidige codeblok af.
            }
            // Regeluitleg: Stelt de voorgrondstijl van dit interface-element in.
            .foregroundStyle(AppPalette.primary)
            // Regeluitleg: Voegt de opgegeven binnenruimte rond dit interface-element toe.
            .padding(16)
            // Regeluitleg: Voegt de opgegeven achtergrond aan dit interface-element toe.
            .background(AppPalette.card, in: RoundedRectangle(cornerRadius: 14))
        // Regeluitleg: Sluit het huidige codeblok af.
        }
    // Regeluitleg: Sluit het huidige codeblok af.
    }
// Regeluitleg: Sluit het huidige codeblok af.
}

// MARK: - Instellingencomponenten

// Regeluitleg: Definieert de structuur `SettingsPickerCard` en opent het bijbehorende codeblok.
private struct SettingsPickerCard: View {
    // Regeluitleg: Declareert de waarde `title` voor gebruik binnen de huidige scope.
    let title: String
    // Regeluitleg: Declareert de waarde `message` voor gebruik binnen de huidige scope.
    let message: String
    // Regeluitleg: Declareert de waarde `options` voor gebruik binnen de huidige scope.
    let options: [String]
    // Regeluitleg: Declareert de waarde `selected` voor gebruik binnen de huidige scope.
    let selected: String
    // Regeluitleg: Declareert de waarde `localizesOptions` voor gebruik binnen de huidige scope.
    let localizesOptions: Bool
    // Regeluitleg: Declareert de waarde `onSelect` voor gebruik binnen de huidige scope.
    let onSelect: (String) -> Void
    // Regeluitleg: Declareert de waarde `onCancel` voor gebruik binnen de huidige scope.
    let onCancel: () -> Void

    // Regeluitleg: Declareert de waarde `body` voor gebruik binnen de huidige scope.
    var body: some View {
        // Regeluitleg: Maakt en configureert het SwiftUI-element `VStack`.
        VStack(spacing: 16) {
            // Regeluitleg: Maakt en configureert het SwiftUI-element `Text`.
            Text(LocalizedStringKey(title))
                // Regeluitleg: Stelt het lettertype voor dit interface-element in.
                .font(.system(size: 21, weight: .bold, design: .rounded))
                // Regeluitleg: Stelt de voorgrondstijl van dit interface-element in.
                .foregroundStyle(AppPalette.primary)

            // Regeluitleg: Maakt en configureert het SwiftUI-element `Text`.
            Text(LocalizedStringKey(message))
                // Regeluitleg: Stelt het lettertype voor dit interface-element in.
                .font(.subheadline)
                // Regeluitleg: Bepaalt de uitlijning van tekst over meerdere regels.
                .multilineTextAlignment(.center)
                // Regeluitleg: Stelt de voorgrondstijl van dit interface-element in.
                .foregroundStyle(AppPalette.textSecondary)
                // Regeluitleg: Laat de inhoud haar ideale afmeting op de opgegeven assen behouden.
                .fixedSize(horizontal: false, vertical: true)

            // Regeluitleg: Maakt en configureert het SwiftUI-element `ScrollView`.
            ScrollView(showsIndicators: options.count > 5) {
                // Regeluitleg: Maakt en configureert het SwiftUI-element `VStack`.
                VStack(spacing: 7) {
                    // Regeluitleg: Maakt en configureert het SwiftUI-element `ForEach`.
                    ForEach(options, id: \.self) { option in
                        // Regeluitleg: Maakt en configureert het SwiftUI-element `Button`.
                        Button { onSelect(option) } label: {
                            // Regeluitleg: Maakt en configureert het SwiftUI-element `HStack`.
                            HStack {
                                // Regeluitleg: Maakt en configureert het SwiftUI-element `Group`.
                                Group {
                                    // Regeluitleg: Voert het volgende codeblok alleen uit wanneer deze voorwaarde waar is.
                                    if localizesOptions {
                                        // Regeluitleg: Maakt en configureert het SwiftUI-element `Text`.
                                        Text(LocalizedStringKey(option))
                                    // Regeluitleg: Sluit de vorige tak en opent het alternatieve uitvoerpad.
                                    } else {
                                        // Regeluitleg: Maakt en configureert het SwiftUI-element `Text`.
                                        Text(verbatim: option)
                                    // Regeluitleg: Sluit het huidige codeblok af.
                                    }
                                // Regeluitleg: Sluit het huidige codeblok af.
                                }
                                // Regeluitleg: Stelt het lettertype voor dit interface-element in.
                                .font(.system(size: 15, weight: .semibold))
                                // Regeluitleg: Maakt en configureert het SwiftUI-element `Spacer`.
                                Spacer()
                                // Regeluitleg: Maakt en configureert het SwiftUI-element `Image`.
                                Image(systemName: selected == option ? "checkmark.circle.fill" : "circle")
                                    // Regeluitleg: Stelt het lettertype voor dit interface-element in.
                                    .font(.system(size: 19, weight: .semibold))
                            // Regeluitleg: Sluit het huidige codeblok af.
                            }
                            // Regeluitleg: Stelt de voorgrondstijl van dit interface-element in.
                            .foregroundStyle(selected == option ? AppPalette.gold : AppPalette.primary)
                            // Regeluitleg: Voegt de opgegeven binnenruimte rond dit interface-element toe.
                            .padding(.horizontal, 14)
                            // Regeluitleg: Bepaalt de afmetingen en uitlijning van dit interface-element.
                            .frame(height: 44)
                            // Regeluitleg: Voegt de opgegeven achtergrond aan dit interface-element toe.
                            .background(
                                // Regeluitleg: Werkt de waarde `selected` bij met het resultaat van deze expressie.
                                selected == option ? AppPalette.goldLight.opacity(0.22) : AppPalette.surfaceBlue.opacity(0.55),
                                // Regeluitleg: Geeft de waarde voor parameter of eigenschap `in` door.
                                in: RoundedRectangle(cornerRadius: 12)
                            // Regeluitleg: Sluit de gegroepeerde argumenten van deze expressie af.
                            )
                            // Regeluitleg: Bepaalt het volledige interactieve gebied van dit element.
                            .contentShape(Rectangle())
                        // Regeluitleg: Sluit het huidige codeblok af.
                        }
                        // Regeluitleg: Past de opgegeven knopstijl toe.
                        .buttonStyle(.plain)
                    // Regeluitleg: Sluit het huidige codeblok af.
                    }
                // Regeluitleg: Sluit het huidige codeblok af.
                }
            // Regeluitleg: Sluit het huidige codeblok af.
            }
            // Regeluitleg: Bepaalt de afmetingen en uitlijning van dit interface-element.
            .frame(height: min(CGFloat(options.count) * 51, 240))

            // Regeluitleg: Maakt en configureert het SwiftUI-element `Button`.
            Button("Cancel", action: onCancel)
                // Regeluitleg: Stelt het lettertype voor dit interface-element in.
                .font(.system(size: 15, weight: .semibold))
                // Regeluitleg: Stelt de voorgrondstijl van dit interface-element in.
                .foregroundStyle(AppPalette.textSecondary)
                // Regeluitleg: Bepaalt de afmetingen en uitlijning van dit interface-element.
                .frame(maxWidth: .infinity, minHeight: 44)
        // Regeluitleg: Sluit het huidige codeblok af.
        }
        // Regeluitleg: Voegt de opgegeven binnenruimte rond dit interface-element toe.
        .padding(18)
        // Regeluitleg: Bepaalt de afmetingen en uitlijning van dit interface-element.
        .frame(maxWidth: 320)
        // Regeluitleg: Voegt de opgegeven achtergrond aan dit interface-element toe.
        .background(AppPalette.card, in: RoundedRectangle(cornerRadius: 22))
        // Regeluitleg: Voegt de opgegeven schaduw aan dit interface-element toe.
        .shadow(color: AppPalette.primary.opacity(0.2), radius: 28, y: 14)
        // Regeluitleg: Voegt de opgegeven binnenruimte rond dit interface-element toe.
        .padding(.horizontal, 24)
        // Regeluitleg: Bepaalt de overgang waarmee dit interface-element verschijnt of verdwijnt.
        .transition(.scale(scale: 0.94).combined(with: .opacity))
    // Regeluitleg: Sluit het huidige codeblok af.
    }
// Regeluitleg: Sluit het huidige codeblok af.
}

// Regeluitleg: Definieert de structuur `SettingsRow` en opent het bijbehorende codeblok.
struct SettingsRow: View {
    // Regeluitleg: Declareert de waarde `icon` voor gebruik binnen de huidige scope.
    let icon: String
    // Regeluitleg: Declareert de waarde `title` voor gebruik binnen de huidige scope.
    let title: LocalizedStringKey
    // Regeluitleg: Declareert de waarde `detail` voor gebruik binnen de huidige scope.
    let detail: String
    // Regeluitleg: Declareert de waarde `localizesDetail` voor gebruik binnen de huidige scope.
    var localizesDetail = true
    // Regeluitleg: Declareert de waarde `action` voor gebruik binnen de huidige scope.
    let action: () -> Void

    // Regeluitleg: Declareert de waarde `body` voor gebruik binnen de huidige scope.
    var body: some View {
        // Regeluitleg: Maakt en configureert het SwiftUI-element `Button`.
        Button(action: action) {
            // Regeluitleg: Maakt en configureert het SwiftUI-element `HStack`.
            HStack(spacing: 14) {
                // Regeluitleg: Maakt en configureert het SwiftUI-element `Image`.
                Image(systemName: icon)
                    // Regeluitleg: Stelt de voorgrondstijl van dit interface-element in.
                    .foregroundStyle(AppPalette.gold)
                    // Regeluitleg: Bepaalt de afmetingen en uitlijning van dit interface-element.
                    .frame(width: 28)
                // Regeluitleg: Maakt en configureert het SwiftUI-element `Text`.
                Text(title).foregroundStyle(AppPalette.primary)
                // Regeluitleg: Maakt en configureert het SwiftUI-element `Spacer`.
                Spacer()
                // Regeluitleg: Maakt en configureert het SwiftUI-element `Group`.
                Group {
                    // Regeluitleg: Voert het volgende codeblok alleen uit wanneer deze voorwaarde waar is.
                    if localizesDetail {
                        // Regeluitleg: Maakt en configureert het SwiftUI-element `Text`.
                        Text(LocalizedStringKey(detail))
                    // Regeluitleg: Sluit de vorige tak en opent het alternatieve uitvoerpad.
                    } else {
                        // Regeluitleg: Maakt en configureert het SwiftUI-element `Text`.
                        Text(verbatim: detail)
                    // Regeluitleg: Sluit het huidige codeblok af.
                    }
                // Regeluitleg: Sluit het huidige codeblok af.
                }
                // Regeluitleg: Stelt het lettertype voor dit interface-element in.
                .font(.subheadline)
                // Regeluitleg: Stelt de voorgrondstijl van dit interface-element in.
                .foregroundStyle(AppPalette.textSecondary)
                    // Regeluitleg: Beperkt het aantal zichtbare tekstregels.
                    .lineLimit(1)
                // Regeluitleg: Maakt en configureert het SwiftUI-element `Image`.
                Image(systemName: "chevron.right")
                    // Regeluitleg: Stelt het lettertype voor dit interface-element in.
                    .font(.caption.weight(.semibold))
                    // Regeluitleg: Stelt de voorgrondstijl van dit interface-element in.
                    .foregroundStyle(AppPalette.textSecondary.opacity(0.4))
            // Regeluitleg: Sluit het huidige codeblok af.
            }
            // Regeluitleg: Bepaalt het volledige interactieve gebied van dit element.
            .contentShape(Rectangle())
        // Regeluitleg: Sluit het huidige codeblok af.
        }
        // Regeluitleg: Past de opgegeven knopstijl toe.
        .buttonStyle(.plain)
        // Regeluitleg: Voegt de opgegeven binnenruimte rond dit interface-element toe.
        .padding(16)
        // Regeluitleg: Voegt de opgegeven achtergrond aan dit interface-element toe.
        .background(AppPalette.card, in: RoundedRectangle(cornerRadius: 16))
        // Regeluitleg: Gebruikt de enumwaarde of gekoppelde optie `overlay` in de huidige expressie.
        .overlay {
            // Regeluitleg: Maakt en configureert het SwiftUI-element `RoundedRectangle`.
            RoundedRectangle(cornerRadius: 16)
                // Regeluitleg: Past de SwiftUI-modifier of gekoppelde bewerking `stroke` toe.
                .stroke(AppPalette.primary.opacity(0.04), lineWidth: 1)
        // Regeluitleg: Sluit het huidige codeblok af.
        }
    // Regeluitleg: Sluit het huidige codeblok af.
    }
// Regeluitleg: Sluit het huidige codeblok af.
}

// Regeluitleg: Definieert de structuur `SettingsSection` en opent het bijbehorende codeblok.
private struct SettingsSection<Content: View>: View {
    // Regeluitleg: Declareert de waarde `title` voor gebruik binnen de huidige scope.
    let title: LocalizedStringKey
    // Regeluitleg: Laat deze declaratie meerdere SwiftUI-weergaven als één inhoudsblok bouwen.
    @ViewBuilder let content: () -> Content

    // Regeluitleg: Declareert de waarde `body` voor gebruik binnen de huidige scope.
    var body: some View {
        // Regeluitleg: Maakt en configureert het SwiftUI-element `VStack`.
        VStack(alignment: .leading, spacing: 10) {
            // Regeluitleg: Maakt en configureert het SwiftUI-element `Text`.
            Text(title)
                // Regeluitleg: Stelt het lettertype voor dit interface-element in.
                .font(.caption.weight(.bold))
                // Regeluitleg: Past de SwiftUI-modifier of gekoppelde bewerking `tracking` toe.
                .tracking(0.8)
                // Regeluitleg: Past de opgegeven hoofdletterweergave op de tekst toe.
                .textCase(.uppercase)
                // Regeluitleg: Stelt de voorgrondstijl van dit interface-element in.
                .foregroundStyle(AppPalette.textSecondary)
                // Regeluitleg: Voegt de opgegeven binnenruimte rond dit interface-element toe.
                .padding(.horizontal, 4)
            // Regeluitleg: Maakt en configureert het SwiftUI-element `VStack`.
            VStack(spacing: 10, content: content)
        // Regeluitleg: Sluit het huidige codeblok af.
        }
    // Regeluitleg: Sluit het huidige codeblok af.
    }
// Regeluitleg: Sluit het huidige codeblok af.
}

// Regeluitleg: Definieert de structuur `SettingsToggleRow` en opent het bijbehorende codeblok.
private struct SettingsToggleRow: View {
    // Regeluitleg: Declareert de waarde `icon` voor gebruik binnen de huidige scope.
    let icon: String
    // Regeluitleg: Declareert de waarde `title` voor gebruik binnen de huidige scope.
    let title: LocalizedStringKey
    // Regeluitleg: Declareert de waarde `detail` voor gebruik binnen de huidige scope.
    let detail: LocalizedStringKey
    // Regeluitleg: Declareert `isOn` met de SwiftUI-propertywrapper `@Binding`.
    @Binding var isOn: Bool

    // Regeluitleg: Declareert de waarde `body` voor gebruik binnen de huidige scope.
    var body: some View {
        // Regeluitleg: Maakt en configureert het SwiftUI-element `HStack`.
        HStack(spacing: 14) {
            // Regeluitleg: Maakt en configureert het SwiftUI-element `Image`.
            Image(systemName: icon)
                // Regeluitleg: Stelt de voorgrondstijl van dit interface-element in.
                .foregroundStyle(AppPalette.gold)
                // Regeluitleg: Bepaalt de afmetingen en uitlijning van dit interface-element.
                .frame(width: 28)
            // Regeluitleg: Maakt en configureert het SwiftUI-element `VStack`.
            VStack(alignment: .leading, spacing: 3) {
                // Regeluitleg: Maakt en configureert het SwiftUI-element `Text`.
                Text(title)
                    // Regeluitleg: Stelt de voorgrondstijl van dit interface-element in.
                    .foregroundStyle(AppPalette.primary)
                // Regeluitleg: Maakt en configureert het SwiftUI-element `Text`.
                Text(detail)
                    // Regeluitleg: Stelt het lettertype voor dit interface-element in.
                    .font(.caption)
                    // Regeluitleg: Stelt de voorgrondstijl van dit interface-element in.
                    .foregroundStyle(AppPalette.textSecondary)
            // Regeluitleg: Sluit het huidige codeblok af.
            }
            // Regeluitleg: Maakt en configureert het SwiftUI-element `Spacer`.
            Spacer()
            // Regeluitleg: Roept `Toggle` aan met de argumenten in deze expressie.
            Toggle("", isOn: $isOn)
                // Regeluitleg: Past de SwiftUI-modifier of gekoppelde bewerking `labelsHidden` toe.
                .labelsHidden()
                // Regeluitleg: Past de accentkleur van dit interface-element aan.
                .tint(AppPalette.gold)
        // Regeluitleg: Sluit het huidige codeblok af.
        }
        // Regeluitleg: Voegt de opgegeven binnenruimte rond dit interface-element toe.
        .padding(16)
        // Regeluitleg: Voegt de opgegeven achtergrond aan dit interface-element toe.
        .background(AppPalette.card.opacity(0.90), in: RoundedRectangle(cornerRadius: 16))
        // Regeluitleg: Gebruikt de enumwaarde of gekoppelde optie `overlay` in de huidige expressie.
        .overlay {
            // Regeluitleg: Maakt en configureert het SwiftUI-element `RoundedRectangle`.
            RoundedRectangle(cornerRadius: 16)
                // Regeluitleg: Past de SwiftUI-modifier of gekoppelde bewerking `stroke` toe.
                .stroke(AppPalette.primary.opacity(0.04), lineWidth: 1)
        // Regeluitleg: Sluit het huidige codeblok af.
        }
    // Regeluitleg: Sluit het huidige codeblok af.
    }
// Regeluitleg: Sluit het huidige codeblok af.
}

// Regeluitleg: Definieert de structuur `AboutSyriaRadioView` en opent het bijbehorende codeblok.
private struct AboutSyriaRadioView: View {
    // Regeluitleg: Declareert de waarde `version` voor gebruik binnen de huidige scope.
    let version: String
    // Regeluitleg: Declareert `dismiss` met de SwiftUI-propertywrapper `@Environment`.
    @Environment(\.dismiss) private var dismiss

    // Regeluitleg: Declareert de waarde `body` voor gebruik binnen de huidige scope.
    var body: some View {
        // Regeluitleg: Maakt en configureert het SwiftUI-element `ZStack`.
        ZStack {
            // Regeluitleg: Maakt en configureert het SwiftUI-element `LinearGradient`.
            LinearGradient(
                // Regeluitleg: Geeft de waarde voor parameter of eigenschap `colors` door.
                colors: [AppPalette.background, AppPalette.surfaceBlue],
                // Regeluitleg: Geeft de waarde voor parameter of eigenschap `startPoint` door.
                startPoint: .topLeading,
                // Regeluitleg: Geeft de waarde voor parameter of eigenschap `endPoint` door.
                endPoint: .bottomTrailing
            // Regeluitleg: Sluit de gegroepeerde argumenten van deze expressie af.
            )
            // Regeluitleg: Laat dit visuele element doorlopen buiten de veilige schermranden.
            .ignoresSafeArea()

            // Regeluitleg: Maakt en configureert het SwiftUI-element `VStack`.
            VStack(spacing: 18) {
                // Regeluitleg: Maakt en configureert het SwiftUI-element `HStack`.
                HStack {
                    // Regeluitleg: Maakt en configureert het SwiftUI-element `Spacer`.
                    Spacer()
                    // Regeluitleg: Maakt en configureert het SwiftUI-element `Button`.
                    Button { dismiss() } label: {
                        // Regeluitleg: Maakt en configureert het SwiftUI-element `Image`.
                        Image(systemName: "xmark")
                            // Regeluitleg: Stelt het lettertype voor dit interface-element in.
                            .font(.system(size: 15, weight: .bold))
                            // Regeluitleg: Stelt de voorgrondstijl van dit interface-element in.
                            .foregroundStyle(AppPalette.primary)
                            // Regeluitleg: Bepaalt de afmetingen en uitlijning van dit interface-element.
                            .frame(width: 38, height: 38)
                            // Regeluitleg: Voegt de opgegeven achtergrond aan dit interface-element toe.
                            .background(AppPalette.card, in: Circle())
                    // Regeluitleg: Sluit het huidige codeblok af.
                    }
                // Regeluitleg: Sluit het huidige codeblok af.
                }

                // Regeluitleg: Maakt en configureert het SwiftUI-element `Image`.
                Image(systemName: "radio.fill")
                    // Regeluitleg: Stelt het lettertype voor dit interface-element in.
                    .font(.system(size: 54))
                    // Regeluitleg: Stelt de voorgrondstijl van dit interface-element in.
                    .foregroundStyle(AppPalette.gold)
                    // Regeluitleg: Bepaalt de afmetingen en uitlijning van dit interface-element.
                    .frame(width: 112, height: 112)
                    // Regeluitleg: Voegt de opgegeven achtergrond aan dit interface-element toe.
                    .background(AppPalette.card, in: RoundedRectangle(cornerRadius: 28))
                    // Regeluitleg: Voegt de opgegeven schaduw aan dit interface-element toe.
                    .shadow(color: AppPalette.primary.opacity(0.12), radius: 18, y: 8)

                // Regeluitleg: Maakt en configureert het SwiftUI-element `Text`.
                Text("SyriaRadio")
                    // Regeluitleg: Stelt het lettertype voor dit interface-element in.
                    .font(.system(size: 30, weight: .bold, design: .rounded))
                    // Regeluitleg: Stelt de voorgrondstijl van dit interface-element in.
                    .foregroundStyle(AppPalette.primary)
                // Regeluitleg: Maakt en configureert het SwiftUI-element `Text`.
                Text(version)
                    // Regeluitleg: Stelt het lettertype voor dit interface-element in.
                    .font(.subheadline.weight(.semibold))
                    // Regeluitleg: Stelt de voorgrondstijl van dit interface-element in.
                    .foregroundStyle(AppPalette.gold)
                // Regeluitleg: Maakt en configureert het SwiftUI-element `Text`.
                Text("Listen to real Syrian radio stations in one simple and independent app.")
                    // Regeluitleg: Stelt het lettertype voor dit interface-element in.
                    .font(.body)
                    // Regeluitleg: Bepaalt de uitlijning van tekst over meerdere regels.
                    .multilineTextAlignment(.center)
                    // Regeluitleg: Stelt de voorgrondstijl van dit interface-element in.
                    .foregroundStyle(AppPalette.textSecondary)
                    // Regeluitleg: Voegt de opgegeven binnenruimte rond dit interface-element toe.
                    .padding(.horizontal, 22)
                // Regeluitleg: Maakt en configureert het SwiftUI-element `Spacer`.
                Spacer()
                // Regeluitleg: Maakt en configureert het SwiftUI-element `Text`.
                Text("Made for Syrian radio listeners")
                    // Regeluitleg: Stelt het lettertype voor dit interface-element in.
                    .font(.footnote.weight(.semibold))
                    // Regeluitleg: Stelt de voorgrondstijl van dit interface-element in.
                    .foregroundStyle(AppPalette.textSecondary.opacity(0.7))
            // Regeluitleg: Sluit het huidige codeblok af.
            }
            // Regeluitleg: Voegt de opgegeven binnenruimte rond dit interface-element toe.
            .padding(24)
        // Regeluitleg: Sluit het huidige codeblok af.
        }
    // Regeluitleg: Sluit het huidige codeblok af.
    }
// Regeluitleg: Sluit het huidige codeblok af.
}

// Regeluitleg: Laat deze declaratie meerdere SwiftUI-weergaven als één inhoudsblok bouwen.
@ViewBuilder
// Regeluitleg: Definieert de functie `sectionTitle` en haar invoerwaarden.
private func sectionTitle(_ text: LocalizedStringKey) -> some View {
    // Regeluitleg: Maakt en configureert het SwiftUI-element `Text`.
    Text(text).font(.system(size: 22, weight: .semibold, design: .rounded)).foregroundStyle(AppPalette.primary)
// Regeluitleg: Sluit het huidige codeblok af.
}
