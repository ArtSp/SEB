import Foundation

struct Transaction: Identifiable {
    let id: UUID
    let title: String
    let description: String?
    let date: Date
    let price: Price
}

// MARK: - Domain

// TODO:

// MARK: - Fakes

extension Transaction: PlaceholderProvider {
    
    static var placeholder: Self {
        .init(
            id: UUID(),
            title: "Title",
            description: "Description",
            date: Date(),
            price: 100.00
        )
    }
    
    static let fakes: [Self] = [
        .init(
            id: UUID(),
            title: "First",
            description: "First description",
            date: Date().addingTimeInterval(-10000),
            price: 10.23
        ),
        .init(
            id: UUID(),
            title: "Second",
            description: "Second description",
            date: Date().addingTimeInterval(-1000),
            price: 0.16
        ),
        .init(
            id: UUID(),
            title: "Third",
            description: nil,
            date: Date().addingTimeInterval(-1000),
            price: 7025.30
        ),
    ]
}
