import Foundation
import Combine

enum API {
    typealias ID = UUID
    enum Model {}
    
    static let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        decoder.dateDecodingStrategy = .custom { decoder in
            let container = try decoder.singleValueContainer()
            let dateString = try container.decode(String.self)
            guard let date = formatter.date(from: dateString) else { throw "Invalid date format" }
            return date
        }
        return decoder
    }()
    
    static var transactions: AnyPublisher<[API.Model.Transaction], Error> {
        let url = URL(string: "https://sheet.best/api/sheets/ebb5bfdc-efda-4966-9ecf-d2c171d6985a")!
        return URLSession.shared.dataTaskPublisher(for: url)
          .map(\.data)
          .decode(type: [API.Model.Transaction].self, decoder: Self.decoder)
          .eraseToAnyPublisher()
    }
}


