import ComposableArchitecture
import SwiftUI
import AppFeature

@main
struct ClassicGamesApp: SwiftUI.App {
  var body: some Scene {
    WindowGroup {
      AppView(
        store: .init(
          initialState: .init(),
          reducer: App()
        )
      )
    }
  }
}

extension UINavigationController {
    open override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.navigationBar.topItem?.backButtonDisplayMode = .minimal
    }
}
