import Foundation
import Combine

/**
 User default property wrapper
 
 If accessing just getter / setter use as simple property.
 In case you need to access get and set at the same time, use mutate function.
 
 An example of usage
 ````
    struct MyStruct {
        @UserDefault("Example")
        var x: Int = 0
 
        mutating func incrementNoneAtomic() {
            x += 1 // ❌ This is not atomic
        }
 
        mutating func incrementAtomic() {
            $x.mutate { $0 += 1 } // ✅ Atomic operation
        }
    }
 ````
 */
@propertyWrapper
public final class UserDefault<Value: Codable> {
    private let queue = DispatchQueue(label: "atomicUserDefault")
    private let key: String
    private let defaultValue: Value
    private var container: UserDefaults
    private lazy var valueSubject = CurrentValueSubject<Value, Never>(value)
    
    private var value: Value {
        get { decodeValue() }
        set { encodeValue(newValue) }
    }
    
    public var wrappedValue: Value {
        get { queue.sync { value } }
        set { queue.sync { value = newValue } }
    }
    
    public func mutate(
        _ mutation: (inout Value) -> Void
    ) {
        queue.sync { mutation(&value) }
    }
    
    /// Value publisher
    ///
    ///     let subscription = UserDefaults.$username.publisher.sink { username in
    ///         print("New username: \(username)")
    ///     }
    ///     UserDefaults.username = "Test"
    ///     // Prints "New username: Test"
    ///
    public var publisher: AnyPublisher<Value, Never> {
        valueSubject.eraseToAnyPublisher()
    }
    
    public var projectedValue: UserDefault<Value> {
        self
    }
    
    public init(
        wrappedValue: Value,
        _ key: String,
        container: UserDefaults = .standard
    ) {
        self.key = key
        self.defaultValue = wrappedValue
        self.container = container
    }
    
    private func decodeValue() -> Value {
        guard let data = container.data(forKey: key) else { return defaultValue }
        let value = try? JSONDecoder().decode(Value.self, from: data)
        return value ?? defaultValue
    }
    
    private func encodeValue(
        _ newValue: Value
    ) {
        if let optional = newValue as? AnyOptional, optional.isNil {
            container.removeObject(forKey: key)
        } else {
            let data = try? JSONEncoder().encode(newValue)
           container.setValue(data, forKey: key)
        }
        valueSubject.send(newValue)
    }

}

public extension UserDefault where Value: ExpressibleByNilLiteral {
    convenience init(
        _ key: String,
        container: UserDefaults = .standard
    ) {
        self.init(wrappedValue: nil, key, container: container)
    }
}

public protocol AnyOptional {
    var isNil: Bool { get }
}

extension Optional: AnyOptional {
    public var isNil: Bool { self == nil }
}

public extension Optional where Wrapped: Collection {
    var isEmptyOrNil: Bool { self?.isEmpty ?? true }
}

