//
//  TestView.swift
//  pia13swiftv4
//
//  Created by Elia Johannes on 2025-01-28.
//

import SwiftUI
import Firebase
import FirebaseStorage
class Todos {
  var title = ""
  var id = ""
  var likes = 0
  var imageName = ""
}
struct testView: View {
  @State var todoadd = ""
  @State var todolist = [Todos]()
  @State private var offset = CGSize.zero
  @State private var color: Color = .white
  @State var fancyimage: Image?
  var person: String
  var imageIndex: Int
  var body: some View {
    ZStack {
      Rectangle()
        .frame(width: 320, height: 420)
        .border(.white, width: 6.0)
        .cornerRadius(4)
        .foregroundColor(color.opacity(0.9))
        .shadow(radius: 4)
      VStack {
        if let fancyimage = fancyimage {
          fancyimage
            .resizable()
            .frame(width: 300, height: 300)
        } else {
          Text("Loading image...")
            .foregroundColor(.white)
            .italic()
        }
      }
    }
    .onAppear {
      doastorage(imageIndex: imageIndex)
    }
    .offset(x: offset.width * 1, y: offset.height * 0.4)
    .rotationEffect(.degrees(Double(offset.width / 40)))
    .gesture(
      DragGesture()
        .onChanged { gesture in
          offset = gesture.translation
          withAnimation {
            changeColor(width: offset.width)
          }
        }
        .onEnded { _ in
          withAnimation {
            swipeCard(width: offset.width)
            changeColor(width: offset.width)
          }
        }
    )
  }
  func doastorage(imageIndex: Int) {
    let storage = Storage.storage()
    let storageRef = storage.reference()
    let imageRef = storageRef.child("\(imageIndex).jpg")
    imageRef.getData(maxSize: 1_000_000) { data, error in
      if let error = error {
        print("Error loading image: \(error.localizedDescription)")
      } else if let data = data, let uiImage = UIImage(data: data) {
        DispatchQueue.main.async {
          fancyimage = Image(uiImage: uiImage)
        }
      }
    }
  }
  func swipeCard(width: CGFloat) {
    switch width {
    case -500...(-150):
      print("\(person) removed")
      offset = CGSize(width: -500, height: 0)
    case 150...500:
      print("\(person) added")
      incrementLikes(for: "\(imageIndex).jpg")
      offset = CGSize(width: 500, height: 0)
    default:
      offset = .zero
    }
  }
  func changeColor(width: CGFloat) {
    switch width {
    case -500...(-130):
      color = Color.red
    case 130...500:
      color = Color.green
    default:
      color = Color.white
    }
  }
  func incrementLikes(for imageName: String) {
    let ref = Database.database().reference().child("todo")
    ref.queryOrdered(byChild: "title").queryEqual(toValue: imageName).observeSingleEvent(of: .value) { snapshot in
      if let snapshotValue = snapshot.value as? [String: Any],
        let firstKey = snapshotValue.keys.first,
        var todoDict = snapshotValue[firstKey] as? [String: Any],
        let currentLikes = todoDict["likes"] as? Int {
        let newLikes = currentLikes + 1
        ref.child(firstKey).updateChildValues(["likes": newLikes])
        print("Likes incremented for \(imageName) with new likes: \(newLikes)")
      } else {
        let newTodo: [String: Any] = ["title": imageName, "likes": 1]
        ref.childByAutoId().setValue(newTodo)
        print("New entry created for \(imageName) with 1 like.")
      }
    }
  }
}
struct testView_Previews: PreviewProvider {
  static var previews: some View {
    testView(person: "Example", imageIndex: 30)
  }
}
