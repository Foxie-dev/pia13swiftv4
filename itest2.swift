//
//  itest2.swift
//  pia13swiftv4
//
//  Created by Elia Johannes on 2025-01-28.
//


import SwiftUI
import FirebaseStorage
import PhotosUI

struct itest2: View {
    @State private var fancyImage: Image?
    @State private var userPhotoItem: PhotosPickerItem?
    @State private var userPhotoImage: Image?
    
    @State private var cameraImage = UIImage()
    @State private var showCameraSheet = false

    var body: some View {
        VStack(spacing: 20) {
            Text("Gallery & Camera")
                .font(.title)
                .padding()

            // Display the fetched Firebase image if available
            if let fancyImage = fancyImage {
                fancyImage
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .shadow(color: .gray.opacity(0.4), radius: 30, x: 0, y: 4) // Shadow with opacity
            }
            
            Divider()

            // Display the selected photo (either from gallery or camera)
            if let userPhotoImage = userPhotoImage {
                userPhotoImage
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .shadow(color: .gray.opacity(0.4), radius: 30, x: 0, y: 4) // Shadow with opacity
            } else {
                Text("No photo selected yet")
                    .foregroundColor(.gray)
            }

            Divider()

            // Button to select an image from the gallery
            PhotosPicker("Select Photo from Gallery", selection: $userPhotoItem, matching: .images)
                .padding()
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.gray.opacity(0.8), Color.black]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                ) // Gradient background with opacity
                .foregroundColor(.white)
                .font(.system(size: 18, weight: .semibold, design: .rounded)) // Font style
                .cornerRadius(12) // Rounded corners
                .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2) // Shadow effect

            Spacer()
            
            // Button to open the camera
            Button(action: {
                showCameraSheet = true
            }) {
                Image(systemName: "camera.fill") // SF Symbol for camera
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100) // Icon size
                    .foregroundColor(.white)
                    .padding()
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.gray.opacity(0.8), Color.black]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    ) // Gradient background with opacity
                    .cornerRadius(52) // Rounded corners
                    .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2) // Shadow effect
            }

            Spacer()
        }
        .padding()
        .onAppear {
            fetchImageFromFirebase()
        }
        .onChange(of: userPhotoItem) { _ in
            Task {
                if let loadedImage = try? await userPhotoItem?.loadTransferable(type: Image.self) {
                    userPhotoImage = loadedImage
                    uploadImageToFirebase(uploadImage: loadedImage)
                } else {
                    print("Failed to load image from gallery.")
                }
            }
        }
        .sheet(isPresented: $showCameraSheet) {
            ImagePicker(sourceType: .camera, selectedImage: $cameraImage)
                .onDisappear {
                    if let image = UIImageToSwiftUIImage(cameraImage) {
                        userPhotoImage = image
                        uploadImageToFirebase(uploadImage: image)
                    }
                }
        }
    }
    
    /// Fetch an image from Firebase Storage.
    func fetchImageFromFirebase() {
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let imageRef = storageRef.child("userselectimage.jpg")
        
        imageRef.getData(maxSize: 1_000_000) { data, error in
            if let error = error {
                print("Error fetching image from Firebase: \(error.localizedDescription)")
                return
            }
            if let data = data, let uiImage = UIImage(data: data) {
                fancyImage = Image(uiImage: uiImage)
            }
        }
    }
    
    /// Upload an image to Firebase Storage.
    func uploadImageToFirebase(uploadImage: Image) {
        Task {
            let storage = Storage.storage()
            let storageRef = storage.reference()
            
            // Generate a unique name for the image
            let imageName = await generateUniqueImageName()
            let imageRef = storageRef.child(imageName)
            
            // Convert the SwiftUI Image to UIImage and then to JPEG data
            let renderer = ImageRenderer(content: uploadImage.frame(width: 800, height: 800))
            if let renderedUIImage = renderer.uiImage, let imageData = renderedUIImage.jpegData(compressionQuality: 0.8) {
                // Upload image data
                imageRef.putData(imageData, metadata: nil) { metadata, error in
                    if let error = error {
                        print("Error uploading image to Firebase: \(error.localizedDescription)")
                    } else {
                        print("Successfully uploaded image: \(imageName)")
                    }
                }
            }
        }
    }
    
    /// Generate a unique image name for Firebase Storage.
    func generateUniqueImageName() async -> String {
        let storage = Storage.storage()
        let storageRef = storage.reference()
        
        var imageName = ""
        var index = 1
        var imageExists = true
        
        while imageExists {
            imageName = "\(index).jpg"
            let imageRef = storageRef.child(imageName)
            do {
                _ = try await imageRef.getMetadata()
                index += 1
            } catch {
                // If metadata fetch fails, the image does not exist
                imageExists = false
            }
        }
        return imageName
    }
    
    /// Convert UIImage to SwiftUI Image.
    func UIImageToSwiftUIImage(_ uiImage: UIImage) -> Image? {
        return Image(uiImage: uiImage)
    }
}

#Preview {
    itest2()
}
