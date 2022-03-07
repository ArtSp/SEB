import Foundation

struct Transaction: Identifiable {
    let id: Model.ID
    let title: String
    let description: String?
    let date: Date
    let price: Price
}

// MARK: - Domain

extension API.Model.Transaction {
    func toDomain() throws -> Transaction {
        guard let price = Price(amount) else { throw "Data type invalid" }
        return .init(
            id: id,
            title: description,
            description: counterPartyName,
            date: date,
            price: price
        )
    }
}

// MARK: - Fakes

extension Transaction: PlaceholderProvider {
    
    static var placeholder: Self {
        .init(
            id: .init(),
            title: "Title",
            description: "Description",
            date: Date(),
            price: 100.00
        )
    }
    
    static let fakes: [Self] = [
        .init(
            id: .init(),
            title: "First",
            description: "First description",
            date: Date().addingTimeInterval(-10000),
            price: 10.23
        ),
        .init(
            id: .init(),
            title: "Second",
            description: "Second description",
            date: Date().addingTimeInterval(-1000),
            price: 0.16
        ),
        .init(
            id: .init(),
            title: "Third",
            description: nil,
            date: Date().addingTimeInterval(-1000),
            price: 7025.30
        ),
    ]
}
