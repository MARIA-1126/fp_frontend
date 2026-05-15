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


---

## 👩‍💻 Backend & Logic Implementation

### Developed by Qudsia ✨

While Myria created the beautiful UI, task model, and core task completion toggle, I implemented the backend logic, data persistence, and advanced features that make this app fully functional.

---

## 🛠️ Technical Implementation

| Component | Technology |
|-----------|------------|
| **Local Storage** | Hive (NoSQL database) |
| **State Management** | Provider pattern |
| **Notifications** | flutter_local_notifications |
| **Task Reordering** | ReorderableListView |
| **CRUD Operations** | Full implementation |

---

## 📋 Features I Added

### ✅ Core Backend Features
- **Hive Integration** - Persistent local storage that survives app restarts
- **Full CRUD Operations** - Create, Read, Update, Delete tasks with Hive
- **State Management with Provider** - Real-time updates across all screens
- **Updated Task Model** - Added Hive annotations, order field, and due date support to Maria's model

### ✅ Advanced Features
- **Task Reordering** - Drag and drop to rearrange tasks within each quadrant
- **Daily Notifications** - Two reminders:
  - Morning reminder at 9:00 AM: "Plan your tasks for today"
  - Evening reminder at 7:00 PM: "Complete pending tasks"
- **Pending Task Counter** - Real-time count of incomplete tasks

### ✅ Data Persistence
- All tasks persist after app restarts
- Task order is maintained after reordering
- Completion status is saved

### ✅ Integration with UI
- Connected Maria's UI components to Hive storage
- Ensured all CRUD operations work from both Home Screen and Quadrant Tasks Screen
- Fixed state synchronization issues between screens
- Implemented task completion toggle on the Quadrant Tasks Screen

---

## 🐛 Issues Fixed in Code

| Issue | Problem | My Fix |
|-------|---------|--------|
| **Mock Data** | Tasks were hardcoded | Replaced with Hive database |
| **State Sync** | Quadrant screen didn't update after actions | Implemented Provider for global state |
| **Navigation** | Quadrant tiles didn't navigate | Added tap navigation to Quadrant Tasks Screen |
| **Task Persistence** | Tasks disappeared after app restart | Implemented Hive storage |
| **Reorder Logic** | No reordering capability | Added ReorderableListView with order field |

---

## 🔧 Technical Challenges Solved

- **Hive Enum Support** - Registered adapters for both TaskModel and QuadrantType enum
- **Provider Integration** - Connected Provider across multiple screens
- **Notification Permissions** - Configured Android permissions for notifications
- **ReorderableListView Indexing** - Fixed index adjustment for drag-and-drop
- **Singleton Pattern** - Implemented for TaskStorageService to prevent multiple box openings

---

## 📁 My Code Structure

```
lib/
├── providers/
│   └── task_provider.dart      (State management)
├── services/
│   ├── task_storage_service.dart (Hive CRUD operations)
│   └── notification_service.dart (Daily reminders)
└── utils/
    └── id_utils.dart           (Unique ID generation)
```

---

## 🔮 Future Improvements (My Wishlist)

- **Cloud Sync** - Sync tasks across devices
- **Task Sharing** - Share tasks with other users
- **Analytics** - Track productivity patterns
- **Export Tasks** - Export to PDF or CSV
- **Voice Input** - Add tasks using voice commands

---

## 👩‍💻 My Contribution Summary

| Metric | Value |
|--------|-------|
| **Lines of Code** | ~450+ |
| **New Files Created** | 4 |
| **Features Implemented** | 10+ |
| **Bugs Fixed** | 5+ |

---

## 🙏 Acknowledgments

Thank you to Myria for:
- Creating the beautiful UI design
- Building the Task Model
- Implementing the task completion toggle logic
- Trusting me with the backend implementation

This project taught me:
- State management with Provider
- Local database integration with Hive
- Notification scheduling
- Working with enums in Hive
- Real-time UI updates with ChangeNotifier

---

**This app is now fully functional with persistent storage, notifications, and task reordering!** 🚀
