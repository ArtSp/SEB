import SwiftUI

extension View {
    
    /// Navigation view modifier
    ///
    /// Example:
    ///
    ///     @State private var nextScreenviewModel: ViewModel?
    ///
    ///     var body: some View {
    ///         Text("Example")
    ///         .navigation(item: $nextScreenviewModel) { NextScreenView(viewModel: $0) }
    ///     }
    ///
    func navigation<Item, Destination: View>(
        item: Binding<Item?>,
        @ViewBuilder destination: (Item) -> Destination
    ) -> some View {
        let isActive = Binding(
            get: { item.wrappedValue != nil },
            set: { value in if !value { item.wrappedValue = nil } }
        )
        return navigation(isActive: isActive) {
            item.wrappedValue.map(destination)
        }
    }
    
    /// Navigation view modifier
    ///
    /// Example:
    ///
    ///     @State private var isShowingView = false
    ///
    ///     var body: some View {
    ///         Text("Example")
    ///         .navigation(isActive: $isShowingView) { Text("Another screen") }
    ///     }
    ///
    func navigation<Destination: View>(
        isActive: Binding<Bool>,
        @ViewBuilder destination: () -> Destination
    ) -> some View {
        overlay(
            NavigationLink(
                destination: isActive.wrappedValue ? destination() : nil,
                isActive: isActive,
                label: { EmptyView() }
            )
        )
    }
    
    /// `if`statement view modifier
    ///
    /// Example:
    ///
    ///     var names: [String]
    ///
    ///     var body: some View {
    ///         Text("Example")
    ///         .if(names.count > 3) { $0.foregroundColor(.red) }
    ///     }
    ///
    @ViewBuilder
    func `if`<Transform: View>(
        _ condition: @autoclosure () -> Bool,
        @ViewBuilder transform: (Self) -> Transform
    ) -> some View {
        if condition() {
            transform(self)
        } else {
            self
        }
    }
    
    /// `if else`statement view modifier
    ///
    /// Example:
    ///
    ///     var names: [String]
    ///
    ///     var body: some View {
    ///         Text("Example")
    ///         .if(names.count > 3) {
    ///             $0.foregroundColor(.red)
    ///         } else: {
    ///             $0.underline()
    ///         }
    ///     }
    ///
    @ViewBuilder
    func `if`<Transform: View, Fallback: View>(
        _ condition: @autoclosure () -> Bool,
        @ViewBuilder transform: (Self) -> Transform,
        @ViewBuilder else fallbackTransform: (Self) -> Fallback
    ) -> some View {
        if condition() {
            transform(self)
        } else {
            fallbackTransform(self)
        }
    }
    
    /// `if let` statement view modifier
    ///
    /// Example:
    ///
    ///     var color: Color?
    ///
    ///     var body: some View {
    ///         Text("Example")
    ///         .if(let: color) { $0.foregroundColor($1) }
    ///     }
    ///
    @ViewBuilder
    func `if`<Transform: View, T> (
        `let` optional: T?,
        @ViewBuilder transform: (Self, T) -> Transform
    ) -> some View {
        if let optional = optional {
            transform(self, optional)
        } else {
            self
        }
    }
    
    /// `if let else` statement view modifier
    ///
    /// Example:
    ///
    ///     var color: Color?
    ///
    ///     var body: some View {
    ///         Text("Example")
    ///         .if(let: color) {
    ///             $0.foregroundColor($1)
    ///         } else: {
    ///             $0.underline()
    ///         }
    ///
    @ViewBuilder
    func `if`<Transform: View, Fallback: View, T> (
        `let` optional: T?,
        @ViewBuilder transform: (Self, T) -> Transform,
        @ViewBuilder else fallbackTransform: (Self) -> Fallback
    ) -> some View {
        if let optional = optional {
            transform(self, optional)
        } else {
            fallbackTransform(self)
        }
    }
    
    /// Font modifier
    @ViewBuilder
    func textStyle(
        _ style: TextStyle
    ) -> some View {
        self.font(style.font)
    }
    
    /// Font adn color modifier
    @ViewBuilder
    func textStyle(
        _ style: TextStyle,
        color: Color
    ) -> some View {
        self.font(style.font)
            .foregroundColor(color)
    }
    
    /// Hides or removes view
    @ViewBuilder
    func isHidden(
        _ hidden: Bool,
        removeWhenHidden: Bool = true
    ) -> some View {
        if !hidden {
            self
        } else if !removeWhenHidden {
            self.hidden()
        }
    }
    
    /// Sets self as placeholder
    @ViewBuilder
    func asPlaceholder() -> some View {
        self
            .isHidden(true, removeWhenHidden: false)
            .background(Placeholder())
    }
}
