import ComposableArchitecture
import Foundation
import SwiftUI
import TicTacToeFeature

public struct AppView: View {
  private let store: StoreOf<App>
  
  public init(
    store: StoreOf<App>
  ) {
    self.store = store
  }
  
  public var body: some View {
    WithViewStore(
      self.store,
      observe: { $0 }
    ) { viewStore in
      NavigationStack {
        List {
          Button {
            viewStore.send(.setTicTacToeNavigation(isActive: true))
          } label: {
            HStack {
              Text("TicTacToe")
              Spacer()
              Image(systemName: "chevron.right")
                .foregroundColor(.gray)
            }
            .contentShape(Rectangle())
          }
          .buttonStyle(.plain)
          Text("Buscaminas")
          Text("Sudoku")
        }
        .navigationDestination(
          isPresented: viewStore.binding(
            get: \.isTicTacToeNavigationActive,
            send: App.Action.setTicTacToeNavigation(isActive:)
          ),
          destination: {
            IfLetStore(
              self.store.scope(
              state: \.ticTacToe,
              action: App.Action.ticTacToe
            )
            ) { TicTacToeView(store: $0) }
          }
        )
      }
    }
  }
}

struct AppView_Preview: PreviewProvider {
  static var previews: some View {
    AppView(
      store: .init(
        initialState: .init(),
        reducer: App()
      )
    )
  }
}
