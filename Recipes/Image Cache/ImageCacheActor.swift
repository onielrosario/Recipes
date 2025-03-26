import UIKit

protocol ImageCacheProtocol: AnyObject {
    func store(image: UIImage, forKey key: String) async
    func retrieve(forKey key: String) async -> UIImage?
    func remove(forKey key: String) async
}

enum PathDirectory {
    static let imageCache: String = "ImageCache"
}

enum ImageCompression {
    static let defaultJPEGQuality: CGFloat = 0.8
}

actor ImageCacheActor: ImageCacheProtocol, @unchecked Sendable {
    private let memoryCache: NSCache<NSString, UIImage> = {
        return NSCache<NSString, UIImage>()
    }()
    
    private let fileManager: FileManager = .default
    private let cacheDirectory: URL
    
    init() {
        guard let path = fileManager.urls(for: .cachesDirectory,
                                           in: .userDomainMask).first else {
            fatalError("Could not initialize directory")
        }
        
        cacheDirectory = path.appendingPathComponent(PathDirectory.imageCache,
                                                         isDirectory: true)
        
        if self.fileManager.fileExists(atPath: cacheDirectory.path) == false {
            try? fileManager.createDirectory(at: cacheDirectory,
                                             withIntermediateDirectories: true,
                                             attributes: nil)
        }
    }
    
    func store(image: UIImage, forKey key: String) async {
        let fileURL = cacheDirectory.appendingPathComponent(key)
        
        memoryCache.setObject(image,
                              forKey: key as NSString)
        
        if let data = image.jpegData(compressionQuality: ImageCompression.defaultJPEGQuality) {
            try? data.write(to: fileURL)
        }
    }
    
    func retrieve(forKey key: String) async -> UIImage? {
        if let memoryImage = memoryCache.object(forKey: key as NSString) {
            return memoryImage
        }
        
        let fileURL = cacheDirectory.appendingPathComponent(key)
        if let diskImage = UIImage(contentsOfFile: fileURL.path) {
            memoryCache.setObject(diskImage, forKey: key as NSString)
            return diskImage
        }
        
        return nil
    }
    
    func remove(forKey key: String) async {
        memoryCache.removeObject(forKey: key as NSString)
        let fileURL = cacheDirectory.appendingPathComponent(key)
        try? fileManager.removeItem(at: fileURL)
    }
}

