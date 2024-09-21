import '../provider_state.dart';

abstract class AuthState extends ProviderState {
  const AuthState();
}

class AuthInitial extends AuthState {}

class LoginLoading extends AuthState {}

class LoginSuccess extends AuthState {}

class LoginFailure extends AuthState {
  final String error;
  const LoginFailure(this.error);
}

class SignUpLoading extends AuthState {}

class SignUpSuccess extends AuthState {}

class SignUpFailure extends AuthState {
  final String error;
  const SignUpFailure(this.error);
}

class VerificationLoading extends AuthState {}

class VerificationSuccess extends AuthState {}

class VerificationFailure extends AuthState {
  final String error;
  const VerificationFailure(this.error);
}

class ResendVerificationCodeLoading extends AuthState {}

class ResendVerificationCodeSuccess extends AuthState {}

class ResendVerificationCodeFailure extends AuthState {
  final String error;
  const ResendVerificationCodeFailure(this.error);
}

class SendVerificationCodeLoading extends AuthState {}

class SendVerificationCodeSuccess extends AuthState {}

class SendVerificationCodeFailure extends AuthState {
  final String error;
  const SendVerificationCodeFailure(this.error);
}

class SendVerificationEmailLoading extends AuthState {}

class SendVerificationEmailSuccess extends AuthState {}

class SendVerificationEmailFailure extends AuthState {
  final String error;
  const SendVerificationEmailFailure(this.error);
}

class EmailVerificationLoading extends AuthState {}

class EmailVerificationSuccess extends AuthState {}

class EmailVerificationFailure extends AuthState {
  final String error;
  const EmailVerificationFailure(this.error);
}

class ResetPasswordLoading extends AuthState {}

class ResetPasswordSuccess extends AuthState {}

class ResetPasswordFailure extends AuthState {
  final String error;
  const ResetPasswordFailure(this.error);
}

class LinkPhoneNumberLoading extends AuthState {}

class LinkPhoneNumberSuccess extends AuthState {}

class LinkPhoneNumberFailure extends AuthState {
  final String error;
  const LinkPhoneNumberFailure(this.error);
}

class SignOutLoading extends AuthState {}

class SignOutSuccess extends AuthState {}

class SignOutFailure extends AuthState {
  final String error;
  const SignOutFailure(this.error);
}

class GoogleSignInLoading extends AuthState {}

class GoogleSignInSuccess extends AuthState {}

class GoogleSignInFailure extends AuthState {
  final String error;
  const GoogleSignInFailure(this.error);
}
