import ComposableArchitecture
import Foundation
import TicTacToeFeature

public struct App: ReducerProtocol {
  public init() {}
  
  public struct State: Equatable {
    var ticTacToe: TicTacToe.State?
    var isTicTacToeNavigationActive: Bool {
      self.ticTacToe != nil
    }
    
    public init(
      ticTacToe: TicTacToe.State? = nil
    ) {
      self.ticTacToe = ticTacToe
    }
  }
  
  public enum Action: Equatable {
    case ticTacToe(TicTacToe.Action)
    case setTicTacToeNavigation(isActive: Bool)
  }
  
  public var body: some ReducerProtocolOf<Self> {
    Reduce(self.core)
      .ifLet(\.ticTacToe, action: /Action.ticTacToe, then: TicTacToe.init)
  }
  
  private func core(
      state: inout State,
      action: Action
  ) -> EffectTask<Action> {
    switch action {
    case .ticTacToe:
      return .none
    case let .setTicTacToeNavigation(isActive: isActive):
      state.ticTacToe = isActive ? .init() : nil
      return .none
    }
  }
}
