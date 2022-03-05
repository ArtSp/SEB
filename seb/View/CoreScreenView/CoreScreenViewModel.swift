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
            
        ]
    }
    
}

// MARK: - ViewModelImpl

final class CoreScreenViewModelImpl: CoreScreenViewModelBase {
    
    override func createPinScreenViewModel() -> PinScreenView.ViewModel? {
        PinScreenViewModelImpl().toAnyViewModel()
    }
    
    override func createTransactionsScreenViewModel() -> TransactionsScreenView.ViewModel? {
        TransactionsScreenViewModelImpl().toAnyViewModel()
    }
    
}

// MARK: - ViewModelFake

final class CoreScreenViewModelFake: CoreScreenViewModelBase {
    
    override func createPinScreenViewModel() -> PinScreenView.ViewModel? {
        PinScreenViewModelFake().toAnyViewModel()
    }
    
    override func createTransactionsScreenViewModel() -> TransactionsScreenView.ViewModel? {
        TransactionsScreenViewModelFake().toAnyViewModel()
    }
    
}
