import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../state/app_config_state.dart';

part 'app_config_controller.g.dart';

@riverpod
class AppConfigController extends _$AppConfigController {
  @override
  AppConfigState build() {
    return AppConfigState();
  }

  void updateAppName(String name) {
    state = state.copyWith(appName: name);
  }

  void updateVersion(String version) {
    state = state.copyWith(version: version);
  }

  void updateApiBaseUrl(String url) {
    state = state.copyWith(apiBaseUrl: url);
  }

  void updateMaxTodosPerUser(int maxTodos) {
    state = state.copyWith(maxTodosPerUser: maxTodos);
  }

  void updateOfflineMode(bool enabled) {
    state = state.copyWith(enableOfflineMode: enabled);
  }
}
