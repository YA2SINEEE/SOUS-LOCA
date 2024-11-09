import SwiftUI

struct SplashScreenView: View {
    @State var isActive : Bool = false
    @State private var size = 0.8
    @State private var opacity = 0.5
    
    var body: some View {
        if isActive {
            ContentView()
        } else {
            ZStack {
                // Ajout du fond en dégradé
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color("Color1"), // Couleur en bas à gauche
                        Color("Color2"),
                        Color("Color3"),
                        Color("Color4") // Couleur en haut à droite
                    ]),
                    startPoint: .bottomLeading,
                    endPoint: .topTrailing
                )
                .ignoresSafeArea() // Remplit toute la vue

                VStack {
                    VStack {
                        Image("logoT")
                            .resizable() // Permet de redimensionner l'image
                            .scaledToFit() // Garde le ratio de l'image
                            .frame(width: 200, height: 200) // Taille de l'image
                    }
                    .scaleEffect(size)
                    .opacity(opacity)
                    .onAppear {
                        withAnimation(.easeIn(duration: 1.2)) {
                            self.size = 0.9
                            self.opacity = 1.00
                        }
                    }
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    withAnimation {
                        self.isActive = true
                    }
                }
            }
        }
    }
}

#Preview {
    SplashScreenView()
}
