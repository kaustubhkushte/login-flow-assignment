import SwiftUI

struct AuthGradientBackground: View {
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [AppColors.gradientTop, AppColors.gradientBottom],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            Circle()
                .fill(.white.opacity(0.06))
                .frame(width: 360, height: 360)
                .offset(x: -120, y: 120)

            RoundedRectangle(cornerRadius: 120)
                .fill(.white.opacity(0.04))
                .frame(width: 280, height: 360)
                .rotationEffect(.degrees(18))
                .offset(x: 150, y: 150)
        }
    }
}
