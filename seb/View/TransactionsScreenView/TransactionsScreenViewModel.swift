import Foundation
import Combine

extension TransactionsScreenView {
    typealias ViewModel = AnyViewModel<Self.ViewState, Self.ViewInput>
    
    // MARK: - State
    
    struct ViewState {
        var transactions: [Transaction]?
        var isLoading = false
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
    var paymentService: PaymentService { fatalError(.notImplemented) }
    
    init() {
        super.init(state: .init())
    }
    
    func loadTransactions() {
        paymentService.listTransactions()
            .handleEvents(
                receiveSubscription: { [weak self] _ in self?.state.isLoading = true },
                receiveCompletion: { [weak self] _ in self?.state.isLoading = false })
            .sinkResult { [weak self] result in
                switch result {
                case let .success(transactions):
                    self?.state.transactions = transactions
                    
                case let .failure(error):
                    Logger.log(error)
                }
            }
            .store(in: &cancelables)
    }
    
    override func trigger(
        _ input: Input
    ) {
        switch input {
        case .logout:
            authService.logout()
            
        case .loadTransactions:
            loadTransactions()
        }
    }
    
}

// MARK: - ViewModelImpl

final class TransactionsScreenViewModelImpl: TransactionsScreenViewModelBase {
    
    override var authService: AuthService {
        AuthServiceImpl.shared
    }
    
    override var paymentService: PaymentService {
        PaymentServiceImpl.shared
    }
}

// MARK: - ViewModelFake

final class TransactionsScreenViewModelFake: TransactionsScreenViewModelBase {
    
    override var authService: AuthService {
        AuthServiceFake.shared
    }
    
    override var paymentService: PaymentService {
        PaymentServiceFake.shared
    }
}
