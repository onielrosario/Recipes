import UIKit

protocol ImageDownloaderProtocol {
    func downloadImage(from url: URL) async throws -> UIImage
}

actor ImageDownloader: ImageDownloaderProtocol {
    func downloadImage(from url: URL) async throws -> UIImage {
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let image = UIImage(data: data),
              let response = response as? HTTPURLResponse,
              response.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        return image
    }
}
