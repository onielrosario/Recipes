import SwiftUI

struct RecipeListView: View {
    
    var recipes: [Recipe]
    
    var body: some View {
        List(recipes, id: \.uuid) { recipe in
            HStack {
                CacheImageView(viewModel: CacheImageViewModel(urlString: recipe.photoUrlLarge,
                                                              recipeName: recipe.name))
                    .frame(width: 100)
                    .cornerRadius(8)
                VStack(alignment: .leading) {
                    Text(recipe.name)
                        .font(.headline)
                    Text(recipe.cuisine)
                }
            }
        }
    }
}

#Preview {
    RecipeListView(recipes: [])
}
