import SwiftUI

struct BearView: View {
    @StateObject private var viewModel = BearViewModel()
    
    var body: some View {
        VStack(spacing: 30) {
            Text("Pogłaszcz misia Ślężysława")
                .font(.largeTitle)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .padding(.top)
            
            ZStack {
                Circle()
                    .fill(Color.brown.opacity(0.3))
                    .frame(width: 220, height: 220)
                
                Text("🧸")
                    .font(.system(size: 150))
            }
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { _ in
                        viewModel.handleStroking()
                    }
                    .onEnded { _ in
                        viewModel.resetInterruption()
                    }
            )
            
            VStack(spacing: 10) {
                ProgressView(value: viewModel.bear.progress)
                    .progressViewStyle(.linear)
                    .tint(.green)
                    .padding(.horizontal, 40)
                    .scaleEffect(x: 1, y: 2, anchor: .center)
                
                Text("\(Int(viewModel.bear.progress * 100))%")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            if viewModel.bear.isRewardAvailable {
                Button(action: {
                }) {
                    Text("Nagroda od Ślężysława")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                .padding(.horizontal, 40)
                .transition(.scale.combined(with: .opacity))
            } else {
                Spacer()
                    .frame(height: 50)
            }
            
            Spacer()
        }
        .padding()
        .animation(.easeInOut, value: viewModel.bear.isRewardAvailable)
    }
}

#Preview {
    BearView()
}
