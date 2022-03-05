import Foundation
import Combine

extension TransactionsScreenView {
    typealias ViewModel = AnyViewModel<Self.ViewState, Self.ViewInput>
    
    // MARK: - State
    
    struct ViewState {
        var transactions: [Transaction]?
    }
    
    // MARK: - Input
    
    enum ViewInput {
        case loadTransactions
        case logout
    }
}

// MARK: - ViewModelBase

class TransactionsScreenViewModelBase: ViewModelBase<TransactionsScreenView.ViewState, TransactionsScreenView.ViewInput> {
    
    var authService: AuthService { fatalError(.notImplemented) }
    
    init() {
        super.init(state: .init())
    }
    
    override func trigger(
        _ input: Input
    ) {
        switch input {
        case .logout:
            authService.logout()
            
        case .loadTransactions:
            // TODO:
            break
        }
    }
    
}

// MARK: - ViewModelImpl

final class TransactionsScreenViewModelImpl: TransactionsScreenViewModelBase {
    
}

// MARK: - ViewModelFake

final class TransactionsScreenViewModelFake: TransactionsScreenViewModelBase {
    
}
