import Dependencies
import Models

extension DependencyValues {
  public var ticTacToeClient: TicTacToeClient {
    get { self[TicTacToeClient.self] }
    set { self[TicTacToeClient.self] = newValue }
  }
}

public struct TicTacToeClient {
  public var board: () -> [Boundaries]
  public var randomElement: () -> Boundaries
}
