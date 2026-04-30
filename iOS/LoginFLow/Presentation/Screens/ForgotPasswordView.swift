import SwiftUI

struct ForgotPasswordView: View {
    @State private var email = ""
    @State private var showMessage = false

    let onBackToLogin: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            VStack(spacing: 16) {
                Text("Password recovery is not connected to a backend endpoint in this assignment.")
                    .font(.footnote)
                    .foregroundStyle(AppColors.mutedText)
                    .frame(maxWidth: .infinity, alignment: .leading)

                AuthTextField(
                    title: "Email Address",
                    placeholder: "jacob@gmail.com",
                    text: $email,
                    error: nil
                )

                PrimaryActionButton(title: "Continue", isLoading: false) {
                    showMessage = true
                }

                if showMessage {
                    Text("Use the seeded user from the backend env or return to login for this assignment flow.")
                        .font(.footnote)
                        .foregroundStyle(AppColors.accent)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }

                Button("Back to login") {
                    onBackToLogin()
                }
                .font(.footnote.weight(.semibold))
                .foregroundStyle(AppColors.accent)
            }
            .padding(24)
        }
        .frame(maxWidth: .infinity)
        .background(AppColors.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
        .shadow(color: .black.opacity(0.14), radius: 24, x: 0, y: 14)
    }
}
