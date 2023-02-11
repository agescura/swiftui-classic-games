import ComposableArchitecture
import Foundation
import Models
import TicTacToeClient
import TicTacToeRowFeature

extension Player {
  var machine: Self {
    self == .x ? .o : .x
  }
}

public enum Finish: Equatable {
  case win(Player)
  case draw
}

public struct TicTacToe: ReducerProtocol {
  public init() {}
  
  public struct State: Equatable {
    var rows: IdentifiedArrayOf<TicTacToeRow.State>
    var alert: AlertState<Action>?
    var player: Player
    var isLoading = false
    
    public init(
      rows: IdentifiedArrayOf<TicTacToeRow.State>,
      player: Player = .x
    ) {
      self.rows = rows
      self.player = player
    }
    
    func hasFinish() -> Finish? {
      let playerX = self.rows
        .filter { $0.player == .x }
        .map(\.boundaries)
      if playerX.contains([.left, .center, .right])
          || playerX.contains([.upperLeft, .upper, .upperRight])
          || playerX.contains([.bottomLeft, .bottom, .bottomRight])
          || playerX.contains([.upperLeft, .left, .bottomLeft])
          || playerX.contains([.upper, .center, .bottom])
          || playerX.contains([.upperRight, .right, .bottomRight])
          || playerX.contains([.upperLeft, .center, .bottomRight])
          || playerX.contains([.upperRight, .center, .bottomLeft]) {
        return .win(.x)
      }
      let playerO = self.rows
        .filter { $0.player == .o }
        .map(\.boundaries)
      if playerO.contains([.left, .center, .right])
          || playerO.contains([.upperLeft, .upper, .upperRight])
          || playerO.contains([.bottomLeft, .bottom, .bottomRight])
          || playerO.contains([.upperRight, .right, .bottomRight])
          || playerO.contains([.upper, .center, .bottom])
          || playerO.contains([.upperRight, .right, .bottomRight])
          || playerO.contains([.upperLeft, .center, .bottomRight])
          || playerO.contains([.upperRight, .center, .bottomLeft]) {
        return .win(.o)
      }
      if self.rows
        .filter({ $0.player != nil })
        .count == 9 {
        return .draw
      }
      return nil
    }
  }
  
  public enum Action: Equatable {
    case alertDismissed
    case alertFinish(Finish)
    case alertOButtonTapped
    case alertXButtonTapped
    case checkFinished(Player)
    case endGameButtonTapped
    case addRandomMovement
    case rows(id: Boundaries, action: TicTacToeRow.Action)
    case startButtonTapped
    case task
  }
  
  @Dependency(\.continuousClock) private var clock
  @Dependency(\.ticTacToeClient) private var gameClient
  
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
    case let .alertFinish(.win(player)):
      state.isLoading = false
      state.alert = .win(player: player)
      return .none
    case .alertFinish(.draw):
      state.isLoading = false
      state.alert = .draw
      return .none
    case .alertOButtonTapped:
      state.player = .o
      return EffectTask(value: .addRandomMovement)
    case .alertXButtonTapped:
      state.player = .x
      return .none
    case let .checkFinished(player):
      switch state.hasFinish() {
      case let .win(player):
        return EffectTask(value: .alertFinish(.win(player)))
      case .draw:
        return EffectTask(value: .alertFinish(.draw))
      case .none:
        if state.player == player {
          return .run { send in
            try await self.clock.sleep(for: .seconds(1))
            await send(.addRandomMovement)
          }
        }
        return .none
      }
    case .endGameButtonTapped:
      return .none
    case .addRandomMovement:
      state.isLoading = false
      while true {
        let randomBoundarie = self.gameClient.randomElement()
        if state.rows[id: randomBoundarie]?.player == nil {
          state.rows[id: randomBoundarie]?.player = state.player.machine
          return EffectTask(value: .checkFinished(state.player.machine))
        }
      }
    case let .rows(id: boundaries, action: .tap):
      state.rows[id: boundaries]?.player = state.player
      state.isLoading = true
      return EffectTask(value: .checkFinished(state.player))
    case .rows:
      return .none
    case .startButtonTapped:
      state.isLoading = false
      state.rows = .board
      return .run { send in
        try await self.clock.sleep(for: .seconds(0.2))
        await send(.task)
      }
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

extension AlertState where Action == TicTacToe.Action {
  public static func win(player: Player) -> Self {
    AlertState {
      TextState("Player \(player.rawValue) won")
    } actions: {
      ButtonState(action: .startButtonTapped) {
        TextState("Yes")
      }
//      ButtonState(action: .backButtonTapped) {
//        TextState("No, go home")
//      }
    } message: {
      TextState("Do you want to play another game now?")
    }
  }
}

extension AlertState where Action == TicTacToe.Action {
  public static var draw: Self {
    AlertState {
      TextState("Draw")
    } actions: {
      ButtonState(action: .startButtonTapped) {
        TextState("Yes")
      }
//      ButtonState(action: .backButtonTapped) {
//        TextState("No, go home")
//      }
    } message: {
      TextState("Do you want to play another game now?")
    }
  }
}
