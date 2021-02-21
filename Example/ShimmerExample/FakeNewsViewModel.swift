//
//  FakeNewsViewModel.swift
//  ShimmerExample
//
//  Created by Joshua Homann on 2/21/21.
//

import Combine
import Foundation
import Shimmer

final class FakeNewsViewModel: ObservableObject {
  @Published private(set) var loadingState: CollectionLoadingState<[NewsItem]> = .loading(placeholder: NewsItem.placeholders)
  @Published var newsResult: NewsResult = .loaded
  enum NewsResult: String, CaseIterable, CustomStringConvertible {
    var description: String { rawValue.capitalized }
    case loaded, empty, error
  }
  private var subscriptions = Set<AnyCancellable>()
  private let reloadSubject = PassthroughSubject<Void, Never>()
  init() {
    let fakeNewsService = FakeNewsService()
    $newsResult.sink(receiveValue: { [reloadSubject] value in
      switch value {
      case .error:
        fakeNewsService.result = .failure(FakeNewsService.error)
      case .loaded:
        fakeNewsService.result = .success(FakeNewsService.sampleItems)
      case .empty:
        fakeNewsService.result = .success([])
      }
      reloadSubject.send()
    })
    .store(in: &subscriptions)

    reloadSubject
    .map {
      fakeNewsService
        .getFeed()
        .delay(for: .seconds(2), scheduler: DispatchQueue.main)
        .mapToLoadingState(placeholder: NewsItem.placeholders)
    }
    .switchToLatest()
    .receive(on: DispatchQueue.main)
    .assign(to: \.loadingState, on: self)
    .store(in: &subscriptions)
  }
  func reload() -> Void {
    reloadSubject.send()
  }
}
