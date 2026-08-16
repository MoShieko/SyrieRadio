// Regeluitleg: Importeert het framework `Combine` voor de functionaliteit in dit bestand.
import Combine
// Regeluitleg: Importeert het framework `Foundation` voor de functionaliteit in dit bestand.
import Foundation
// Regeluitleg: Importeert het framework `UIKit` voor de functionaliteit in dit bestand.
import UIKit

/// Centrale externe bestemmingen voor Instellingen en de juridische schermen.
/// Centralisatie voorkomt dat koppelingen in de app en README van elkaar afwijken.
// Regeluitleg: Definieert de opsomming `AppLinks` en opent het bijbehorende codeblok.
enum AppLinks {
    // Regeluitleg: Declareert de waarde `privacyPolicy` voor gebruik binnen de huidige scope.
    static let privacyPolicy = URL(
        // Regeluitleg: Geeft de waarde voor parameter of eigenschap `string` door.
        string: "https://github.com/MoShieko/SyrieRadio/blob/main/PRIVACY_POLICY.md"
    // Regeluitleg: Sluit de gegroepeerde argumenten van deze expressie af.
    )!
    // Regeluitleg: Declareert de waarde `termsOfUse` voor gebruik binnen de huidige scope.
    static let termsOfUse = URL(
        // Regeluitleg: Geeft de waarde voor parameter of eigenschap `string` door.
        string: "https://github.com/MoShieko/SyrieRadio/blob/main/TERMS_OF_USE.md"
    // Regeluitleg: Sluit de gegroepeerde argumenten van deze expressie af.
    )!
    // Regeluitleg: Declareert de waarde `appleStandardEULA` voor gebruik binnen de huidige scope.
    static let appleStandardEULA = URL(
        // Regeluitleg: Geeft de waarde voor parameter of eigenschap `string` door.
        string: "https://www.apple.com/legal/internet-services/itunes/dev/stdeula/"
    // Regeluitleg: Sluit de gegroepeerde argumenten van deze expressie af.
    )!
    // Regeluitleg: Declareert de waarde `applePrivacy` voor gebruik binnen de huidige scope.
    static let applePrivacy = URL(string: "https://www.apple.com/legal/privacy/")!
    // Regeluitleg: Declareert de waarde `googlePrivacy` voor gebruik binnen de huidige scope.
    static let googlePrivacy = URL(string: "https://policies.google.com/privacy")!
    // Regeluitleg: Declareert de waarde `supportEmail` voor gebruik binnen de huidige scope.
    static let supportEmail = "mohammed.shekho.2022@gmail.com"
// Regeluitleg: Sluit het huidige codeblok af.
}

/// Opent na een bewuste gebruikersactie de permanente beoordelingspagina in de App Store.
/// Een ingesteld numeriek App Store-ID heeft voorrang; zoeken via de bundel ondersteunt
/// de overgang van ontwikkeling naar de eerste gepubliceerde versie.
// Regeluitleg: Dwingt toegang tot deze interfacegebonden status af op de hoofdactor.
@MainActor
// Regeluitleg: Definieert de niet-overerfbare klasse `AppStoreReviewManager` en opent het bijbehorende codeblok.
final class AppStoreReviewManager: ObservableObject {
    // Regeluitleg: Past het attribuut `@Published` op de volgende declaratie toe.
    @Published private(set) var isOpening = false
    // Regeluitleg: Declareert `errorMessage` met de SwiftUI-propertywrapper `@Published`.
    @Published var errorMessage: String?

    // Regeluitleg: Definieert de structuur `LookupResponse` en opent het bijbehorende codeblok.
    private struct LookupResponse: Decodable {
        // Regeluitleg: Definieert de structuur `App` en opent het bijbehorende codeblok.
        struct App: Decodable { let trackId: Int }
        // Regeluitleg: Declareert de waarde `results` voor gebruik binnen de huidige scope.
        let results: [App]
    // Regeluitleg: Sluit het huidige codeblok af.
    }

    /// Bepaalt de beoordelings-URL en geeft bruikbare fouten terug aan Instellingen.
    // Regeluitleg: Definieert de functie `openReviewPage` en haar invoerwaarden.
    func openReviewPage() async {
        // Regeluitleg: Controleert de vereiste voorwaarden en verlaat de huidige bewerking als die niet gelden.
        guard !isOpening else { return }
        // Regeluitleg: Werkt de waarde `isOpening` bij met het resultaat van deze expressie.
        isOpening = true
        // Regeluitleg: Werkt de waarde `errorMessage` bij met het resultaat van deze expressie.
        errorMessage = nil
        // Regeluitleg: Plant opruimwerk dat bij het verlaten van de huidige scope altijd wordt uitgevoerd.
        defer { isOpening = false }

        // Regeluitleg: Opent een foutafhandelbaar codeblok.
        do {
            // Regeluitleg: Declareert de waarde `reviewURL` voor gebruik binnen de huidige scope.
            let reviewURL = try await resolveReviewURL()
            // Regeluitleg: Declareert de waarde `opened` voor gebruik binnen de huidige scope.
            let opened = await withCheckedContinuation { continuation in
                // Regeluitleg: Roept `UIApplication.shared.open` aan met de argumenten in deze expressie.
                UIApplication.shared.open(reviewURL) { success in
                    // Regeluitleg: Roept `continuation.resume` aan met de argumenten in deze expressie.
                    continuation.resume(returning: success)
                // Regeluitleg: Sluit het huidige codeblok af.
                }
            // Regeluitleg: Sluit het huidige codeblok af.
            }
            // Regeluitleg: Voert het volgende codeblok alleen uit wanneer deze voorwaarde waar is.
            if !opened { throw ReviewError.cannotOpenAppStore }
        // Regeluitleg: Sluit de normale uitvoering en verwerkt de opgetreden fout.
        } catch let error as ReviewError {
            // Regeluitleg: Werkt de waarde `errorMessage` bij met het resultaat van deze expressie.
            errorMessage = error.localizedDescription
        // Regeluitleg: Sluit de normale uitvoering en verwerkt de opgetreden fout.
        } catch {
            // Regeluitleg: Werkt de waarde `errorMessage` bij met het resultaat van deze expressie.
            errorMessage = NSLocalizedString(
                // Regeluitleg: Voegt deze tekstwaarde aan de huidige collectie of configuratie toe.
                "The App Store could not be opened. Check your connection and try again.",
                // Regeluitleg: Geeft de waarde voor parameter of eigenschap `comment` door.
                comment: ""
            // Regeluitleg: Sluit de gegroepeerde argumenten van deze expressie af.
            )
        // Regeluitleg: Sluit het huidige codeblok af.
        }
    // Regeluitleg: Sluit het huidige codeblok af.
    }

    // Regeluitleg: Definieert de functie `resolveReviewURL` en haar invoerwaarden.
    private func resolveReviewURL() async throws -> URL {
        // AppStoreAppID voorkomt een netwerkzoekopdracht zodra App Store Connect
        // de definitieve identificatie heeft toegewezen.
        // Regeluitleg: Voert het volgende codeblok alleen uit wanneer deze voorwaarde waar is.
        if let configuredID = configuredAppStoreID,
           // Regeluitleg: Declareert de waarde `url` voor gebruik binnen de huidige scope.
           let url = reviewURL(appID: configuredID) {
            // Regeluitleg: Geeft het berekende resultaat terug aan de aanroeper.
            return url
        // Regeluitleg: Sluit het huidige codeblok af.
        }

        // Voordat AppStoreAppID is ingesteld, kan Apples zoekdienst een gepubliceerde app vinden
        // aan de hand van de bundel-ID en het land van de App Store.
        // Regeluitleg: Controleert de vereiste voorwaarden en verlaat de huidige bewerking als die niet gelden.
        guard let bundleID = Bundle.main.bundleIdentifier else {
            // Regeluitleg: Stopt de normale uitvoering en geeft deze fout aan de aanroeper door.
            throw ReviewError.appNotPublished
        // Regeluitleg: Sluit het huidige codeblok af.
        }

        // Regeluitleg: Declareert de waarde `components` voor gebruik binnen de huidige scope.
        var components = URLComponents(string: "https://itunes.apple.com/lookup")
        // Regeluitleg: Voert deze instructie uit als onderdeel van de huidige bewerking.
        components?.queryItems = [
            // Regeluitleg: Roept `URLQueryItem` aan met de argumenten in deze expressie.
            URLQueryItem(name: "bundleId", value: bundleID),
            // Regeluitleg: Roept `URLQueryItem` aan met de argumenten in deze expressie.
            URLQueryItem(name: "country", value: Locale.current.regionCode?.lowercased())
        // Regeluitleg: Sluit de huidige collectie of subscriptexpressie af.
        ]
        // Regeluitleg: Controleert de vereiste voorwaarden en verlaat de huidige bewerking als die niet gelden.
        guard let lookupURL = components?.url else { throw ReviewError.appNotPublished }

        // Regeluitleg: Roept `let` aan met de argumenten in deze expressie.
        let (data, response) = try await URLSession.shared.data(from: lookupURL)
        // Regeluitleg: Controleert de vereiste voorwaarden en verlaat de huidige bewerking als die niet gelden.
        guard let httpResponse = response as? HTTPURLResponse,
              // Regeluitleg: Opent of vervolgt de gegroepeerde argumenten van deze expressie.
              (200..<300).contains(httpResponse.statusCode)
        // Regeluitleg: Opent het alternatieve uitvoerpad wanneer de vorige voorwaarde niet geldt.
        else { throw ReviewError.cannotOpenAppStore }

        // Regeluitleg: Declareert de waarde `result` voor gebruik binnen de huidige scope.
        let result = try JSONDecoder().decode(LookupResponse.self, from: data)
        // Regeluitleg: Controleert de vereiste voorwaarden en verlaat de huidige bewerking als die niet gelden.
        guard let appID = result.results.first?.trackId,
              // Regeluitleg: Declareert de waarde `url` voor gebruik binnen de huidige scope.
              let url = reviewURL(appID: String(appID))
        // Regeluitleg: Opent het alternatieve uitvoerpad wanneer de vorige voorwaarde niet geldt.
        else { throw ReviewError.appNotPublished }
        // Regeluitleg: Geeft het berekende resultaat terug aan de aanroeper.
        return url
    // Regeluitleg: Sluit het huidige codeblok af.
    }

    // Regeluitleg: Declareert de waarde `configuredAppStoreID` voor gebruik binnen de huidige scope.
    private var configuredAppStoreID: String? {
        // Regeluitleg: Controleert de vereiste voorwaarden en verlaat de huidige bewerking als die niet gelden.
        guard let rawValue = Bundle.main.object(forInfoDictionaryKey: "AppStoreAppID") as? String else {
            // Regeluitleg: Geeft het berekende resultaat terug aan de aanroeper.
            return nil
        // Regeluitleg: Sluit het huidige codeblok af.
        }
        // Regeluitleg: Declareert de waarde `digits` voor gebruik binnen de huidige scope.
        let digits = rawValue.filter(\.isNumber)
        // Regeluitleg: Geeft het berekende resultaat terug aan de aanroeper.
        return digits.isEmpty ? nil : digits
    // Regeluitleg: Sluit het huidige codeblok af.
    }

    // Regeluitleg: Definieert de functie `reviewURL` en haar invoerwaarden.
    private func reviewURL(appID: String) -> URL? {
        // Regeluitleg: Roept `URL` aan met de argumenten in deze expressie.
        URL(string: "https://apps.apple.com/app/id\(appID)?action=write-review")
    // Regeluitleg: Sluit het huidige codeblok af.
    }
// Regeluitleg: Sluit het huidige codeblok af.
}

// Regeluitleg: Definieert de opsomming `ReviewError` en opent het bijbehorende codeblok.
private enum ReviewError: LocalizedError {
    // Regeluitleg: Declareert of behandelt de enumwaarde `appNotPublished`.
    case appNotPublished
    // Regeluitleg: Declareert of behandelt de enumwaarde `cannotOpenAppStore`.
    case cannotOpenAppStore

    // Regeluitleg: Declareert de waarde `errorDescription` voor gebruik binnen de huidige scope.
    var errorDescription: String? {
        // Regeluitleg: Kiest een uitvoerpad op basis van `self`.
        switch self {
        // Regeluitleg: Declareert of behandelt de enumwaarde `.appNotPublished`.
        case .appNotPublished:
            // Regeluitleg: Geeft het berekende resultaat terug aan de aanroeper.
            return NSLocalizedString(
                // Regeluitleg: Voegt deze tekstwaarde aan de huidige collectie of configuratie toe.
                "Reviews become available when SyriaRadio is published on the App Store.",
                // Regeluitleg: Geeft de waarde voor parameter of eigenschap `comment` door.
                comment: ""
            // Regeluitleg: Sluit de gegroepeerde argumenten van deze expressie af.
            )
        // Regeluitleg: Declareert of behandelt de enumwaarde `.cannotOpenAppStore`.
        case .cannotOpenAppStore:
            // Regeluitleg: Geeft het berekende resultaat terug aan de aanroeper.
            return NSLocalizedString(
                // Regeluitleg: Voegt deze tekstwaarde aan de huidige collectie of configuratie toe.
                "The App Store could not be opened. Check your connection and try again.",
                // Regeluitleg: Geeft de waarde voor parameter of eigenschap `comment` door.
                comment: ""
            // Regeluitleg: Sluit de gegroepeerde argumenten van deze expressie af.
            )
        // Regeluitleg: Sluit het huidige codeblok af.
        }
    // Regeluitleg: Sluit het huidige codeblok af.
    }
// Regeluitleg: Sluit het huidige codeblok af.
}

// Regeluitleg: Definieert de structuur `LegalSection` en opent het bijbehorende codeblok.
struct LegalSection: Identifiable {
    // Regeluitleg: Declareert de waarde `id` voor gebruik binnen de huidige scope.
    let id: String
    // Regeluitleg: Declareert de waarde `title` voor gebruik binnen de huidige scope.
    let title: String
    // Regeluitleg: Declareert de waarde `body` voor gebruik binnen de huidige scope.
    let body: String
// Regeluitleg: Sluit het huidige codeblok af.
}

/// Centrale bron voor de korte juridische tekst in de app. De openbare
/// Markdown-documenten blijven via AppLinks beschikbaar voor App Store-metadata.
// Regeluitleg: Definieert de opsomming `LegalDocument` en opent het bijbehorende codeblok.
enum LegalDocument: Equatable {
    // Regeluitleg: Declareert of behandelt de enumwaarde `privacy`.
    case privacy
    // Regeluitleg: Declareert of behandelt de enumwaarde `terms`.
    case terms

    // Regeluitleg: Declareert de waarde `title` voor gebruik binnen de huidige scope.
    var title: String {
        // Regeluitleg: Kiest een uitvoerpad op basis van `self`.
        switch self {
        // Regeluitleg: Declareert of behandelt de enumwaarde `.privacy`.
        case .privacy: return "Privacy Policy"
        // Regeluitleg: Declareert of behandelt de enumwaarde `.terms`.
        case .terms: return "Terms of Use"
        // Regeluitleg: Sluit het huidige codeblok af.
        }
    // Regeluitleg: Sluit het huidige codeblok af.
    }

    // Regeluitleg: Declareert de waarde `icon` voor gebruik binnen de huidige scope.
    var icon: String {
        // Regeluitleg: Kiest een uitvoerpad op basis van `self`.
        switch self {
        // Regeluitleg: Declareert of behandelt de enumwaarde `.privacy`.
        case .privacy: return "hand.raised.fill"
        // Regeluitleg: Declareert of behandelt de enumwaarde `.terms`.
        case .terms: return "doc.text.fill"
        // Regeluitleg: Sluit het huidige codeblok af.
        }
    // Regeluitleg: Sluit het huidige codeblok af.
    }

    // Regeluitleg: Declareert de waarde `sections` voor gebruik binnen de huidige scope.
    var sections: [LegalSection] {
        // Regeluitleg: Kiest een uitvoerpad op basis van `self`.
        switch self {
        // Regeluitleg: Declareert of behandelt de enumwaarde `.privacy`.
        case .privacy:
            // Regeluitleg: Geeft het berekende resultaat terug aan de aanroeper.
            return [
                // Regeluitleg: Past de SwiftUI-modifier of gekoppelde bewerking `init` toe.
                .init(
                    // Regeluitleg: Geeft de waarde voor parameter of eigenschap `id` door.
                    id: "privacy-overview",
                    // Regeluitleg: Geeft de waarde voor parameter of eigenschap `title` door.
                    title: "Privacy overview",
                    // Regeluitleg: Geeft de waarde voor parameter of eigenschap `body` door.
                    body: "SyriaRadio does not require an account. The developer does not operate a server that stores your listening history or favorites."
                // Regeluitleg: Sluit de gegroepeerde argumenten van deze expressie af.
                ),
                // Regeluitleg: Past de SwiftUI-modifier of gekoppelde bewerking `init` toe.
                .init(
                    // Regeluitleg: Geeft de waarde voor parameter of eigenschap `id` door.
                    id: "local-data",
                    // Regeluitleg: Geeft de waarde voor parameter of eigenschap `title` door.
                    title: "Information stored on your device",
                    // Regeluitleg: Geeft de waarde voor parameter of eigenschap `body` door.
                    body: "Favorites, language, appearance, streaming quality and playback preferences are stored locally on your device. You can remove this information by deleting the app."
                // Regeluitleg: Sluit de gegroepeerde argumenten van deze expressie af.
                ),
                // Regeluitleg: Past de SwiftUI-modifier of gekoppelde bewerking `init` toe.
                .init(
                    // Regeluitleg: Geeft de waarde voor parameter of eigenschap `id` door.
                    id: "advertising-data",
                    // Regeluitleg: Geeft de waarde voor parameter of eigenschap `title` door.
                    title: "Advertising",
                    // Regeluitleg: Geeft de waarde voor parameter of eigenschap `body` door.
                    body: "The free version uses Google Mobile Ads. Google and its partners may process device identifiers, IP address, advertising interactions and diagnostic information according to your consent and device settings. Premium prevents banner and audio advertisements after the App Store entitlement is verified."
                // Regeluitleg: Sluit de gegroepeerde argumenten van deze expressie af.
                ),
                // Regeluitleg: Past de SwiftUI-modifier of gekoppelde bewerking `init` toe.
                .init(
                    // Regeluitleg: Geeft de waarde voor parameter of eigenschap `id` door.
                    id: "stream-data",
                    // Regeluitleg: Geeft de waarde voor parameter of eigenschap `title` door.
                    title: "Radio streams",
                    // Regeluitleg: Geeft de waarde voor parameter of eigenschap `body` door.
                    body: "When you play a station, your device connects directly to that station’s streaming provider. The provider may receive technical information such as your IP address, request time and device networking information. SyriaRadio does not control the provider’s retention practices."
                // Regeluitleg: Sluit de gegroepeerde argumenten van deze expressie af.
                ),
                // Regeluitleg: Past de SwiftUI-modifier of gekoppelde bewerking `init` toe.
                .init(
                    // Regeluitleg: Geeft de waarde voor parameter of eigenschap `id` door.
                    id: "store-data",
                    // Regeluitleg: Geeft de waarde voor parameter of eigenschap `title` door.
                    title: "Purchases and the App Store",
                    // Regeluitleg: Geeft de waarde voor parameter of eigenschap `body` door.
                    body: "Apple processes Premium purchases, entitlements, payments, restores and App Store reviews. SyriaRadio receives only the verified entitlement needed to unlock Premium and does not receive your payment-card details."
                // Regeluitleg: Sluit de gegroepeerde argumenten van deze expressie af.
                ),
                // Regeluitleg: Past de SwiftUI-modifier of gekoppelde bewerking `init` toe.
                .init(
                    // Regeluitleg: Geeft de waarde voor parameter of eigenschap `id` door.
                    id: "privacy-choices",
                    // Regeluitleg: Geeft de waarde voor parameter of eigenschap `title` door.
                    title: "Your choices and data deletion",
                    // Regeluitleg: Geeft de waarde voor parameter of eigenschap `body` door.
                    body: "You can manage advertising and tracking choices in iOS Settings. Deleting SyriaRadio removes locally stored app preferences. For a privacy question or deletion request relating to information you sent by email, contact the developer."
                // Regeluitleg: Sluit de gegroepeerde argumenten van deze expressie af.
                ),
                // Regeluitleg: Past de SwiftUI-modifier of gekoppelde bewerking `init` toe.
                .init(
                    // Regeluitleg: Geeft de waarde voor parameter of eigenschap `id` door.
                    id: "privacy-contact",
                    // Regeluitleg: Geeft de waarde voor parameter of eigenschap `title` door.
                    title: "Changes and contact",
                    // Regeluitleg: Geeft de waarde voor parameter of eigenschap `body` door.
                    body: "This policy may be updated when the app or its third-party services change. Material changes will be reflected in the app and the online policy."
                // Regeluitleg: Sluit de gegroepeerde argumenten van deze expressie af.
                )
            // Regeluitleg: Sluit de huidige collectie of subscriptexpressie af.
            ]
        // Regeluitleg: Declareert of behandelt de enumwaarde `.terms`.
        case .terms:
            // Regeluitleg: Geeft het berekende resultaat terug aan de aanroeper.
            return [
                // Regeluitleg: Past de SwiftUI-modifier of gekoppelde bewerking `init` toe.
                .init(
                    // Regeluitleg: Geeft de waarde voor parameter of eigenschap `id` door.
                    id: "terms-license",
                    // Regeluitleg: Geeft de waarde voor parameter of eigenschap `title` door.
                    title: "Using SyriaRadio",
                    // Regeluitleg: Geeft de waarde voor parameter of eigenschap `body` door.
                    body: "By using SyriaRadio you agree to these terms and Apple’s Standard Licensed Application End User License Agreement. The app is licensed for personal, non-commercial use on supported Apple devices."
                // Regeluitleg: Sluit de gegroepeerde argumenten van deze expressie af.
                ),
                // Regeluitleg: Past de SwiftUI-modifier of gekoppelde bewerking `init` toe.
                .init(
                    // Regeluitleg: Geeft de waarde voor parameter of eigenschap `id` door.
                    id: "terms-streams",
                    // Regeluitleg: Geeft de waarde voor parameter of eigenschap `title` door.
                    title: "Third-party radio streams",
                    // Regeluitleg: Geeft de waarde voor parameter of eigenschap `body` door.
                    body: "SyriaRadio provides convenient access to streams operated by independent radio stations and hosting providers. Their content, availability and quality can change without notice. Inclusion does not imply ownership or endorsement."
                // Regeluitleg: Sluit de gegroepeerde argumenten van deze expressie af.
                ),
                // Regeluitleg: Past de SwiftUI-modifier of gekoppelde bewerking `init` toe.
                .init(
                    // Regeluitleg: Geeft de waarde voor parameter of eigenschap `id` door.
                    id: "terms-premium",
                    // Regeluitleg: Geeft de waarde voor parameter of eigenschap `title` door.
                    title: "Premium purchase",
                    // Regeluitleg: Geeft de waarde voor parameter of eigenschap `body` door.
                    body: "Premium is a one-time, non-consumable in-app purchase. The App Store shows the final local price before you confirm. Apple handles billing, refunds and purchase restoration under its own terms. Premium remains linked to the Apple ID used for purchase."
                // Regeluitleg: Sluit de gegroepeerde argumenten van deze expressie af.
                ),
                // Regeluitleg: Past de SwiftUI-modifier of gekoppelde bewerking `init` toe.
                .init(
                    // Regeluitleg: Geeft de waarde voor parameter of eigenschap `id` door.
                    id: "terms-ads",
                    // Regeluitleg: Geeft de waarde voor parameter of eigenschap `title` door.
                    title: "Advertising",
                    // Regeluitleg: Geeft de waarde voor parameter of eigenschap `body` door.
                    body: "The free version may show banner and audio advertisements. A verified Premium entitlement removes these advertisements. Advertising availability and content are provided by third parties."
                // Regeluitleg: Sluit de gegroepeerde argumenten van deze expressie af.
                ),
                // Regeluitleg: Past de SwiftUI-modifier of gekoppelde bewerking `init` toe.
                .init(
                    // Regeluitleg: Geeft de waarde voor parameter of eigenschap `id` door.
                    id: "terms-use",
                    // Regeluitleg: Geeft de waarde voor parameter of eigenschap `title` door.
                    title: "Acceptable use",
                    // Regeluitleg: Geeft de waarde voor parameter of eigenschap `body` door.
                    body: "Do not misuse the app, interfere with streams or services, attempt unauthorized access, reverse engineer the app except where law permits, or use the app in a way that violates applicable law or third-party rights."
                // Regeluitleg: Sluit de gegroepeerde argumenten van deze expressie af.
                ),
                // Regeluitleg: Past de SwiftUI-modifier of gekoppelde bewerking `init` toe.
                .init(
                    // Regeluitleg: Geeft de waarde voor parameter of eigenschap `id` door.
                    id: "terms-availability",
                    // Regeluitleg: Geeft de waarde voor parameter of eigenschap `title` door.
                    title: "Availability and responsibility",
                    // Regeluitleg: Geeft de waarde voor parameter of eigenschap `body` door.
                    body: "The app and radio streams are provided as available. Interruptions, outdated station information or unavailable streams can occur. Nothing in these terms limits consumer rights that cannot legally be excluded."
                // Regeluitleg: Sluit de gegroepeerde argumenten van deze expressie af.
                ),
                // Regeluitleg: Past de SwiftUI-modifier of gekoppelde bewerking `init` toe.
                .init(
                    // Regeluitleg: Geeft de waarde voor parameter of eigenschap `id` door.
                    id: "terms-contact",
                    // Regeluitleg: Geeft de waarde voor parameter of eigenschap `title` door.
                    title: "Changes and contact",
                    // Regeluitleg: Geeft de waarde voor parameter of eigenschap `body` door.
                    body: "These terms may be updated for legal, technical or service changes. Continued use after an update means the revised terms apply, subject to your mandatory consumer rights."
                // Regeluitleg: Sluit de gegroepeerde argumenten van deze expressie af.
                )
            // Regeluitleg: Sluit de huidige collectie of subscriptexpressie af.
            ]
        // Regeluitleg: Sluit het huidige codeblok af.
        }
    // Regeluitleg: Sluit het huidige codeblok af.
    }
// Regeluitleg: Sluit het huidige codeblok af.
}
