import SwiftUI

struct CacheImageView: View {
    @StateObject var viewModel: CacheImageViewModel
    
    init(viewModel: @autoclosure @escaping () -> CacheImageViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel())
    }
    
    var body: some View {
        ZStack {
            if let image = viewModel.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .transition(.opacity)
                    .animation(.easeInOut(duration: 0.3), value: viewModel.image)
                    .accessibilityLabel(viewModel.recipeName)
            }
            else if viewModel.isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            else {
                Image(uiImage: viewModel.placeholder)
            }
        }
        .onAppear {
            Task {
                await viewModel.loadImage()
            }
        }
    }
}

#Preview {
    CacheImageView(viewModel: CacheImageViewModel(urlString: "", recipeName: ""))
}
