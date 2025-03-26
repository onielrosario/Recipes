import UIKit

class MockUseCase: ImageUseCaseProtocol {
    
    let expectedImage: UIImage
    
    init(expectedImage: UIImage) {
        self.expectedImage = expectedImage
    }
    
    func fetchImage(for urlString: String) async throws -> UIImage {
        return expectedImage
    }
    func storeImage(_ image: UIImage, for urlString: String) async {}
    
    func removeImage(for urlString: String) async {}
}
