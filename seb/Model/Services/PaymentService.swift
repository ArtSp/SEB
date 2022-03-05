import Foundation
import Combine

// MARK: - PaymentService

protocol PaymentService: CancelableStore {
    func listTransactions() -> AnyPublisher<[Transaction], Error>
}

// MARK: - PaymentServiceImpl

// TODO: Use API
typealias PaymentServiceImpl = PaymentServiceFake

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
