import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/providers.dart';

class RiverpodDemoScreen extends ConsumerStatefulWidget {
  const RiverpodDemoScreen({super.key});

  @override
  ConsumerState<RiverpodDemoScreen> createState() => _RiverpodDemoScreenState();
}

class _RiverpodDemoScreenState extends ConsumerState<RiverpodDemoScreen>
    with TickerProviderStateMixin {
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    final darkMode = ref.watch(darkModeProvider);
    final appConfig = ref.watch(appConfigProvider);

    return Theme(
      data: Theme.of(
        context,
      ).copyWith(brightness: darkMode ? Brightness.dark : Brightness.light),
      child: Scaffold(
        backgroundColor: darkMode ? Colors.grey[900] : Colors.grey[50],
        appBar: AppBar(
          title: Text('${appConfig.appName} - Riverpod Demo'),
          backgroundColor: darkMode ? Colors.grey[800] : Colors.blue[600],
          foregroundColor: Colors.white,
        ),
        body: Column(
          children: [
            // Tab Bar
            Container(
              color: darkMode ? Colors.grey[800] : Colors.white,
              child: TabBar(
                controller: TabController(
                  length: 4,
                  vsync: this,
                  initialIndex: _selectedTab,
                ),
                onTap: (index) => setState(() => _selectedTab = index),
                tabs: const [
                  Tab(text: 'Provider Types'),
                  Tab(text: 'Modifiers'),
                  Tab(text: 'Performance'),
                  Tab(text: 'Advanced'),
                ],
                labelColor: darkMode ? Colors.white : Colors.black87,
                unselectedLabelColor: darkMode
                    ? Colors.grey[400]
                    : Colors.grey[600],
                indicatorColor: darkMode ? Colors.blue[400] : Colors.blue[600],
              ),
            ),

            // Tab Content
            Expanded(
              child: IndexedStack(
                index: _selectedTab,
                children: [
                  _buildProviderTypesTab(),
                  _buildModifiersTab(),
                  _buildPerformanceTab(),
                  _buildAdvancedTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProviderTypesTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Core Provider Types'),

          // Provider (Immutable values)
          _buildProviderCard(
            'Provider',
            'Immutable values (app configuration, constants)',
            'App Config: ${ref.watch(appConfigProvider).appName}',
            Colors.blue,
          ),

          // StateProvider (Simple state)
          _buildStateProviderCard(),

          // StateNotifierProvider (Complex state)
          _buildStateNotifierProviderCard(),

          // FutureProvider (Async operations)
          _buildFutureProviderCard(),

          // StreamProvider (Real-time data)
          _buildStreamProviderCard(),

          const SizedBox(height: 24),
          _buildSectionTitle('Provider Reading Methods'),

          _buildReadingMethodsCard(),
        ],
      ),
    );
  }

  Widget _buildModifiersTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Provider Modifiers'),

          // Family modifier
          _buildFamilyModifierCard(),

          // AutoDispose modifier
          _buildAutoDisposeModifierCard(),

          // Family + AutoDispose
          _buildCombinedModifierCard(),

          const SizedBox(height: 24),
          _buildSectionTitle('Provider Composition'),

          _buildCompositionCard(),
        ],
      ),
    );
  }

  Widget _buildPerformanceTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Performance Optimizations'),

          // Select method
          _buildSelectCard(),

          // Lazy loading
          _buildLazyLoadingCard(),

          // Granular providers
          _buildGranularProvidersCard(),

          const SizedBox(height: 24),
          _buildSectionTitle('Consumer Widgets'),

          _buildConsumerWidgetsCard(),
        ],
      ),
    );
  }

  Widget _buildAdvancedTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Advanced Features'),

          // Computed/Derived State
          _buildComputedStateCard(),

          // Provider Dependencies
          _buildDependenciesCard(),

          // Error Handling
          _buildErrorHandlingCard(),

          // AsyncValue handling
          _buildAsyncValueCard(),

          const SizedBox(height: 24),
          _buildSectionTitle('Testing Features'),

          _buildTestingCard(),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    final darkMode = ref.watch(darkModeProvider);
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: darkMode ? Colors.white : Colors.black87,
        ),
      ),
    );
  }

  Widget _buildProviderCard(
      String title,
      String description,
      String example,
      Color color,
      ) {
    final darkMode = ref.watch(darkModeProvider);
    return Card(
      color: darkMode ? Colors.grey[800] : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    title,
                    style: TextStyle(fontWeight: FontWeight.bold, color: color),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: TextStyle(
                color: darkMode ? Colors.grey[300] : Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: darkMode ? Colors.grey[700] : Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                example,
                style: TextStyle(
                  fontFamily: 'monospace',
                  color: darkMode ? Colors.green[300] : Colors.green[700],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStateProviderCard() {
    final darkMode = ref.watch(darkModeProvider);
    final searchQuery = ref.watch(searchQueryProvider);

    return Card(
      color: darkMode ? Colors.grey[800] : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'StateProvider',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Simple state management (theme toggle, filter selection)',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Search Query (StateProvider)',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                ref.read(searchQueryProvider.notifier).state = value;
              },
            ),
            const SizedBox(height: 8),
            Text('Current value: "$searchQuery"'),
          ],
        ),
      ),
    );
  }

  Widget _buildStateNotifierProviderCard() {
    final darkMode = ref.watch(darkModeProvider);
    final authState = ref.watch(authStateProvider);

    return Card(
      color: darkMode ? Colors.grey[800] : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.purple.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'StateNotifierProvider',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.purple,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Complex state management (todo list, cart)',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            Text('Auth Status: ${authState.status.name}'),
            if (authState.isAuthenticated)
              Text('User: ${authState.user?.name}'),
            const SizedBox(height: 8),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    ref.read(authStateProvider.notifier).clearError();
                  },
                  child: const Text('Clear Error'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    ref.read(authStateProvider.notifier).refreshUser();
                  },
                  child: const Text('Refresh User'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFutureProviderCard() {
    final darkMode = ref.watch(darkModeProvider);
    final currentUser = ref.watch(currentUserProvider);

    return Card(
      color: darkMode ? Colors.grey[800] : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'FutureProvider',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Async operations (API calls, database queries)',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            currentUser.when(
              data: (user) =>
                  Text('Current User: ${user?.name ?? "Not logged in"}'),
              loading: () => const CircularProgressIndicator(),
              error: (error, stack) => Text('Error: $error'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                ref.invalidate(currentUserProvider);
              },
              child: const Text('Refresh'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStreamProviderCard() {
    final darkMode = ref.watch(darkModeProvider);
    final authStateStream = ref.watch(authStateStreamProvider);

    return Card(
      color: darkMode ? Colors.grey[800] : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.teal.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'StreamProvider',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Real-time data (WebSocket, Firebase streams)',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            authStateStream.when(
              data: (state) => Text('Stream Status: ${state.status.name}'),
              loading: () => const CircularProgressIndicator(),
              error: (error, stack) => Text('Error: $error'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReadingMethodsCard() {
    final darkMode = ref.watch(darkModeProvider);

    return Card(
      color: darkMode ? Colors.grey[800] : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Reading Providers',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildMethodItem(
              'ref.watch',
              'Listen to changes in build method',
              'final value = ref.watch(myProvider);',
            ),
            _buildMethodItem(
              'ref.read',
              'One-time read in event handlers',
              'ref.read(myProvider.notifier).doSomething();',
            ),
            _buildMethodItem(
              'ref.listen',
              'Side effects (navigation, snackbars)',
              'ref.listen(myProvider, (prev, next) => ...);',
            ),
            _buildMethodItem(
              'ref.invalidate',
              'Force provider refresh',
              'ref.invalidate(myProvider);',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMethodItem(String method, String description, String example) {
    final darkMode = ref.watch(darkModeProvider);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            method,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: darkMode ? Colors.white : Colors.black87,
            ),
          ),
          Text(
            description,
            style: TextStyle(
              color: darkMode ? Colors.grey[300] : Colors.grey[600],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: darkMode ? Colors.grey[700] : Colors.grey[100],
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              example,
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 12,
                color: darkMode ? Colors.green[300] : Colors.green[700],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFamilyModifierCard() {
    final darkMode = ref.watch(darkModeProvider);
    final userProfile = ref.watch(userProfileProvider('demo-user-id'));

    return Card(
      color: darkMode ? Colors.grey[800] : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.indigo.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'Family Modifier',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Parameterized providers (fetch user by ID)',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            userProfile.when(
              data: (user) =>
                  Text('User Profile: ${user?.name ?? "Not found"}'),
              loading: () => const CircularProgressIndicator(),
              error: (error, stack) => Text('Error: $error'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAutoDisposeModifierCard() {
    final darkMode = ref.watch(darkModeProvider);
    final tempData = ref.watch(temporaryDataProvider);

    return Card(
      color: darkMode ? Colors.grey[800] : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.amber.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'AutoDispose Modifier',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.amber,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Automatic cleanup when no longer used',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            Text('Temporary Data: $tempData'),
            const SizedBox(height: 8),
            const Text(
              'This provider will be disposed when not watched',
              style: TextStyle(
                fontSize: 12,
                fontStyle: FontStyle.italic,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCombinedModifierCard() {
    final darkMode = ref.watch(darkModeProvider);
    final userData = ref.watch(userSpecificDataProvider('demo-user'));

    return Card(
      color: darkMode ? Colors.grey[800] : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.pink.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'Family + AutoDispose',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.pink,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Combined for optimal resource management',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            Text('User Specific Data: $userData'),
          ],
        ),
      ),
    );
  }

  Widget _buildCompositionCard() {
    final darkMode = ref.watch(darkModeProvider);
    final filteredTodos = ref.watch(filteredTodosProvider('demo-user'));

    return Card(
      color: darkMode ? Colors.grey[800] : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Provider Composition',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Combining multiple providers to create derived state',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            Text('Filtered Todos Count: ${filteredTodos.length}'),
            const SizedBox(height: 8),
            const Text(
              'This provider combines:\n• Todo list provider\n• Search query provider\n• Filter providers\n• Sort order provider',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectCard() {
    final darkMode = ref.watch(darkModeProvider);
    final todoCount = ref.watch(todoCountProvider('demo-user'));

    return Card(
      color: darkMode ? Colors.grey[800] : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.cyan.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'select() Method',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.cyan,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Subscribe to partial state for performance',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            Text('Todo Count: $todoCount'),
            const SizedBox(height: 8),
            const Text(
              'Only rebuilds when todo count changes, not when individual todos change',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLazyLoadingCard() {
    final darkMode = ref.watch(darkModeProvider);
    final lazyData = ref.watch(lazyDataProvider);

    return Card(
      color: darkMode ? Colors.grey[800] : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.deepOrange.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'Lazy Loading',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.deepOrange,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Loading data on demand',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            lazyData.when(
              data: (data) => Text('Lazy Data: $data'),
              loading: () => const CircularProgressIndicator(),
              error: (error, stack) => Text('Error: $error'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                ref.invalidate(lazyDataProvider);
              },
              child: const Text('Load Data'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGranularProvidersCard() {
    final darkMode = ref.watch(darkModeProvider);

    return Card(
      color: darkMode ? Colors.grey[800] : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Provider Granularity',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Splitting providers correctly for optimal performance',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            const Text(
              'Best Practices:\n'
                  '• Separate concerns into different providers\n'
                  '• Use specific providers instead of large state objects\n'
                  '• Create computed providers for derived state\n'
                  '• Use autoDispose for temporary data',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConsumerWidgetsCard() {
    final darkMode = ref.watch(darkModeProvider);

    return Card(
      color: darkMode ? Colors.grey[800] : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Consumer Widgets',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildWidgetItem('ConsumerWidget', 'Replacing StatelessWidget'),
            _buildWidgetItem(
              'ConsumerStatefulWidget',
              'With lifecycle methods',
            ),
            _buildWidgetItem('Consumer', 'Localized rebuilds for optimization'),
          ],
        ),
      ),
    );
  }

  Widget _buildWidgetItem(String widget, String description) {
    final darkMode = ref.watch(darkModeProvider);

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Text(
            widget,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: darkMode ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '- $description',
            style: TextStyle(
              color: darkMode ? Colors.grey[300] : Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComputedStateCard() {
    final darkMode = ref.watch(darkModeProvider);
    final searchSuggestions = ref.watch(searchSuggestionsProvider);

    return Card(
      color: darkMode ? Colors.grey[800] : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.lime.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'Computed/Derived State',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.lime,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Filtering, sorting, transformations',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            Text('Search Suggestions: ${searchSuggestions.join(', ')}'),
          ],
        ),
      ),
    );
  }

  Widget _buildDependenciesCard() {
    final darkMode = ref.watch(darkModeProvider);

    return Card(
      color: darkMode ? Colors.grey[800] : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Provider Dependencies',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Watching other providers',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            const Text(
              'Providers can depend on other providers:\n'
                  '• Use ref.watch() to depend on other providers\n'
                  '• Automatic invalidation when dependencies change\n'
                  '• Circular dependencies are handled gracefully',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorHandlingCard() {
    final darkMode = ref.watch(darkModeProvider);
    final errorState = ref.watch(errorStateProvider);

    return Card(
      color: darkMode ? Colors.grey[800] : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'Error Handling',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Graceful error UI and retry mechanisms',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            Text('Error State: ${errorState ?? "No errors"}'),
            const SizedBox(height: 8),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    ref.read(errorStateProvider.notifier).state = 'Test error';
                  },
                  child: const Text('Set Error'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    ref.read(errorStateProvider.notifier).state = null;
                  },
                  child: const Text('Clear Error'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAsyncValueCard() {
    final darkMode = ref.watch(darkModeProvider);

    return Card(
      color: darkMode ? Colors.grey[800] : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'AsyncValue Handling',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'Methods for handling async states:\n'
                  '• AsyncValue.when() - Handle loading/error/data states\n'
                  '• AsyncValue.maybeWhen() - Partial state handling\n'
                  '• AsyncValue.hasValue - Check if has data\n'
                  '• AsyncValue.hasError - Check if has error\n'
                  '• AsyncValue.isLoading - Check if loading',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTestingCard() {
    final darkMode = ref.watch(darkModeProvider);

    return Card(
      color: darkMode ? Colors.grey[800] : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Testing Features',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'Testing capabilities:\n'
                  '• Provider Overrides - Mocking for tests\n'
                  '• Integration Testing - End-to-end with Riverpod\n'
                  '• ProviderContainer for testing\n'
                  '• Easy provider mocking and stubbing',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
