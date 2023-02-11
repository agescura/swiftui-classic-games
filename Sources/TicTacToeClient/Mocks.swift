import Dependencies
import Models

extension TicTacToeClient: TestDependencyKey {
  public static let previewValue = Self.noop
  
  public static let testValue = Self(
    board: XCTUnimplemented("\(Self.self).board"),
    randomElement: XCTUnimplemented("\(Self.self).randomElement")
  )
}

extension TicTacToeClient {
    public static let noop = Self(
      board: { [] },
      randomElement: { .center }
    )
}
