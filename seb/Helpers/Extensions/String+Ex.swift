import Foundation

extension String {
    static let notImplemented = "Not Implemented!"
}

extension String: LocalizedError {
    public var errorDescription: String? { self }
}
