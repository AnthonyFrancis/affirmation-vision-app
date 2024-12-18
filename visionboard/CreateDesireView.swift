import SwiftUI
import PhotosUI

struct CreateDesireView: View {
   @Environment(\.dismiss) private var dismiss
   @State private var desireText = ""
   @State private var selectedImage: UIImage?
   @State private var showingImagePicker = false
   private let characterLimit = 120
   
   var onDesireCreated: ((String, String, Data?) -> Void)?
   
   @State private var selectedCategory = "Personal"
   let categories = ["Personal", "Wealth", "Health", "Career", "Relationships"]
   
   var body: some View {
       NavigationView {
           VStack(alignment: .leading, spacing: 20) {
               // Main content
               VStack(alignment: .leading, spacing: 16) {
                   Text("Add a new affirmation")
                       .font(.system(size: 32, weight: .bold))
                       .padding(.top, 40)
                   
                   Text("Narrow it down to one specific desire and write it below")
                       .font(.system(size: 20))
                       .foregroundColor(.black)
               }
               .padding(.horizontal)
               
               // Category Picker
               VStack(alignment: .leading, spacing: 10) {
                   Text("Category")
                       .font(.system(size: 18, weight: .semibold))
                       .foregroundColor(.black)
                   
                   Picker("Category", selection: $selectedCategory) {
                       ForEach(categories, id: \.self) { category in
                           Text(category)
                               .tag(category)
                       }
                   }
                   .pickerStyle(.segmented)
               }
               .padding(.horizontal)
               
               // Text input area
               VStack(alignment: .trailing) {
                   TextField("Type it here", text: $desireText)
                       .font(.system(size: 24))
                       .foregroundColor(.black)
                       .padding()
                       .background(Color(UIColor.systemGray5))
                       .cornerRadius(12)
                       .onChange(of: desireText) { newValue in
                           if newValue.count > characterLimit {
                               desireText = String(newValue.prefix(characterLimit))
                           }
                       }
                   
                   Text("\(desireText.count)/\(characterLimit)")
                       .font(.system(size: 14))
                       .foregroundColor(.gray)
                       .padding(.trailing, 4)
               }
               .padding(.horizontal)
               
               // Image Selection Button
               VStack(alignment: .leading, spacing: 10) {
                       
                   Button(action: {
                       showingImagePicker = true
                   }) {
                       if let image = selectedImage {
                           Image(uiImage: image)
                               .resizable()
                               .aspectRatio(contentMode: .fill)
                               .frame(height: 150)
                               .frame(maxWidth: .infinity)
                               .clipped()
                               .cornerRadius(12)
                               .overlay(
                                   Image(systemName: "pencil.circle.fill")
                                       .font(.title)
                                       .foregroundColor(.white)
                                       .padding(8)
                                       .background(Color.black.opacity(0.6))
                                       .clipShape(Circle())
                                       .padding(8),
                                   alignment: .topTrailing
                               )
                       } else {
                           HStack {
                               Image(systemName: "photo")
                               Text("Add Image")
                           }
                           .font(.headline)
                           .foregroundColor(.white)
                           .frame(maxWidth: .infinity)
                           .frame(height: 50)
                           .background(Color.gray)
                           .cornerRadius(12)
                       }
                   }
               }
               .padding(.horizontal)
               
               // Guidelines
               VStack(alignment: .leading, spacing: 12) {
                   Text("Guidelines for effective manifestation:")
                       .font(.system(size: 16, weight: .semibold))
                   
                   BulletPoint(text: "Be specific and clear")
                   BulletPoint(text: "Write in present tense")
                   BulletPoint(text: "Focus on what you want, not what you don't want")
                   BulletPoint(text: "Keep it positive and empowering")
               }
               .padding()
               .background(Color(UIColor.systemGray6))
               .cornerRadius(12)
               .padding(.horizontal)
               
               Spacer()
               
               // Continue button
               Button(action: {
                   let imageData = selectedImage?.jpegData(compressionQuality: 0.7)
                   onDesireCreated?(desireText, selectedCategory, imageData)
                   dismiss()
               }) {
                   Text("Continue")
                       .font(.system(size: 18, weight: .semibold))
                       .foregroundColor(.white)
                       .frame(maxWidth: .infinity)
                       .padding()
                       .background(desireText.isEmpty ? Color.gray : Color.black)
                       .cornerRadius(30)
               }
               .padding()
               .disabled(desireText.isEmpty)
           }
           .navigationBarItems(leading: Button(action: {
               dismiss()
           }) {
               Image(systemName: "chevron.left")
                   .font(.system(size: 20, weight: .semibold))
                   .foregroundColor(.black)
           })
           .navigationBarTitleDisplayMode(.inline)
           .sheet(isPresented: $showingImagePicker) {
               ImagePicker(selectedImage: $selectedImage)
           }
       }
   }
}

struct BulletPoint: View {
   let text: String
   
   var body: some View {
       HStack(alignment: .top, spacing: 8) {
           Text("•")
               .font(.system(size: 16))
           Text(text)
               .font(.system(size: 16))
       }
   }
}

struct ImagePicker: UIViewControllerRepresentable {
   @Binding var selectedImage: UIImage?
   @Environment(\.presentationMode) private var presentationMode
   
   func makeUIViewController(context: Context) -> UIImagePickerController {
       let picker = UIImagePickerController()
       picker.delegate = context.coordinator
       picker.sourceType = .photoLibrary
       return picker
   }
   
   func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
   
   func makeCoordinator() -> Coordinator {
       Coordinator(self)
   }
   
   class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
       let parent: ImagePicker
       
       init(_ parent: ImagePicker) {
           self.parent = parent
       }
       
       func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
           if let image = info[.originalImage] as? UIImage {
               parent.selectedImage = image
           }
           parent.presentationMode.wrappedValue.dismiss()
       }
       
       func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
           parent.presentationMode.wrappedValue.dismiss()
       }
   }
}

struct CreateDesireView_Previews: PreviewProvider {
   static var previews: some View {
       CreateDesireView()
   }
}
