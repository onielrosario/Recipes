import Foundation
import Testing
@testable import Recipes

struct RecipeClientTests {
    @Test func test_fetchRecipes_successfullyParsesJSON() async throws {
        let mockJSON = """
        {
            "recipes": [
                {
                    "uuid": "1234",
                    "name": "Test Recipe",
                    "cuisine": "Italian",
                    "photo_url_large": "https://example.com/large.jpg",
                    "photo_url_small": "https://example.com/small.jpg",
                    "source_url": "https://example.com",
                    "youtube_url": "https://youtube.com"
                }
            ]
        }
        """.data(using: .utf8)!
        
        let mockSession = URLSessionMock(data: mockJSON, responseCode: 200)
        let client = RecipeClient(session: mockSession)
        
        let recipes = try #require(await client.fetchRecipes(from: .allRecipes))
        
        #expect(recipes.count == 1)
        #expect(recipes.first?.name == "Test Recipe")
        #expect(recipes.first?.cuisine == "Italian")
        #expect(recipes.first?.uuid == "1234")
        #expect(recipes.first?.photoUrlLarge == "https://example.com/large.jpg")
        #expect(recipes.first?.protoUrlSmall == "https://example.com/small.jpg")
        #expect(recipes.first?.sourceUrl == "https://example.com")
        #expect(recipes.first?.youtubeUrl == "https://youtube.com")
    }
    
    @Test func test_fetchRecipes_badResponse() async throws {
        let mockJSON = """
        {
        }
        """.data(using: .utf8)!
        
        let mockSession = URLSessionMock(data: mockJSON,
                                         responseCode: 400)
        let client = RecipeClient(session: mockSession)
        
        do {
            _ = try #require(await client.fetchRecipes(from: .allRecipes))
        }
        catch let error as RecipeFetchError {
            #expect(error == .badResponse)
        }
    }
    
    @Test func test_fetchRecipes_badDecoding() async throws {
        let mockJSON = """
        {}
        """.data(using: .utf8)!
        
        let mockSession = URLSessionMock(data: mockJSON,
                                         responseCode: 200)
        let client = RecipeClient(session: mockSession)
        
        do {
            _ = try #require(await client.fetchRecipes(from: .allRecipes))
        }
        catch let error as RecipeFetchError {
            #expect(error == .badDecoding)
        }
    }
}
