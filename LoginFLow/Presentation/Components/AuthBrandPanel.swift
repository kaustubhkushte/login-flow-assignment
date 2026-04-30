import SwiftUI

struct AuthBrandPanel: View {
    let selectedMode: AuthMode
    let onModeChange: (AuthMode) -> Void

    var body: some View {
        VStack(spacing: 18) {
            Spacer()

            Image(systemName: "drop.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 68, height: 86)
                .foregroundStyle(
                    LinearGradient(
                        colors: [AppColors.gradientTop, AppColors.accent],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )

            Text("SentriNova")
                .font(.system(size: 24, weight: .bold, design: .rounded))
                .multilineTextAlignment(.center)
                .foregroundStyle(AppColors.accent)

            VStack(spacing: 6) {
                Text(selectedMode == .signup ? "Sign Up" : "Log In")
                    .font(.system(size: 34, weight: .bold, design: .rounded))
                Text(selectedMode == .signup ? "It's easier to sign up now" : "Welcome back to your account")
                    .foregroundStyle(AppColors.mutedText)
            }

            HStack(spacing: 12) {
                Button {
                    onModeChange(.login)
                } label: {
                    Text("Log In")
                        .fontWeight(.semibold)
                        .foregroundStyle(selectedMode == .login ? .white : AppColors.accent)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(selectedMode == .login ? AppColors.accent : .white)
                        .clipShape(Capsule())
                        .overlay {
                            Capsule()
                                .stroke(AppColors.accent.opacity(0.2), lineWidth: 1)
                        }
                }

                Button {
                    onModeChange(.signup)
                } label: {
                    Text("Sign Up")
                        .fontWeight(.semibold)
                        .foregroundStyle(selectedMode == .signup ? .white : AppColors.accent)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(selectedMode == .signup ? AppColors.accent : .white)
                        .clipShape(Capsule())
                        .overlay {
                            Capsule()
                                .stroke(AppColors.accent.opacity(0.2), lineWidth: 1)
                        }
                }
            }

            HStack(spacing: 16) {
                Image(systemName: "f.cursive.circle.fill")
                Image(systemName: "g.circle.fill")
                Image(systemName: "link.circle.fill")
            }
            .font(.title2)
            .foregroundStyle(AppColors.accent)

            Spacer()
        }
        .padding(28)
        .frame(maxWidth: 320)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
        .shadow(color: .black.opacity(0.08), radius: 28, x: 0, y: 12)
    }
}
