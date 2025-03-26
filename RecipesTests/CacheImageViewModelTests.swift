@testable import Recipes
import Testing
import UIKit

struct CacheImageViewModelTests {

    @Test @MainActor func test_loadImage_setsImageAndStopsLoading() async {
        let expectedImage = UIImage(systemName: "star")!
        let expectedName = "image name"
        
        let mockUseCase = MockUseCase(expectedImage: expectedImage)
        
        let viewModel = CacheImageViewModel(urlString: "https://example.com",
                                            recipeName: expectedName,
                                            useCase: mockUseCase)
        
        #expect(viewModel.image == nil)

        await viewModel.loadImage()

        #expect(viewModel.image?.pngData() == expectedImage.pngData())
        #expect(viewModel.isLoading == false)
    }
}
