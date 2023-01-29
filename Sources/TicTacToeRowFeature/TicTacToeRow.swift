import ComposableArchitecture
import Foundation
import Models

public struct TicTacToeRow: ReducerProtocol {
  public init() {}
  
  public struct State: Identifiable, Equatable {
    public var boundaries: Boundaries
    public var player: Player?
    public var disabled: Bool {
      self.player != nil
    }
    
    public var id: Boundaries {
      self.boundaries
    }
    
    public init(
      boundaries: Boundaries,
      player: Player? = nil
    ) {
      self.boundaries = boundaries
      self.player = player
    }
  }
  
  public enum Action: Equatable {
    case tap
  }
  
  public var body: some ReducerProtocolOf<Self> {
    EmptyReducer()
  }
}
