import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:emagency/providers/base_provider.dart';
import 'package:emagency/providers/provider_state.dart';

class ProviderListener<T extends BaseProvider<S>, S extends ProviderState>
    extends StatefulWidget {
  final T provider; // The provider instance to listen to
  final Widget child;
  final Function(BuildContext context, S state) listener;

  const ProviderListener({
    super.key,
    required this.provider,
    required this.child,
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
      child: widget.child,
    );
  }
}

class MultiProviderListener extends StatelessWidget {
  final List<ProviderListener> listeners; // List of ProviderListeners
  final Widget child;

  const MultiProviderListener({
    super.key,
    required this.listeners,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    // Apply all ProviderListeners in the widget tree
    Widget result = child;
    for (var listener in listeners.reversed) {
      result = listener.copyWithChild(result);
    }
    return result;
  }
}

extension on ProviderListener {
  ProviderListener copyWithChild(Widget newChild) {
    return ProviderListener(
      provider: provider,
      listener: listener,
      child: newChild,
    );
  }
}
