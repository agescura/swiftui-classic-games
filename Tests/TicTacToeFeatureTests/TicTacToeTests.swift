import XCTest
import ComposableArchitecture
@testable import TicTacToeFeature

@MainActor
final class TicTacToeTests: XCTestCase {
  func testHappyPath() async throws {
    let store = TestStore(
      initialState: .init(
        rows: .board
      ),
      reducer: TicTacToe()
    )
    
    store.dependencies.ticTacToeClient.randomElement = {
      .upperLeft
    }
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
    
    await store.receive(.checkFinished(.x))
    
    await clock.advance(by: .seconds(1))
    
    await store.receive(.addRandomMovement) {
      $0.rows[id: .upperLeft]?.player = .o
      $0.isLoading = false
    }
    
    await store.receive(.checkFinished(.o))
  }
  
  func testTictactoeStatePlayerXWonVLeft() {
    var state = TicTacToe.State(rows: .board)
    
    state.rows[id: .upperLeft]?.player = .x
    state.rows[id: .left]?.player = .x
    state.rows[id: .bottomLeft]?.player = .x
    
    XCTAssertEqual(state.hasFinish(), .win(.x))
  }
  
  func testTictactoeStatePlayerXWonVCenter() {
    var state = TicTacToe.State(rows: .board)
    
    state.rows[id: .upper]?.player = .x
    state.rows[id: .center]?.player = .x
    state.rows[id: .bottom]?.player = .x
    
    XCTAssertEqual(state.hasFinish(), .win(.x))
  }
  
  func testTictactoeStatePlayerXWonVRight() {
    var state = TicTacToe.State(rows: .board)
    
    state.rows[id: .upperRight]?.player = .x
    state.rows[id: .right]?.player = .x
    state.rows[id: .bottomRight]?.player = .x
    
    XCTAssertEqual(state.hasFinish(), .win(.x))
  }
  
  func testTictactoeStatePlayerXWonUpper() {
    var state = TicTacToe.State(rows: .board)
    
    state.rows[id: .upperLeft]?.player = .x
    state.rows[id: .upper]?.player = .x
    state.rows[id: .upperRight]?.player = .x
    
    XCTAssertEqual(state.hasFinish(), .win(.x))
  }
}
