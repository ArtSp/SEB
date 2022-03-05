import SwiftUI

public struct TextStyle {
    
    public var font: Font
    
    public init(
        _ font: Font
    ) {
        self.font = font
    }
}

extension TextStyle {
    
    static let body: TextStyle = .init(.body)
    static let caption: TextStyle = .init(.caption)
    static let headline: TextStyle = .init(.headline)
}
