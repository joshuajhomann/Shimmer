//
//  CollectionLoadingState.swift
//  
//
//  Created by Joshua Homann on 2/20/21.
//

import Combine
import Foundation

public enum CollectionLoadingState<Content> {
  case loading(placeholder: Content), loaded(content: Content), empty, error(Error)
}

extension Publisher where Output: Collection {
  public func mapToLoadingState(placeholder: Output) -> AnyPublisher<CollectionLoadingState<Output>, Never> {
    map { $0.isEmpty ? CollectionLoadingState.empty : .loaded(content:$0) }
      .catch { Just(CollectionLoadingState.error($0)) }
      .prepend(.loading(placeholder: placeholder))
      .eraseToAnyPublisher()
  }
}

