import SwiftUI

@MainActor
final class CacheImageViewModel: ObservableObject {
    @Published var image: UIImage?
    @Published var isLoading = false
    
    let placeholder: UIImage
    let recipeName: String
    
    private let urlString: String
    private let useCase: ImageUseCaseProtocol
    
    init(urlString: String,
         recipeName: String,
         placeholder: UIImage = UIImage(systemName: "photo")!,
         useCase: ImageUseCaseProtocol = ImageUseCase()) {
        self.urlString = urlString
        self.recipeName = recipeName
        self.placeholder = placeholder
        self.useCase = useCase
    }
    
    func loadImage() async {
        guard image == nil,
        isLoading == false else { return }
        isLoading = true
        
        defer {
            isLoading = false
        }
        
        do {
            image = try await useCase.fetchImage(for: urlString)
        } catch {
            print("Image load error: \(error)")
        }
    }
}
