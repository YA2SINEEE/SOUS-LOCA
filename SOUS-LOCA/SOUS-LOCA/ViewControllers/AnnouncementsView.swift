import SwiftUI
import FirebaseFirestore

struct AnnouncementsView: View {
    @State private var announcements: [(title: String, imageUrl: String)] = []
    @State private var currentIndex: Int = 0
    @State private var timer: Timer?

    var body: some View {
        VStack {
            // Scrolling announcements
            HStack(spacing: 15) {
                ForEach(announcements, id: \.title) { announcement in
                    VStack {
                        // Carte avec image et texte
                        VStack {
                            AsyncImage(url: URL(string: announcement.imageUrl)) { image in
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 100, height: 100)
                                    .clipped()
                            } placeholder: {
                                Color.gray.opacity(0.2)
                                    .frame(width: 100, height: 100)
                            }
                            Text(announcement.title)
                                .font(.headline)
                                .padding(.top, 8)
                        }
                        .frame(width: 280, height: 150)
                        .background(RoundedRectangle(cornerRadius: 15)
                            .fill(LinearGradient(gradient: Gradient(colors: [Color("Color1"), Color("Color2")]), startPoint: .top, endPoint: .bottom)))
                        .shadow(radius: 5)
                    }
                    .padding(.vertical, 10)
                }
            }
            .offset(x: CGFloat(currentIndex) * -310) // Défiler vers la gauche
            .animation(.easeInOut(duration: 1), value: currentIndex) // Animation du défilement

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
                        return (title, imageUrl)
                    } ?? []
                }
            }
    }

    // Démarrer le défilement des annonces toutes les 5 secondes
    func startScrollingAnnouncements() {
        timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { _ in
            if announcements.isEmpty { return }
            currentIndex = (currentIndex + 1) % announcements.count
        }
    }
}

#Preview {
    AnnouncementsView()
        .previewLayout(.sizeThatFits)
}
