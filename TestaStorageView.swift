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
    
    @State var userphotoItem : PhotosPickerItem?
    @State var userphotoImage : Image?
    
    // man måste alltid guard sig när man kodar mot fel, annars kommer koden inte funka.
    @State var fancyimage : Image?
    
    //vi skapar en utrymme för att spara en bild, bilden kan ändra sig. Det är en state variabel, struktur variabel.
    @State private var image = UIImage()
    @State private var showSheet = false
    
    var body: some View {
        VStack {
            Text("Bird")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.black)
            
            if fancyimage != nil {
                fancyimage!
                    .resizable()
                    .frame(width: 100, height: 100)
            }
        }
        
        PhotosPicker("select some image", selection:
                        $userphotoItem, matching: .images)
        
        
        userphotoImage?
            .resizable()
            .scaledToFit()
            .frame(width: 200, height: 200)
        
        Image(uiImage: self.image)
            .resizable()
            .cornerRadius(50)
            .padding(.all, 4)
            .frame(width: 100, height: 100)
        
        Button(action: {
            showSheet = true
        }) {
            Text("Camera")
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .foregroundColor(.blue)
        }
        
        .padding()
        .background(
            LinearGradient(
                gradient: Gradient(colors: [.blue, .purple]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
        )
        
        //Här startar koden
        .onAppear() {
            dostorage()
        }
        .onChange(of: userphotoItem) {
            Task {
                if let loaded = try? await userphotoItem?.loadTransferable(type: Image.self) {
                    userphotoImage = loaded
                    
                    uploadToStorage(uploadimage: loaded)
                } else {
                    print("Failed")
                }
            }
        }
        .sheet(isPresented: $showSheet) {
            ImagePicker(sourceType: .camera, selectedImage: self.$image)
        }
        
    }
        //Här definerar vi funktionens namn och kod
        func dostorage() {
            //"du är du", dubbeldefinera
            let storage = Storage.storage()
            
            // Create a storage reference from our storage service, skriver referense till en koppling/adress till en databas (firebase här)
            let storageRef = storage.reference()
            
            // Create a reference to the file you want to upload/ vilken vi vill prata me. Vi skapar en bildkoppling till bilden i databasen. först en koppling till databasen, sen en koppling till bilden i databasen. Den bilden som finns i gallerian
            let imagesRef = storageRef.child("userselectimage.jpg")
            
            // säger get på den
            imagesRef.getData(maxSize: 1_000_000) { data, error in
                
                // kollar om det gick dåligt
                if error != nil {
                    // FEL FEL FEL
                }
                
                // Vi har gjort massa konstanter för att: vi jobbar me förutsatt kod.
                
                if let data = data {
                    let uiimage = UIImage(data: data)!
                    fancyimage = Image(uiImage: uiimage)
                }
            }
            
        }
        
        func uploadToStorage(uploadimage: Image) {
            
            let smallerImage = uploadimage.resizable().scaledToFit().frame(width: 200, height: 200)
            
            let storage = Storage.storage()
            
            let storageRef = storage.reference()
            
            let imagesRef = storageRef.child("userselectimage.jpg")
            
            let imagedata = ImageRenderer(content: uploadimage).uiImage!.jpegData(compressionQuality: 0.8)
            
            imagesRef.putData(imagedata!, metadata: nil) { metadata, error in
                if error != nil {
                    print("Failed")
                } else {
                    print("Upload ok")
                }
            }
        }
    }
    
    
    // Gör en ImagePicker, får me sig in vilken sorts typ det är: kamera elr photolibrary. Den får med sig en binding, vilket är tvåvägs, dollartecken, jag ger den en lådan. När den valt en bild här läg i den här! Smidigt sätt att starta och skicka tillbaka.
    struct ImagePicker: UIViewControllerRepresentable {
        @Environment(\.presentationMode) private var presentationMode
        var sourceType: UIImagePickerController.SourceType = .camera
        @Binding var selectedImage: UIImage
        
        func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
            
            let imagePicker = UIImagePickerController()
            imagePicker.allowsEditing = false
            imagePicker.sourceType = sourceType
            imagePicker.delegate = context.coordinator
            
            return imagePicker
        }
        
        func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {
        }
        
        func makeCoordinator() -> Coordinator {
            Coordinator(self)
        }
        
        final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
            
            var parent: ImagePicker
            
            init(_ parent: ImagePicker) {
                self.parent = parent
            }
            
            func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
                
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

               
