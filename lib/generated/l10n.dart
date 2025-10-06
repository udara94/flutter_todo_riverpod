// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name =
        (locale.countryCode?.isEmpty ?? false)
            ? locale.languageCode
            : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `ToDo Mate`
  String get appName {
    return Intl.message('ToDo Mate', name: 'appName', desc: '', args: []);
  }

  /// `Stay organized, stay productive`
  String get splashSubtitle {
    return Intl.message(
      'Stay organized, stay productive',
      name: 'splashSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Welcome back!`
  String get loginWelcome {
    return Intl.message(
      'Welcome back!',
      name: 'loginWelcome',
      desc: '',
      args: [],
    );
  }

  /// `Sign in to continue`
  String get loginSubtitle {
    return Intl.message(
      'Sign in to continue',
      name: 'loginSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Sign In`
  String get singIn {
    return Intl.message('Sign In', name: 'singIn', desc: '', args: []);
  }

  /// `Email`
  String get emailLabel {
    return Intl.message('Email', name: 'emailLabel', desc: '', args: []);
  }

  /// `Enter your email`
  String get emailHint {
    return Intl.message(
      'Enter your email',
      name: 'emailHint',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get passwordLabel {
    return Intl.message('Password', name: 'passwordLabel', desc: '', args: []);
  }

  /// `Enter your password`
  String get passwordHint {
    return Intl.message(
      'Enter your password',
      name: 'passwordHint',
      desc: '',
      args: [],
    );
  }

  /// `Login`
  String get loginButton {
    return Intl.message('Login', name: 'loginButton', desc: '', args: []);
  }

  /// `Demo Credentials`
  String get demoCredentials {
    return Intl.message(
      'Demo Credentials',
      name: 'demoCredentials',
      desc: '',
      args: [],
    );
  }

  /// `Email: demo@example.com\nPassword: password123`
  String get demoCredentialsText {
    return Intl.message(
      'Email: demo@example.com\nPassword: password123',
      name: 'demoCredentialsText',
      desc: '',
      args: [],
    );
  }

  /// `Use Demo Credentials`
  String get useDemoCredentials {
    return Intl.message(
      'Use Demo Credentials',
      name: 'useDemoCredentials',
      desc: '',
      args: [],
    );
  }

  /// `Dark Mode`
  String get darkMode {
    return Intl.message('Dark Mode', name: 'darkMode', desc: '', args: []);
  }

  /// `Light Mode`
  String get lightMode {
    return Intl.message('Light Mode', name: 'lightMode', desc: '', args: []);
  }

  /// `My Tasks`
  String get homeTitle {
    return Intl.message('My Tasks', name: 'homeTitle', desc: '', args: []);
  }

  /// `Add Task`
  String get addTask {
    return Intl.message('Add Task', name: 'addTask', desc: '', args: []);
  }

  /// `Search tasks...`
  String get searchHint {
    return Intl.message(
      'Search tasks...',
      name: 'searchHint',
      desc: '',
      args: [],
    );
  }

  /// `All`
  String get filterAll {
    return Intl.message('All', name: 'filterAll', desc: '', args: []);
  }

  /// `Pending`
  String get filterPending {
    return Intl.message('Pending', name: 'filterPending', desc: '', args: []);
  }

  /// `In Progress`
  String get filterInProgress {
    return Intl.message(
      'In Progress',
      name: 'filterInProgress',
      desc: '',
      args: [],
    );
  }

  /// `Completed`
  String get filterCompleted {
    return Intl.message(
      'Completed',
      name: 'filterCompleted',
      desc: '',
      args: [],
    );
  }

  /// `Overdue`
  String get filterOverdue {
    return Intl.message('Overdue', name: 'filterOverdue', desc: '', args: []);
  }

  /// `Total`
  String get statTotal {
    return Intl.message('Total', name: 'statTotal', desc: '', args: []);
  }

  /// `Completed`
  String get statCompleted {
    return Intl.message('Completed', name: 'statCompleted', desc: '', args: []);
  }

  /// `Pending`
  String get statPending {
    return Intl.message('Pending', name: 'statPending', desc: '', args: []);
  }

  /// `In Progress`
  String get statInProgress {
    return Intl.message(
      'In Progress',
      name: 'statInProgress',
      desc: '',
      args: [],
    );
  }

  /// `Overdue`
  String get statOverdue {
    return Intl.message('Overdue', name: 'statOverdue', desc: '', args: []);
  }

  /// `Title`
  String get todoTitle {
    return Intl.message('Title', name: 'todoTitle', desc: '', args: []);
  }

  /// `Description`
  String get todoDescription {
    return Intl.message(
      'Description',
      name: 'todoDescription',
      desc: '',
      args: [],
    );
  }

  /// `Priority`
  String get todoPriority {
    return Intl.message('Priority', name: 'todoPriority', desc: '', args: []);
  }

  /// `Status`
  String get todoStatus {
    return Intl.message('Status', name: 'todoStatus', desc: '', args: []);
  }

  /// `Due Date`
  String get todoDueDate {
    return Intl.message('Due Date', name: 'todoDueDate', desc: '', args: []);
  }

  /// `Tags`
  String get todoTags {
    return Intl.message('Tags', name: 'todoTags', desc: '', args: []);
  }

  /// `Low`
  String get priorityLow {
    return Intl.message('Low', name: 'priorityLow', desc: '', args: []);
  }

  /// `Medium`
  String get priorityMedium {
    return Intl.message('Medium', name: 'priorityMedium', desc: '', args: []);
  }

  /// `High`
  String get priorityHigh {
    return Intl.message('High', name: 'priorityHigh', desc: '', args: []);
  }

  /// `Pending`
  String get statusPending {
    return Intl.message('Pending', name: 'statusPending', desc: '', args: []);
  }

  /// `In Progress`
  String get statusInProgress {
    return Intl.message(
      'In Progress',
      name: 'statusInProgress',
      desc: '',
      args: [],
    );
  }

  /// `Completed`
  String get statusCompleted {
    return Intl.message(
      'Completed',
      name: 'statusCompleted',
      desc: '',
      args: [],
    );
  }

  /// `Due:`
  String get dueDateLabel {
    return Intl.message('Due:', name: 'dueDateLabel', desc: '', args: []);
  }

  /// `No tasks found`
  String get noTasks {
    return Intl.message('No tasks found', name: 'noTasks', desc: '', args: []);
  }

  /// `Start by adding a new task!`
  String get noTasksMessage {
    return Intl.message(
      'Start by adding a new task!',
      name: 'noTasksMessage',
      desc: '',
      args: [],
    );
  }

  /// `Edit Task`
  String get editTask {
    return Intl.message('Edit Task', name: 'editTask', desc: '', args: []);
  }

  /// `Add New Task`
  String get addNewTask {
    return Intl.message('Add New Task', name: 'addNewTask', desc: '', args: []);
  }

  /// `Save Task`
  String get saveTask {
    return Intl.message('Save Task', name: 'saveTask', desc: '', args: []);
  }

  /// `Cancel`
  String get cancel {
    return Intl.message('Cancel', name: 'cancel', desc: '', args: []);
  }

  /// `Delete`
  String get delete {
    return Intl.message('Delete', name: 'delete', desc: '', args: []);
  }

  /// `Edit`
  String get edit {
    return Intl.message('Edit', name: 'edit', desc: '', args: []);
  }

  /// `Mark Complete`
  String get markComplete {
    return Intl.message(
      'Mark Complete',
      name: 'markComplete',
      desc: '',
      args: [],
    );
  }

  /// `Mark Incomplete`
  String get markIncomplete {
    return Intl.message(
      'Mark Incomplete',
      name: 'markIncomplete',
      desc: '',
      args: [],
    );
  }

  /// `Delete Task`
  String get deleteTask {
    return Intl.message('Delete Task', name: 'deleteTask', desc: '', args: []);
  }

  /// `Are you sure you want to delete this task?`
  String get deleteTaskConfirm {
    return Intl.message(
      'Are you sure you want to delete this task?',
      name: 'deleteTaskConfirm',
      desc: '',
      args: [],
    );
  }

  /// `Yes`
  String get yes {
    return Intl.message('Yes', name: 'yes', desc: '', args: []);
  }

  /// `No`
  String get no {
    return Intl.message('No', name: 'no', desc: '', args: []);
  }

  /// `Enter task title`
  String get taskTitleHint {
    return Intl.message(
      'Enter task title',
      name: 'taskTitleHint',
      desc: '',
      args: [],
    );
  }

  /// `Enter task description`
  String get taskDescriptionHint {
    return Intl.message(
      'Enter task description',
      name: 'taskDescriptionHint',
      desc: '',
      args: [],
    );
  }

  /// `Enter tags (comma separated)`
  String get tagsHint {
    return Intl.message(
      'Enter tags (comma separated)',
      name: 'tagsHint',
      desc: '',
      args: [],
    );
  }

  /// `Select Due Date`
  String get selectDueDate {
    return Intl.message(
      'Select Due Date',
      name: 'selectDueDate',
      desc: '',
      args: [],
    );
  }

  /// `Task Statistics`
  String get statsTitle {
    return Intl.message(
      'Task Statistics',
      name: 'statsTitle',
      desc: '',
      args: [],
    );
  }

  /// `Total Tasks`
  String get totalTasks {
    return Intl.message('Total Tasks', name: 'totalTasks', desc: '', args: []);
  }

  /// `Completed Tasks`
  String get completedTasks {
    return Intl.message(
      'Completed Tasks',
      name: 'completedTasks',
      desc: '',
      args: [],
    );
  }

  /// `Pending Tasks`
  String get pendingTasks {
    return Intl.message(
      'Pending Tasks',
      name: 'pendingTasks',
      desc: '',
      args: [],
    );
  }

  /// `In Progress Tasks`
  String get inProgressTasks {
    return Intl.message(
      'In Progress Tasks',
      name: 'inProgressTasks',
      desc: '',
      args: [],
    );
  }

  /// `Overdue Tasks`
  String get overdueTasks {
    return Intl.message(
      'Overdue Tasks',
      name: 'overdueTasks',
      desc: '',
      args: [],
    );
  }

  /// `Completion Rate`
  String get completionRate {
    return Intl.message(
      'Completion Rate',
      name: 'completionRate',
      desc: '',
      args: [],
    );
  }

  /// `Average Completion Time`
  String get averageCompletionTime {
    return Intl.message(
      'Average Completion Time',
      name: 'averageCompletionTime',
      desc: '',
      args: [],
    );
  }

  /// `Recently Completed`
  String get recentlyCompleted {
    return Intl.message(
      'Recently Completed',
      name: 'recentlyCompleted',
      desc: '',
      args: [],
    );
  }

  /// `Upcoming Deadlines`
  String get upcomingDeadlines {
    return Intl.message(
      'Upcoming Deadlines',
      name: 'upcomingDeadlines',
      desc: '',
      args: [],
    );
  }

  /// `No statistics available`
  String get noStatsAvailable {
    return Intl.message(
      'No statistics available',
      name: 'noStatsAvailable',
      desc: '',
      args: [],
    );
  }

  /// `Welcome back, {name}!`
  String welcomeBack(Object name) {
    return Intl.message(
      'Welcome back, $name!',
      name: 'welcomeBack',
      desc: '',
      args: [name],
    );
  }

  /// `Login failed`
  String get loginFailed {
    return Intl.message(
      'Login failed',
      name: 'loginFailed',
      desc: '',
      args: [],
    );
  }

  /// `Retry`
  String get retry {
    return Intl.message('Retry', name: 'retry', desc: '', args: []);
  }

  /// `Logout`
  String get logout {
    return Intl.message('Logout', name: 'logout', desc: '', args: []);
  }

  /// `Are you sure you want to logout?`
  String get logoutConfirm {
    return Intl.message(
      'Are you sure you want to logout?',
      name: 'logoutConfirm',
      desc: '',
      args: [],
    );
  }

  /// `Error`
  String get error {
    return Intl.message('Error', name: 'error', desc: '', args: []);
  }

  /// `Success`
  String get success {
    return Intl.message('Success', name: 'success', desc: '', args: []);
  }

  /// `Loading...`
  String get loading {
    return Intl.message('Loading...', name: 'loading', desc: '', args: []);
  }

  /// `Version {version}`
  String version(Object version) {
    return Intl.message(
      'Version $version',
      name: 'version',
      desc: '',
      args: [version],
    );
  }

  /// `days`
  String get days {
    return Intl.message('days', name: 'days', desc: '', args: []);
  }

  /// `hours`
  String get hours {
    return Intl.message('hours', name: 'hours', desc: '', args: []);
  }

  /// `minutes`
  String get minutes {
    return Intl.message('minutes', name: 'minutes', desc: '', args: []);
  }

  /// `ago`
  String get ago {
    return Intl.message('ago', name: 'ago', desc: '', args: []);
  }

  /// `Today`
  String get today {
    return Intl.message('Today', name: 'today', desc: '', args: []);
  }

  /// `Tomorrow`
  String get tomorrow {
    return Intl.message('Tomorrow', name: 'tomorrow', desc: '', args: []);
  }

  /// `Yesterday`
  String get yesterday {
    return Intl.message('Yesterday', name: 'yesterday', desc: '', args: []);
  }

  /// `This Week`
  String get thisWeek {
    return Intl.message('This Week', name: 'thisWeek', desc: '', args: []);
  }

  /// `Next Week`
  String get nextWeek {
    return Intl.message('Next Week', name: 'nextWeek', desc: '', args: []);
  }

  /// `This Month`
  String get thisMonth {
    return Intl.message('This Month', name: 'thisMonth', desc: '', args: []);
  }

  /// `Next Month`
  String get nextMonth {
    return Intl.message('Next Month', name: 'nextMonth', desc: '', args: []);
  }

  /// `Task deleted successfully`
  String get taskDeleted {
    return Intl.message(
      'Task deleted successfully',
      name: 'taskDeleted',
      desc: '',
      args: [],
    );
  }

  /// `Created (Oldest)`
  String get sortCreatedOldest {
    return Intl.message(
      'Created (Oldest)',
      name: 'sortCreatedOldest',
      desc: '',
      args: [],
    );
  }

  /// `Created (Newest)`
  String get sortCreatedNewest {
    return Intl.message(
      'Created (Newest)',
      name: 'sortCreatedNewest',
      desc: '',
      args: [],
    );
  }

  /// `Title (A-Z)`
  String get sortTitleAZ {
    return Intl.message('Title (A-Z)', name: 'sortTitleAZ', desc: '', args: []);
  }

  /// `Title (Z-A)`
  String get sortTitleZA {
    return Intl.message('Title (Z-A)', name: 'sortTitleZA', desc: '', args: []);
  }

  /// `Priority (Low-High)`
  String get sortPriorityLowHigh {
    return Intl.message(
      'Priority (Low-High)',
      name: 'sortPriorityLowHigh',
      desc: '',
      args: [],
    );
  }

  /// `Priority (High-Low)`
  String get sortPriorityHighLow {
    return Intl.message(
      'Priority (High-Low)',
      name: 'sortPriorityHighLow',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[Locale.fromSubtags(languageCode: 'en')];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
