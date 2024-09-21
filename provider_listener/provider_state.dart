abstract class ProviderState {
  const ProviderState();
}

// General Loading, Success, and Failure states that can be shared
class LoadingState extends ProviderState {}

class SuccessState extends ProviderState {}

class FailureState extends ProviderState {
  final String error;
  const FailureState(this.error);
}
