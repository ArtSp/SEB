import Combine

public protocol ViewModel: ObservableObject, CancelableStore where ObjectWillChangePublisher.Output == Void {
    associatedtype State
    associatedtype Input // If there are no events, just use `Never`

    var state: State { get set }
    func trigger(_ input: Input)
}

public extension ViewModel {
    func toAnyViewModel() -> AnyViewModel<State, Input> {
        AnyViewModel(self)
    }
}

extension AnyViewModel: Identifiable where State: Identifiable {
    public var id: State.ID {
        state.id
    }
}

@dynamicMemberLookup
public final class AnyViewModel<State, Input>: ViewModel {

    private let wrappedObjectWillChange: () -> AnyPublisher<Void, Never>
    private let wrappedTrigger: (Input) -> Void
    private let wrappedStateGetter: () -> State
    private let wrappedStateSetter: (State) -> Void

    public var objectWillChange: AnyPublisher<Void, Never> {
        wrappedObjectWillChange()
    }

    public var state: State {
        get { wrappedStateGetter() }
        set { wrappedStateSetter(newValue) }
    }

    public func trigger(
        _ input: Input
    ) {
        wrappedTrigger(input)
    }

    public subscript<Value>(
        dynamicMember keyPath: KeyPath<State, Value>
    ) -> Value {
        state[keyPath: keyPath]
    }

    public init<V: ViewModel>(
        _ viewModel: V
    ) where V.State == State, V.Input == Input {
        self.wrappedObjectWillChange = { viewModel.objectWillChange.eraseToAnyPublisher() }
        self.wrappedTrigger = viewModel.trigger
        self.wrappedStateGetter = { viewModel.state }
        self.wrappedStateSetter = { state in viewModel.state = state }
    }

}

