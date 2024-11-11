import SwiftUI
import MessageUI

struct ContactView: View {
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var email: String = ""
    @State private var phoneNumber: String = ""
    @State private var message: String = ""
    @State private var showMailError: Bool = false
    @State private var isKeyboardVisible: Bool = false
    @State private var alertMessage: String = ""

    // Utiliser l'attribut @FocusState pour gérer le focus du champ
    @FocusState private var focusedField: Field?

    // Enum pour les différents champs du formulaire
    enum Field: Hashable {
        case firstName, lastName, email, phoneNumber, message
    }

    // Numéro de téléphone WhatsApp
    let whatsappNumber = "+33771728081" // Remplacez par le numéro WhatsApp sans espaces ni symboles

    private var keyboardHeight: CGFloat {
        return isKeyboardVisible ? 300 : 0 // Ajustez la hauteur en fonction de la taille du clavier
    }

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

            ScrollView {
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
                                .focused($focusedField, equals: .firstName) // Focus sur ce champ
                                .submitLabel(.next) // Change le label du bouton clavier pour "Next"
                            
                            TextField("Nom", text: $lastName)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .focused($focusedField, equals: .lastName)
                                .submitLabel(.next)
                        }

                        TextField("Email", text: $email)
                            .keyboardType(.emailAddress)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .focused($focusedField, equals: .email)
                            .submitLabel(.next)

                        TextField("Téléphone", text: $phoneNumber)
                            .keyboardType(.phonePad)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .focused($focusedField, equals: .phoneNumber)
                            .submitLabel(.next)

                        // Champ de texte pour le message
                        TextEditor(text: $message)
                            .padding(5) // Padding interne du TextEditor
                            .frame(minHeight: 100, maxHeight: 150) // Hauteur fixe
                            .background(Color.white.opacity(0.2))
                            .cornerRadius(8)
                            .fixedSize(horizontal: false, vertical: true)
                            .focused($focusedField, equals: .message)
                            .submitLabel(.done) // Affiche "Done" sur le clavier pour fermer le clavier
                    }
                    .padding(.horizontal)

                    // Bouton d'envoi
                    Button(action: sendEmail) {
                        Text("Envoyer")
                            .font(.headline)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(isFormValid() ? Color.blue : Color.gray)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)
                    .disabled(!isFormValid()) // Désactiver le bouton si le formulaire est incomplet
                    .alert(isPresented: $showMailError) {
                        Alert(title: Text("Erreur"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
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
                .padding(.bottom, keyboardHeight) // Ajuste la vue en fonction de la taille du clavier
            }
            .onTapGesture {
                hideKeyboard() // Fermer le clavier en tapotant n'importe où
            }
            .onAppear {
                // Observer les changements du clavier
                NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { _ in
                    withAnimation {
                        isKeyboardVisible = true
                    }
                }

                NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { _ in
                    withAnimation {
                        isKeyboardVisible = false
                    }
                }
            }
            .onDisappear {
                // Retirer les observateurs de clavier
                NotificationCenter.default.removeObserver(self)
            }
        }
    }

    // Vérifier si tous les champs sont remplis
    private func isFormValid() -> Bool {
        return !firstName.isEmpty && !lastName.isEmpty && !email.isEmpty && !phoneNumber.isEmpty && !message.isEmpty
    }

    // Fonction pour envoyer les informations par email
    private func sendEmail() {
        if let emptyField = validateForm() {
            alertMessage = "\(emptyField) n'est pas complété"
            showMailError = true
        } else {
            guard let emailURL = createEmailUrl() else {
                showMailError = true
                return
            }
            UIApplication.shared.open(emailURL)
        }
    }

    // Vérification des champs pour afficher le message d'alerte
    private func validateForm() -> String? {
        if firstName.isEmpty { return "Le prénom" }
        if lastName.isEmpty { return "Le nom" }
        if email.isEmpty { return "L'email" }
        if phoneNumber.isEmpty { return "Le téléphone" }
        if message.isEmpty { return "Le message" }
        return nil
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

    // Fermer le clavier en tapotant n'importe où
    private func hideKeyboard() {
        focusedField = nil // Délier le focus du champ pour fermer le clavier
    }
}

#Preview {
    ContactView()
}
