//
//  TestaStorage View.swift
//  pia13swiftv4
//
//  Created by Elia Johannes on 2025-01-22.
//

import SwiftUI
import FirebaseStorage
import PhotosUI

struct TestaStorageView: View {
    
    @State var userphotoItem: PhotosPickerItem?
    @State var userphotoImage: Image?
    
    @State private var image = UIImage()
    @State private var showSheet = false
    
    @State var fancyimage: Image?
    
    var body: some View {
        VStack(spacing: 20) {
            
            // Topptexten för användarvänlighet (kan ta bort om det känns för mycket)
            Text("Choose your image")
                .font(.largeTitle)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .padding(.top, 400)
            
            // Om användaren valt en bild från galleriet, visa den
            if let userphotoImage = userphotoImage {
                userphotoImage
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250, height: 250)
                    .clipShape(RoundedRectangle(cornerRadius: 25))
                    .shadow(radius: 10)
            }
            
            // Om en bild finns i Firebase Storage, visa den
            if let fancyimage = fancyimage {
                fancyimage
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250, height: 250)
                    .clipShape(RoundedRectangle(cornerRadius: 25))
                    .shadow(radius: 10)
            }
            
            // För att välja en bild från galleriet
            PhotosPicker("Select Image from Gallery", selection: $userphotoItem, matching: .images)
                .padding(.horizontal, 20)
                .frame(height: 50)
                .background(Color.white)
                .cornerRadius(12)
                .shadow(radius: 10)
            
            // För att ta en ny bild
            Button(action: {
                showSheet = true
            }) {
                Text("Take a Picture")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.white)
                    .foregroundColor(.black)
                    .cornerRadius(8)
                    .scaleEffect(1.0)
            }
            .padding(.top, 20)
            .padding(.horizontal)
            
            Spacer()
        }
        .background(LinearGradient(gradient: Gradient(colors: [.black, .gray]), startPoint: .top, endPoint: .bottom))
        .edgesIgnoringSafeArea(.all)
        .onAppear() {
            dostorage()
        }
        .onChange(of: userphotoItem) { _ in
            Task {
                if let loaded = try? await userphotoItem?.loadTransferable(type: Image.self) {
                    userphotoImage = loaded
                    uploadToStorage(uploadimage: loaded)
                }
            }
        }
        .sheet(isPresented: $showSheet) {
            ImagePicker(sourceType: .camera, selectedImage: self.$image)
        }
        
        
    }
    
    func dostorage() {
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let imagesRef = storageRef.child("userselectimage.jpg")
        
        imagesRef.getData(maxSize: 2_500_000) { data, error in
            if let error = error {
                print("Error fetching image: \(error)")
                return
            }
            
            if let data = data, let uiimage = UIImage(data: data) {
                fancyimage = Image(uiImage: uiimage)
            }
        }
    }
    
    func uploadToStorage(uploadimage: Image) {
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let imagesRef = storageRef.child("userselectimage.jpg")
        
        let imagedata = ImageRenderer(content: uploadimage).uiImage!.jpegData(compressionQuality: 0.8)
        
        imagesRef.putData(imagedata!, metadata: nil) { metadata, error in
            if let error = error {
                print("Upload failed: \(error)")
            } else {
                print("Upload successful!")
            }
        }
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Environment(\.presentationMode) private var presentationMode
    var sourceType: UIImagePickerController.SourceType = .camera
    @Binding var selectedImage: UIImage
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = false
        imagePicker.sourceType = sourceType
        imagePicker.delegate = context.coordinator
        return imagePicker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        var parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                parent.selectedImage = image
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
   

    
}

#Preview {
    TestaStorageView()
}
