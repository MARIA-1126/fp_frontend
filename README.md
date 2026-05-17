Priority Matrix Project

A simple and interactive Priority Matrix Mobile Application built using Flutter. This application helps users organize and manage their tasks based on priority and urgency using the Eisenhower Matrix method.

📌 Project Overview

The Priority Matrix app allows users to categorize tasks into four different sections for better productivity and time management.

The matrix is divided into:

Important & Urgent Important but Not Urgent Urgent but Not Important Neither Urgent nor Important

This project focuses on providing a clean and user-friendly mobile interface for efficient task organization.

✨ Features Add and manage tasks Organize tasks into priority categories Simple and responsive UI Interactive task management interface Clean mobile app design Easy navigation and usability 🛠 Technologies Used Flutter Dart 🚀 How to Run the Project Download or clone the repository Open the project in Flutter-supported IDE (VS Code or Android Studio) Run the following command: flutter pub get Start the application using: flutter run 🎯 Purpose of the Project

The main purpose of this project is to practice:

Mobile app development using Flutter UI/UX design State management concepts Task management system creation Productivity app interface development 🔮 Future Improvements Firebase integration User authentication Cloud database storage Task reminders and notifications Dark mode Drag and drop functionality Advanced task filters 👩‍💻 Author

Developed by Myria ✨

Here's your updated README section with the **issues that need fixing** added:

---

## 👩‍💻 Backend & Logic Implementation

### Developed by Qudsia ✨

While Maria focused on the beautiful UI and layout, I implemented the backend logic, data persistence, and advanced features that make this app fully functional.

---

## 🛠️ Technical Implementation

| Component | Technology |
|-----------|------------|
| **Local Storage** | Hive (NoSQL database) |
| **State Management** | Provider pattern |
| **Task Reordering** | ReorderableListView with drag-and-drop |
| **Calendar Integration** | add_2_calendar package |
| **Splash Screen** | Lottie animations + flutter_native_splash |

---

## 📋 Features I Added

### ✅ Core Backend Features
- **Hive Integration** - Persistent local storage that survives app restarts
- **Full CRUD Operations** - Create, Read, Update, and Delete tasks
- **State Management with Provider** - Real-time updates across all screens (Home, Add, Edit, Quadrant)
- **Task Model** - Complete data model with ID, title, note, quadrant, due date, completion status, creation date, and order field

### ✅ Advanced Features
- **Task Reordering** - Drag and drop to rearrange tasks within each quadrant using ReorderableListView
- **Daily Notifications** - Two reminders:
  - Morning reminder at 9:00 AM: *"Good morning! Plan your tasks for today"*
  - Evening reminder at 7:00 PM: *"You have X pending tasks. Complete them before the day ends!"*
- **Calendar Integration** - Tasks with due dates are automatically synced to the user's device calendar
- **Pending Task Counter** - Real-time count of incomplete tasks displayed on the home screen
- **Dark Mode** - Full dark/light theme toggle across all screens
- **Splash Screen** - Professional animated splash screen using Lottie that loads data in the background
- **Quadrant Navigation** - Tap any quadrant to view all tasks in that quadrant on a dedicated screen
- **Task Completion** - Full toggle functionality with visual feedback (grayed out with strikethrough)

### ✅ Data Persistence
- All tasks persist after app restarts
- Task order is maintained after reordering
- Completion status is saved
- Due dates are stored and used for sorting and calendar sync

---

## 🐛 Issues Fixed in Maria's Code

| Issue | Problem | My Fix |
|-------|---------|--------|
| **Mock Data** | Tasks were hardcoded | Replaced with Hive database |
| **State Sync** | Quadrant screen didn't update after actions | Implemented Provider for global state |
| **Navigation** | Quadrant tiles didn't navigate | Added tap navigation to Quadrant Tasks Screen |
| **Task Persistence** | Tasks disappeared after app restart | Implemented Hive storage |
| **Reorder Logic** | No reordering capability | Added ReorderableListView with order field |

---

## 🔧 Technical Challenges Solved

| Challenge | Solution |
|-----------|----------|
| **Hive Enum Support** | Registered adapters for both TaskModel and QuadrantType enum |
| **Provider Integration** | Connected Provider across multiple screens using ChangeNotifier |
| **Notification Permissions** | Configured Android permissions for notifications |
| **ReorderableListView Indexing** | Fixed index adjustment for drag-and-drop: `if (oldIndex < newIndex) newIndex -= 1` |
| **Singleton Pattern** | Implemented for TaskStorageService to prevent multiple box openings |
| **Calendar Event Visibility** | Added specific time (9:00 AM) instead of midnight to ensure events appear |
| **Splash Screen Data Loading** | Used `addPostFrameCallback` to load data after widget tree is built |

---

## ⚠️ Known Issues That Need Fixing

### 🔴 Notifications
| Issue | Description | Status |
|-------|-------------|--------|
| **Notification permission prompt** | The app doesn't request notification permissions on first launch (Android 13+) | ⚠️ Needs fix |
| **Notification cancellation** | When toggling notifications off, all notifications are cancelled but the setting doesn't persist after app restart | ⚠️ Needs fix |
| **Scheduled time accuracy** | Notifications may fire at slightly different times due to Android's battery optimization | ⚠️ Needs fix |

### 🔴 Reorder
| Issue | Description | Status |
|-------|-------------|--------|
| **Reorder handle visibility** | The drag handle icon doesn't appear consistently on all Android devices | ⚠️ Needs fix |
| **Cross-quadrant reorder** | Tasks cannot be dragged between quadrants (only within the same quadrant) | ⚠️ Needs fix |

### 🔴 Calendar Integration
| Issue | Description | Status |
|-------|-------------|--------|
| **Event update** | When a task's due date is edited, the existing calendar event is not updated (new event is created instead) | ⚠️ Needs fix |
| **Event deletion** | When a task is deleted, the calendar event remains in the device calendar | ⚠️ Needs fix |
| **Multiple calendar accounts** | The event is added to the first available calendar, not necessarily the user's preferred calendar | ⚠️ Needs fix |
| **Event duplication** | If the user edits a task multiple times, duplicate events may be created | ⚠️ Needs fix |

---

## 📁 My Code Structure

```
lib/
├── models/
│   └── task_models.dart        (Hive annotations + model with order field)
├── providers/
│   └── task_provider.dart      (State management with ChangeNotifier)
├── services/
│   ├── task_storage_service.dart (Hive CRUD operations with singleton pattern)
│   └── calendar_service.dart     (Calendar sync using add_2_calendar)
├── screens/
│   ├── quadrant_tasks_screen.dart (Reordered tasks with drag-and-drop)
│   └── splash_screen.dart        (Lottie animated splash with data loading)

```

---

## 🔮 Future Improvements (My Wishlist)

- **Cloud Sync** - Sync tasks across devices using Firebase
- **Task Sharing** - Share tasks with other users
- **Analytics** - Track productivity patterns
- **Export Tasks** - Export to PDF or CSV
- **Recurring Tasks** - Support for daily/weekly recurring tasks
- **Calendar Update** - Add ability to update/delete calendar events when tasks change

---

## 🙏 Acknowledgments

Thank you to Maria for:
- Creating the beautiful UI design
- Building the Task Model
- Implementing the task completion toggle logic
- Trusting me with the backend implementation

---

## 🎯 What I Learned

This project taught me:
- **State Management** - Using Provider with ChangeNotifier for real-time updates
- **Local Storage** - Hive integration with custom adapters for enums
- **Calendar Integration** - Syncing tasks with device calendar using add_2_calendar
- **Task Reordering** - Implementing drag-and-drop with ReorderableListView
- **Splash Screens** - Creating animated splash screens with Lottie
- **Collaboration** - Working with a team using Git/GitHub
- **Debugging** - Troubleshooting build errors, permission issues, and state sync problems

---

**This app is now fully functional with persistent storage, notifications, calendar sync, and task reordering!** 🚀


---

