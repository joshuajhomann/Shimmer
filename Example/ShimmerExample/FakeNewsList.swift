//
//  FakeNewsList.swift
//  ShimmerExample
//
//  Created by Joshua Homann on 2/21/21.
//

import SwiftUI

struct FakeNewsList: View {
  let items: [NewsItem]
  @Environment(\.redactionReasons) private var redactionReasons
  private var isRedacted: Bool { redactionReasons.contains(.placeholder) }
  var body: some View {
    List(items) { item in
      HStack(alignment: .center, spacing: 12) {
        Image(systemName: item.imageName)
        VStack(alignment: .leading) {
          Text(item.title)
            .font(.title)
          Text(item.subtitle)
            .font(.subheadline)
        }
      }
      .padding()
    }
    .animation(.none)
  }
}
