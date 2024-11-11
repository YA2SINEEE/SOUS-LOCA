import SwiftUI
import MessageUI

struct ContactView: View {
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var email: String = ""
    @State private var phoneNumber: String = ""
    @State private var message: String = ""
    @State private var showMailError: Bool = false
    
    // Numéro de téléphone WhatsApp
    let whatsappNumber = "0771728081" // Remplacez par le numéro WhatsApp sans espaces ni symboles

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
            
            // Contenu du formulaire
            VStack(spacing: 20) {
                Text("Contactez-moi")
                    .font(.largeTitle)
                    .padding(.top)
                    .foregroundStyle(.white)
                
                // Formulaire de saisie
                Group {
                    HStack {
                        TextField("Prénom", text: $firstName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        TextField("Nom", text: $lastName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                    
                    TextField("Email", text: $email)
                        .keyboardType(.emailAddress)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    TextField("Téléphone", text: $phoneNumber)
                        .keyboardType(.phonePad)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    // Champ de texte pour le message
                    TextEditor(text: $message)
                        .padding(5) // Padding interne du TextEditor
                        .frame(minHeight: 100, maxHeight: 150) // Hauteur fixe, environ trois fois celle des autres champs
                        .background(Color.white.opacity(0.2))
                        .cornerRadius(8)
                        .fixedSize(horizontal: false, vertical: true) // Empêche le redimensionnement en hauteur
                }
                .padding(.horizontal)
                
                // Bouton d'envoi
                Button(action: sendEmail) {
                    Text("Envoyer")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
                .disabled(!isFormValid()) // Désactiver le bouton si le formulaire est incomplet
                .alert(isPresented: $showMailError) {
                    Alert(title: Text("Erreur"), message: Text("Impossible d'envoyer l'email"), dismissButton: .default(Text("OK")))
                }
                
                // Section WhatsApp
                VStack(spacing: 10) {
                    Text("Vous avez une question ?")
                        .font(.headline)
                        .foregroundStyle(.white)
                    
                    Button(action: openWhatsApp) {
                        HStack {
                            Image("whatsapp")
                                .resizable()
                                .frame(width: 60, height: 60)
                            Text("Mon WhatsApp")
                                .foregroundColor(.white)
                                .font(.headline)
                                .padding(.trailing)
                        }
                        .background(Color.green)
                        .cornerRadius(10)
                    }
                }
                .padding(.top, 20)
                
                Spacer()
            }
        }
    }
    
    // Vérifier si tous les champs sont remplis
    private func isFormValid() -> Bool {
        return !firstName.isEmpty && !lastName.isEmpty && !email.isEmpty && !phoneNumber.isEmpty && !message.isEmpty
    }
    
    // Fonction pour envoyer les informations par email
    private func sendEmail() {
        guard let emailURL = createEmailUrl() else {
            showMailError = true
            return
        }
        UIApplication.shared.open(emailURL)
    }
    
    // Créer l'URL pour envoyer l'email
    private func createEmailUrl() -> URL? {
        let recipientEmail = "flexi.mentoring1@gmail.com" // Remplacez par l'email du destinataire
        let subject = "Nouveau contact de \(firstName) \(lastName)"
        let body = """
        Nom: \(firstName) \(lastName)
        Email: \(email)
        Téléphone: \(phoneNumber)
        
        Message:
        \(message)
        """
        let urlString = "mailto:\(recipientEmail)?subject=\(subject)&body=\(body)"
        return URL(string: urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
    }
    
    // Fonction pour ouvrir la conversation WhatsApp
    private func openWhatsApp() {
        let urlStr = "https://wa.me/\(whatsappNumber)"
        if let url = URL(string: urlStr) {
            UIApplication.shared.open(url)
        }
    }
}

#Preview {
    ContactView()
}
