//
//  FakeNewsService.swift
//  ShimmerExample
//
//  Created by Joshua Homann on 2/21/21.
//

import Combine
import Foundation

struct NewsItem: Codable, Identifiable {
  var id: Int
  var title: String
  var subtitle: String
  var imageName: String
  static let placeholders: [Self] = (0..<10).map {
    .init(
      id: $0,
      title: "Lorem ipsum dolor",
      subtitle: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
      imageName: "star.fill"
    )
  }
}

final class FakeNewsService {
  var result: Result<[NewsItem], Error> = .success(sampleItems)
  static let error = URLError(.badServerResponse)
  static let sampleItems: [NewsItem] = {
    return Bundle.main.url(forResource: "newsItems", withExtension: "json")
      .flatMap { try? Data(contentsOf: $0) }
      .flatMap { try? JSONDecoder().decode([NewsItem].self, from: $0)} ?? []
  }()

  func getFeed() -> AnyPublisher<[NewsItem], Error> {
    result.publisher.eraseToAnyPublisher()
  }
}
