//
//  SView.swift
//  pia13swiftv4
//
//  Created by Elia Johannes on 2025-01-28.
//

import SwiftUI
import Firebase
import FirebaseStorage
// Model for Todo
struct TodoItem: Identifiable, Comparable {
  let id: String
  let title: String
  let likes: Int
  static func < (lhs: TodoItem, rhs: TodoItem) -> Bool {
    lhs.likes > rhs.likes
  }
}
class TodoViewModel: ObservableObject {
  @Published var todos: [TodoItem] = []
  private let databaseRef = Database.database().reference().child("todo")
  private let storageRef = Storage.storage().reference()
  init() {
    fetchTodos()
  }
  func fetchTodos() {
    databaseRef.observe(.value) { snapshot in
      var fetchedTodos: [TodoItem] = []
      for child in snapshot.children {
        if let childSnapshot = child as? DataSnapshot,
          let data = childSnapshot.value as? [String: Any],
          let title = data["title"] as? String,
          let likes = data["likes"] as? NSNumber { // Use NSNumber to handle numeric types
          let todoItem = TodoItem(id: childSnapshot.key, title: title, likes: likes.intValue) // Convert to Int
          fetchedTodos.append(todoItem)
        }
      }
      DispatchQueue.main.async {
        self.todos = fetchedTodos.sorted()
      }
    }
  }
  func fetchImage(for title: String, completion: @escaping (UIImage?) -> Void) {
    let imageRef = storageRef.child(title)
    imageRef.getData(maxSize: Int64(5 * 1024 * 1024)) { data, error in
      if let data = data, let image = UIImage(data: data) {
        completion(image)
      } else {
        print("Error fetching image for \(title): \(error?.localizedDescription ?? "Unknown error")")
        completion(nil) // Return nil if the image fails to load
      }
    }
  }
}
struct SView: View {
  @StateObject private var viewModel = TodoViewModel()
  var body: some View {
    NavigationView {
      ScrollView {
        LazyVStack(alignment: .leading) {
          ForEach(viewModel.todos) { todo in
            HStack(alignment: .center) {
              AsyncImageView(imageName: todo.title, viewModel: viewModel)
              VStack(alignment: .leading) {
                Text("Likes: \(todo.likes)")
                  .font(.subheadline)
                  .foregroundColor(.gray)
              }
              Spacer()
            }
            .padding()
            Divider()
          }
        }
      }
      .navigationTitle("Top images")
    }
  }
}
struct AsyncImageView: View {
  let imageName: String
  @ObservedObject var viewModel: TodoViewModel
  @State private var image: UIImage? = nil
  private let placeholder = UIImage(systemName: "photo") // Placeholder image
  var body: some View {
    Group {
      if let image = image {
        Image(uiImage: image)
          .resizable()
          .scaledToFit()
          .frame(width: 100, height: 100)
          .cornerRadius(8)
      } else {
        Image(uiImage: placeholder!)
          .resizable()
          .scaledToFit()
          .frame(width: 100, height: 100)
          .cornerRadius(8)
          .overlay(ProgressView().frame(width: 50, height: 50))
      }
    }
    .onAppear {
      viewModel.fetchImage(for: imageName) { fetchedImage in
        DispatchQueue.main.async {
          self.image = fetchedImage
        }
      }
    }
  }
}
#Preview {
  SView()
}
