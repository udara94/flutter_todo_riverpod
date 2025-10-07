// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  static String m0(days) => "${days} days ago";

  static String m1(hours) => "${hours} hours ago";

  static String m2(minutes) => "${minutes} minutes ago";

  static String m3(version) => "Version ${version}";

  static String m4(name) => "Welcome back, ${name}!";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "addNewTask": MessageLookupByLibrary.simpleMessage("Add New Task"),
    "addTask": MessageLookupByLibrary.simpleMessage("Add Task"),
    "ago": MessageLookupByLibrary.simpleMessage("ago"),
    "appName": MessageLookupByLibrary.simpleMessage("ToDo Mate"),
    "averageCompletionTime": MessageLookupByLibrary.simpleMessage(
      "Average Completion Time",
    ),
    "cancel": MessageLookupByLibrary.simpleMessage("Cancel"),
    "completedTasks": MessageLookupByLibrary.simpleMessage("Completed Tasks"),
    "completionRate": MessageLookupByLibrary.simpleMessage("Completion Rate"),
    "darkMode": MessageLookupByLibrary.simpleMessage("Dark Mode"),
    "days": MessageLookupByLibrary.simpleMessage("days"),
    "daysAgo": m0,
    "delete": MessageLookupByLibrary.simpleMessage("Delete"),
    "deleteTask": MessageLookupByLibrary.simpleMessage("Delete Task"),
    "deleteTaskConfirm": MessageLookupByLibrary.simpleMessage(
      "Are you sure you want to delete this task?",
    ),
    "demoCredentials": MessageLookupByLibrary.simpleMessage("Demo Credentials"),
    "demoCredentialsText": MessageLookupByLibrary.simpleMessage(
      "Email: demo@example.com\nPassword: password123",
    ),
    "dueDateLabel": MessageLookupByLibrary.simpleMessage("Due:"),
    "edit": MessageLookupByLibrary.simpleMessage("Edit"),
    "editTask": MessageLookupByLibrary.simpleMessage("Edit Task"),
    "emailHint": MessageLookupByLibrary.simpleMessage("Enter your email"),
    "emailLabel": MessageLookupByLibrary.simpleMessage("Email"),
    "emailRequiredError": MessageLookupByLibrary.simpleMessage(
      "Please enter your email",
    ),
    "error": MessageLookupByLibrary.simpleMessage("Error"),
    "errorLoadingStatistics": MessageLookupByLibrary.simpleMessage(
      "Error loading statistics",
    ),
    "filterAll": MessageLookupByLibrary.simpleMessage("All"),
    "filterCompleted": MessageLookupByLibrary.simpleMessage("Completed"),
    "filterInProgress": MessageLookupByLibrary.simpleMessage("In Progress"),
    "filterOverdue": MessageLookupByLibrary.simpleMessage("Overdue"),
    "filterPending": MessageLookupByLibrary.simpleMessage("Pending"),
    "homeTitle": MessageLookupByLibrary.simpleMessage("My Tasks"),
    "hours": MessageLookupByLibrary.simpleMessage("hours"),
    "hoursAgo": m1,
    "inProgressTasks": MessageLookupByLibrary.simpleMessage(
      "In Progress Tasks",
    ),
    "justNow": MessageLookupByLibrary.simpleMessage("Just now"),
    "lightMode": MessageLookupByLibrary.simpleMessage("Light Mode"),
    "loading": MessageLookupByLibrary.simpleMessage("Loading..."),
    "loggedOutSuccessfully": MessageLookupByLibrary.simpleMessage(
      "Logged out successfully",
    ),
    "loginButton": MessageLookupByLibrary.simpleMessage("Login"),
    "loginFailed": MessageLookupByLibrary.simpleMessage("Login failed"),
    "loginSubtitle": MessageLookupByLibrary.simpleMessage(
      "Sign in to continue",
    ),
    "loginWelcome": MessageLookupByLibrary.simpleMessage("Welcome back!"),
    "logout": MessageLookupByLibrary.simpleMessage("Logout"),
    "logoutConfirm": MessageLookupByLibrary.simpleMessage(
      "Are you sure you want to logout?",
    ),
    "logoutMessage": MessageLookupByLibrary.simpleMessage(
      "Are you sure you want to logout?",
    ),
    "logoutTitle": MessageLookupByLibrary.simpleMessage("Logout"),
    "logoutTooltip": MessageLookupByLibrary.simpleMessage("Logout"),
    "markComplete": MessageLookupByLibrary.simpleMessage("Mark Complete"),
    "markIncomplete": MessageLookupByLibrary.simpleMessage("Mark Incomplete"),
    "minutes": MessageLookupByLibrary.simpleMessage("minutes"),
    "minutesAgo": m2,
    "nextMonth": MessageLookupByLibrary.simpleMessage("Next Month"),
    "nextWeek": MessageLookupByLibrary.simpleMessage("Next Week"),
    "no": MessageLookupByLibrary.simpleMessage("No"),
    "noRecentActivity": MessageLookupByLibrary.simpleMessage(
      "No recent activity",
    ),
    "noStatsAvailable": MessageLookupByLibrary.simpleMessage(
      "No statistics available",
    ),
    "noTasks": MessageLookupByLibrary.simpleMessage("No tasks found"),
    "noTasksMessage": MessageLookupByLibrary.simpleMessage(
      "Start by adding a new task!",
    ),
    "overdueRate": MessageLookupByLibrary.simpleMessage("Overdue Rate"),
    "overdueTasks": MessageLookupByLibrary.simpleMessage("Overdue Tasks"),
    "overview": MessageLookupByLibrary.simpleMessage("Overview"),
    "passwordHint": MessageLookupByLibrary.simpleMessage("Enter your password"),
    "passwordLabel": MessageLookupByLibrary.simpleMessage("Password"),
    "passwordLengthError": MessageLookupByLibrary.simpleMessage(
      "Password must be at least 6 characters",
    ),
    "passwordRequiredError": MessageLookupByLibrary.simpleMessage(
      "Please enter your password",
    ),
    "pendingTasks": MessageLookupByLibrary.simpleMessage("Pending Tasks"),
    "performanceMetrics": MessageLookupByLibrary.simpleMessage(
      "Performance Metrics",
    ),
    "pleaseLoginToViewStats": MessageLookupByLibrary.simpleMessage(
      "Please login to view stats",
    ),
    "priorityDistribution": MessageLookupByLibrary.simpleMessage(
      "Priority Distribution",
    ),
    "priorityHigh": MessageLookupByLibrary.simpleMessage("High"),
    "priorityLow": MessageLookupByLibrary.simpleMessage("Low"),
    "priorityMedium": MessageLookupByLibrary.simpleMessage("Medium"),
    "recentActivity": MessageLookupByLibrary.simpleMessage("Recent Activity"),
    "recentlyCompleted": MessageLookupByLibrary.simpleMessage(
      "Recently Completed",
    ),
    "retry": MessageLookupByLibrary.simpleMessage("Retry"),
    "saveTask": MessageLookupByLibrary.simpleMessage("Save Task"),
    "searchHint": MessageLookupByLibrary.simpleMessage("Search tasks..."),
    "selectDueDate": MessageLookupByLibrary.simpleMessage("Select Due Date"),
    "singIn": MessageLookupByLibrary.simpleMessage("Sign In"),
    "sortCreatedNewest": MessageLookupByLibrary.simpleMessage(
      "Created (Newest)",
    ),
    "sortCreatedOldest": MessageLookupByLibrary.simpleMessage(
      "Created (Oldest)",
    ),
    "sortPriorityHighLow": MessageLookupByLibrary.simpleMessage(
      "Priority (High-Low)",
    ),
    "sortPriorityLowHigh": MessageLookupByLibrary.simpleMessage(
      "Priority (Low-High)",
    ),
    "sortTitleAZ": MessageLookupByLibrary.simpleMessage("Title (A-Z)"),
    "sortTitleZA": MessageLookupByLibrary.simpleMessage("Title (Z-A)"),
    "splashSubtitle": MessageLookupByLibrary.simpleMessage(
      "Stay organized, stay productive",
    ),
    "statCompleted": MessageLookupByLibrary.simpleMessage("Completed"),
    "statInProgress": MessageLookupByLibrary.simpleMessage("In Progress"),
    "statOverdue": MessageLookupByLibrary.simpleMessage("Overdue"),
    "statPending": MessageLookupByLibrary.simpleMessage("Pending"),
    "statTotal": MessageLookupByLibrary.simpleMessage("Total"),
    "statsTitle": MessageLookupByLibrary.simpleMessage("Task Statistics"),
    "statusCompleted": MessageLookupByLibrary.simpleMessage("Completed"),
    "statusDistribution": MessageLookupByLibrary.simpleMessage(
      "Status Distribution",
    ),
    "statusInProgress": MessageLookupByLibrary.simpleMessage("In Progress"),
    "statusPending": MessageLookupByLibrary.simpleMessage("Pending"),
    "success": MessageLookupByLibrary.simpleMessage("Success"),
    "tagsHint": MessageLookupByLibrary.simpleMessage(
      "Enter tags (comma separated)",
    ),
    "taskDeleted": MessageLookupByLibrary.simpleMessage(
      "Task deleted successfully",
    ),
    "taskDescriptionHint": MessageLookupByLibrary.simpleMessage(
      "Enter task description",
    ),
    "taskTitleHint": MessageLookupByLibrary.simpleMessage("Enter task title"),
    "thisMonth": MessageLookupByLibrary.simpleMessage("This Month"),
    "thisWeek": MessageLookupByLibrary.simpleMessage("This Week"),
    "today": MessageLookupByLibrary.simpleMessage("Today"),
    "todoDescription": MessageLookupByLibrary.simpleMessage("Description"),
    "todoDueDate": MessageLookupByLibrary.simpleMessage("Due Date"),
    "todoPriority": MessageLookupByLibrary.simpleMessage("Priority"),
    "todoStatus": MessageLookupByLibrary.simpleMessage("Status"),
    "todoTags": MessageLookupByLibrary.simpleMessage("Tags"),
    "todoTitle": MessageLookupByLibrary.simpleMessage("Title"),
    "tomorrow": MessageLookupByLibrary.simpleMessage("Tomorrow"),
    "totalTasks": MessageLookupByLibrary.simpleMessage("Total Tasks"),
    "totalTodos": MessageLookupByLibrary.simpleMessage("Total Todos"),
    "upcomingDeadlines": MessageLookupByLibrary.simpleMessage(
      "Upcoming Deadlines",
    ),
    "useDemoCredentials": MessageLookupByLibrary.simpleMessage(
      "Use Demo Credentials",
    ),
    "version": m3,
    "welcomeBack": m4,
    "yes": MessageLookupByLibrary.simpleMessage("Yes"),
    "yesterday": MessageLookupByLibrary.simpleMessage("Yesterday"),
  };
}
