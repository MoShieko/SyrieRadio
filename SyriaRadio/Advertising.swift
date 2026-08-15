import AVFoundation
import StoreKit
import SwiftUI
import UIKit

#if canImport(GoogleMobileAds)
import GoogleMobileAds
#endif

@MainActor
final class AdvertisingManager: NSObject, ObservableObject {
    static let cooldown: TimeInterval = 30 * 60
    static let audioDuration = 8

    @Published private(set) var isPremium: Bool
    @Published private(set) var isPlayingAudioAdvertisement = false
    @Published private(set) var countdown = audioDuration

    private let defaults: UserDefaults
    private var audioPlayer: AVAudioPlayer?
    private var countdownTask: Task<Void, Never>?
    private var completion: (() -> Void)?
    private var entitlementTask: Task<Void, Never>?

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        isPremium = defaults.bool(forKey: "isPremium")
        super.init()
        entitlementTask = Task { [weak self] in
            await self?.refreshPremiumEntitlement()
            for await _ in Transaction.updates {
                await self?.refreshPremiumEntitlement()
            }
        }
    }

    deinit { entitlementTask?.cancel() }

    /// Call this after StoreKit has verified or revoked the premium entitlement.
    func updatePremiumEntitlement(_ active: Bool) {
        isPremium = active
        defaults.set(active, forKey: "isPremium")
        if active, isPlayingAudioAdvertisement { finishAudioAdvertisement() }
    }

    func startRadio(afterAdvertisement completion: @escaping () -> Void) {
        if isPlayingAudioAdvertisement {
            // A station change during the ad replaces the pending station; it never starts a second ad.
            self.completion = completion
            return
        }
        guard shouldPlayAudioAdvertisement,
              let url = advertisementURL,
              let player = try? AVAudioPlayer(contentsOf: url)
        else {
            completion()
            return
        }

        countdownTask?.cancel()
        self.completion = completion
        audioPlayer = player
        player.play()
        isPlayingAudioAdvertisement = true
        countdown = Self.audioDuration
        defaults.set(Date(), forKey: "lastAudioAdvertisementDate")

        countdownTask = Task { [weak self] in
            for remaining in stride(from: Self.audioDuration, through: 1, by: -1) {
                guard !Task.isCancelled else { return }
                self?.countdown = remaining
                try? await Task.sleep(nanoseconds: 1_000_000_000)
            }
            guard !Task.isCancelled else { return }
            self?.finishAudioAdvertisement()
        }
    }

    private var shouldPlayAudioAdvertisement: Bool {
        guard !isPremium, !isPlayingAudioAdvertisement else { return false }
        guard let lastDate = defaults.object(forKey: "lastAudioAdvertisementDate") as? Date else {
            return true
        }
        return Date().timeIntervalSince(lastDate) >= Self.cooldown
    }

    private var advertisementURL: URL? {
        Bundle.main.url(forResource: "AudioAdvertisement", withExtension: "mp3")
            ?? Bundle.main.url(forResource: "AudioAdvertisement", withExtension: "wav")
    }

    private func refreshPremiumEntitlement() async {
        let productID = Bundle.main.object(forInfoDictionaryKey: "PremiumProductIdentifier") as? String
        guard let productID, !productID.isEmpty else { return }
        var entitled = false
        for await result in Transaction.currentEntitlements {
            guard case .verified(let transaction) = result,
                  transaction.productID == productID,
                  transaction.revocationDate == nil
            else { continue }
            entitled = true
            break
        }
        updatePremiumEntitlement(entitled)
    }

    private func finishAudioAdvertisement() {
        guard isPlayingAudioAdvertisement else { return }
        countdownTask?.cancel()
        countdownTask = nil
        audioPlayer?.stop()
        audioPlayer = nil
        isPlayingAudioAdvertisement = false
        let action = completion
        completion = nil
        action?()
    }
}

struct AudioAdvertisementNotice: View {
    let seconds: Int

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: "speaker.wave.2.fill")
            Text("Advertentie – radio start over \(seconds) seconden")
                .font(.subheadline.weight(.semibold))
        }
        .foregroundStyle(.white)
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(.black.opacity(0.88), in: Capsule())
        .accessibilityLabel("Advertentie. Radio start over \(seconds) seconden.")
    }
}

#if canImport(GoogleMobileAds)
struct AdMobBanner: UIViewRepresentable {
    // Google's iOS banner test unit. Replace with the production unit before release.
    static let testAdUnitID = "ca-app-pub-3940256099942544/2435281174"
    static let productionAdUnitID = "ca-app-pub-4415870051466870/1392187844"
    static var defaultAdUnitID: String {
        #if DEBUG
        testAdUnitID
        #else
        productionAdUnitID
        #endif
    }
    let adUnitID: String

    func makeUIView(context: Context) -> BannerView {
        let view = BannerView(adSize: AdSizeBanner)
        view.adUnitID = adUnitID
        view.rootViewController = UIApplication.shared.connectedScenes
            .compactMap { ($0 as? UIWindowScene)?.keyWindow?.rootViewController }
            .first
        view.load(Request())
        return view
    }

    func updateUIView(_ uiView: BannerView, context: Context) {}
}
#else
struct AdMobBanner: View {
    let adUnitID: String
    var body: some View { EmptyView() }
    static let testAdUnitID = "ca-app-pub-3940256099942544/2435281174"
    static let productionAdUnitID = "ca-app-pub-4415870051466870/1392187844"
    static var defaultAdUnitID: String { testAdUnitID }
}
#endif
