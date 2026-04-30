import SwiftUI

struct LoginCardView: View {
    @StateObject var viewModel: LoginViewModel
    let onShowSignUp: () -> Void
    let onForgotPassword: () -> Void

    var body: some View {
        VStack(spacing: 20) {
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
                }

                Button("Forgot password?") {
                    onForgotPassword()
                }
                .font(.footnote.weight(.semibold))
                .foregroundStyle(AppColors.accent)
                .frame(maxWidth: .infinity, alignment: .trailing)

                PrimaryActionButton(title: "Log in", isLoading: viewModel.isLoading) {
                    Task {
                        await viewModel.login()
                    }
                }
                .disabled(viewModel.isLoading)
                .opacity(viewModel.isLoading ? 0.8 : 1)

                HStack(spacing: 6) {
                    Text("Don't have an account?")
                        .foregroundStyle(AppColors.mutedText)
                    Button("Sign Up") {
                        onShowSignUp()
                    }
                    .fontWeight(.semibold)
                    .foregroundStyle(AppColors.accent)
                }
                .font(.footnote)
            }
            .padding(24)
        }
        .frame(maxWidth: .infinity)
        .background(AppColors.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
        .shadow(color: .black.opacity(0.14), radius: 24, x: 0, y: 14)
    }
}
