import SwiftUI

struct CoreScreenView: View {
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
        Color.sebWhite
            .fullScreenCover(item: $viewModel.state.pinScreenViewModel) { PinScreenView(viewModel: $0) }
            .fullScreenCover(item: $viewModel.state.transactionsScreenViewModel) { TransactionsScreenView(viewModel: $0) }
    }
}

// MARK: - Preview

struct CoreScreenView_Previews: PreviewProvider {
    static let viewModel = CoreScreenViewModelFake().toAnyViewModel()
    
    static var previews: some View {
        LocalePreview {
            CoreScreenView(viewModel: viewModel)
        }
    }
}
