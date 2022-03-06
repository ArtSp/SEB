import SwiftUI

enum SceneRouter {
    
    static var useSimulatedMode = false
    
    /// Create the SwiftUI view that provides the window contents.
    @ViewBuilder
    private static var appContentView: some View {
        if Self.useSimulatedMode {
            CoreScreenView(viewModel: CoreScreenViewModelFake().toAnyViewModel())
        } else {
            CoreScreenView(viewModel: CoreScreenViewModelImpl().toAnyViewModel())
        }
    }
    
    static var window: UIWindow? {
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            if let sceneDelegate = scene.delegate as? SceneDelegate {
                let window = UIWindow(windowScene: scene)
                window.overrideUserInterfaceStyle = .light
                sceneDelegate.window = window
                window.makeKeyAndVisible()
                return window
            }
        }
        return nil
    }
    
    /// Asigns view to rootViewController
    static func show<Content: View>(
        content: Content
    ) {
        window?.rootViewController = UIHostingController(rootView: content)
    }
    
    /// Asigns current app contentView to rootViewController
    static func showAppContent() {
        show(content: appContentView)
    }
}
