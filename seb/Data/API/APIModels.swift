import Foundation

extension API.Model {
    
    struct Transaction: Decodable {
        let id: API.ID
        let counterPartyName: String
        let counterPartyAccount: String
        let type: String
        let amount: String
        let description: String
        let date: Date
    }
    
}
