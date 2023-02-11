import Dependencies
import Models

extension TicTacToeClient: DependencyKey {
  public static var liveValue = Self(
    board: { Boundaries.allCases },
    randomElement: { Boundaries.allCases.randomElement()! }
  )
}
