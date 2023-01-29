import ComposableArchitecture
import Foundation
import Models
import TicTacToeRowFeature

extension Player {
  var machine: Self {
    self == .x ? .o : .x
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

public struct TicTacToe: ReducerProtocol {
  public init() {}
  
  public struct State: Equatable {
    var rows: IdentifiedArrayOf<TicTacToeRow.State>
    var alert: AlertState<Action>?
    var player: Player
    var isLoading = false
    
    public init(
      rows: IdentifiedArrayOf<TicTacToeRow.State> = .board,
      player: Player = .x
    ) {
      self.rows = rows
      self.player = player
    }
  }
  
  public enum Action: Equatable {
    case alertDismissed
    case alertOButtonTapped
    case alertXButtonTapped
    case endGameButtonTapped
    case addRandomMovement
    case rows(id: Boundaries, action: TicTacToeRow.Action)
    case task
  }
  
  @Dependency(\.continuousClock) private var clock
  
  public var body: some ReducerProtocolOf<Self> {
    Reduce(self.core)
      .forEach(\.rows, action: /Action.rows, TicTacToeRow.init)
  }
  
  private func core(
      state: inout State,
      action: Action
  ) -> EffectTask<Action> {
    switch action {
    case .alertDismissed:
      state.alert = nil
      return .none
    case .alertOButtonTapped:
      state.player = .o
      return .none
    case .alertXButtonTapped:
      state.player = .x
      return .none
    case .endGameButtonTapped:
      return .none
    case .addRandomMovement:
      state.isLoading = false
      for row in state.rows {
        if row.player == nil {
          state.rows[id: row.boundaries]?.player = state.player.machine
          return .none
        }
      }
      return .none
    case let .rows(id: boundaries, action: .tap):
      state.rows[id: boundaries]?.player = state.player
      state.isLoading = true
      return .run { send in
        try await self.clock.sleep(for: .seconds(1))
        await send(.addRandomMovement)
      }
    case .rows:
      return .none
    case .task:
      state.alert = .ticTacToe
      return .none
    }
  }
}

extension AlertState where Action == TicTacToe.Action {
  public static var ticTacToe: Self {
    AlertState {
      TextState("Starting game")
    } actions: {
      ButtonState(action: .alertXButtonTapped) {
        TextState("X")
      }
      ButtonState(action: .alertOButtonTapped) {
        TextState("O")
      }
    } message: {
      TextState("Choose to place either an X or O")
    }
  }
}
