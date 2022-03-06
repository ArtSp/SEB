import Foundation
import Combine

extension PinScreenView {
    typealias ViewModel = AnyViewModel<Self.ViewState, Self.ViewInput>
    
    // MARK: - State
    
    struct ViewState: Identifiable {
        let id = UUID()
        var pin = ""
        var requiredPinCount = 4
        var isLoading = false
    }
    
    // MARK: - Input
    
    enum ViewInput {
        case didInput(Int)
    }
}

// MARK: - ViewModelBase

class PinScreenViewModelBase: ViewModelBase<PinScreenView.ViewState, PinScreenView.ViewInput> {
    
    var authService: AuthService { fatalError(.notImplemented) }
    
    init() {
        super.init(state: .init())
    }
    
    func login() {
        guard !state.isLoading else { return }
        authService.login(pin: state.pin)
            .handleEvents(
                receiveSubscription: { [weak self] _ in self?.state.isLoading = true },
                receiveCompletion: { [weak self] _ in self?.state.isLoading = false })
            .sinkResult { [weak self] result in
                self?.state.pin.removeAll()
                
                switch result {
                case .success: break
                case let .failure(error): Logger.log(error)
                }
            }
            .store(in: &cancelables)
    }
    
    override func trigger(
        _ input: Input
    ) {
        switch input {
        case let .didInput(pin):
            state.pin += "\(pin)"
            if state.pin.count == state.requiredPinCount {
                login()
            }
        }
    }
    
}

// MARK: - ViewModelImpl

final class PinScreenViewModelImpl: PinScreenViewModelBase {
    
    override var authService: AuthService {
        AuthServiceImpl.shared
    }
}

// MARK: - ViewModelFake

final class PinScreenViewModelFake: PinScreenViewModelBase {
        
    override var authService: AuthService {
        AuthServiceFake.shared
    }
}
