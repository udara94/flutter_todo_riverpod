import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_config_state.freezed.dart';

@Freezed(toJson: false, fromJson: false)
abstract class AppConfigState with _$AppConfigState {
  factory AppConfigState({
    @Default('Riverpod Todo App') String appName,
    @Default('1.0.0') String version,
    @Default('https://jsonplaceholder.typicode.com') String apiBaseUrl,
    @Default(100) int maxTodosPerUser,
    @Default(true) bool enableOfflineMode,
  }) = _AppConfigState;

  AppConfigState._();
}
