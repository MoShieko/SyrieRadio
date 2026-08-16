// Regeluitleg: Importeert het framework `AVFoundation` voor de functionaliteit in dit bestand.
import AVFoundation
// Regeluitleg: Importeert het framework `Combine` voor de functionaliteit in dit bestand.
import Combine
// Regeluitleg: Importeert het framework `StoreKit` voor de functionaliteit in dit bestand.
import StoreKit
// Regeluitleg: Importeert het framework `SwiftUI` voor de functionaliteit in dit bestand.
import SwiftUI
// Regeluitleg: Importeert het framework `UIKit` voor de functionaliteit in dit bestand.
import UIKit

// Regeluitleg: Compileert het volgende blok alleen wanneer `GoogleMobileAds` beschikbaar is.
#if canImport(GoogleMobileAds)
// Regeluitleg: Importeert het framework `GoogleMobileAds` voor de functionaliteit in dit bestand.
import GoogleMobileAds
// Regeluitleg: Sluit het voorwaardelijke compileerblok af.
#endif

/// Coördineert StoreKit-rechten en beide advertentieformaten.
/// Advertenties blijven verborgen totdat de rechtencontrole klaar is, zodat geverifieerde
/// Premium-gebruikers bij het starten niet kort een advertentie zien.
// Regeluitleg: Dwingt toegang tot deze interfacegebonden status af op de hoofdactor.
@MainActor
// Regeluitleg: Definieert de niet-overerfbare klasse `AdvertisingManager` en opent het bijbehorende codeblok.
final class AdvertisingManager: NSObject, ObservableObject {
    // Regeluitleg: Definieert de opsomming `StoreOperation` en opent het bijbehorende codeblok.
    enum StoreOperation {
        // Regeluitleg: Declareert of behandelt de enumwaarde `loadProduct`.
        case loadProduct
        // Regeluitleg: Declareert of behandelt de enumwaarde `purchase`.
        case purchase
        // Regeluitleg: Declareert of behandelt de enumwaarde `restore`.
        case restore
    // Regeluitleg: Sluit het huidige codeblok af.
    }

    // Regeluitleg: Declareert de waarde `cooldown` voor gebruik binnen de huidige scope.
    static let cooldown: TimeInterval = 30 * 60
    // Regeluitleg: Declareert de waarde `audioDuration` voor gebruik binnen de huidige scope.
    static let audioDuration = 8
    // Regeluitleg: Declareert de waarde `fallbackPremiumProductID` voor gebruik binnen de huidige scope.
    static let fallbackPremiumProductID = "Mohammed.Shieko.SyriaRadio.premium"

    // Regeluitleg: Past het attribuut `@Published` op de volgende declaratie toe.
    @Published private(set) var isPremium = false
    // Regeluitleg: Past het attribuut `@Published` op de volgende declaratie toe.
    @Published private(set) var isEntitlementResolved = false
    // Regeluitleg: Past het attribuut `@Published` op de volgende declaratie toe.
    @Published private(set) var premiumProduct: Product?
    // Regeluitleg: Past het attribuut `@Published` op de volgende declaratie toe.
    @Published private(set) var isLoadingProduct = false
    // Regeluitleg: Past het attribuut `@Published` op de volgende declaratie toe.
    @Published private(set) var isPurchasing = false
    // Regeluitleg: Past het attribuut `@Published` op de volgende declaratie toe.
    @Published private(set) var isRestoring = false
    // Regeluitleg: Past het attribuut `@Published` op de volgende declaratie toe.
    @Published private(set) var storeMessage: String?
    // Regeluitleg: Past het attribuut `@Published` op de volgende declaratie toe.
    @Published private(set) var storeErrorMessage: String?
    // Regeluitleg: Past het attribuut `@Published` op de volgende declaratie toe.
    @Published private(set) var isPlayingAudioAdvertisement = false
    // Regeluitleg: Past het attribuut `@Published` op de volgende declaratie toe.
    @Published private(set) var countdown = audioDuration

    // Regeluitleg: Declareert de waarde `defaults` voor gebruik binnen de huidige scope.
    private let defaults: UserDefaults
    // Regeluitleg: Declareert de waarde `premiumProductID` voor gebruik binnen de huidige scope.
    private let premiumProductID: String
    // Regeluitleg: Declareert de waarde `audioPlayer` voor gebruik binnen de huidige scope.
    private var audioPlayer: AVAudioPlayer?
    // Regeluitleg: Declareert de waarde `countdownTask` voor gebruik binnen de huidige scope.
    private var countdownTask: Task<Void, Never>?
    // Regeluitleg: Declareert de waarde `radioStartCompletion` voor gebruik binnen de huidige scope.
    private var radioStartCompletion: (() -> Void)?
    // Regeluitleg: Declareert de waarde `entitlementTask` voor gebruik binnen de huidige scope.
    private var entitlementTask: Task<Void, Never>?
    // Regeluitleg: Declareert de waarde `transactionListenerTask` voor gebruik binnen de huidige scope.
    private var transactionListenerTask: Task<Void, Never>?
    // Regeluitleg: Declareert de waarde `failedStoreOperation` voor gebruik binnen de huidige scope.
    private var failedStoreOperation: StoreOperation?

    // Regeluitleg: Definieert de initializer die een nieuwe instantie configureert.
    init(defaults: UserDefaults = .standard, bundle: Bundle = .main) {
        // Regeluitleg: Slaat de aangeleverde waarde op in instantie-eigenschap `defaults`.
        self.defaults = defaults
        // Regeluitleg: Werkt de waarde `premiumProductID` bij met het resultaat van deze expressie.
        premiumProductID = (bundle.object(forInfoDictionaryKey: "PremiumProductIdentifier") as? String)
            // Regeluitleg: Gebruikt de enumwaarde of gekoppelde optie `flatMap` in de huidige expressie.
            .flatMap { $0.isEmpty ? nil : $0 }
            // Regeluitleg: Gebruikt deze reservewaarde wanneer de voorafgaande optionele waarde ontbreekt.
            ?? Self.fallbackPremiumProductID
        // Regeluitleg: Initialiseert eerst het overgeërfde gedeelte van deze instantie.
        super.init()

        // Controleer eigendom vóór productmetadata. Eigendom bepaalt advertenties;
        // productmetadata levert de gelokaliseerde naam, omschrijving en prijs.
        // Regeluitleg: Werkt de waarde `entitlementTask` bij met het resultaat van deze expressie.
        entitlementTask = Task { [weak self] in
            // Regeluitleg: Wacht asynchroon tot deze bewerking is afgerond.
            await self?.refreshPremiumEntitlement()
            // Regeluitleg: Wacht asynchroon tot deze bewerking is afgerond.
            await self?.loadPremiumProduct()
        // Regeluitleg: Sluit het huidige codeblok af.
        }
        // Regeluitleg: Werkt de waarde `transactionListenerTask` bij met het resultaat van deze expressie.
        transactionListenerTask = Task { [weak self] in
            // Regeluitleg: Doorloopt de opgegeven reeks en voert het volgende blok voor ieder element uit.
            for await result in StoreKit.Transaction.updates {
                // Regeluitleg: Controleert de vereiste voorwaarden en verlaat de huidige bewerking als die niet gelden.
                guard let self else { return }
                // Regeluitleg: Wacht asynchroon tot deze bewerking is afgerond.
                await self.processTransactionUpdate(result)
            // Regeluitleg: Sluit het huidige codeblok af.
            }
        // Regeluitleg: Sluit het huidige codeblok af.
        }
    // Regeluitleg: Sluit het huidige codeblok af.
    }

    // Regeluitleg: Definieert opruimwerk dat bij het vrijgeven van deze instantie wordt uitgevoerd.
    deinit {
        // Regeluitleg: Voert deze instructie uit als onderdeel van de huidige bewerking.
        countdownTask?.cancel()
        // Regeluitleg: Voert deze instructie uit als onderdeel van de huidige bewerking.
        entitlementTask?.cancel()
        // Regeluitleg: Voert deze instructie uit als onderdeel van de huidige bewerking.
        transactionListenerTask?.cancel()
    // Regeluitleg: Sluit het huidige codeblok af.
    }

    // Regeluitleg: Declareert de waarde `shouldShowAdvertisements` voor gebruik binnen de huidige scope.
    var shouldShowAdvertisements: Bool {
        // Regeluitleg: Voert deze instructie uit als onderdeel van de huidige bewerking.
        isEntitlementResolved && !isPremium
    // Regeluitleg: Sluit het huidige codeblok af.
    }

    // Regeluitleg: Declareert de waarde `isStoreBusy` voor gebruik binnen de huidige scope.
    var isStoreBusy: Bool {
        // Regeluitleg: Voert deze instructie uit als onderdeel van de huidige bewerking.
        isLoadingProduct || isPurchasing || isRestoring
    // Regeluitleg: Sluit het huidige codeblok af.
    }

    /// Laadt App Store-metadata zonder een reserveprijs te verzinnen. De interface gebruikt
    /// Product.displayPrice pas nadat StoreKit een gelokaliseerde waarde levert.
    // Regeluitleg: Definieert de functie `loadPremiumProduct` en haar invoerwaarden.
    func loadPremiumProduct() async {
        // Regeluitleg: Controleert de vereiste voorwaarden en verlaat de huidige bewerking als die niet gelden.
        guard !isLoadingProduct else { return }
        // Regeluitleg: Werkt de waarde `isLoadingProduct` bij met het resultaat van deze expressie.
        isLoadingProduct = true
        // Regeluitleg: Werkt de waarde `storeErrorMessage` bij met het resultaat van deze expressie.
        storeErrorMessage = nil
        // Regeluitleg: Werkt de waarde `storeMessage` bij met het resultaat van deze expressie.
        storeMessage = nil
        // Regeluitleg: Plant opruimwerk dat bij het verlaten van de huidige scope altijd wordt uitgevoerd.
        defer { isLoadingProduct = false }

        // Regeluitleg: Opent een foutafhandelbaar codeblok.
        do {
            // Regeluitleg: Declareert de waarde `products` voor gebruik binnen de huidige scope.
            let products = try await Product.products(for: [premiumProductID])
            // Regeluitleg: Controleert de vereiste voorwaarden en verlaat de huidige bewerking als die niet gelden.
            guard let product = products.first(where: { $0.id == premiumProductID }) else {
                // Regeluitleg: Stopt de normale uitvoering en geeft deze fout aan de aanroeper door.
                throw StoreFailure.productUnavailable
            // Regeluitleg: Sluit het huidige codeblok af.
            }
            // Regeluitleg: Werkt de waarde `premiumProduct` bij met het resultaat van deze expressie.
            premiumProduct = product
            // Regeluitleg: Werkt de waarde `failedStoreOperation` bij met het resultaat van deze expressie.
            failedStoreOperation = nil
        // Regeluitleg: Sluit de normale uitvoering en verwerkt de opgetreden fout.
        } catch {
            // Regeluitleg: Werkt de waarde `premiumProduct` bij met het resultaat van deze expressie.
            premiumProduct = nil
            // Regeluitleg: Roept `recordStoreFailure` aan met de argumenten in deze expressie.
            recordStoreFailure(.loadProduct, error: error)
        // Regeluitleg: Sluit het huidige codeblok af.
        }
    // Regeluitleg: Sluit het huidige codeblok af.
    }

    /// Rondt alleen geverifieerde StoreKit 2-transacties af en controleert daarna opnieuw
    /// het huidige recht voordat Premium-functies beschikbaar komen.
    // Regeluitleg: Definieert de functie `purchasePremium` en haar invoerwaarden.
    func purchasePremium() async {
        // Regeluitleg: Controleert de vereiste voorwaarden en verlaat de huidige bewerking als die niet gelden.
        guard !isPurchasing else { return }
        // Regeluitleg: Controleert de vereiste voorwaarden en verlaat de huidige bewerking als die niet gelden.
        guard let product = premiumProduct else {
            // Regeluitleg: Wacht asynchroon tot deze bewerking is afgerond.
            await loadPremiumProduct()
            // Regeluitleg: Voert het volgende codeblok alleen uit wanneer deze voorwaarde waar is.
            if premiumProduct == nil {
                // Regeluitleg: Werkt de waarde `failedStoreOperation` bij met het resultaat van deze expressie.
                failedStoreOperation = .loadProduct
            // Regeluitleg: Sluit het huidige codeblok af.
            }
            // Regeluitleg: Geeft het berekende resultaat terug aan de aanroeper.
            return
        // Regeluitleg: Sluit het huidige codeblok af.
        }

        // Regeluitleg: Werkt de waarde `isPurchasing` bij met het resultaat van deze expressie.
        isPurchasing = true
        // Regeluitleg: Werkt de waarde `storeErrorMessage` bij met het resultaat van deze expressie.
        storeErrorMessage = nil
        // Regeluitleg: Werkt de waarde `storeMessage` bij met het resultaat van deze expressie.
        storeMessage = nil
        // Regeluitleg: Plant opruimwerk dat bij het verlaten van de huidige scope altijd wordt uitgevoerd.
        defer { isPurchasing = false }

        // Regeluitleg: Opent een foutafhandelbaar codeblok.
        do {
            // Regeluitleg: Declareert de waarde `result` voor gebruik binnen de huidige scope.
            let result = try await product.purchase()
            // Regeluitleg: Kiest een uitvoerpad op basis van `result`.
            switch result {
            // Regeluitleg: Declareert of behandelt de enumwaarde `.success(.verified(let transaction))`.
            case .success(.verified(let transaction)):
                // Regeluitleg: Controleert de vereiste voorwaarden en verlaat de huidige bewerking als die niet gelden.
                guard transaction.productID == premiumProductID else {
                    // Regeluitleg: Stopt de normale uitvoering en geeft deze fout aan de aanroeper door.
                    throw StoreFailure.verificationFailed
                // Regeluitleg: Sluit het huidige codeblok af.
                }
                // Regeluitleg: Wacht asynchroon tot deze bewerking is afgerond.
                await transaction.finish()
                // Regeluitleg: Wacht asynchroon tot deze bewerking is afgerond.
                await refreshPremiumEntitlement()
                // Regeluitleg: Controleert de vereiste voorwaarden en verlaat de huidige bewerking als die niet gelden.
                guard isPremium else { throw StoreFailure.verificationFailed }
                // Regeluitleg: Werkt de waarde `storeMessage` bij met het resultaat van deze expressie.
                storeMessage = NSLocalizedString("Premium is now active.", comment: "")
                // Regeluitleg: Werkt de waarde `failedStoreOperation` bij met het resultaat van deze expressie.
                failedStoreOperation = nil
            // Regeluitleg: Declareert of behandelt de enumwaarde `.success(.unverified)`.
            case .success(.unverified):
                // Regeluitleg: Stopt de normale uitvoering en geeft deze fout aan de aanroeper door.
                throw StoreFailure.verificationFailed
            // Regeluitleg: Declareert of behandelt de enumwaarde `.pending`.
            case .pending:
                // Regeluitleg: Werkt de waarde `storeMessage` bij met het resultaat van deze expressie.
                storeMessage = NSLocalizedString("Your purchase is pending approval.", comment: "")
                // Regeluitleg: Werkt de waarde `failedStoreOperation` bij met het resultaat van deze expressie.
                failedStoreOperation = nil
            // Regeluitleg: Declareert of behandelt de enumwaarde `.userCancelled`.
            case .userCancelled:
                // Regeluitleg: Werkt de waarde `failedStoreOperation` bij met het resultaat van deze expressie.
                failedStoreOperation = nil
            // Regeluitleg: Past het attribuut `@unknown` op de volgende declaratie toe.
            @unknown default:
                // Regeluitleg: Stopt de normale uitvoering en geeft deze fout aan de aanroeper door.
                throw StoreFailure.purchaseFailed
            // Regeluitleg: Sluit het huidige codeblok af.
            }
        // Regeluitleg: Sluit de normale uitvoering en verwerkt de opgetreden fout.
        } catch {
            // Regeluitleg: Roept `recordStoreFailure` aan met de argumenten in deze expressie.
            recordStoreFailure(.purchase, error: error)
        // Regeluitleg: Sluit het huidige codeblok af.
        }
    // Regeluitleg: Sluit het huidige codeblok af.
    }

    /// Synchroniseert aankopen met de App Store en controleert of Premium actief is.
    // Regeluitleg: Definieert de functie `restorePurchases` en haar invoerwaarden.
    func restorePurchases() async {
        // Regeluitleg: Controleert de vereiste voorwaarden en verlaat de huidige bewerking als die niet gelden.
        guard !isRestoring else { return }
        // Regeluitleg: Werkt de waarde `isRestoring` bij met het resultaat van deze expressie.
        isRestoring = true
        // Regeluitleg: Werkt de waarde `storeErrorMessage` bij met het resultaat van deze expressie.
        storeErrorMessage = nil
        // Regeluitleg: Werkt de waarde `storeMessage` bij met het resultaat van deze expressie.
        storeMessage = nil
        // Regeluitleg: Plant opruimwerk dat bij het verlaten van de huidige scope altijd wordt uitgevoerd.
        defer { isRestoring = false }

        // Regeluitleg: Opent een foutafhandelbaar codeblok.
        do {
            // Regeluitleg: Voert deze werpende asynchrone bewerking uit en wacht op het resultaat.
            try await AppStore.sync()
            // Regeluitleg: Wacht asynchroon tot deze bewerking is afgerond.
            await refreshPremiumEntitlement()
            // Regeluitleg: Controleert de vereiste voorwaarden en verlaat de huidige bewerking als die niet gelden.
            guard isPremium else { throw StoreFailure.nothingToRestore }
            // Regeluitleg: Werkt de waarde `storeMessage` bij met het resultaat van deze expressie.
            storeMessage = NSLocalizedString("Premium purchase restored.", comment: "")
            // Regeluitleg: Werkt de waarde `failedStoreOperation` bij met het resultaat van deze expressie.
            failedStoreOperation = nil
        // Regeluitleg: Sluit de normale uitvoering en verwerkt de opgetreden fout.
        } catch {
            // Regeluitleg: Roept `recordStoreFailure` aan met de argumenten in deze expressie.
            recordStoreFailure(.restore, error: error)
        // Regeluitleg: Sluit het huidige codeblok af.
        }
    // Regeluitleg: Sluit het huidige codeblok af.
    }

    // Regeluitleg: Definieert de functie `retryLastStoreOperation` en haar invoerwaarden.
    func retryLastStoreOperation() async {
        // Regeluitleg: Kiest een uitvoerpad op basis van `failedStoreOperation`.
        switch failedStoreOperation {
        // Regeluitleg: Declareert of behandelt de enumwaarde `.purchase`.
        case .purchase:
            // Regeluitleg: Wacht asynchroon tot deze bewerking is afgerond.
            await purchasePremium()
        // Regeluitleg: Declareert of behandelt de enumwaarde `.restore`.
        case .restore:
            // Regeluitleg: Wacht asynchroon tot deze bewerking is afgerond.
            await restorePurchases()
        // Regeluitleg: Declareert of behandelt de enumwaarde `.loadProduct`.
        case .loadProduct, .none:
            // Regeluitleg: Wacht asynchroon tot deze bewerking is afgerond.
            await loadPremiumProduct()
        // Regeluitleg: Sluit het huidige codeblok af.
        }
    // Regeluitleg: Sluit het huidige codeblok af.
    }

    // Regeluitleg: Definieert de functie `clearStoreMessage` en haar invoerwaarden.
    func clearStoreMessage() {
        // Regeluitleg: Werkt de waarde `storeMessage` bij met het resultaat van deze expressie.
        storeMessage = nil
        // Regeluitleg: Werkt de waarde `storeErrorMessage` bij met het resultaat van deze expressie.
        storeErrorMessage = nil
    // Regeluitleg: Sluit het huidige codeblok af.
    }

    /// Start radio direct voor Premium-gebruikers of na de lokaal meegeleverde
    /// audioreclame wanneer de wachttijd dit toestaat.
    // Regeluitleg: Definieert de functie `startRadio` en haar invoerwaarden.
    func startRadio(afterAdvertisement completion: @escaping () -> Void) {
        // Regeluitleg: Voert het volgende codeblok alleen uit wanneer deze voorwaarde waar is.
        if !isEntitlementResolved {
            // Regeluitleg: Werkt de waarde `radioStartCompletion` bij met het resultaat van deze expressie.
            radioStartCompletion = completion
            // Regeluitleg: Geeft het berekende resultaat terug aan de aanroeper.
            return
        // Regeluitleg: Sluit het huidige codeblok af.
        }

        // Regeluitleg: Voert het volgende codeblok alleen uit wanneer deze voorwaarde waar is.
        if isPlayingAudioAdvertisement {
            // Een zenderwissel tijdens de reclame vervangt de zender die klaarstaat.
            // Regeluitleg: Werkt de waarde `radioStartCompletion` bij met het resultaat van deze expressie.
            radioStartCompletion = completion
            // Regeluitleg: Geeft het berekende resultaat terug aan de aanroeper.
            return
        // Regeluitleg: Sluit het huidige codeblok af.
        }

        // Regeluitleg: Controleert de vereiste voorwaarden en verlaat de huidige bewerking als die niet gelden.
        guard shouldShowAdvertisements,
              // Regeluitleg: Voegt deze waarde of dit argument toe aan de huidige lijst.
              shouldPlayAudioAdvertisement,
              // Regeluitleg: Declareert de waarde `url` voor gebruik binnen de huidige scope.
              let url = advertisementURL,
              // Regeluitleg: Declareert de waarde `player` voor gebruik binnen de huidige scope.
              let player = try? AVAudioPlayer(contentsOf: url)
        // Regeluitleg: Opent het alternatieve uitvoerpad wanneer de vorige voorwaarde niet geldt.
        else {
            // Regeluitleg: Roept `completion` aan met de argumenten in deze expressie.
            completion()
            // Regeluitleg: Geeft het berekende resultaat terug aan de aanroeper.
            return
        // Regeluitleg: Sluit het huidige codeblok af.
        }

        // Regeluitleg: Voert deze instructie uit als onderdeel van de huidige bewerking.
        countdownTask?.cancel()
        // Regeluitleg: Werkt de waarde `radioStartCompletion` bij met het resultaat van deze expressie.
        radioStartCompletion = completion
        // Regeluitleg: Werkt de waarde `audioPlayer` bij met het resultaat van deze expressie.
        audioPlayer = player
        // Regeluitleg: Roept `player.play` aan met de argumenten in deze expressie.
        player.play()
        // Regeluitleg: Werkt de waarde `isPlayingAudioAdvertisement` bij met het resultaat van deze expressie.
        isPlayingAudioAdvertisement = true
        // Regeluitleg: Werkt de waarde `countdown` bij met het resultaat van deze expressie.
        countdown = Self.audioDuration
        // Regeluitleg: Roept `defaults.set` aan met de argumenten in deze expressie.
        defaults.set(Date(), forKey: "lastAudioAdvertisementDate")

        // Regeluitleg: Werkt de waarde `countdownTask` bij met het resultaat van deze expressie.
        countdownTask = Task { [weak self] in
            // Regeluitleg: Doorloopt de opgegeven reeks en voert het volgende blok voor ieder element uit.
            for remaining in stride(from: Self.audioDuration, through: 1, by: -1) {
                // Regeluitleg: Controleert de vereiste voorwaarden en verlaat de huidige bewerking als die niet gelden.
                guard !Task.isCancelled else { return }
                // Regeluitleg: Voert deze instructie uit als onderdeel van de huidige bewerking.
                self?.countdown = remaining
                // Regeluitleg: Voert deze werpende asynchrone bewerking uit en wacht op het resultaat.
                try? await Task.sleep(nanoseconds: 1_000_000_000)
            // Regeluitleg: Sluit het huidige codeblok af.
            }
            // Regeluitleg: Controleert de vereiste voorwaarden en verlaat de huidige bewerking als die niet gelden.
            guard !Task.isCancelled else { return }
            // Regeluitleg: Voert deze instructie uit als onderdeel van de huidige bewerking.
            self?.finishAudioAdvertisement()
        // Regeluitleg: Sluit het huidige codeblok af.
        }
    // Regeluitleg: Sluit het huidige codeblok af.
    }

    // Regeluitleg: Definieert de functie `cancelPendingRadioStart` en haar invoerwaarden.
    func cancelPendingRadioStart() {
        // Regeluitleg: Werkt de waarde `radioStartCompletion` bij met het resultaat van deze expressie.
        radioStartCompletion = nil
    // Regeluitleg: Sluit het huidige codeblok af.
    }

    // Regeluitleg: Declareert de waarde `shouldPlayAudioAdvertisement` voor gebruik binnen de huidige scope.
    private var shouldPlayAudioAdvertisement: Bool {
        // Regeluitleg: Controleert de vereiste voorwaarden en verlaat de huidige bewerking als die niet gelden.
        guard shouldShowAdvertisements, !isPlayingAudioAdvertisement else { return false }
        // Regeluitleg: Controleert de vereiste voorwaarden en verlaat de huidige bewerking als die niet gelden.
        guard let lastDate = defaults.object(forKey: "lastAudioAdvertisementDate") as? Date else {
            // Regeluitleg: Geeft het berekende resultaat terug aan de aanroeper.
            return true
        // Regeluitleg: Sluit het huidige codeblok af.
        }
        // Regeluitleg: Geeft het berekende resultaat terug aan de aanroeper.
        return Date().timeIntervalSince(lastDate) >= Self.cooldown
    // Regeluitleg: Sluit het huidige codeblok af.
    }

    // Regeluitleg: Declareert de waarde `advertisementURL` voor gebruik binnen de huidige scope.
    private var advertisementURL: URL? {
        // Regeluitleg: Roept `Bundle.main.url` aan met de argumenten in deze expressie.
        Bundle.main.url(forResource: "AudioAdvertisement", withExtension: "mp3")
            // Regeluitleg: Gebruikt deze reservewaarde wanneer de voorafgaande optionele waarde ontbreekt.
            ?? Bundle.main.url(forResource: "AudioAdvertisement", withExtension: "wav")
    // Regeluitleg: Sluit het huidige codeblok af.
    }

    // Regeluitleg: Definieert de functie `refreshPremiumEntitlement` en haar invoerwaarden.
    private func refreshPremiumEntitlement() async {
        // Niet-geverifieerde, ingetrokken, vervangen of verlopen transacties ontgrendelen Premium nooit.
        // Regeluitleg: Declareert de waarde `entitled` voor gebruik binnen de huidige scope.
        var entitled = false
        // Regeluitleg: Doorloopt de opgegeven reeks en voert het volgende blok voor ieder element uit.
        for await result in StoreKit.Transaction.currentEntitlements {
            // Regeluitleg: Controleert de vereiste voorwaarden en verlaat de huidige bewerking als die niet gelden.
            guard case .verified(let transaction) = result,
                  // Regeluitleg: Voegt deze waarde of dit argument toe aan de huidige lijst.
                  transaction.productID == premiumProductID,
                  // Regeluitleg: Voegt deze waarde of dit argument toe aan de huidige lijst.
                  transaction.revocationDate == nil,
                  // Regeluitleg: Voert deze instructie uit als onderdeel van de huidige bewerking.
                  !transaction.isUpgraded
            // Regeluitleg: Opent het alternatieve uitvoerpad wanneer de vorige voorwaarde niet geldt.
            else { continue }

            // Regeluitleg: Voert het volgende codeblok alleen uit wanneer deze voorwaarde waar is.
            if let expirationDate = transaction.expirationDate, expirationDate <= Date() {
                // Regeluitleg: Slaat de rest van deze iteratie over en gaat door met het volgende element.
                continue
            // Regeluitleg: Sluit het huidige codeblok af.
            }
            // Regeluitleg: Werkt de waarde `entitled` bij met het resultaat van deze expressie.
            entitled = true
            // Regeluitleg: Beëindigt de huidige switchtak of lus.
            break
        // Regeluitleg: Sluit het huidige codeblok af.
        }

        // Regeluitleg: Werkt de waarde `isPremium` bij met het resultaat van deze expressie.
        isPremium = entitled
        // Regeluitleg: Werkt de waarde `isEntitlementResolved` bij met het resultaat van deze expressie.
        isEntitlementResolved = true

        // Regeluitleg: Voert het volgende codeblok alleen uit wanneer deze voorwaarde waar is.
        if entitled, isPlayingAudioAdvertisement {
            // Regeluitleg: Roept `finishAudioAdvertisement` aan met de argumenten in deze expressie.
            finishAudioAdvertisement()
        // Regeluitleg: Sluit de vorige tak en controleert vervolgens een aanvullende voorwaarde.
        } else if let completion = radioStartCompletion, !isPlayingAudioAdvertisement {
            // Regeluitleg: Werkt de waarde `radioStartCompletion` bij met het resultaat van deze expressie.
            radioStartCompletion = nil
            // Regeluitleg: Roept `startRadio` aan met de argumenten in deze expressie.
            startRadio(afterAdvertisement: completion)
        // Regeluitleg: Sluit het huidige codeblok af.
        }
    // Regeluitleg: Sluit het huidige codeblok af.
    }

    // Regeluitleg: Definieert de functie `processTransactionUpdate` en haar invoerwaarden.
    private func processTransactionUpdate(
        // Regeluitleg: Voert deze instructie uit als onderdeel van de huidige bewerking.
        _ result: VerificationResult<StoreKit.Transaction>
    // Regeluitleg: Sluit de gegroepeerde argumenten van deze expressie af.
    ) async {
        // Regeluitleg: Kiest een uitvoerpad op basis van `result`.
        switch result {
        // Regeluitleg: Declareert of behandelt de enumwaarde `.verified(let transaction)`.
        case .verified(let transaction):
            // Regeluitleg: Controleert de vereiste voorwaarden en verlaat de huidige bewerking als die niet gelden.
            guard transaction.productID == premiumProductID else { return }
            // Regeluitleg: Wacht asynchroon tot deze bewerking is afgerond.
            await transaction.finish()
            // Regeluitleg: Wacht asynchroon tot deze bewerking is afgerond.
            await refreshPremiumEntitlement()
        // Regeluitleg: Declareert of behandelt de enumwaarde `.unverified`.
        case .unverified:
            // Regeluitleg: Roept `recordStoreFailure` aan met de argumenten in deze expressie.
            recordStoreFailure(.purchase, error: StoreFailure.verificationFailed)
        // Regeluitleg: Sluit het huidige codeblok af.
        }
    // Regeluitleg: Sluit het huidige codeblok af.
    }

    // Regeluitleg: Definieert de functie `recordStoreFailure` en haar invoerwaarden.
    private func recordStoreFailure(_ operation: StoreOperation, error: Error) {
        // Regeluitleg: Werkt de waarde `failedStoreOperation` bij met het resultaat van deze expressie.
        failedStoreOperation = operation
        // Regeluitleg: Voert het volgende codeblok alleen uit wanneer deze voorwaarde waar is.
        if let failure = error as? StoreFailure {
            // Regeluitleg: Werkt de waarde `storeErrorMessage` bij met het resultaat van deze expressie.
            storeErrorMessage = failure.localizedDescription
        // Regeluitleg: Sluit de vorige tak en opent het alternatieve uitvoerpad.
        } else {
            // Regeluitleg: Werkt de waarde `storeErrorMessage` bij met het resultaat van deze expressie.
            storeErrorMessage = error.localizedDescription
        // Regeluitleg: Sluit het huidige codeblok af.
        }
    // Regeluitleg: Sluit het huidige codeblok af.
    }

    // Regeluitleg: Definieert de functie `finishAudioAdvertisement` en haar invoerwaarden.
    private func finishAudioAdvertisement() {
        // Regeluitleg: Controleert de vereiste voorwaarden en verlaat de huidige bewerking als die niet gelden.
        guard isPlayingAudioAdvertisement else { return }
        // Regeluitleg: Voert deze instructie uit als onderdeel van de huidige bewerking.
        countdownTask?.cancel()
        // Regeluitleg: Werkt de waarde `countdownTask` bij met het resultaat van deze expressie.
        countdownTask = nil
        // Regeluitleg: Voert deze instructie uit als onderdeel van de huidige bewerking.
        audioPlayer?.stop()
        // Regeluitleg: Werkt de waarde `audioPlayer` bij met het resultaat van deze expressie.
        audioPlayer = nil
        // Regeluitleg: Werkt de waarde `isPlayingAudioAdvertisement` bij met het resultaat van deze expressie.
        isPlayingAudioAdvertisement = false
        // Regeluitleg: Declareert de waarde `action` voor gebruik binnen de huidige scope.
        let action = radioStartCompletion
        // Regeluitleg: Werkt de waarde `radioStartCompletion` bij met het resultaat van deze expressie.
        radioStartCompletion = nil
        // Regeluitleg: Voert deze instructie uit als onderdeel van de huidige bewerking.
        action?()
    // Regeluitleg: Sluit het huidige codeblok af.
    }
// Regeluitleg: Sluit het huidige codeblok af.
}

// Regeluitleg: Definieert de opsomming `StoreFailure` en opent het bijbehorende codeblok.
private enum StoreFailure: LocalizedError {
    // Regeluitleg: Declareert of behandelt de enumwaarde `productUnavailable`.
    case productUnavailable
    // Regeluitleg: Declareert of behandelt de enumwaarde `purchaseFailed`.
    case purchaseFailed
    // Regeluitleg: Declareert of behandelt de enumwaarde `verificationFailed`.
    case verificationFailed
    // Regeluitleg: Declareert of behandelt de enumwaarde `nothingToRestore`.
    case nothingToRestore

    // Regeluitleg: Declareert de waarde `errorDescription` voor gebruik binnen de huidige scope.
    var errorDescription: String? {
        // Regeluitleg: Kiest een uitvoerpad op basis van `self`.
        switch self {
        // Regeluitleg: Declareert of behandelt de enumwaarde `.productUnavailable`.
        case .productUnavailable:
            // Regeluitleg: Geeft het berekende resultaat terug aan de aanroeper.
            return NSLocalizedString(
                // Regeluitleg: Voegt deze tekstwaarde aan de huidige collectie of configuratie toe.
                "Premium could not be loaded. Check your connection and try again.",
                // Regeluitleg: Geeft de waarde voor parameter of eigenschap `comment` door.
                comment: ""
            // Regeluitleg: Sluit de gegroepeerde argumenten van deze expressie af.
            )
        // Regeluitleg: Declareert of behandelt de enumwaarde `.purchaseFailed`.
        case .purchaseFailed:
            // Regeluitleg: Geeft het berekende resultaat terug aan de aanroeper.
            return NSLocalizedString(
                // Regeluitleg: Voegt deze tekstwaarde aan de huidige collectie of configuratie toe.
                "The purchase could not be completed. Please try again.",
                // Regeluitleg: Geeft de waarde voor parameter of eigenschap `comment` door.
                comment: ""
            // Regeluitleg: Sluit de gegroepeerde argumenten van deze expressie af.
            )
        // Regeluitleg: Declareert of behandelt de enumwaarde `.verificationFailed`.
        case .verificationFailed:
            // Regeluitleg: Geeft het berekende resultaat terug aan de aanroeper.
            return NSLocalizedString(
                // Regeluitleg: Voegt deze tekstwaarde aan de huidige collectie of configuratie toe.
                "The Premium purchase could not be verified.",
                // Regeluitleg: Geeft de waarde voor parameter of eigenschap `comment` door.
                comment: ""
            // Regeluitleg: Sluit de gegroepeerde argumenten van deze expressie af.
            )
        // Regeluitleg: Declareert of behandelt de enumwaarde `.nothingToRestore`.
        case .nothingToRestore:
            // Regeluitleg: Geeft het berekende resultaat terug aan de aanroeper.
            return NSLocalizedString(
                // Regeluitleg: Voegt deze tekstwaarde aan de huidige collectie of configuratie toe.
                "No active Premium purchase was found.",
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

// Regeluitleg: Definieert de structuur `AudioAdvertisementNotice` en opent het bijbehorende codeblok.
struct AudioAdvertisementNotice: View {
    // Regeluitleg: Declareert de waarde `seconds` voor gebruik binnen de huidige scope.
    let seconds: Int

    // Regeluitleg: Declareert de waarde `body` voor gebruik binnen de huidige scope.
    var body: some View {
        // Regeluitleg: Maakt en configureert het SwiftUI-element `HStack`.
        HStack(spacing: 10) {
            // Regeluitleg: Maakt en configureert het SwiftUI-element `Image`.
            Image(systemName: "speaker.wave.2.fill")
            // Regeluitleg: Maakt en configureert het SwiftUI-element `Text`.
            Text(String.localizedStringWithFormat(
                // Regeluitleg: Roept `NSLocalizedString` aan met de argumenten in deze expressie.
                NSLocalizedString("Advertisement – radio starts in %lld seconds", comment: ""),
                // Regeluitleg: Voert deze instructie uit als onderdeel van de huidige bewerking.
                seconds
            // Regeluitleg: Sluit de gegroepeerde argumenten van deze expressie af.
            ))
                // Regeluitleg: Stelt het lettertype voor dit interface-element in.
                .font(.subheadline.weight(.semibold))
        // Regeluitleg: Sluit het huidige codeblok af.
        }
        // Regeluitleg: Stelt de voorgrondstijl van dit interface-element in.
        .foregroundStyle(.white)
        // Regeluitleg: Voegt de opgegeven binnenruimte rond dit interface-element toe.
        .padding(.horizontal, 16)
        // Regeluitleg: Voegt de opgegeven binnenruimte rond dit interface-element toe.
        .padding(.vertical, 12)
        // Regeluitleg: Voegt de opgegeven achtergrond aan dit interface-element toe.
        .background(.black.opacity(0.88), in: Capsule())
        // Regeluitleg: Geeft VoiceOver een duidelijk toegankelijkheidslabel.
        .accessibilityLabel(Text(String.localizedStringWithFormat(
            // Regeluitleg: Roept `NSLocalizedString` aan met de argumenten in deze expressie.
            NSLocalizedString("Advertisement. Radio starts in %lld seconds.", comment: ""),
            // Regeluitleg: Voert deze instructie uit als onderdeel van de huidige bewerking.
            seconds
        // Regeluitleg: Sluit de gegroepeerde argumenten van deze expressie af.
        )))
    // Regeluitleg: Sluit het huidige codeblok af.
    }
// Regeluitleg: Sluit het huidige codeblok af.
}

// Regeluitleg: Definieert de opsomming `AdConfiguration` en opent het bijbehorende codeblok.
enum AdConfiguration {
    /// Googles officiële testeenheid voorkomt onbedoeld productieverkeer in DEBUG.
    // Regeluitleg: Declareert de waarde `googleDebugBannerUnitID` voor gebruik binnen de huidige scope.
    static let googleDebugBannerUnitID = "ca-app-pub-3940256099942544/2435281174"

    // Regeluitleg: Declareert de waarde `bannerUnitID` voor gebruik binnen de huidige scope.
    static var bannerUnitID: String? {
// Regeluitleg: Compileert het volgende blok uitsluitend voor een DEBUG-build.
#if DEBUG
        // Lees in DEBUG nooit een productie-ID in.
        // Regeluitleg: Geeft het berekende resultaat terug aan de aanroeper.
        return googleDebugBannerUnitID
// Regeluitleg: Start de alternatieve compileertak wanneer de vorige voorwaarde niet geldt.
#else
        // Regeluitleg: Controleert de vereiste voorwaarden en verlaat de huidige bewerking als die niet gelden.
        guard let value = Bundle.main.object(forInfoDictionaryKey: "AdMobBannerUnitID") as? String,
              // Regeluitleg: Voegt deze waarde of dit argument toe aan de huidige lijst.
              !value.isEmpty,
              // Regeluitleg: Voert deze instructie uit als onderdeel van de huidige bewerking.
              !value.contains("$(")
        // Regeluitleg: Opent het alternatieve uitvoerpad wanneer de vorige voorwaarde niet geldt.
        else { return nil }
        // Regeluitleg: Geeft het berekende resultaat terug aan de aanroeper.
        return value
// Regeluitleg: Sluit het voorwaardelijke compileerblok af.
#endif
    // Regeluitleg: Sluit het huidige codeblok af.
    }
// Regeluitleg: Sluit het huidige codeblok af.
}

// Regeluitleg: Compileert het volgende blok alleen wanneer `GoogleMobileAds` beschikbaar is.
#if canImport(GoogleMobileAds)
// Regeluitleg: Definieert de structuur `AdMobBanner` en opent het bijbehorende codeblok.
struct AdMobBanner: UIViewRepresentable {
    // Regeluitleg: Declareert de waarde `adUnitID` voor gebruik binnen de huidige scope.
    let adUnitID: String

    // Regeluitleg: Definieert de functie `makeUIView` en haar invoerwaarden.
    func makeUIView(context: Context) -> BannerView {
        // Regeluitleg: Declareert de waarde `view` voor gebruik binnen de huidige scope.
        let view = BannerView(adSize: AdSizeBanner)
        // Regeluitleg: Voert deze instructie uit als onderdeel van de huidige bewerking.
        view.adUnitID = adUnitID
        // Regeluitleg: Voert deze instructie uit als onderdeel van de huidige bewerking.
        view.rootViewController = UIApplication.shared.connectedScenes
            // Regeluitleg: Gebruikt de enumwaarde of gekoppelde optie `compactMap` in de huidige expressie.
            .compactMap { ($0 as? UIWindowScene)?.keyWindow?.rootViewController }
            // Regeluitleg: Gebruikt de enumwaarde of gekoppelde optie `first` in de huidige expressie.
            .first
        // Regeluitleg: Roept `view.load` aan met de argumenten in deze expressie.
        view.load(Request())
        // Regeluitleg: Geeft het berekende resultaat terug aan de aanroeper.
        return view
    // Regeluitleg: Sluit het huidige codeblok af.
    }

    // Regeluitleg: Definieert de functie `updateUIView` en haar invoerwaarden.
    func updateUIView(_ uiView: BannerView, context: Context) {}
// Regeluitleg: Sluit het huidige codeblok af.
}
// Regeluitleg: Start de alternatieve compileertak wanneer de vorige voorwaarde niet geldt.
#else
// Regeluitleg: Definieert de structuur `AdMobBanner` en opent het bijbehorende codeblok.
struct AdMobBanner: View {
    // Regeluitleg: Declareert de waarde `adUnitID` voor gebruik binnen de huidige scope.
    let adUnitID: String
    // Regeluitleg: Declareert de waarde `body` voor gebruik binnen de huidige scope.
    var body: some View { EmptyView() }
// Regeluitleg: Sluit het huidige codeblok af.
}
// Regeluitleg: Sluit het voorwaardelijke compileerblok af.
#endif
