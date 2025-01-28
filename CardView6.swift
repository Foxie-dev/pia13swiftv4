//
//  Cardview.swift
//  pia13swiftv4
//
//  Created by Elia Johannes on 2025-01-28.
//
import SwiftUI
import Firebase
import FirebaseStorage
struct CardView6: View {
  @State private var availableImages: [Int] = []
  @State private var displayedImages: [Int] = []
  @State private var currentBatch: Int = 0
  private let batchSize = 20
  var body: some View {
    ZStack {
      // Background for the entire screen to provide visual space
      Color.gray.opacity(0.1).edgesIgnoringSafeArea(.all)
      // Centered card stack (vertically and horizontally)
      ZStack {
        Spacer() // Pushes content upwards
        // Card Stack: Display images
        ForEach(displayedImages, id: \.self) { imageIndex in
          testView(person: "Person \(imageIndex)", imageIndex: imageIndex)
            .frame(width: 320, height: 420)
            .zIndex(Double(displayedImages.count - imageIndex)) // Ensure cards stay on top
            .padding(.bottom, 10)
        }
        Spacer() // Pushes content upwards to create space for the button
        // efg9e9iio8b Batch loading button
        if displayedImages.count >= currentBatch * batchSize {
          VStack {
            Text("End of swipes")
              .font(.headline)
              .foregroundColor(.gray)
              .padding(.bottom, 10)
            if availableImages.count > displayedImages.count {
              Button(action: loadNextBatch) {
                Text("Load 20 more cards")
                  .font(.headline)
                  .foregroundColor(.blue)
                  .padding()
                  .background(Color.white.opacity(0.8))
                  .cornerRadius(10)
                  .shadow(radius: 5)
              }
            } else {
              Text("No more cards available")
                .font(.subheadline)
                .foregroundColor(.red)
            }
          }
          .frame(width: 320, height: 100)
          .background(Color.white.opacity(0.8))
          .cornerRadius(10)
          .shadow(radius: 5)
        }
      }
      .frame(maxWidth: .infinity, maxHeight: .infinity)
      .onAppear {
        Task {
          await loadAvailableImages()
        }
      }
    }
  }
  /// Load the indices of images that exist in Firebase Storage using the `listAll` API.
  func loadAvailableImages() async {
    let storage = Storage.storage()
    let storageRef = storage.reference()
    let imagesRef = storageRef.child("")
    do {
      // Fetch all items in the root directory
      let result = try await imagesRef.listAll()
      let tempAvailableImages = result.items.compactMap { item -> Int? in
        if let index = Int(item.name.replacingOccurrences(of: ".jpg", with: "")) {
          return index
        }
        return nil
      }
      // Shuffle and set the available images
      DispatchQueue.main.async {
        self.availableImages = tempAvailableImages.shuffled()
        self.loadNextBatch() // Load the first batch
      }
    } catch {
      print("Error fetching image list: \(error.localizedDescription)")
    }
  }
  /// Load the next batch of 20 cards.
  func loadNextBatch() {
    let startIndex = currentBatch * batchSize
    let endIndex = min(startIndex + batchSize, availableImages.count)
    if startIndex < endIndex {
      let newBatch = availableImages[startIndex..<endIndex]
      displayedImages.append(contentsOf: newBatch)
      currentBatch += 1
    }
  }
}
struct CardView6_Previews: PreviewProvider {
  static var previews: some View {
    CardView6()
  }
}
