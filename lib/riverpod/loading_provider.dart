import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoadingNotifer extends StateNotifier<bool> {
  LoadingNotifer() : super(false);
  void changeState() {
    state = !state;
  }
}

final loadingProvider =
    StateNotifierProvider<LoadingNotifer, bool>((ref) => LoadingNotifer());
