import Foundation

protocol RecipeClientProtocol {
    func fetchRecipes(from type: EndpointDataType) async throws -> [Recipe]
}

enum RecipeFetchError: Error, Equatable {
    case badResponse
    case badDecoding
    case badUrl
}

actor RecipeClient: RecipeClientProtocol {
    private let baseUrl = "https://d3jbb8n5wk0qxi.cloudfront.net/"
    private let session: URLSessionProtocol
    
    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }
    
    func fetchRecipes(from type: EndpointDataType) async throws -> [Recipe] {
        guard let url = URL(string: baseUrl + type.rawValue + ".json") else {
            throw RecipeFetchError.badUrl
        }
        
        let session = self.session
        let (data, response) = try await session.data(from: url)
        
        guard let response = response as? HTTPURLResponse,
              response.statusCode == 200 else {
            throw RecipeFetchError.badResponse
        }
        
        do {
            return try JSONDecoder().decode(RecipeModel.self, from: data).recipes
        }
        catch {
            throw RecipeFetchError.badDecoding
        }
    }
}

