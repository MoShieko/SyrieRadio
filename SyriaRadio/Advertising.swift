import AVFoundation
import Combine
import StoreKit
import SwiftUI
import UIKit

#if canImport(GoogleMobileAds)
import GoogleMobileAds
#endif

/// Coordinates StoreKit entitlements and both advertising formats.
/// Ads remain hidden until entitlement resolution finishes, preventing verified
/// Premium users from seeing an ad briefly during startup.
@MainActor
final class AdvertisingManager: NSObject, ObservableObject {
    enum StoreOperation {
        case loadProduct
        case purchase
        case restore
    }

    static let cooldown: TimeInterval = 30 * 60
    static let audioDuration = 8
    static let fallbackPremiumProductID = "Mohammed.Shieko.SyriaRadio.premium"

    @Published private(set) var isPremium = false
    @Published private(set) var isEntitlementResolved = false
    @Published private(set) var premiumProduct: Product?
    @Published private(set) var isLoadingProduct = false
    @Published private(set) var isPurchasing = false
    @Published private(set) var isRestoring = false
    @Published private(set) var storeMessage: String?
    @Published private(set) var storeErrorMessage: String?
    @Published private(set) var isPlayingAudioAdvertisement = false
    @Published private(set) var countdown = audioDuration

    private let defaults: UserDefaults
    private let premiumProductID: String
    private var audioPlayer: AVAudioPlayer?
    private var countdownTask: Task<Void, Never>?
    private var radioStartCompletion: (() -> Void)?
    private var entitlementTask: Task<Void, Never>?
    private var transactionListenerTask: Task<Void, Never>?
    private var failedStoreOperation: StoreOperation?

    init(defaults: UserDefaults = .standard, bundle: Bundle = .main) {
        self.defaults = defaults
        premiumProductID = (bundle.object(forInfoDictionaryKey: "PremiumProductIdentifier") as? String)
            .flatMap { $0.isEmpty ? nil : $0 }
            ?? Self.fallbackPremiumProductID
        super.init()

        // Resolve ownership before product metadata. Ownership controls ads;
        // product metadata supplies the localized name, description, and price.
        entitlementTask = Task { [weak self] in
            await self?.refreshPremiumEntitlement()
            await self?.loadPremiumProduct()
        }
        transactionListenerTask = Task { [weak self] in
            for await result in StoreKit.Transaction.updates {
                guard let self else { return }
                await self.processTransactionUpdate(result)
            }
        }
    }

    deinit {
        countdownTask?.cancel()
        entitlementTask?.cancel()
        transactionListenerTask?.cancel()
    }

    var shouldShowAdvertisements: Bool {
        isEntitlementResolved && !isPremium
    }

    var isStoreBusy: Bool {
        isLoadingProduct || isPurchasing || isRestoring
    }

    /// Loads App Store metadata without inventing a fallback price. The UI uses
    /// Product.displayPrice only after StoreKit supplies a localized value.
    func loadPremiumProduct() async {
        guard !isLoadingProduct else { return }
        isLoadingProduct = true
        storeErrorMessage = nil
        storeMessage = nil
        defer { isLoadingProduct = false }

        do {
            let products = try await Product.products(for: [premiumProductID])
            guard let product = products.first(where: { $0.id == premiumProductID }) else {
                throw StoreFailure.productUnavailable
            }
            premiumProduct = product
            failedStoreOperation = nil
        } catch {
            premiumProduct = nil
            recordStoreFailure(.loadProduct, error: error)
        }
    }

    /// Completes only verified StoreKit 2 transactions and then rechecks the
    /// current entitlement before exposing Premium features.
    func purchasePremium() async {
        guard !isPurchasing else { return }
        guard let product = premiumProduct else {
            await loadPremiumProduct()
            if premiumProduct == nil {
                failedStoreOperation = .loadProduct
            }
            return
        }

        isPurchasing = true
        storeErrorMessage = nil
        storeMessage = nil
        defer { isPurchasing = false }

        do {
            let result = try await product.purchase()
            switch result {
            case .success(.verified(let transaction)):
                guard transaction.productID == premiumProductID else {
                    throw StoreFailure.verificationFailed
                }
                await transaction.finish()
                await refreshPremiumEntitlement()
                guard isPremium else { throw StoreFailure.verificationFailed }
                storeMessage = NSLocalizedString("Premium is now active.", comment: "")
                failedStoreOperation = nil
            case .success(.unverified):
                throw StoreFailure.verificationFailed
            case .pending:
                storeMessage = NSLocalizedString("Your purchase is pending approval.", comment: "")
                failedStoreOperation = nil
            case .userCancelled:
                failedStoreOperation = nil
            @unknown default:
                throw StoreFailure.purchaseFailed
            }
        } catch {
            recordStoreFailure(.purchase, error: error)
        }
    }

    /// Reconciles purchases with the App Store and verifies that Premium is active.
    func restorePurchases() async {
        guard !isRestoring else { return }
        isRestoring = true
        storeErrorMessage = nil
        storeMessage = nil
        defer { isRestoring = false }

        do {
            try await AppStore.sync()
            await refreshPremiumEntitlement()
            guard isPremium else { throw StoreFailure.nothingToRestore }
            storeMessage = NSLocalizedString("Premium purchase restored.", comment: "")
            failedStoreOperation = nil
        } catch {
            recordStoreFailure(.restore, error: error)
        }
    }

    func retryLastStoreOperation() async {
        switch failedStoreOperation {
        case .purchase:
            await purchasePremium()
        case .restore:
            await restorePurchases()
        case .loadProduct, .none:
            await loadPremiumProduct()
        }
    }

    func clearStoreMessage() {
        storeMessage = nil
        storeErrorMessage = nil
    }

    /// Starts radio immediately for Premium users, or after the locally bundled
    /// audio advertisement when the cooldown allows one.
    func startRadio(afterAdvertisement completion: @escaping () -> Void) {
        if !isEntitlementResolved {
            radioStartCompletion = completion
            return
        }

        if isPlayingAudioAdvertisement {
            // A station change during the ad replaces the pending station.
            radioStartCompletion = completion
            return
        }

        guard shouldShowAdvertisements,
              shouldPlayAudioAdvertisement,
              let url = advertisementURL,
              let player = try? AVAudioPlayer(contentsOf: url)
        else {
            completion()
            return
        }

        countdownTask?.cancel()
        radioStartCompletion = completion
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

    func cancelPendingRadioStart() {
        radioStartCompletion = nil
    }

    private var shouldPlayAudioAdvertisement: Bool {
        guard shouldShowAdvertisements, !isPlayingAudioAdvertisement else { return false }
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
        // Unverified, revoked, upgraded, or expired transactions never unlock Premium.
        var entitled = false
        for await result in StoreKit.Transaction.currentEntitlements {
            guard case .verified(let transaction) = result,
                  transaction.productID == premiumProductID,
                  transaction.revocationDate == nil,
                  !transaction.isUpgraded
            else { continue }

            if let expirationDate = transaction.expirationDate, expirationDate <= Date() {
                continue
            }
            entitled = true
            break
        }

        isPremium = entitled
        isEntitlementResolved = true

        if entitled, isPlayingAudioAdvertisement {
            finishAudioAdvertisement()
        } else if let completion = radioStartCompletion, !isPlayingAudioAdvertisement {
            radioStartCompletion = nil
            startRadio(afterAdvertisement: completion)
        }
    }

    private func processTransactionUpdate(
        _ result: VerificationResult<StoreKit.Transaction>
    ) async {
        switch result {
        case .verified(let transaction):
            guard transaction.productID == premiumProductID else { return }
            await transaction.finish()
            await refreshPremiumEntitlement()
        case .unverified:
            recordStoreFailure(.purchase, error: StoreFailure.verificationFailed)
        }
    }

    private func recordStoreFailure(_ operation: StoreOperation, error: Error) {
        failedStoreOperation = operation
        if let failure = error as? StoreFailure {
            storeErrorMessage = failure.localizedDescription
        } else {
            storeErrorMessage = error.localizedDescription
        }
    }

    private func finishAudioAdvertisement() {
        guard isPlayingAudioAdvertisement else { return }
        countdownTask?.cancel()
        countdownTask = nil
        audioPlayer?.stop()
        audioPlayer = nil
        isPlayingAudioAdvertisement = false
        let action = radioStartCompletion
        radioStartCompletion = nil
        action?()
    }
}

private enum StoreFailure: LocalizedError {
    case productUnavailable
    case purchaseFailed
    case verificationFailed
    case nothingToRestore

    var errorDescription: String? {
        switch self {
        case .productUnavailable:
            return NSLocalizedString(
                "Premium could not be loaded. Check your connection and try again.",
                comment: ""
            )
        case .purchaseFailed:
            return NSLocalizedString(
                "The purchase could not be completed. Please try again.",
                comment: ""
            )
        case .verificationFailed:
            return NSLocalizedString(
                "The Premium purchase could not be verified.",
                comment: ""
            )
        case .nothingToRestore:
            return NSLocalizedString(
                "No active Premium purchase was found.",
                comment: ""
            )
        }
    }
}

struct AudioAdvertisementNotice: View {
    let seconds: Int

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: "speaker.wave.2.fill")
            Text(String.localizedStringWithFormat(
                NSLocalizedString("Advertisement – radio starts in %lld seconds", comment: ""),
                seconds
            ))
                .font(.subheadline.weight(.semibold))
        }
        .foregroundStyle(.white)
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(.black.opacity(0.88), in: Capsule())
        .accessibilityLabel(Text(String.localizedStringWithFormat(
            NSLocalizedString("Advertisement. Radio starts in %lld seconds.", comment: ""),
            seconds
        )))
    }
}

enum AdConfiguration {
    /// Google's documented test unit prevents accidental production traffic in DEBUG.
    static let googleDebugBannerUnitID = "ca-app-pub-3940256099942544/2435281174"

    static var bannerUnitID: String? {
#if DEBUG
        // Never read a production identifier in DEBUG.
        return googleDebugBannerUnitID
#else
        guard let value = Bundle.main.object(forInfoDictionaryKey: "AdMobBannerUnitID") as? String,
              !value.isEmpty,
              !value.contains("$(")
        else { return nil }
        return value
#endif
    }
}

#if canImport(GoogleMobileAds)
struct AdMobBanner: UIViewRepresentable {
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
}
#endif
