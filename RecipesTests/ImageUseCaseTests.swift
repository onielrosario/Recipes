import Testing
import UIKit
@testable import Recipes

struct ImageUseCaseTests {
    
    @Test func test_fetchImage_returnsFromCache() async throws {
        let mockImage = UIImage(systemName: "checkmark")!
        let mockCache = MockImageCache()
        await mockCache.store(image: mockImage, forKey: "test_key")

        let useCase = ImageUseCase(cache: mockCache, downloader: MockImageDownloader(image: UIImage(systemName: "photo")!))

        let result = try #require(await useCase.fetchImage(for: "https://example.com/test"))
        
        #expect(result.pngData() == mockImage.pngData())
    }

    @Test func test_fetchImage_downloadsIfNotCached() async throws {
        let mockImage = UIImage(systemName: "photo")!
        let mockCache = MockImageCache()
        let downloader = MockImageDownloader(image: mockImage)
        let useCase = ImageUseCase(cache: mockCache, downloader: downloader)

        let result = try #require(await useCase.fetchImage(for: "https://example.com/test"))
        #expect(result.pngData() == mockImage.pngData())
        #expect(mockCache.storeCallCount == 1)
    }
}
