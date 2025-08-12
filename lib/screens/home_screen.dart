import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_models/task_view_model.dart';
import '../view_models/auth_view_model.dart';
import '../widgets/task_card.dart';
import '../models/task_model.dart';
import 'add_edit_task_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  String _searchQuery = '';
  String _selectedPriority = 'All';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    // Load tasks when the screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TaskViewModel>().loadTasks();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Consumer<AuthViewModel>(
          builder: (context, authViewModel, child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('To-Do List'),
                if (authViewModel.currentUser != null)
                  Text(
                    'Welcome, ${authViewModel.currentUser!.name}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
              ],
            );
          },
        ),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) async {
              if (value == 'logout') {
                final authViewModel = Provider.of<AuthViewModel>(
                  context,
                  listen: false,
                );
                await authViewModel.signOut();
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem(
                  value: 'logout',
                  child: Row(
                    children: [
                      Icon(Icons.logout, color: Colors.red),
                      SizedBox(width: 8),
                      Text('Logout'),
                    ],
                  ),
                ),
              ];
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(text: 'All Tasks'),
            Tab(text: 'Pending'),
            Tab(text: 'Completed'),
          ],
        ),
      ),
      body: Column(
        children: [
          // Search and filter section
          Container(
            color: Theme.of(context).primaryColor,
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Search bar
                TextField(
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Search tasks...',
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                ),

                const SizedBox(height: 12),

                // Priority filter
                Row(
                  children: [
                    const Text(
                      'Priority: ',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Expanded(
                      child: DropdownButton<String>(
                        value: _selectedPriority,
                        dropdownColor: Colors.white,
                        style: const TextStyle(color: Colors.black),
                        underline: Container(height: 2, color: Colors.white),
                        items: ['All', 'High', 'Medium', 'Low']
                            .map(
                              (priority) => DropdownMenuItem(
                                value: priority,
                                child: Text(priority),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedPriority = value ?? 'All';
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Task list
          Expanded(
            child: Consumer<TaskViewModel>(
              builder: (context, taskViewModel, child) {
                if (taskViewModel.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                return TabBarView(
                  controller: _tabController,
                  children: [
                    _buildTaskList(taskViewModel.tasks, taskViewModel),
                    _buildTaskList(
                      taskViewModel.incompleteTasks,
                      taskViewModel,
                    ),
                    _buildTaskList(taskViewModel.completedTasks, taskViewModel),
                  ],
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToAddTask(context),
        child: const Icon(Icons.add),
        tooltip: 'Add new task',
      ),
    );
  }

  Widget _buildTaskList(List<Task> tasks, TaskViewModel taskViewModel) {
    // Apply search filter
    List<Task> filteredTasks = tasks;

    if (_searchQuery.isNotEmpty) {
      filteredTasks = taskViewModel
          .searchTasks(_searchQuery)
          .where((task) => tasks.contains(task))
          .toList();
    }

    // Apply priority filter
    if (_selectedPriority != 'All') {
      filteredTasks = filteredTasks
          .where((task) => task.priority == _selectedPriority)
          .toList();
    }

    if (filteredTasks.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.task_alt, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              _getEmptyMessage(),
              style: TextStyle(fontSize: 18, color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            Text(
              'Tap the + button to add a new task',
              style: TextStyle(fontSize: 14, color: Colors.grey[500]),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => taskViewModel.loadTasks(),
      child: ListView.builder(
        itemCount: filteredTasks.length,
        itemBuilder: (context, index) {
          final task = filteredTasks[index];
          return TaskCard(
            task: task,
            onTap: () => _navigateToEditTask(context, task),
            onDelete: () => _showDeleteDialog(context, task, taskViewModel),
            onToggleComplete: (value) =>
                _toggleTaskCompletion(task, taskViewModel),
          );
        },
      ),
    );
  }

  String _getEmptyMessage() {
    switch (_tabController.index) {
      case 1:
        return 'No pending tasks';
      case 2:
        return 'No completed tasks';
      default:
        return 'No tasks yet';
    }
  }

  void _navigateToAddTask(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => const AddEditTaskScreen()));
  }

  void _navigateToEditTask(BuildContext context, Task task) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => AddEditTaskScreen(task: task)),
    );
  }

  void _showDeleteDialog(
    BuildContext context,
    Task task,
    TaskViewModel taskViewModel,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Task'),
          content: Text('Are you sure you want to delete "${task.title}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _deleteTask(task, taskViewModel);
              },
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void _deleteTask(Task task, TaskViewModel taskViewModel) async {
    final success = await taskViewModel.deleteTask(task.id!);
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Task "${task.title}" deleted successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to delete task'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _toggleTaskCompletion(Task task, TaskViewModel taskViewModel) async {
    final success = await taskViewModel.toggleTaskCompletion(task);
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            task.isCompleted ? 'Task marked as pending' : 'Task completed!',
          ),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 1),
        ),
      );
    }
  }
}
