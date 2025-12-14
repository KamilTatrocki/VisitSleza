import SwiftUI

struct StartView: View {
    // Binding to the selected tab in ContentView
    @Binding var selectedTab: Int

    var body: some View {
        // NavigationStack not needed if we switch tabs instead of pushing
        VStack {
            // Top content
            VStack(spacing: 16) {
                Text("Official Visit Sleza App")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)

                Button {
                    // Switch to Map tab (tag 1)
                    selectedTab = 1
                } label: {
                    Text("Discover Ślęża")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                .padding(.horizontal)
            }
            .padding(.top, 32)

            Spacer()

            // Bottom image, full width
            Image("sleza")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity)
                .clipped()
        }
        .safeAreaPadding(.bottom)
    }
}

#Preview {
    // Provide a constant for preview
    StartView(selectedTab: .constant(0))
}
