// Regeluitleg: Importeert het framework `SwiftUI` voor de functionaliteit in dit bestand.
import SwiftUI
// Regeluitleg: Compileert het volgende blok alleen wanneer `GoogleMobileAds` beschikbaar is.
#if canImport(GoogleMobileAds)
// Regeluitleg: Importeert het framework `GoogleMobileAds` voor de functionaliteit in dit bestand.
import GoogleMobileAds
// Regeluitleg: Sluit het voorwaardelijke compileerblok af.
#endif

// Regeluitleg: Markeert dit type als het startpunt van de applicatie.
@main
// Regeluitleg: Definieert de structuur `SyriaRadioApp` en opent het bijbehorende codeblok.
struct SyriaRadioApp: App {
    // Regeluitleg: Definieert de initializer die een nieuwe instantie configureert.
    init() {
        // Start de advertentie-SDK één keer bij het starten van de app. De voorwaardelijke import houdt
        // previews en builds zonder het optionele pakket bruikbaar.
        // Regeluitleg: Compileert het volgende blok alleen wanneer `GoogleMobileAds` beschikbaar is.
        #if canImport(GoogleMobileAds)
        // Regeluitleg: Roept `MobileAds.shared.start` aan met de argumenten in deze expressie.
        MobileAds.shared.start()
        // Regeluitleg: Sluit het voorwaardelijke compileerblok af.
        #endif
    // Regeluitleg: Sluit het huidige codeblok af.
    }
    // Regeluitleg: Declareert de waarde `body` voor gebruik binnen de huidige scope.
    var body: some Scene {
        // Regeluitleg: Opent het codeblok voor deze declaratie of bewerking.
        WindowGroup {
            // Regeluitleg: Roept `ContentView` aan met de argumenten in deze expressie.
            ContentView()
        // Regeluitleg: Sluit het huidige codeblok af.
        }
    // Regeluitleg: Sluit het huidige codeblok af.
    }
// Regeluitleg: Sluit het huidige codeblok af.
}
