import XCTest
@testable import AppFeature
import ComposableArchitecture

final class AppTests: XCTestCase {
  func testHappyPath() throws {
    let store = TestStore(
      initialState: .init(),
      reducer: App()
    )
    
    store.send(.setTicTacToeNavigation(isActive: true)) {
      $0.ticTacToe = .init()
    }
    
    store.send(.setTicTacToeNavigation(isActive: false)) {
      $0.ticTacToe = nil
    }
  }
}
