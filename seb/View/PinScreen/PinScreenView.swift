import SwiftUI

struct PinScreenView: View {
    @ObservedObject var viewModel: ViewModel
    
    func buttonForDigit(
        digit: Int
    ) -> some View {
        Button(
            action: {
                viewModel.trigger(.didInput(digit))
            },
            label: {
                Text("\(digit)")
                    .textStyle(.headline, color: .sebWhite)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .aspectRatio(1, contentMode: .fit)
                    .background(RoundedRectangle(cornerRadius: 16).foregroundColor(.sebSecondary))
            }
        )
    }
    
    var body: some View {
        VStack {
            Spacer()
            // Pins
            HStack {
                ForEach(0..<viewModel.requiredPinCount) { idx in
                    let isFilled = viewModel.pin.count > idx
                    Circle()
                        .foregroundColor(isFilled ? .sebSecondary : .sebGray )
                        .frame(width: 15, height: 15)
                }
            }
            
            Spacer()
            
            // Buttons
            
            VStack(spacing: 16) {
                GridStack(rows: 3, sections: 3, spacing: 16) { item, section in
                    let idx = 3 * section + item + 1
                    buttonForDigit(digit: idx)
                }
                
                HStack {
                    buttonForDigit(digit: -1).isHidden(true, removeWhenHidden: false)
                    buttonForDigit(digit: 0)
                    buttonForDigit(digit: -1).isHidden(true, removeWhenHidden: false)
                }
            }
            .frame(maxWidth: 250)
            
            Text("common_pinTip")
                .textStyle(.caption, color: .sebGray)
                .padding()
        }
        .if(viewModel.isLoading) { view in
            view.shimmed()
        }
            
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
