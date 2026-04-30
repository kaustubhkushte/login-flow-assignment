import SwiftUI

struct SignUpCardView: View {
    @StateObject var viewModel: SignUpViewModel
    let onBackToLogin: () -> Void

    var body: some View {
        VStack(spacing: 20) {
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

                HStack(spacing: 6) {
                    Text("Already have an account?")
                        .foregroundStyle(AppColors.mutedText)
                    Button("Log In") {
                        onBackToLogin()
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
