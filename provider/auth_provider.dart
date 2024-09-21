import 'dart:io';
import 'package:emagency/models/phone_verification_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../models/user_profile.dart';
import '../../core/services/auth/auth_service.dart';
import '../../core/services/profile/profile_service.dart';
import 'auth_state.dart';
import '../base_provider.dart';

class AuthProvider extends BaseProvider<AuthState> {
  AuthProvider() : super(AuthInitial()); // Initial state

  final AuthService _authService = AuthService();
  VerificationModel _verificationModel = VerificationModel();
  VerificationModel get verificationModel => _verificationModel;
  late UserCredential _user;
  UserCredential get user => _user;
  UserProfile? _userProfile;
  bool _isEmailSent = false;
  bool get isEmailSent => _isEmailSent;
  UserProfile? get userProfile => _userProfile;

  /// Login user
  Future<void> login({required String email, required String password}) async {
    try {
      emit(LoginLoading()); // Emit loading state

      final loginResponse = await _authService.login(email, password);
      _user = loginResponse;

      if (loginResponse.user!.emailVerified) {
        emit(LoginSuccess()); // Emit success state
      } else {
        emit(const LoginFailure("Email not verified.")); // Emit failure state
      }
    } catch (e) {
      _handleError(e, (msg) => LoginFailure(msg)); // Handle error
    }
  }

  // Send the verification code
  Future<void> sendVerificationCode(String phoneNumber) async {
    try {
      emit(SendVerificationCodeLoading()); // Emit loading state

      _verificationModel = await _authService.sendVerificationCode(phoneNumber);

      if (_verificationModel.errorMessage != null) {
        emit(SendVerificationCodeFailure(
            _verificationModel.errorMessage ?? "Unknown error"));
      } else {
        emit(SendVerificationCodeSuccess()); // Emit success state
      }
    } catch (e) {
      _handleError(
          e, (msg) => SendVerificationCodeFailure(msg)); // Handle error
    }
  }

  // Handle errors and emit failure states
  void _handleError<T extends AuthState>(
    dynamic e,
    T Function(String) errorState,
  ) {
    String errorMessage;

    if (e is SocketException) {
      errorMessage = "Network error. Please check your internet connection.";
    } else if (e is AuthServiceException) {
      errorMessage = e.message;
    } else if (e is FirebaseAuthException) {
      errorMessage = e.message!;
    } else if (e is ProfileServiceException) {
      errorMessage = e.message;
    } else {
      print(e);
      errorMessage = "An unexpected error occurred.";
    }

    emit(errorState(errorMessage));
    // Reset to initial state after handling the error
  }
}
