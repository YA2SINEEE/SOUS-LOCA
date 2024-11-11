import SwiftUI
import FirebaseFirestore

struct AnnouncementsView: View {
    @State private var announcements: [(title: String, imageUrl: String, description: String)] = []
    @State private var currentIndex: Int = 0
    @State private var timer: Timer?

    var body: some View {
        ZStack {
            // Dégradé de fond
            LinearGradient(
                gradient: Gradient(colors: [
                    Color("Color1"),
                    Color("Color2"),
                    Color("Color3"),
                    Color("Color4")
                ]),
                startPoint: .bottomLeading,
                endPoint: .topTrailing
            )
            .ignoresSafeArea() // Remplit toute la vue

            VStack {
                // Affichage des annonces avec un HStack sans ScrollView (désactivation du scroll manuel)
                GeometryReader { geometry in
                    let cardWidth = geometry.size.width * 0.85 // 85% de la largeur de l'écran pour chaque carte
                    let spacing = geometry.size.width * 0.10 // Espacement entre les cartes (10% de la largeur de l'écran)
                    
                    HStack(spacing: spacing) { // Ajustement dynamique de l'espacement
                        // Pour chaque annonce, nous affichons une carte
                        ForEach(announcements.indices, id: \.self) { index in
                            let announcement = announcements[index]
                            
                            VStack {
                                HStack {
                                    // Image à gauche avec taille flexible
                                    AsyncImage(url: URL(string: announcement.imageUrl)) { image in
                                        image
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 120, height: 120) // Taille fixe pour l'image (modifiable selon votre besoin)
                                            .clipped()
                                    } placeholder: {
                                        Color.gray.opacity(0.2)
                                            .frame(width: 120, height: 120) // Placeholder avec la même taille
                                    }
                                    .padding(10) // Padding autour de l'image uniquement
                                    
                                    // VStack avec titre et description à droite
                                    VStack(alignment: .leading) {
                                        Text(announcement.title)
                                            .font(.headline)
                                            .foregroundColor(.white)
                                            .padding(.bottom, 8)
                                        
                                        Text(announcement.description) // Description sous le titre
                                            .font(.subheadline)
                                            .foregroundColor(.white)
                                            .lineLimit(nil) // Permet au texte de s'afficher en plusieurs lignes si nécessaire
                                            .fixedSize(horizontal: false, vertical: true) // S'assurer que le texte s'adapte
                                    }
                                    .padding(.leading, 5) // Ajout de padding entre l'image et le texte
                                    
                                }
                                .frame(width: cardWidth, height: 120) // Limiter la taille de chaque carte
                                .background(
                                    RoundedRectangle(cornerRadius: 15)
                                        .fill(LinearGradient(gradient: Gradient(colors: [Color("Color1"), Color("Color2")]), startPoint: .bottomLeading, endPoint: .topTrailing))
                                        .shadow(color: .black.opacity(0.4), radius: 20) // Ombre autour de la carte sans décalage
                                )
                            }
                            .padding(.vertical, 10) // Padding vertical autour de chaque carte
                        }
                    }
                    .padding(.horizontal, (geometry.size.width - cardWidth) / 2) // Centrer la carte dans la vue
                    .offset(x: CGFloat(currentIndex) * -(spacing + cardWidth)) // Décalage ajusté pour l'espacement
                    .animation(.easeInOut(duration: 1), value: currentIndex) // Animation du défilement
                }
                .frame(height: 120) // Limiter la hauteur de l'affichage des annonces

                Spacer()
            }
            .onAppear {
                loadAnnouncements()
                startScrollingAnnouncements()
            }
            .onDisappear {
                timer?.invalidate() // Arrêter le timer si la vue disparaît
            }
        }
    }

    // Charger les annonces depuis Firebase
    func loadAnnouncements() {
        let db = Firestore.firestore()
        db.collection("announcements")
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Erreur lors de la récupération des annonces: \(error.localizedDescription)")
                } else {
                    self.announcements = snapshot?.documents.compactMap { document in
                        let title = document["title"] as? String ?? ""
                        let imageUrl = document["imageUrl"] as? String ?? ""
                        let description = document["description"] as? String ?? "" // Récupérer la description
                        return (title, imageUrl, description)
                    } ?? []
                }
            }
    }

    // Démarrer le défilement des annonces toutes les 5 secondes
    func startScrollingAnnouncements() {
        timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { _ in
            if announcements.isEmpty { return }
            // Défilement circulaire sans vide
            withAnimation(.easeInOut(duration: 1)) {
                currentIndex = (currentIndex + 1) % announcements.count
            }
        }
    }
}

#Preview {
    AnnouncementsView()
        .previewLayout(.sizeThatFits)
}
