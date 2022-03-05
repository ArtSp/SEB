import SwiftUI

extension View {
    
    func shimmed(
        intensity: Double = 0.5,
        shimmerColor: Color = .sebShimmer,
        shimmerBackgroundColor: Color = .sebShimmerBackground,
        shimmerAnimationDuration: TimeInterval = 1.5,
        shimmerDelay: TimeInterval? = nil
    ) -> some View {
        modifier(
            Shimmer(
                intensity: intensity,
                shimmerColor: shimmerColor,
                shimmerBackgroundColor: shimmerBackgroundColor,
                shimmerAnimationDuration: shimmerAnimationDuration,
                shimmerDelay: shimmerDelay
            )
        )
    }
}

fileprivate struct Shimmer: ViewModifier {
    
    @State private var show = false
    @State private var contentSize: CGSize = .zero
    @State private var animationStarted = false
    private let shimmableWidth = UIScreen.main.bounds.width + 100
    private let shimmerRotation = Angle(degrees: 20)
    private var shimmerSide: CGFloat { max(contentSize.width, contentSize.height) * 1.5 }
    private let intensity: Double
    private let shimmerColor: Color
    private let shimmerBackgroundColor: Color
    private let shimmerAnimationDuration: TimeInterval
    private let shimmerDelay: TimeInterval?
    
    public init(
        intensity: Double = 0.5,
        shimmerColor: Color,
        shimmerBackgroundColor: Color,
        shimmerAnimationDuration: TimeInterval = 1.5,
        shimmerDelay: TimeInterval? = nil
    ) {
        self.intensity = intensity
        self.shimmerColor = shimmerColor
        self.shimmerBackgroundColor = shimmerBackgroundColor
        self.shimmerAnimationDuration = shimmerAnimationDuration
        self.shimmerDelay = shimmerDelay
    }
    
    @ViewBuilder
    private func shimmer(
        for content: Content
    ) -> some View {
        Rectangle()
            .foregroundColor(shimmerColor)
            .frame(width: shimmerSide, height: shimmerSide)
            .mask(
                Rectangle()
                    .fill(
                        LinearGradient(gradient: .init(colors: [.clear, .clear, .black.opacity(intensity), .clear, .clear]),
                                       startPoint: .leading,
                                       endPoint: .trailing)
                    )
                    .rotationEffect(shimmerRotation)
                    .blur(radius: contentSize.width / 10)
                    .offset(x: show ? shimmableWidth : -shimmableWidth)
            )
            .frame(width: contentSize.width, height: contentSize.height)
            .flipsForRightToLeftLayoutDirection(true)
            .mask(content)
    }
    
    public func body(
        content: Content
    ) -> some View {
        ZStack {
            content
                .readSize { newSize in
                    self.contentSize = newSize
                }
            shimmer(for: content)
        }
        .foregroundColor(shimmerBackgroundColor)
        .onAppear {
            if !animationStarted {
                self.animationStarted.toggle()
                withAnimation(Animation.easeInOut(duration: shimmerAnimationDuration).repeatForever(autoreverses: false)) {
                    self.show.toggle()
                }
            }
        }
    }
}

