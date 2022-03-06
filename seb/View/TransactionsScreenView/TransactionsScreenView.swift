import SwiftUI

struct TransactionsScreenView: View {
    @ObservedObject var viewModel: ViewModel
    @Environment(\.locale) var locale
    
    var priceFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        formatter.numberStyle = .currency
        formatter.locale = locale
        formatter.currencyCode = Constants.currencyCode
        return formatter
    }
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = locale
        formatter.dateFormat = "d MMM, yyyy HH:mm"
        return formatter
    }
    
    func cell(
        for transaction: Transaction
    ) -> some View {
        HStack {
            VStack(alignment: .leading) {
                Text(transaction.title)
                Text(transaction.description ?? "")
                    .textStyle(.caption)
            }
            
            Spacer()
            
            VStack(alignment: .trailing) {
                Text(priceFormatter.string(from: NSNumber(value: transaction.price)) ?? "")
                    .foregroundColor(transaction.price > 0 ? .sebPrimary : .sebSecondary)
                Text(dateFormatter.string(from: transaction.date))
                    .textStyle(.caption)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.sebWhite)
        .cornerRadius(8)
    }
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical) {
                VStack {
                    Text("transactions_history")
                        .padding(.vertical)
                    
                    Unwrap(viewModel.transactions) { transactions in
                        LazyVStack(spacing: 16) {
                            ForEach(transactions) { transaction in
                                cell(for: transaction)
                            }
                        }
                    } fallbackContent: {
                        if viewModel.isLoading {
                            LazyVStack(spacing: 16) {
                                ForEach(Transaction.placeholders(count: 5)) { transaction in
                                    cell(for: transaction)
                                        .asPlaceholder()
                                }
                            }
                            .shimmed()
                        }
                    }
                    
                    Spacer()
                }
            }
            .padding(.horizontal)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.sebBackground)
            .textStyle(.body, color: .sebGray)
            .navigationTitle("transactions_navTitle")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: Button("common_logout") { viewModel.trigger(.logout) })
        }
        .onAppear {
            viewModel.trigger(.loadTransactions)
        }
    }
}

// MARK: - Preview

struct TransactionsScreenView_Previews: PreviewProvider {
    static let viewModel = TransactionsScreenViewModelFake().toAnyViewModel()
    
    static var previews: some View {
        LocalePreview {
            TransactionsScreenView(viewModel: viewModel)
        }
    }
}
