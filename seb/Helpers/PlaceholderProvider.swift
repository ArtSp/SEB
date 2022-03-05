import Foundation

protocol PlaceholderProvider {
    associatedtype Element
    static var placeholder: Element { get }
    static func placeholders(count: Int) -> [Element]
}

extension PlaceholderProvider {
    static func placeholders(
        count: Int
    ) -> [Element] {
        Array(repeating: true, count: count).map { _ in Self.placeholder }
    }
}
