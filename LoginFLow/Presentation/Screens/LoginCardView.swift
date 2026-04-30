import SwiftUI

struct LoginCardView: View {
    @StateObject var viewModel: LoginViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            VStack(alignment: .leading, spacing: 6) {
                Text("Welcome Back,")
                    .font(.headline)
                    .foregroundStyle(.white.opacity(0.9))
                Text("Log In!")
                    .font(.system(size: 34, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
            }
            .padding(24)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                ZStack(alignment: .topTrailing) {
                    LinearGradient(
                        colors: [AppColors.accentDark, AppColors.accent],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    Circle()
                        .fill(.white)
                        .frame(width: 82, height: 82)
                        .offset(x: 36, y: -36)
                        .opacity(0.96)
                }
            )
            .clipShape(RoundedRectangle(cornerRadius: 26, style: .continuous))

            VStack(spacing: 16) {
                if let generalError = viewModel.generalError {
                    ErrorBanner(message: generalError)
                }

                AuthTextField(
                    title: "Email Address",
                    placeholder: "jacob@gmail.com",
                    text: $viewModel.email,
                    error: viewModel.fieldErrors["email"]
                )

                AuthSecureField(
                    title: "Password",
                    placeholder: "Enter password",
                    text: $viewModel.password,
                    error: viewModel.fieldErrors["password"]
                )

                HStack {
                    Toggle("Remember me", isOn: $viewModel.rememberMe)
                        .toggleStyle(.switch)
                        .font(.footnote)
                        .foregroundStyle(AppColors.mutedText)

                    Spacer()

                    Text("Secure login")
                        .font(.footnote)
                        .foregroundStyle(AppColors.mutedText)
                }

                PrimaryActionButton(title: "Log in", isLoading: viewModel.isLoading) {
                    Task {
                        await viewModel.login()
                    }
                }
                .disabled(viewModel.isLoading)
                .opacity(viewModel.isLoading ? 0.8 : 1)
            }
            .padding(.horizontal, 22)
            .padding(.bottom, 26)
        }
        .frame(maxWidth: .infinity)
        .background(AppColors.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
        .shadow(color: .black.opacity(0.12), radius: 24, x: 0, y: 16)
    }
}
