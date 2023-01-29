import XCTest
import ComposableArchitecture
@testable import TicTacToeFeature

@MainActor
final class TicTacToeTests: XCTestCase {
  func testHappyPath() async throws {
    let store = TestStore(
      initialState: .init(),
      reducer: TicTacToe()
    )
    
    let clock = TestClock()
    store.dependencies.continuousClock = clock
    
    await store.send(.task) {
      $0.alert = .ticTacToe
    }
    
    await store.send(.alertXButtonTapped)
    
    await store.send(.rows(id: .upper, action: .tap)) {
      $0.isLoading = true
      $0.rows[id: .upper]?.player = .x
    }
    
    await clock.advance(by: .seconds(1))
    
    await store.receive(.addRandomMovement) {
      $0.rows[id: .upperLeft]?.player = .o
      $0.isLoading = false
    }
  }
}
