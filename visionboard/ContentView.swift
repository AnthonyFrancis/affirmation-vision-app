import SwiftUI

struct ContentView: View {
   @StateObject private var desireStore = DesireStore()
   @State private var showingCreateDesire = false
   
   var body: some View {
       NavigationView {
           ZStack {
               Color(UIColor.systemGray6)
                   .ignoresSafeArea()
               
               ScrollView {
                   VStack(alignment: .leading, spacing: 20) {
                       // Header
                       Text("Hey Anthony")
                           .font(.system(size: 40, weight: .bold))
                           .padding(.horizontal)
                       
                       // Desires Section
                       VStack(alignment: .leading, spacing: 12) {
                           HStack {
                               Text("🤩")
                                   .font(.title)
                               Text("Your Desires")
                                   .font(.system(size: 24, weight: .semibold))
                           }
                           
                           Text("Important:")
                               .font(.headline) +
                           Text(" Your desires can become a reality sooner than you expect!. But you need to do the manifest exercise everyday.") +
                           Text("🌈") +
                           Text("\nFor fastest results we recommend 4 manifest sessions daily.") +
                           Text("(Tip 👈)") +
                           Text("\nClick the \"Add reminders\" button to set multiple reminders so you don't forget)")
                       }
                       .padding()
                       .background(Color.white)
                       .cornerRadius(15)
                       .padding(.horizontal)
                       
                       // Display Desires
                       if !desireStore.desires.isEmpty {
                           VStack(alignment: .leading, spacing: 15) {
                               Text("My Affirmations")
                                   .font(.system(size: 24, weight: .semibold))
                                   .padding(.horizontal)
                               
                               ForEach(desireStore.desires) { desire in
                                   SwipeView {
                                       DesireCard(desire: desire) { updatedCount in
                                           var updatedDesire = desire
                                           updatedDesire.manifestCount = updatedCount
                                           desireStore.updateDesire(updatedDesire)
                                       }
                                   } onDelete: {
                                       if let index = desireStore.desires.firstIndex(where: { $0.id == desire.id }) {
                                           withAnimation {
                                               desireStore.removeDesire(at: index)
                                           }
                                       }
                                   }
                               }
                           }
                       }
                       
                       Spacer()
                   }
               }
               
               // Floating Action Button
               VStack {
                   Spacer()
                   HStack {
                       Spacer()
                       Button(action: {
                           showingCreateDesire = true
                       }) {
                           Image(systemName: "plus")
                               .font(.title)
                               .foregroundColor(.black)
                               .frame(width: 60, height: 60)
                               .background(Color.white)
                               .clipShape(Circle())
                               .shadow(radius: 4)
                       }
                       .padding()
                   }
               }
           }
           .sheet(isPresented: $showingCreateDesire) {
               CreateDesireView { text, category, imageData in
                   let newDesire = Desire(text: text, category: category, manifestCount: 0, imageData: imageData)
                   desireStore.addDesire(newDesire)
               }
           }
           
           // Bottom Navigation Bar
           .safeAreaInset(edge: .bottom) {
               HStack {
                   // Non-functional Home button
                   VStack {
                       Image(systemName: "house.fill")
                       Text("Home")
                           .font(.caption)
                   }
                   .foregroundColor(.black)
                   
                   Spacer()
                   
                   NavigationLink(destination: Text("Activity")) {
                       VStack {
                           Image(systemName: "bell")
                           Text("Activity")
                               .font(.caption)
                       }
                   }
                   .foregroundColor(.gray)
                   
                   Spacer()
                   
                   NavigationLink(destination: Text("Settings")) {
                       VStack {
                           Image(systemName: "gear")
                           Text("Settings")
                               .font(.caption)
                       }
                   }
                   .foregroundColor(.gray)
               }
               .padding()
               .background(Color.white)
               .overlay(
                   Rectangle()
                       .frame(height: 1)
                       .foregroundColor(Color.gray.opacity(0.2)),
                   alignment: .top
               )
           }
       }
   }
}

struct SwipeView<Content: View>: View {
    let content: Content
    let onDelete: () -> Void
    
    @State private var offset: CGFloat = 0
    @State private var showingDeleteAlert = false
    
    init(@ViewBuilder content: () -> Content, onDelete: @escaping () -> Void) {
        self.content = content()
        self.onDelete = onDelete
    }
    
    var body: some View {
        ZStack(alignment: .trailing) {
            // Delete background
            if offset < 0 {
                Rectangle()
                    .foregroundColor(.red)
                    .frame(width: abs(offset))
                    .overlay(
                        Image(systemName: "trash")
                            .foregroundColor(.white)
                            .padding(.trailing, 25)
                        , alignment: .trailing
                    )
            }
            
            // Content
            content
                .offset(x: offset)
                .gesture(
                    DragGesture(minimumDistance: 20, coordinateSpace: .local)
                        .onChanged { gesture in
                            let horizontalTranslation = gesture.translation.width
                            let verticalTranslation = gesture.translation.height
                            
                            // Only respond if the gesture is primarily horizontal
                            // and moving left (negative translation)
                            if abs(horizontalTranslation) > abs(verticalTranslation) && horizontalTranslation < 0 {
                                withAnimation {
                                    offset = max(horizontalTranslation, -100)
                                }
                            }
                        }
                        .onEnded { gesture in
                            withAnimation {
                                if offset < -50 {
                                    showingDeleteAlert = true
                                }
                                offset = 0
                            }
                        }
                )
        }
        .alert("Are you sure?", isPresented: $showingDeleteAlert) {
            Button("Delete", role: .destructive) {
                onDelete()
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("If you hit the button, this desire will be deleted.")
        }
    }
}

struct DesireCard: View {
   let desire: Desire
   let onManifest: (Int) -> Void
   @State private var localManifestCount: Int
   
   init(desire: Desire, onManifest: @escaping (Int) -> Void) {
       self.desire = desire
       self.onManifest = onManifest
       _localManifestCount = State(initialValue: desire.manifestCount)
   }
   
   var body: some View {
       VStack(alignment: .leading, spacing: 15) {
           // Image Section
           if let imageData = desire.imageData, let uiImage = UIImage(data: imageData) {
               Image(uiImage: uiImage)
                   .resizable()
                   .aspectRatio(contentMode: .fill)
                   .frame(height: 150)
                   .clipped()
                   .cornerRadius(12)
           }
           
           HStack {
               Text(desire.category)
                   .font(.system(size: 14, weight: .medium))
                   .padding(.horizontal, 12)
                   .padding(.vertical, 6)
                   .background(Color(UIColor.systemGray5))
                   .cornerRadius(12)
               Spacer()
           }
           
           Text(desire.text)
               .font(.system(size: 20, weight: .semibold))
           
           HStack {
               HStack(spacing: 5) {
                   Image(systemName: "star")
                   Text("\(localManifestCount) times today")
               }
               
               Spacer()
               
               Button(action: {
                   localManifestCount += 1
                   onManifest(localManifestCount)
               }) {
                   Text("MANIFEST")
                       .fontWeight(.semibold)
                       .foregroundColor(.white)
                       .padding(.horizontal, 20)
                       .padding(.vertical, 10)
                       .background(Color.black)
                       .cornerRadius(20)
               }
           }
       }
       .padding()
       .background(Color.white)
       .cornerRadius(15)
       .padding(.horizontal)
   }
}

struct ContentView_Previews: PreviewProvider {
   static var previews: some View {
       ContentView()
   }
}
