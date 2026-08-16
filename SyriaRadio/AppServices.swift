import Combine
import Foundation
import UIKit

enum AppLinks {
    static let privacyPolicy = URL(
        string: "https://github.com/MoShieko/SyrieRadio/blob/main/PRIVACY_POLICY.md"
    )!
    static let termsOfUse = URL(
        string: "https://github.com/MoShieko/SyrieRadio/blob/main/TERMS_OF_USE.md"
    )!
    static let appleStandardEULA = URL(
        string: "https://www.apple.com/legal/internet-services/itunes/dev/stdeula/"
    )!
    static let applePrivacy = URL(string: "https://www.apple.com/legal/privacy/")!
    static let googlePrivacy = URL(string: "https://policies.google.com/privacy")!
    static let supportEmail = "mohammed.shekho.2022@gmail.com"
}

@MainActor
final class AppStoreReviewManager: ObservableObject {
    @Published private(set) var isOpening = false
    @Published var errorMessage: String?

    private struct LookupResponse: Decodable {
        struct App: Decodable { let trackId: Int }
        let results: [App]
    }

    func openReviewPage() async {
        guard !isOpening else { return }
        isOpening = true
        errorMessage = nil
        defer { isOpening = false }

        do {
            let reviewURL = try await resolveReviewURL()
            let opened = await withCheckedContinuation { continuation in
                UIApplication.shared.open(reviewURL) { success in
                    continuation.resume(returning: success)
                }
            }
            if !opened { throw ReviewError.cannotOpenAppStore }
        } catch let error as ReviewError {
            errorMessage = error.localizedDescription
        } catch {
            errorMessage = NSLocalizedString(
                "The App Store could not be opened. Check your connection and try again.",
                comment: ""
            )
        }
    }

    private func resolveReviewURL() async throws -> URL {
        if let configuredID = configuredAppStoreID,
           let url = reviewURL(appID: configuredID) {
            return url
        }

        guard let bundleID = Bundle.main.bundleIdentifier else {
            throw ReviewError.appNotPublished
        }

        var components = URLComponents(string: "https://itunes.apple.com/lookup")
        components?.queryItems = [
            URLQueryItem(name: "bundleId", value: bundleID),
            URLQueryItem(name: "country", value: Locale.current.regionCode?.lowercased())
        ]
        guard let lookupURL = components?.url else { throw ReviewError.appNotPublished }

        let (data, response) = try await URLSession.shared.data(from: lookupURL)
        guard let httpResponse = response as? HTTPURLResponse,
              (200..<300).contains(httpResponse.statusCode)
        else { throw ReviewError.cannotOpenAppStore }

        let result = try JSONDecoder().decode(LookupResponse.self, from: data)
        guard let appID = result.results.first?.trackId,
              let url = reviewURL(appID: String(appID))
        else { throw ReviewError.appNotPublished }
        return url
    }

    private var configuredAppStoreID: String? {
        guard let rawValue = Bundle.main.object(forInfoDictionaryKey: "AppStoreAppID") as? String else {
            return nil
        }
        let digits = rawValue.filter(\.isNumber)
        return digits.isEmpty ? nil : digits
    }

    private func reviewURL(appID: String) -> URL? {
        URL(string: "https://apps.apple.com/app/id\(appID)?action=write-review")
    }
}

private enum ReviewError: LocalizedError {
    case appNotPublished
    case cannotOpenAppStore

    var errorDescription: String? {
        switch self {
        case .appNotPublished:
            return NSLocalizedString(
                "Reviews become available when SyriaRadio is published on the App Store.",
                comment: ""
            )
        case .cannotOpenAppStore:
            return NSLocalizedString(
                "The App Store could not be opened. Check your connection and try again.",
                comment: ""
            )
        }
    }
}

struct LegalSection: Identifiable {
    let id: String
    let title: String
    let body: String
}

enum LegalDocument: Equatable {
    case privacy
    case terms

    var title: String {
        switch self {
        case .privacy: return "Privacy Policy"
        case .terms: return "Terms of Use"
        }
    }

    var icon: String {
        switch self {
        case .privacy: return "hand.raised.fill"
        case .terms: return "doc.text.fill"
        }
    }

    var sections: [LegalSection] {
        switch self {
        case .privacy:
            return [
                .init(
                    id: "privacy-overview",
                    title: "Privacy overview",
                    body: "SyriaRadio does not require an account. The developer does not operate a server that stores your listening history or favorites."
                ),
                .init(
                    id: "local-data",
                    title: "Information stored on your device",
                    body: "Favorites, language, appearance, streaming quality and playback preferences are stored locally on your device. You can remove this information by deleting the app."
                ),
                .init(
                    id: "advertising-data",
                    title: "Advertising",
                    body: "The free version uses Google Mobile Ads. Google and its partners may process device identifiers, IP address, advertising interactions and diagnostic information according to your consent and device settings. Premium prevents banner and audio advertisements after the App Store entitlement is verified."
                ),
                .init(
                    id: "stream-data",
                    title: "Radio streams",
                    body: "When you play a station, your device connects directly to that station’s streaming provider. The provider may receive technical information such as your IP address, request time and device networking information. SyriaRadio does not control the provider’s retention practices."
                ),
                .init(
                    id: "store-data",
                    title: "Purchases and the App Store",
                    body: "Apple processes Premium purchases, entitlements, payments, restores and App Store reviews. SyriaRadio receives only the verified entitlement needed to unlock Premium and does not receive your payment-card details."
                ),
                .init(
                    id: "privacy-choices",
                    title: "Your choices and data deletion",
                    body: "You can manage advertising and tracking choices in iOS Settings. Deleting SyriaRadio removes locally stored app preferences. For a privacy question or deletion request relating to information you sent by email, contact the developer."
                ),
                .init(
                    id: "privacy-contact",
                    title: "Changes and contact",
                    body: "This policy may be updated when the app or its third-party services change. Material changes will be reflected in the app and the online policy."
                )
            ]
        case .terms:
            return [
                .init(
                    id: "terms-license",
                    title: "Using SyriaRadio",
                    body: "By using SyriaRadio you agree to these terms and Apple’s Standard Licensed Application End User License Agreement. The app is licensed for personal, non-commercial use on supported Apple devices."
                ),
                .init(
                    id: "terms-streams",
                    title: "Third-party radio streams",
                    body: "SyriaRadio provides convenient access to streams operated by independent radio stations and hosting providers. Their content, availability and quality can change without notice. Inclusion does not imply ownership or endorsement."
                ),
                .init(
                    id: "terms-premium",
                    title: "Premium purchase",
                    body: "Premium is a one-time, non-consumable in-app purchase. The App Store shows the final local price before you confirm. Apple handles billing, refunds and purchase restoration under its own terms. Premium remains linked to the Apple ID used for purchase."
                ),
                .init(
                    id: "terms-ads",
                    title: "Advertising",
                    body: "The free version may show banner and audio advertisements. A verified Premium entitlement removes these advertisements. Advertising availability and content are provided by third parties."
                ),
                .init(
                    id: "terms-use",
                    title: "Acceptable use",
                    body: "Do not misuse the app, interfere with streams or services, attempt unauthorized access, reverse engineer the app except where law permits, or use the app in a way that violates applicable law or third-party rights."
                ),
                .init(
                    id: "terms-availability",
                    title: "Availability and responsibility",
                    body: "The app and radio streams are provided as available. Interruptions, outdated station information or unavailable streams can occur. Nothing in these terms limits consumer rights that cannot legally be excluded."
                ),
                .init(
                    id: "terms-contact",
                    title: "Changes and contact",
                    body: "These terms may be updated for legal, technical or service changes. Continued use after an update means the revised terms apply, subject to your mandatory consumer rights."
                )
            ]
        }
    }
}
