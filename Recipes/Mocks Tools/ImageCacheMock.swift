import UIKit

final class MockImageCache: ImageCacheProtocol {
    var storedImage: UIImage?
    var storeCallCount = 0
    
    func store(image: UIImage, forKey key: String) async {
        storedImage = image
        storeCallCount += 1
    }
    
    func retrieve(forKey key: String) async -> UIImage? {
        return storedImage
    }
    
    func remove(forKey key: String) async {
        storedImage = nil
    }
}

final class MockImageDownloader: ImageDownloaderProtocol {
    var imageToReturn: UIImage
    
    init(image: UIImage) {
        self.imageToReturn = image
    }
    
    func downloadImage(from url: URL) async throws -> UIImage {
        return imageToReturn
    }
}
