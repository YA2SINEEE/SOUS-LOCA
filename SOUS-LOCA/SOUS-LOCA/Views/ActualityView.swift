import SwiftUI

struct ActualityView: View {
    var body: some View {
        NavigationView {
            VStack {
                WebView(url: URL(string: "https://news.airbnb.com/fr/")!)
                    .edgesIgnoringSafeArea(.all) // Pour que la WebView prenne toute la taille disponible
            }
            .navigationBarTitle("Actualités Airbnb", displayMode: .inline)
        }
    }
}
