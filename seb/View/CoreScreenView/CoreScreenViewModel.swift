import Foundation
import Combine

extension CoreScreenView {
    typealias ViewModel = AnyViewModel<Self.ViewState, Self.ViewInput>
    
    // MARK: - State
    
    struct ViewState {
        var isLoggedIn = false
        var pinScreenViewModel: PinScreenView.ViewModel?
        var transactionsScreenViewModel: TransactionsScreenView.ViewModel?
    }
    
    // MARK: - Input
    
    typealias ViewInput = Never
}

// MARK: - ViewModelBase

class CoreScreenViewModelBase: ViewModelBase<CoreScreenView.ViewState, CoreScreenView.ViewInput> {
    
    var authService: AuthService { fatalError(.notImplemented) }
    func createPinScreenViewModel() -> PinScreenView.ViewModel? { fatalError(.notImplemented) }
    func createTransactionsScreenViewModel() -> TransactionsScreenView.ViewModel? { fatalError(.notImplemented) }
    
    init() {
        super.init(state: .init())
    }
    
    override var bindings: [AnyCancellable] {
        [
            authService.isLoggedInPublisher
                .removeDuplicates()
                .sink(receiveValue: { [weak self] isLoggedIn in
                    self?.setScreen(isLoggedIn: isLoggedIn)
                })
        ]
    }
    
    private func setScreen(
        isLoggedIn: Bool
    ) {
        state.pinScreenViewModel = isLoggedIn ? nil : createPinScreenViewModel()
        state.transactionsScreenViewModel = isLoggedIn ? createTransactionsScreenViewModel() : nil
    }
    
}

// MARK: - ViewModelImpl

final class CoreScreenViewModelImpl: CoreScreenViewModelBase {
    
    override var authService: AuthService {
        AuthServiceImpl.shared
    }
    
    override func createPinScreenViewModel() -> PinScreenView.ViewModel? {
        PinScreenViewModelImpl().toAnyViewModel()
    }
    
    override func createTransactionsScreenViewModel() -> TransactionsScreenView.ViewModel? {
        TransactionsScreenViewModelImpl().toAnyViewModel()
    }
    
}

// MARK: - ViewModelFake

final class CoreScreenViewModelFake: CoreScreenViewModelBase {
    
    override var authService: AuthService {
        AuthServiceFake.shared
    }
    
    override func createPinScreenViewModel() -> PinScreenView.ViewModel? {
        PinScreenViewModelFake().toAnyViewModel()
    }
    
    override func createTransactionsScreenViewModel() -> TransactionsScreenView.ViewModel? {
        TransactionsScreenViewModelFake().toAnyViewModel()
    }
    
}
