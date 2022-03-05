import SwiftUI

struct CoreScreenView: View {
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
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
