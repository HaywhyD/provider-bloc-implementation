// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:emagency/providers/base_provider.dart';
import 'package:emagency/providers/provider_state.dart';

class ProviderListener<T extends BaseProvider<S>, S extends ProviderState>
    extends StatefulWidget {
  final T provider; // The provider instance to listen to
  Widget? child;
  final void Function(BuildContext context, S state) listener;

  ProviderListener({
    super.key,
    required this.provider,
    this.child, // Only used if it’s a standalone ProviderListener
    required this.listener,
  });

  @override
  State<ProviderListener<T, S>> createState() => _ProviderListenerState<T, S>();
}

class _ProviderListenerState<T extends BaseProvider<S>, S extends ProviderState>
    extends State<ProviderListener<T, S>> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final provider = Provider.of<T>(context, listen: true);
    _handleState(provider.state);
  }

  @override
  void didUpdateWidget(covariant ProviderListener<T, S> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.provider != widget.provider) {
      _handleState(widget.provider.state);
    }
  }

  void _handleState(S state) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.listener(context, state);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<T>.value(
        value: widget.provider,
        child:
            widget.child ?? Container() // If no child, provide an empty widget
        );
  }
}

// MultiProviderListener without generic type constraints, supports different provider types
class MultiProviderListener extends StatefulWidget {
  final List<ProviderListener> listeners; // List of ProviderListeners
  final Widget child; // The child for MultiProviderListener

  const MultiProviderListener({
    super.key,
    required this.listeners,
    required this.child,
  });

  @override
  State<MultiProviderListener> createState() => _MultiProviderListenerState();
}

class _MultiProviderListenerState extends State<MultiProviderListener> {
  @override
  Widget build(BuildContext context) {
    // Apply all ProviderListeners in the widget tree
    Widget result = widget.child;

    // Wrap all listeners around the child
    for (var listener in widget.listeners.reversed) {
      listener.child = widget.child;
      result = listener;
    }
    return result;
  }
}
