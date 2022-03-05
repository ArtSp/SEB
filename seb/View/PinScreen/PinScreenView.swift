import SwiftUI

struct PinScreenView: View {
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

// MARK: - Preview

struct PinScreenView_Previews: PreviewProvider {
    static let viewModel = PinScreenViewModelFake().toAnyViewModel()
    
    static var previews: some View {
        LocalePreview {
            PinScreenView(viewModel: viewModel)            
        }
    }
}
