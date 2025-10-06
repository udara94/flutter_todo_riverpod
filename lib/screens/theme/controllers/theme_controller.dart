import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../state/theme_state.dart';

part 'theme_controller.g.dart';

@riverpod
class ThemeController extends _$ThemeController {
  @override
  ThemeState build() {
    return ThemeState();
  }

  void toggleDarkMode() {
    state = state.copyWith(isDarkMode: !state.isDarkMode);
  }

  void setDarkMode(bool isDark) {
    state = state.copyWith(isDarkMode: isDark);
  }
}
