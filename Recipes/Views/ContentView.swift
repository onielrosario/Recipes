import SwiftUI

struct ContentView: View {
    @StateObject var viewModel: ContentViewModel
    
    init(viewModelFactory: @escaping () -> ContentViewModel) {
        _viewModel = StateObject(wrappedValue: viewModelFactory())
    }
    
    var body: some View {
        NavigationStack {
            Group {
                if let error = viewModel.errorMessage {
                    ErrorMessageView(userMessage: error.userMessage,
                                     isLoading: viewModel.isLoading) {
                        Task {
                            await viewModel.loadRecipes()
                        }
                    }
                }
                else {
                    RecipeListView(recipes: viewModel.recipes)
                    .refreshable {
                        await viewModel.loadRecipes()
                    }
                    .task {
                        await viewModel.loadRecipes()
                    }
                }
            }
            .navigationTitle("Recipes")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Menu {
                        ForEach(EndpointDataType.allCases, id: \.self) { type in
                            Button(type.displayName) {
                                Task {
                                    await viewModel.loadRecipes(dataType: type)
                                }
                            }
                        }
                    } label: {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView(viewModelFactory: {
        ContentViewModel()
    })
}
