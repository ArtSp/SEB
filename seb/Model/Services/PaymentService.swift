import Foundation
import Combine

// MARK: - PaymentService

protocol PaymentService: CancelableStore {
    func listTransactions() -> AnyPublisher<[Transaction], Error>
}

// MARK: - PaymentServiceImpl

final class PaymentServiceImpl: PaymentService {
    
    static let shared: PaymentServiceImpl = .init()
    private init() {}
    
    func listTransactions() -> AnyPublisher<[Transaction], Error> {
        API.transactions
            .tryMap { items in try items.map { try $0.toDomain() } }
            .eraseToAnyPublisher()
    }
}

// MARK: - PaymentServiceFake

final class PaymentServiceFake: PaymentService {
    
    static let shared: PaymentServiceFake = .init()
    private init() {}
    
    func listTransactions() -> AnyPublisher<[Transaction], Error> {
        Publishers.FakeRequest()
            .map { Transaction.fakes }
            .eraseToAnyPublisher()
    }
}
