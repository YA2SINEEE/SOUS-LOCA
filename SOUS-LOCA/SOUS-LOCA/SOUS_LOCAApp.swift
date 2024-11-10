import SwiftUI

@main
struct MyApp: App {
    // Utilisation de l'AppDelegate pour gérer le cycle de vie de l'application
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            SplashScreenView()
        }
    }
}
