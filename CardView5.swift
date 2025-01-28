//
//  CardView5.swift
//  pia13swiftv4
//
//  Created by Elia Johannes on 2025-01-28.
//

import SwiftUI
import Firebase
import FirebaseStorage
struct CardView5: View {
  let people = [
    ("Person 1", 30),
    ("Person 2", 2),
    ("Person 3", 3),
    ("Person 4", 4),
    ("Person 5", 5),
    ("Person 6", 6),
    ("Person 7", 7),
    ("Person 8", 8),
    ("Person 9", 9),
    ("Person 11", 10),
    ("Person 12", 31),
    ("Person 14", 12),
    ("Person 15", 13),
    ("Person 16", 14),
    ("Person 17", 15),
    ("Person 18", 16),
    ("Person 19", 17),
    ("Person 20", 22),
    ("Person 21", 20),
    ("Person 22", 47)
  ]
  var body: some View {
    ScrollView(.horizontal, showsIndicators: false) {
      ZStack
      {
        ForEach(people, id: \.1) { person in
          testView(person: person.0, imageIndex: person.1)
            .frame(width: 320, height: 420)
        }
      }
      .padding()
    }
  }
}
struct CardView5_Previews: PreviewProvider {
  static var previews: some View {
    CardView5()
  }
}






