import Foundation

struct Recipe: Decodable {
    let cuisine: String
    let name: String
    let photoUrlLarge: String
    let protoUrlSmall: String
    let sourceUrl: String?
    let uuid: String
    let youtubeUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case photoUrlLarge = "photo_url_large"
        case protoUrlSmall = "photo_url_small"
        case sourceUrl = "source_url"
        case youtubeUrl = "youtube_url"
        
        case cuisine, name, uuid
    }
}

struct RecipeModel: Decodable {
    let recipes: [Recipe]
}
