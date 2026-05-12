# 📋 Smart Attendance App

A **Flutter mobile application** for real-time student and faculty attendance tracking, powered by Firebase Firestore with live stream updates.

---

## 🛠️ Tech Stack

| Layer      | Technology                     |
|------------|--------------------------------|
| Framework  | Flutter (Dart)                 |
| State Mgmt | Riverpod / Provider            |
| Backend    | Firebase (Firestore, Auth)     |
| Auth       | Firebase OTP / Email Auth      |
| Database   | Cloud Firestore (real-time)    |

---

## ✨ Features

- 👨‍🏫 **Faculty Module** — Start attendance sessions, view live student check-ins in real-time
- 👨‍🎓 **Student Module** — Mark attendance by scanning QR / tapping in session
- 📊 **Attendance Reports** — Per-subject attendance percentages
- 🔴 **Live Updates** — Faculty view updates instantly as students mark attendance
- 🔐 **Role-based Auth** — Separate student and faculty login flows
- 📱 **Responsive UI** — Material Design, works on Android and iOS

---

## ⚙️ Setup & Installation

### Prerequisites
- Flutter SDK (v3.x or later)
- Firebase project with Authentication and Firestore enabled

### Steps

1. **Clone the repository**
```bash
git clone https://github.com/VashimSipai/smart-attendance-app.git
cd smart-attendance-app
```

2. **Add Firebase config**  
   - Android: place `google-services.json` in `android/app/`
   - iOS: place `GoogleService-Info.plist` in `ios/Runner/`

3. **Install dependencies**
```bash
flutter pub get
```

4. **Run the app**
```bash
flutter run
```

---

## 👤 Author

**Vashim Sipai**  
GitHub: [@VashimSipai](https://github.com/VashimSipai)

---

## 📄 License

ISC License
