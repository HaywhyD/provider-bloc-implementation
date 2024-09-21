import 'package:emagency/providers/auth_provider/auth_state.dart';
import 'package:emagency/providers/provider_listener.dart';
import 'package:emagency/ui/screens/home/home_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/assets/assets.dart';
import '../../../providers/auth_provider/auth_provider.dart';
import '../../../core/utils/functions.dart';
import '../../../main.dart';
import '../../colors/colors.dart';
import '../../common/text_fields.dart';
import '../../common/widgets.dart';
import 'forgot_password_screen.dart';
import 'sign_up_screen.dart';
import 'verify_phone_number_screen.dart';

class SignInScreen extends StatefulWidget {
  static const String name = 'sign-in-screen';
  static const String path = '/sign-in-screen';
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isObscuredPassword = true;
  late TabController _tabViewController;
  int _tabIndex = 0;

  String _phoneNumber = "";
  bool _isSigninWithPhoneNumber = false;

  @override
  void initState() {
    super.initState();
    _tabViewController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _tabViewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Consumer<AuthProvider>(
            builder: (context, authProvider, child) {
              final isLoggingIn = authProvider.state is LoginLoading ||
                  authProvider.state is VerificationLoading ||
                  authProvider.state is SendVerificationCodeLoading;

              return ProviderListener<AuthProvider, AuthState>(
                provider: authProvider,
                listener: (context, state) {
                  if (state is LoginSuccess) {
                    print("loginLoading");
                  } else if (state is LoginFailure) {
                    showEmagencyErrorDialog(context, state.error);
                  } else if (state is GoogleSignInSuccess) {
                    print("loginLoading");
                  } else if (state is GoogleSignInFailure) {
                    showEmagencyErrorDialog(context, state.error);
                  }
                  if (state is SendVerificationCodeSuccess) {
                    context.push(
                      VerifyPhoneNumberScreen.path,
                      extra: {"destination": HomeScreen.path},
                    );
                  } else if (state is SendVerificationCodeFailure) {
                    showEmagencyErrorDialog(context, state.error);
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          "Sign In",
                          textAlign: TextAlign.start,
                          style: textTheme.displayMedium?.copyWith(
                            color: AppColor.primaryColor,
                            fontSize: 24,
                          ),
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Text(
                          "Welcome Back! We've Missed You.",
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.start,
                          style: textTheme.bodyMedium?.copyWith(
                            color: AppColor.primaryColor,
                            fontSize: 12,
                          ),
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        TabBar(
                          onTap: (value) => setState(() {
                            _tabIndex = value;
                            _isSigninWithPhoneNumber =
                                !_isSigninWithPhoneNumber;
                          }),
                          controller: _tabViewController,
                          tabs: const [
                            Tab(
                              text: "Sign in with Email",
                            ),
                            Tab(
                              text: "Sign in with Phone Number",
                            )
                          ],
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        ButtonWidget(
                          onPressed: isLoggingIn
                              ? null
                              : () => _login(context, authProvider),
                          child: isLoggingIn
                              ? const CircularLoadingWidget()
                              : Text(
                                  "Sign in",
                                  style: textTheme.bodyLarge?.copyWith(
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            text: "Don't have an account? ",
                            children: [
                              TextSpan(
                                text: "Sign up",
                                style: textTheme.bodyMedium?.copyWith(
                                  color: AppColor.primaryColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () => context
                                      .pushReplacement(SignUpScreen.path),
                              ),
                            ],
                            style: textTheme.bodyMedium?.copyWith(
                              color: Colors.grey,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  _signInWithGoogle(BuildContext context, AuthProvider authProvider) async {
    await authProvider.signInWithGoogle();
  }

  _login(BuildContext context, AuthProvider authProvider) async {
    if (_formKey.currentState!.validate()) {
      if (_isSigninWithPhoneNumber) {
        await authProvider.sendVerificationCode(_phoneNumber);
      }
    } else {
      await authProvider.login(
          email: _emailController.text, password: _passwordController.text);
    }
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    if (!value.contains(RegExp(r'\d'))) {
      return 'Password must contain at least one number';
    }
    if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return 'Password must contain at least one special character';
    }
    return null;
  }
}
