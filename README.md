# 📝 Flutter To-Do List App

A beautiful and functional to-do list application built with Flutter, featuring local database storage, task management, and an intuitive user interface that helps you stay organized and productive.

---

## 🚀 Features

- ✨ **Create Tasks** - Add new tasks with title, description, due date, and priority
- 📋 **View Tasks** - Display all tasks in an organized list with filtering options
- ✏️ **Edit Tasks** - Update existing tasks with new information
- 🗑️ **Delete Tasks** - Remove tasks with confirmation dialog
- ✅ **Mark Complete** - Toggle task completion status with visual feedback
- 🎯 **Priority Levels** - Organize tasks by High, Medium, and Low priority
- 🔍 **Search & Filter** - Find tasks quickly with search and filter functionality
- 💾 **Local Storage** - Data persists locally using SQLite database
- 🎨 **Clean UI** - Modern Material Design interface with smooth animations

---


## 📂 Project Structure

```
lib/
│
├── main.dart                      # App entry point
├── models/
│   └── task_model.dart           # Task data model
├── databases/
│   └── task_database.dart        # SQLite database operations
├── view_models/
│   └── task_view_model.dart      # Business logic & state management
├── screens/
│   ├── home_screen.dart          # Main task list screen
│   └── add_edit_task_screen.dart # Add/edit task form
└── widgets/
    └── task_card.dart            # Custom task card widget
```

---

## 🧠 Skills Demonstrated

- 🏗️ **MVVM Architecture** - Clean separation of concerns with Model-View-ViewModel pattern
- 📊 **State Management** - Efficient state handling using Provider pattern
- 🗄️ **Database Integration** - SQLite database for persistent local storage
- 🎨 **UI/UX Design** - Material Design principles with custom widgets
- 🔄 **CRUD Operations** - Complete Create, Read, Update, Delete functionality
- 📱 **Responsive Design** - Adaptive layouts for different screen sizes
- ⚡ **Performance** - Optimized list rendering with ListView.builder
- 🧪 **Code Organization** - Clean, maintainable, and scalable code structure

---

## 🛠 Technologies Used

- **Flutter** (Dart) - Cross-platform mobile development framework
- **SQLite** (`sqflite` package) - Local database storage
- **Provider** - State management solution
- **Material Design** - UI components and design system
- **Path** - File path utilities for database operations

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (version 3.8.1 or higher)
- Dart SDK (included with Flutter)
- VS Code or Android Studio with Flutter plugin

### Installation
1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/flutter-todo-list.git
   cd flutter-todo-list
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

---

## 📦 Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  provider: ^6.1.2        # State management
  sqflite: ^2.4.1         # SQLite database
  path: ^1.9.1            # File path utilities
```

---

## 🗄️ Database Schema

```sql
CREATE TABLE tasks(
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  title TEXT NOT NULL,
  description TEXT NOT NULL,
  date INTEGER NOT NULL,
  priority TEXT NOT NULL,
  isCompleted INTEGER NOT NULL DEFAULT 0
);
```

---

## 🎯 Future Enhancements

- [ ] 🏷️ Task categories/tags
- [ ] 🔔 Task reminders/notifications
- [ ] ☁️ Data backup and sync
- [ ] 🌙 Dark mode support
- [ ] 📤 Task sharing functionality
- [ ] 📊 Statistics and analytics
- [ ] 📁 Import/export tasks
- [ ] 🎨 Custom themes and colors

---

## 🙌 Author

**Your Name**  
Feel free to connect or contribute to this project.

📧 [contact.mhayat@gmail.com](contact.mhayat@gmail.com)  
🔗 [hayat-ishfaq](https://github.com/hayat-ishfaq)

---

> 📌 *This app was developed as part of a Flutter development project showcasing MVVM architecture, state management, and local database integration.*
