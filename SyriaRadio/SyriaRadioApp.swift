import SwiftUI
#if canImport(GoogleMobileAds)
import GoogleMobileAds
#endif

@main
struct SyriaRadioApp: App {
    init() {
        // Start the ads SDK once during app launch. The conditional import keeps
        // previews and builds without the optional package usable.
        #if canImport(GoogleMobileAds)
        MobileAds.shared.start()
        #endif
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
