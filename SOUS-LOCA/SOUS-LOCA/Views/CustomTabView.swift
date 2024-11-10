import SwiftUI

struct CustomTabView: View {
    @Binding var tabSelection: Int
    @Namespace private var animationNamespace
    
    let tabBarItems: [(image: String, title: String)] = [
        ("house","Accueil"),
        ("book","Actualités"),
        ("video","Formation"),
        ("person","Contact"),
        //("gear","Paramètres")
    ]
    
    var body: some View {
        ZStack {
            Capsule()
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color("Color1"), // En bas à gauche
                            Color("Color2"),
                            Color("Color3"),
                            Color("Color4")  // En haut à droite
                        ]),
                        startPoint: .bottomLeading,
                        endPoint: .topTrailing
                    )
                )
                .frame(height: 80)
                //.foregroundColor(Color(.secondarySystemBackground))
                .shadow(radius: 8) //2
            
            HStack {
                ForEach(tabBarItems.indices, id: \.self) { index in
                    let isSelected = (index + 1 == tabSelection)
                    
                    Button(action: {
                        tabSelection = index + 1
                    }) {
                        VStack (spacing: 8) {
                            Spacer()
                            
                            Image(systemName: tabBarItems[index].image)
                            
                            Text(tabBarItems[index].title)
                                .font(.caption)
                            
                            if isSelected {
                                Capsule()
                                    .frame(height: 8)
                                    .foregroundColor(.white)
                                    .matchedGeometryEffect(id: "SelectedTabId", in: animationNamespace)
                                    .offset(y: 3)
                            } else {
                                Capsule()
                                    .frame(height: 8)
                                    .foregroundColor(.clear)
                                    .offset(y: 3)
                            }
                        }
                        .foregroundColor(isSelected ? .white : .gray)
                    }
                }
            }
            .frame(height: 80)
            .clipShape(Capsule())
        }
        .padding(.horizontal)
    }
}

#Preview {
    CustomTabView(tabSelection: .constant(1))
        .previewLayout(.sizeThatFits)
        .padding(.vertical)
}
