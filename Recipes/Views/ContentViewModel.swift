import SwiftUI

@MainActor
protocol ContentViewModelProtocol: AnyObject {
    func loadRecipes(dataType: EndpointDataType?) async
    var isLoading: Bool { get }
}

enum RecipeLoadError: Error, Equatable {
    case malformedData
    case noRecipes

    var userMessage: String {
        switch self {
        case .malformedData:
            return "Oh no! Recipes are malformed!"
        case .noRecipes:
            return "Sorry! No recipes available :("
        }
    }
}

@MainActor
final class ContentViewModel: ObservableObject, ContentViewModelProtocol {
    
    @Published var recipes: [Recipe] = []
    @Published var errorMessage: RecipeLoadError?
    private var selectedEndpoint: EndpointDataType = .allRecipes
    
    private let recipeClient: RecipeClientProtocol
    
    var isLoading: Bool = false
    
    
    init(recipeClient: RecipeClientProtocol = RecipeClient()) {
        self.recipeClient = recipeClient
    }
    
    
    func loadRecipes(dataType: EndpointDataType? = nil) async {
        guard isLoading == false else { return }
        let endpoint = dataType ?? selectedEndpoint
        
        isLoading = true
        
        defer { isLoading = false }
        
        do {
            let allRecipes = try await recipeClient.fetchRecipes(from: endpoint)
            
            if allRecipes.isEmpty {
                errorMessage = RecipeLoadError.noRecipes
            }
            else {
                errorMessage = nil
                recipes = allRecipes
            }
        }
        catch {
            errorMessage = RecipeLoadError.malformedData
        }
    }
}
