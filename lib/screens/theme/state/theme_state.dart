import 'package:freezed_annotation/freezed_annotation.dart';

part 'theme_state.freezed.dart';

@Freezed(toJson: false, fromJson: false)
abstract class ThemeState with _$ThemeState {
  factory ThemeState({@Default(false) bool isDarkMode}) = _ThemeState;

  ThemeState._();
}
