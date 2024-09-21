import 'package:flutter/material.dart';
import 'provider_state.dart';

class BaseProvider<T extends ProviderState> extends ChangeNotifier {
  T _state;

  BaseProvider(this._state);

  T get state => _state; // State getter

  // Emit function to update the state and notify listeners
  void emit(T newState) {
    _state = newState;
    notifyListeners(); // Notify listeners of the state change
  }
}
