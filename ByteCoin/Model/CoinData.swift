import Foundation

struct CoinData: Codable {
    let asset_id_quote: String
    let time: String
    let asset_id_base: String
    let rate: Double
}
