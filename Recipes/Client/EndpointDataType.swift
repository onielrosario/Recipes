import Foundation

enum EndpointDataType: String, CaseIterable {
    case allRecipes = "recipes"
    case malFormed = "recipes-malformed"
    case empty = "recipes-empty"
    
    var displayName: String {
        switch self {
        case .allRecipes: return "All Recipes"
        case .malFormed: return "Malformed"
        case .empty: return "Empty"
        }
    }
}
