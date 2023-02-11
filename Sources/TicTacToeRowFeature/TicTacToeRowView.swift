import ComposableArchitecture
import Foundation
import Models
import SwiftUI

public struct TicTacToeRowView: View {
  private let store: StoreOf<TicTacToeRow>
  
  public init(
    store: StoreOf<TicTacToeRow>
  ) {
    self.store = store
  }
  
  public var body: some View {
    WithViewStore(
      self.store,
      observe: { $0 }
    ) { viewStore in
      ZStack {
        GeometryReader { proxy in
          Path { p in
            p.addLines(
              viewStore.boundaries.lines(
                with: proxy.size
              )
            )
          }
          .stroke(Color.black, lineWidth: 10)
        
          if let player = viewStore.player {
            Image(systemName: player.systemName)
              .resizable()
              .padding(32)
              .bold()
              .foregroundColor(player.color)
          } else {
            EmptyView()
          }
        }
        .contentShape(Rectangle())
        .onTapGesture {
          viewStore.send(.tap)
        }
        .disabled(viewStore.disabled)
      }
      .aspectRatio(1, contentMode: .fit)
    }
  }
}

public struct TicTacToeRowView_Preview: PreviewProvider {
  public static var previews: some View {
    TicTacToeRowView(
      store: .init(
        initialState: .init(
          boundaries: .upper,
          player: .x
        ),
        reducer: TicTacToeRow()
      )
    )
    .padding()
  }
}

extension Player {
  var systemName: String {
    switch self {
    case .x:
      return "xmark"
    case .o:
      return "circle"
    }
  }
  
  var color: Color {
    switch self {
    case .o:
      return .red
    case .x:
      return .blue
    }
  }
}

extension Boundaries {
    func lines(with size: CGSize) -> [CGPoint] {
        switch self {
        case .upperLeft:
            return [
                CGPoint(x: size.width, y: -5),
                CGPoint(x: size.width, y: size.height),
                CGPoint(x: 0, y: size.height)
            ]
        case .upper:
            return [
                CGPoint(x: size.width, y: -5),
                CGPoint(x: size.width, y: size.height),
                CGPoint(x: 0, y: size.height),
                CGPoint(x: 0, y: -5)
            ]
        case .upperRight:
            return [
                CGPoint(x: size.width, y: size.height),
                CGPoint(x: 0, y: size.height),
                CGPoint(x: 0, y: -5)
            ]
        case .left:
            return [
                CGPoint(x: 0, y: 0),
                CGPoint(x: size.width, y: 0),
                CGPoint(x: size.width, y: size.height),
                CGPoint(x: 0, y: size.height)
            ]
        case .center:
            return [
                CGPoint(x: 0, y: 0),
                CGPoint(x: size.width, y: 0),
                CGPoint(x: size.width, y: size.height),
                CGPoint(x: 0, y: size.height),
                CGPoint(x: 0, y: -5)
            ]
        case .right:
            return [
                CGPoint(x: size.width, y: size.height),
                CGPoint(x: 0, y: size.height),
                CGPoint(x: 0, y: -5),
                CGPoint(x: 0, y: 0),
                CGPoint(x: size.width, y: 0),
            ]
        case .bottomLeft:
            return [
                CGPoint(x: 0, y: 0),
                CGPoint(x: size.width, y: 0),
                CGPoint(x: size.width, y: size.height)
            ]
        case .bottom:
            return [
                CGPoint(x: 0, y: size.height),
                CGPoint(x: 0, y: -5),
                CGPoint(x: 0, y: 0),
                CGPoint(x: size.width, y: 0),
                CGPoint(x: size.width, y: size.height)
            ]
        case .bottomRight:
            return [
                CGPoint(x: 0, y: size.height),
                CGPoint(x: 0, y: -5),
                CGPoint(x: 0, y: 0),
                CGPoint(x: size.width, y: 0)
            ]
        }
    }
}
