# Flutter Provider-Bloc Integration

This repository demonstrates how to integrate the Provider and BLoC patterns in a Flutter project. The combination leverages Provider to hold application-wide states and BLoC-like event-based state management. Below is a description of each file and how they work together.

## File Descriptions

### 1. `main.dart`
This is the entry point of the Flutter app. Here, the `AuthProvider` is wrapped using the `ChangeNotifierProvider`. This ensures the state is accessible across the application.

**Important**: Make sure you wrap your main widget with `MultiProvider` or `ChangeNotifierProvider` to ensure that the `Provider` is available throughout your app.

**Example:**
```dart
runApp(
  MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (context) => AuthProvider(),
      ),
    ],
    child: const MyApp(),
  ),
);
```

### 2. `auth_provider.dart`
This file contains the `AuthProvider`, which is an extension of `BaseProvider`. The `AuthProvider` is responsible for managing all authentication logic, such as login, sending verification codes, signing out, and checking if the user is verified.

**Important**: The `AuthProvider` uses the `emit` method to notify listeners of state changes, which can trigger UI updates or other actions in the app.

**Example:**
```dart
class AuthProvider extends BaseProvider<AuthState> {
  void login(String username, String password) {
    // Perform login logic
    emit(LoginLoading());
    try {
      // If successful
      emit(LoginSuccess(user));
    } catch (e) {
      emit(LoginFailure(errorMessage));
    }
  }
}
```
### 3. `auth_state.dart`
This file defines the various states that the `AuthProvider` can emit. These states help represent different authentication statuses such as login success, login failure, verification success, and verification failure.

**Important**: Each state extends the base `ProviderState` class to allow seamless integration with the `ProviderListener`.

**Example:**
```dart
abstract class AuthState extends ProviderState {}

class LoginSuccess extends AuthState {
  final User user;
  LoginSuccess(this.user);
}

class LoginFailure extends AuthState {
  final String errorMessage;
  LoginFailure(this.errorMessage);
}

class VerificationSuccess extends AuthState {}

class VerificationFailure extends AuthState {}
```
### 4. `base_provider.dart`
This file contains the `BaseProvider<T>`, which extends `ChangeNotifier`. It includes the core `emit` method that notifies listeners whenever the state changes. All specific providers, such as `AuthProvider`, extend this class to manage state and notify the UI.

**Important**: The `emit` method is essential for updating the current state and triggering UI updates. Always use it to manage the flow of state changes.

**Example:**
```dart
class BaseProvider<T extends ProviderState> extends ChangeNotifier {
  T? _state;

  T? get state => _state;

  void emit(T newState) {
    _state = newState;
    notifyListeners();
  }
}
```
### 5. `provider_listener.dart`
This file defines the `ProviderListener<T, S>`, which listens for state changes in a specific provider. The listener reacts to the emitted states and allows the UI to respond accordingly, such as navigating on a successful login or showing an error message on failure.

**Important**: Use the `ProviderListener` to respond to different states emitted by a provider. You can also wrap multiple listeners using `MultiProviderListener`.

**Example:**
```dart
class ProviderListener<T extends ChangeNotifier, S extends ProviderState> extends StatelessWidget {
  final Widget Function(BuildContext context, S state) listener;
  final Widget child;

  const ProviderListener({
    Key? key,
    required this.listener,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<T>(
      builder: (context, provider, _) {
        final state = provider.state as S;
        return listener(context, state);
      },
      child: child,
    );
  }
}
```
### 6. `provider_state.dart`
This file contains the `ProviderState` class, which serves as the base class for all states in the application. Specific states, such as `AuthState`, extend from this class to manage state transitions like `LoadingState`, `SuccessState`, and `FailureState`.

**Important**: All states used in the application should extend `ProviderState`. This ensures consistency across different providers and allows for easy handling of common states.

**Example:**
```dart
abstract class ProviderState {}

class LoadingState extends ProviderState {}

class SuccessState extends ProviderState {}

class FailureState extends ProviderState {
  final String errorMessage;
  FailureState(this.errorMessage);
}
```
### 7. `sign_in_screen.dart`
This file contains the UI for the sign-in screen. It uses the `ProviderListener` to listen for different states emitted by the `AuthProvider`, such as successful login or failure. Depending on the emitted state, the UI reacts by navigating to another screen or showing an error message.

**Important**: Ensure that the `ProviderListener` is properly set up to handle state changes and provide feedback to the user based on the authentication flow.

**Example:**
```dart
class SignInScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign In')),
      body: ProviderListener<AuthProvider, AuthState>(
        listener: (context, state) {
          if (state is LoginSuccess) {
            Navigator.pushNamed(context, '/home');
          } else if (state is LoginFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage)),
            );
          }
        },
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(labelText: 'Email'),
              onChanged: (value) {
                context.read<AuthProvider>().email = value;
              },
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'Password'),
              onChanged: (value) {
                context.read<AuthProvider>().password = value;
              },
            ),
            ElevatedButton(
              onPressed: () {
                context.read<AuthProvider>().login();
              },
              child: const Text('Sign In'),
            ),
          ],
        ),
      ),
    );
  }
}

```
## How to Use:

1. **Clone this repository**:  
   Clone the repository to your local machine using the following command:
   ```bash
   git clone https://github.com/HaywhyD/provider-bloc-implementation.git
   ```
2. **Install dependencies**:  
   After cloning the repository, navigate into the project directory and install all dependencies, including the `provider` package, using the following commands:

   ```bash
   cd provider-bloc-implementation
   flutter pub get
   ```
   If the `provider` package is not already included, add it to your `pubspec.yaml` file:

  ```yaml
  dependencies:
  provider: ^6.0.0
  ```
   
3. **Wrap your app with `ChangeNotifierProvider` or `MultiProvider`**:  
   Ensure that your `main.dart` file is properly configured to use `ChangeNotifierProvider` or `MultiProvider`, so that the `AuthProvider` is accessible throughout the app.

   **Example**:
   ```dart
   runApp(
     MultiProvider(
       providers: [
         ChangeNotifierProvider(
           create: (context) => AuthProvider(),
         ),
       ],
       child: const MyApp(),
     ),
   );

4. **Integrate the `AuthProvider` and `ProviderListener` into your widgets where necessary**:  
   Use the `AuthProvider` for handling authentication logic, and the `ProviderListener` to listen for and respond to state changes in your UI.

5. **Use the `AuthProvider` to handle authentication-related logic and emit corresponding states**:  
   The `AuthProvider` should be used to manage all authentication logic, such as logging in, verifying users, and handling logouts. You can call its methods to trigger state changes and emit different authentication states.
