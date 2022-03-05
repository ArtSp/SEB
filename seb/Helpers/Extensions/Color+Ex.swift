import SwiftUI

extension Color {
    static let sebPrimary: Color = .init( #colorLiteral(red: 0.3749371469, green: 0.8029767275, blue: 0.09275915474, alpha: 1) )
    static let sebSecondary: Color = .init( #colorLiteral(red: 0, green: 0.572435379, blue: 0.883582592, alpha: 1) )
    static let sebGray: Color = .init( #colorLiteral(red: 0.5109832883, green: 0.5109832883, blue: 0.5109832883, alpha: 1) )
    static let sebWhite: Color = .init( #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) )
    static let sebBackground: Color = .init( #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1) )
    static let sebShimmer: Color = .init(hex: "#C5C5C5")
    static let sebShimmerBackground: Color = .init(hex: "#F3F3F3")
    
    @available(iOS 14.0, *)
    var uiColor: UIColor { UIColor(self) }
    
    init(
        hex: String
    ) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
