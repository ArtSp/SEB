import Foundation
import Combine

// MARK: - AuthService

protocol AuthService: CancelableStore {
    var isLoggedInPublisher: AnyPublisher<Bool, Never> { get }
    func login(pin: String) -> AnyPublisher<Success, Error>
    func logout()
}

// MARK: - AuthServiceImpl

// Real auth manager not available, using fake instead
typealias AuthServiceImpl = AuthServiceFake

// MARK: - AuthServiceFake

final class AuthServiceFake: AuthService {
    
    @UserDefault("authToken")
    var authToken: String?

    static let shared: AuthServiceFake = .init()
    private init() {}
    
    var isLoggedInPublisher: AnyPublisher<Bool, Never> {
        $authToken.publisher
            .map { $0 != nil }
            .eraseToAnyPublisher()
    }
    
    func login(
        pin: String
    ) -> AnyPublisher<Success, Error> {
        Publishers.FakeRequest()
            .map { pin == "1234" }
            .handleEvents(receiveOutput: { [weak self] success in
                self?.authToken = success ? UUID().uuidString : nil
            })
            .eraseToAnyPublisher()
    }
    
    func logout() {
        authToken = nil
    }
    
}
