import SwiftUI

struct ErrorBanner: View {
    let message: String

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: "exclamationmark.circle.fill")
                .foregroundStyle(.white)

            Text(message)
                .font(.footnote)
                .foregroundStyle(.white)

            Spacer()
        }
        .padding(12)
        .background(AppColors.error)
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }
}
