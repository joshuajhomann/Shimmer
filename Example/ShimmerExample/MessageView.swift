//
//  MessageView.swift
//  ShimmerExample
//
//  Created by Joshua Homann on 2/21/21.
//

import SwiftUI

struct MessageView: View {
  let message: String
  let imageName: String
  var body: some View {
    VStack(spacing: 12) {
      Spacer()
      Image(systemName: imageName).font(.system(size: 48))
      Text(message)
      Spacer()
    }
  }
}
