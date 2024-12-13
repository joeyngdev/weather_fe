import 'package:flutter/material.dart';

class OverlayHandler {
  OverlayHandler._();
  static final OverlayHandler _overlayHandler = OverlayHandler._();
  factory OverlayHandler() {
    return _overlayHandler;
  }
  static OverlayEntry? _overlayEntry;
  void show(BuildContext context, Widget overlay) {
    if (_overlayEntry == null) {
      _overlayEntry = OverlayEntry(builder: (context) => overlay);
      Overlay.of(context).insert(_overlayEntry!);
    }
  }

  void hide() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }
}
