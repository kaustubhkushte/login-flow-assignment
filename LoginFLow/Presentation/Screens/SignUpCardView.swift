import SwiftUI

struct SignUpCardView: View {
    @StateObject var viewModel: SignUpViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            VStack(alignment: .leading, spacing: 6) {
                Text("Hello,")
                    .font(.headline)
                    .foregroundStyle(.white.opacity(0.9))
                Text("Sign Up!")
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
                    title: "User Name",
                    placeholder: "Jacob Joseph",
                    text: $viewModel.name,
                    error: viewModel.fieldErrors["name"]
                )

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

                VStack(alignment: .leading, spacing: 6) {
                    Toggle("I accept the policy and terms", isOn: $viewModel.hasAcceptedTerms)
                        .font(.footnote)
                        .toggleStyle(.switch)
                        .foregroundStyle(AppColors.mutedText)

                    if let termsError = viewModel.fieldErrors["terms"] {
                        Text(termsError)
                            .font(.caption)
                            .foregroundStyle(AppColors.error)
                    }
                }

                PrimaryActionButton(title: "Sign up", isLoading: viewModel.isLoading) {
                    Task {
                        await viewModel.signUp()
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
