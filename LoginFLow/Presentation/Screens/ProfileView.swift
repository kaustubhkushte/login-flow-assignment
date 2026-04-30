import SwiftUI

struct ProfileView: View {
    @EnvironmentObject private var sessionRouter: AppSessionRouter
    let user: AppUser

    var body: some View {
        VStack(spacing: 24) {
            VStack(spacing: 14) {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [AppColors.gradientTop, AppColors.accent],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 92, height: 92)
                    .overlay {
                        Text(String(user.name.prefix(1)).uppercased())
                            .font(.system(size: 34, weight: .bold, design: .rounded))
                            .foregroundStyle(.white)
                    }

                Text("Welcome, \(user.name)")
                    .font(.system(size: 30, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)

                Text(user.email)
                    .foregroundStyle(.white.opacity(0.86))
            }

            VStack(alignment: .leading, spacing: 16) {
                profileRow(title: "User ID", value: user.id)
                profileRow(title: "Email", value: user.email)
                profileRow(title: "Status", value: "Authenticated with JWT")
            }
            .padding(24)
            .frame(maxWidth: 520)
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
            .shadow(color: .black.opacity(0.12), radius: 24, x: 0, y: 16)

            Button("Log out") {
                sessionRouter.logout()
            }
            .font(.headline)
            .foregroundStyle(.white)
            .padding(.horizontal, 28)
            .padding(.vertical, 14)
            .background(AppColors.error)
            .clipShape(Capsule())
        }
        .padding(24)
    }

    @ViewBuilder
    private func profileRow(title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title.uppercased())
                .font(.caption.weight(.semibold))
                .foregroundStyle(AppColors.mutedText)
            Text(value)
                .font(.body.weight(.medium))
        }
    }
}
