import SwiftUI

enum AuthRoute: Equatable {
    case login
    case signup
    case forgotPassword
}

struct AuthFlowView: View {
    @EnvironmentObject private var container: AppContainer
    @EnvironmentObject private var sessionRouter: AppSessionRouter
    @State private var route: AuthRoute = .login

    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer(minLength: 16)

                VStack(spacing: 24) {
                    authHeader

                    Group {
                        switch route {
                        case .login:
                            LoginCardView(
                                viewModel: LoginViewModel(
                                    authService: container.authService,
                                    sessionRouter: sessionRouter
                                ),
                                onShowSignUp: {
                                    route = .signup
                                },
                                onForgotPassword: {
                                    route = .forgotPassword
                                }
                            )
                        case .signup:
                            SignUpCardView(
                                viewModel: SignUpViewModel(
                                    authService: container.authService,
                                    sessionRouter: sessionRouter
                                ),
                                onBackToLogin: {
                                    route = .login
                                }
                            )
                        case .forgotPassword:
                            ForgotPasswordView {
                                route = .login
                            }
                        }
                    }
                }
                .frame(maxWidth: min(geometry.size.width - 32, 430))
                .padding(.horizontal, 16)

                Spacer(minLength: 16)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }

    private var authHeader: some View {
        VStack(spacing: 14) {
            Image(systemName: "drop.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 48, height: 62)
                .foregroundStyle(
                    LinearGradient(
                        colors: [AppColors.gradientTop, AppColors.accent],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )

            Text("SentriNova")
                .font(.system(size: 26, weight: .bold, design: .rounded))
                .foregroundStyle(.white)

            Text(headerTitle)
                .font(.system(size: 34, weight: .bold, design: .rounded))
                .foregroundStyle(.white)

            Text(headerSubtitle)
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.88))
                .multilineTextAlignment(.center)
        }
        .padding(.top, 8)
    }

    private var headerTitle: String {
        switch route {
        case .login:
            return "Log In"
        case .signup:
            return "Create Account"
        case .forgotPassword:
            return "Forgot Password"
        }
    }

    private var headerSubtitle: String {
        switch route {
        case .login:
            return "Access your account with a clean mobile-first flow."
        case .signup:
            return "Set up a new account to continue."
        case .forgotPassword:
            return "Enter your email to continue with password recovery."
        }
    }
}
