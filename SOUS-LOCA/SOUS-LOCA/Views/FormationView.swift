import SwiftUI

struct FormationView: View {
    var body: some View {
        NavigationView {
            VStack {
                WebView(url: URL(string: "https://formation.sous-loca.online/login")!)
                    .edgesIgnoringSafeArea(.all) // Pour que la WebView prenne toute la taille disponible
            }
            //.navigationBarTitle("Formation SOUS-LOCA V2", displayMode: .inline)
        }
    }
}
