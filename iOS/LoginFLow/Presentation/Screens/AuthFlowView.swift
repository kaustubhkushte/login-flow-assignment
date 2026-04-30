import SwiftUI

enum AuthMode: Equatable {
    case login
    case signup
}

struct AuthFlowView: View {
    @EnvironmentObject private var container: AppContainer
    @EnvironmentObject private var sessionRouter: AppSessionRouter
    @State private var selectedMode: AuthMode = .login

    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack {
                    if geometry.size.width > 900 {
                        HStack(alignment: .center, spacing: 28) {
                            LoginCardView(
                                viewModel: LoginViewModel(
                                    authService: container.authService,
                                    sessionRouter: sessionRouter
                                )
                            )
                            .frame(maxWidth: 300)

                            AuthBrandPanel(selectedMode: selectedMode) { mode in
                                selectedMode = mode
                            }

                            SignUpCardView(
                                viewModel: SignUpViewModel(
                                    authService: container.authService,
                                    sessionRouter: sessionRouter
                                )
                            )
                            .frame(maxWidth: 300)
                        }
                        .frame(maxWidth: .infinity, minHeight: geometry.size.height)
                        .padding(40)
                    } else {
                        VStack(spacing: 24) {
                            AuthBrandPanel(selectedMode: selectedMode) { mode in
                                selectedMode = mode
                            }

                            Group {
                                if selectedMode == .login {
                                    LoginCardView(
                                        viewModel: LoginViewModel(
                                            authService: container.authService,
                                            sessionRouter: sessionRouter
                                        )
                                    )
                                } else {
                                    SignUpCardView(
                                        viewModel: SignUpViewModel(
                                            authService: container.authService,
                                            sessionRouter: sessionRouter
                                        )
                                    )
                                }
                            }
                            .frame(maxWidth: 420)
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 28)
                        .frame(maxWidth: .infinity, minHeight: geometry.size.height)
                    }
                }
            }
            .scrollIndicators(.hidden)
        }
    }
}
