import UIKit

enum ImageUseCaseError: Error {
    case invalidURL
    case downloadFailed(underlying: Error)
}

protocol ImageUseCaseProtocol {
    func fetchImage(for urlString: String) async throws -> UIImage
    func storeImage(_ image: UIImage, for urlString: String) async
    func removeImage(for urlString: String) async
}


final class ImageUseCase: ImageUseCaseProtocol {
    private let cache: ImageCacheProtocol
    private let downloader: ImageDownloaderProtocol
    
    init(cache: ImageCacheProtocol = ImageCacheActor(),
        downloader: ImageDownloaderProtocol = ImageDownloader()) {
        self.cache = cache
        self.downloader = downloader
    }

    func fetchImage(for urlString: String) async throws -> UIImage {
        let key = sanitize(urlString)
        
        if let cached = await cache.retrieve(forKey: key) {
            return cached
        }

        guard let url = URL(string: urlString) else {
            throw ImageUseCaseError.invalidURL
        }

        do {
            let image = try await downloader.downloadImage(from: url)
            await cache.store(image: image, forKey: key)
            return image
        } catch {
            throw ImageUseCaseError.downloadFailed(underlying: error)
        }
    }

    func storeImage(_ image: UIImage, for urlString: String) async {
        let key = sanitize(urlString)
        await cache.store(image: image, forKey: key)
    }

    /// Removes an image from memory and disk cache. Not used yet, but exposed for future features like manual cache invalidation or testing.
    func removeImage(for urlString: String) async {
        let key = sanitize(urlString)
        await cache.remove(forKey: key)
    }

    private func sanitize(_ url: String) -> String {
        return url.replacingOccurrences(of: "/", with: "_")
    }
}

