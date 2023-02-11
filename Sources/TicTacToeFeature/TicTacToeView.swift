import ComposableArchitecture
import Foundation
import SwiftUI
import TicTacToeRowFeature

public struct TicTacToeView: View {
  private let store: StoreOf<TicTacToe>
  
  public init(
    store: StoreOf<TicTacToe>
  ) {
    self.store = store
  }
  
  public var body: some View {
    WithViewStore(
      self.store,
      observe: { $0 }
    ) { viewStore in
      NavigationStack {
        GeometryReader { proxy in
          VStack(spacing: 32) {
            Spacer()
            VStack {
              if viewStore.isLoading {
                HStack(spacing: 32) {
                  Text("Waiting... next moving...")
                  ProgressView()
                }
              }
            }
            .frame(height: 50)
            LazyVGrid(
              columns: Array(
                repeating: GridItem(.flexible()),
                count: 3
              ),
              spacing: 10
            ) {
              ForEachStore(
                store.scope(
                  state: \.rows,
                  action: TicTacToe.Action.rows(id:action:)),
                content: TicTacToeRowView.init(store:)
              )
            }
            Spacer()
          }
          .padding()
        }
        .navigationTitle("TicTacToe")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
          ToolbarItem(placement: .navigationBarTrailing) {
            Button {
              viewStore.send(.endGameButtonTapped)
            } label: {
              Text("End game")
            }
          }
        }
        .alert(
          self.store.scope(state: \.alert),
          dismiss: .alertDismissed
        )
        .task { viewStore.send(.task) }
      }
    }
  }
}

struct TicTacToeView_Preview: PreviewProvider {
  static var previews: some View {
    TicTacToeView(
      store: .init(
        initialState: .init(
          rows: .board
        ),
        reducer: TicTacToe()
      )
    )
  }
}

extension IdentifiedArray where Element == TicTacToeRow.State, ID == Boundaries {
  public static var board: Self {
    IdentifiedArrayOf<TicTacToeRow.State>(
      uniqueElements: Boundaries
        .allCases
        .map { .init(boundaries: $0) }
    )
  }
}

import Models
