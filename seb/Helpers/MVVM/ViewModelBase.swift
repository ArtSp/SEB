import Foundation
import Combine

class ViewModelBase<State, Input>: NSObject, ViewModel {
    
    @Published var state: State
    var bindings: [AnyCancellable] { [] }
    
    init(
        state: State
    ) {
        self.state = state
        super.init()
        bind()
    }
    
    final func bind() {
        bindings.forEach { $0.store(in: &cancelables) }
    }
    
    func trigger(
        _ input: Input
    ) {
        fatalError("Override!")
    }
}
