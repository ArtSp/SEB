import SwiftUI

public struct GridStack<Content: View>: View {
    public typealias Section = Int
    public typealias Item = Int
    
    let rows: Int
    let sections: Int
    let spacing: CGFloat?
    let content: (Item, Section) -> Content
    
    public init(
        rows: Int,
        sections: Int,
        spacing: CGFloat? = nil,
        @ViewBuilder content: @escaping (Item, Section) -> Content
    ) {
        self.rows = rows
        self.sections = sections
        self.spacing = spacing
        self.content = content
    }
    
    public var body: some View {
        HStack(alignment: .center, spacing: spacing) {
            ForEach(0..<rows, id: \.self) { row in
                VStack(alignment: .center, spacing: spacing) {
                    ForEach(0..<sections, id: \.self) { section in
                        content(row, section)
                    }
                }
            }
        }
    }
}
