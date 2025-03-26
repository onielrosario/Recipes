import SwiftUI

struct ErrorMessageView: View {
    
    var userMessage: String
    var isLoading: Bool
    var onTap: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            Text(userMessage)
            Button("Try Again") {
                onTap()
            }
            .disabled(isLoading)
        }
    }
}

#Preview {
    ErrorMessageView(userMessage: "Oops",
                     isLoading: true,
                     onTap: {})
}
