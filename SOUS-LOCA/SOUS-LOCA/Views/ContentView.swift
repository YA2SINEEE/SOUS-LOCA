import SwiftUI

struct ContentView: View {
    @State private var tabSelection = 1
    
    var body: some View {
        TabView(selection: $tabSelection) {
            AnnouncementsView()
                .tag(1)
            ActualityView()
                .tag(2)
            FormationView()
                .tag(3)
            Text("Tab Content 4")
                .tag(4)
            /*Text("Tab Content 5")
                .tag(5)*/
        }
        .overlay(alignment: .bottom) {
            CustomTabView(tabSelection: $tabSelection)
        }
    }
}

#Preview {
    ContentView()
}
