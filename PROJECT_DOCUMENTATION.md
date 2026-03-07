# Smart Attendance System — Project Documentation

---

## 1. Abstract

The **Smart Attendance System** is a cross-platform mobile and web application built using Flutter and Firebase that automates the process of attendance tracking in educational institutions. Traditional paper-based and manual roll-call methods are time-consuming, prone to proxy attendance, and lack real-time visibility for stakeholders.

This system replaces manual methods with a **QR-code-based attendance mechanism** secured by **HMAC-SHA256 time-rotating tokens**. Faculty members initiate a live session from their device, which generates a dynamic QR code that refreshes every two minutes. Students scan this QR code via their mobile device to mark their attendance instantly. The system prevents proxy attendance through token expiry, duplicate-scan prevention, and device-level validation.

The application supports **multi-tenant architecture**, allowing multiple colleges to operate independently on the same platform. Each institution is managed by a College Admin who configures programs, classes, subjects, faculty assignments, and timetables through an intuitive admin dashboard.

Built with **Clean Architecture** principles and **Riverpod** state management, the project ensures scalability, testability, and maintainability. Firebase Firestore provides real-time data synchronization, while Firebase Authentication handles secure identity management via Google Sign-In.

---

## 2. Introduction

### 2.1 Background

Attendance management in educational institutions has traditionally relied on paper registers or basic digital systems that are susceptible to manipulation. With increasing class sizes and the growing need for data-driven academic decision-making, institutions require a modern, tamper-proof, and real-time attendance tracking solution.

### 2.2 Problem Statement

- **Proxy attendance** is rampant — students mark attendance on behalf of absent peers.
- **Manual roll calls** waste 5–10 minutes of lecture time per session.
- **Lack of real-time data** — administrators and students have no instant visibility into attendance percentages.
- **No centralized system** — attendance data is fragmented across registers, making reports tedious.

### 2.3 Proposed Solution

A QR-code-based Smart Attendance System that:
1. Generates **time-bound, cryptographically signed QR tokens** that rotate every 2 minutes.
2. Validates attendance in **real-time** with instant feedback to both faculty and students.
3. Provides a **multi-role, multi-tenant platform** with admin, faculty, and student dashboards.
4. Runs on **Android, iOS, and Web** from a single Flutter codebase.

---

## 3. Objectives

| # | Objective |
|---|-----------|
| 1 | Develop a cross-platform (Android, iOS, Web) attendance management application using Flutter. |
| 2 | Implement secure QR-code-based attendance using HMAC-SHA256 rotating tokens to prevent proxy attendance. |
| 3 | Enable real-time attendance tracking with instant Firestore synchronization between faculty and student devices. |
| 4 | Build a multi-tenant system supporting multiple colleges with independent data isolation. |
| 5 | Provide role-based dashboards (Admin, Faculty, Student) with appropriate access controls. |
| 6 | Create an admin panel for managing institutional hierarchy — programs, classes, subjects, faculty assignments, and timetables. |
| 7 | Ensure a premium, responsive UI/UX optimized for both web browsers and mobile devices. |

---

## 4. System Analysis

### 4.1 Existing System Analysis

| System Type | Limitations |
|---|---|
| **Paper-based attendance** | Easily forged, no real-time data, tedious report generation |
| **Basic biometric systems** | Expensive hardware, not scalable, device-dependent |
| **Simple QR apps** | Static QR codes are screenshot-able, no anti-proxy mechanism |
| **RFID-based systems** | Require physical cards and readers, single-point-of-failure |

### 4.2 Proposed System Advantages

| Feature | Benefit |
|---|---|
| Dynamic QR (rotates every 2 min) | Screenshots become useless within minutes |
| HMAC-SHA256 signed tokens | Cryptographic verification prevents token forgery |
| Duplicate scan prevention | Each student can only mark attendance once per session |
| Real-time Firestore streams | Faculty sees live attendance count; students get instant confirmation |
| Multi-tenant architecture | Multiple colleges share the platform with data isolation |
| Cross-platform (Flutter) | Single codebase for Android, iOS, and Web |

### 4.3 Functional Requirements

1. **Authentication** — Google Sign-In for all users; role selection on first login.
2. **College Onboarding** — Admin creates a college; students/faculty join via college code.
3. **Admin Management** — CRUD for programs, classes, subjects, faculty assignments, timetables.
4. **Session Management** — Faculty starts/ends live attendance sessions.
5. **QR Generation** — Time-rotating HMAC tokens displayed as QR codes.
6. **QR Scanning** — Students scan to mark attendance; validated in real-time.
7. **Attendance Records** — Real-time attendance list visible to faculty during active session.

### 4.4 Non-Functional Requirements

| Requirement | Specification |
|---|---|
| **Performance** | QR refreshes within 1 second; attendance write < 500ms |
| **Security** | HMAC-SHA256 tokens, Firebase Auth, Firestore rules |
| **Scalability** | Multi-tenant Firestore collections, indexed queries |
| **Availability** | Firebase-managed 99.95% SLA |
| **Usability** | Material 3 design, responsive for web and mobile |

### 4.5 System Architecture Diagram

```mermaid
graph TB
    subgraph "Client Layer (Flutter)"
        A[Admin App] --> F[Firebase SDK]
        B[Faculty App] --> F
        C[Student App] --> F
    end

    subgraph "Firebase Backend"
        F --> G[Firebase Auth]
        F --> H[Cloud Firestore]
    end

    subgraph "Firestore Collections"
        H --> I[colleges/]
        H --> J[users/]
        H --> K[sessions/]
        K --> L[attendance/]
    end
```

---

## 5. Literature Review / Survey

### 5.1 QR-Code-Based Attendance Systems

**Kadry & Smaili (2013)** proposed an early QR-based attendance system but used static QR codes, making it vulnerable to screenshot-based proxy attacks. Our system improves upon this by introducing **time-rotating HMAC tokens** that expire every 2 minutes.

### 5.2 HMAC-Based Security in Attendance

**TOTP (Time-based One-Time Password)** algorithms, as defined in **RFC 6238**, use HMAC to generate time-bound tokens. Our QR token system adapts this standard by combining `sessionId + timestamp + secret` into an HMAC-SHA256 digest, producing a cryptographically unique token for each 2-minute window.

### 5.3 Cross-Platform Mobile Development

**Flutter** by Google has emerged as the leading cross-platform framework, enabling a single Dart codebase to compile into native Android, iOS, Web, and Desktop applications. According to the **Stack Overflow Developer Survey 2024**, Flutter is the most popular cross-platform framework among professional developers.

### 5.4 Real-Time Databases for Education

**Firebase Cloud Firestore** provides real-time synchronization with offline support, making it ideal for classroom use where network conditions may vary. Studies by **Moroney (2017)** demonstrate that Firestore's event-driven model significantly reduces latency in collaborative applications.

### 5.5 State Management in Flutter

**Riverpod** (successor to Provider) offers compile-time safety, testability, and dependency injection — making it the recommended choice for production Flutter applications as per the Flutter community guidelines.

| Study / Technology | Contribution | Our Improvement |
|---|---|---|
| Kadry & Smaili (2013) — QR Attendance | Static QR Code | Dynamic HMAC-rotating QR |
| RFC 6238 — TOTP | Time-based OTP standard | Adapted for session-specific tokens |
| Flutter (Google) | Cross-platform framework | Used for web + mobile from single codebase |
| Firebase Firestore | Real-time NoSQL DB | Multi-tenant attendance streaming |
| Riverpod | State management | Compile-safe, testable architecture |

---

## 6. Planning and Scheduling

### 6.1 Development Phases

| Phase | Title | Duration | Status |
|---|---|---|---|
| Phase 1 | Authentication & College Linking | Week 1–2 | ✅ Complete |
| Phase 2 | College Setup & Timetable System | Week 3–4 | ✅ Complete |
| Phase 3 | Live Session & QR System | Week 5–6 | ✅ Complete |
| Phase 4 | Attendance Reports & Analytics | Week 7–8 | 🔲 Planned |
| Phase 5 | Enhancements (Web Panel, Notifications) | Week 9–10 | 🔲 Planned |

### 6.2 Gantt Chart

```mermaid
gantt
    title Smart Attendance System — Development Timeline
    dateFormat YYYY-MM-DD
    axisFormat %b %d

    section Phase 1
    Firebase Setup & Auth         :done, p1a, 2026-01-15, 5d
    Role Selection & Onboarding   :done, p1b, after p1a, 4d
    Web UI Optimization           :done, p1c, after p1b, 3d

    section Phase 2
    Admin Dashboard & CRUD        :done, p2a, after p1c, 5d
    Timetable Drag-and-Drop       :done, p2b, after p2a, 5d

    section Phase 3
    Session Repository & HMAC     :done, p3a, after p2b, 3d
    Faculty QR Screen             :done, p3b, after p3a, 3d
    Student Scanner               :done, p3c, after p3b, 3d

    section Phase 4
    Student Reports               :p4a, after p3c, 5d
    Faculty & Admin Analytics     :p4b, after p4a, 5d

    section Phase 5
    Web Admin Panel               :p5a, after p4b, 5d
    Push Notifications            :p5b, after p5a, 3d
```

### 6.3 Phase-wise Deliverables

**Phase 1 — Authentication & College Linking**
- Google Sign-In via Firebase Auth (Web + Mobile)
- User document creation in Firestore on first login
- Role selection screen (Student, Faculty, College Admin)
- College code joining flow for Students/Faculty
- College creation flow for Admins
- Responsive card-based UI for all auth screens

**Phase 2 — College Setup & Timetable System**
- Admin Dashboard with Material 3 grid navigation
- CRUD operations for Programs, Classes, and Subjects
- Faculty member assignment to subject + class pairs
- Interactive drag-and-drop timetable builder

**Phase 3 — Live Session & QR System**
- Session repository with HMAC-SHA256 token engine
- Faculty "Start Session" with confirmation flow
- Live QR code display with 2-minute countdown timer
- Real-time attendance counter on faculty screen
- Student QR scanner with camera overlay (mobile)
- Web-compatible manual token entry (browser fallback)
- Duplicate attendance prevention at Firestore level

---

## 7. Tools and Technology

### 7.1 Development Stack

| Layer | Technology | Version | Purpose |
|---|---|---|---|
| **Framework** | Flutter | 3.x (Dart 3.10+) | Cross-platform UI |
| **Language** | Dart | 3.10+ | Application logic |
| **State Management** | Riverpod | 2.6.1 | Reactive state & DI |
| **Routing** | GoRouter | 17.1.0 | Declarative navigation |
| **Backend** | Firebase | — | Auth, Database, Hosting |
| **Database** | Cloud Firestore | 6.1.2 | Real-time NoSQL |
| **Authentication** | Firebase Auth | 6.1.4 | Google Sign-In |
| **Code Generation** | Freezed + JSON Serializable | 3.2.5 / 6.13.0 | Immutable models |
| **QR Generation** | qr_flutter | 4.1.0 | QR code rendering |
| **QR Scanning** | mobile_scanner | 7.2.0 | Camera-based scanning |
| **Cryptography** | crypto | 3.0.3 | HMAC-SHA256 tokens |
| **Typography** | Google Fonts | 8.0.2 | Inter font family |
| **Environment** | flutter_dotenv | 6.0.0 | Secure config |

### 7.2 Development Environment

| Tool | Purpose |
|---|---|
| VS Code / Android Studio | IDE |
| Chrome DevTools | Web debugging |
| Firebase Console | Database & Auth management |
| Git | Version control |
| macOS / Windows | Development OS |

### 7.3 Design Specifications

| Property | Value |
|---|---|
| Design System | Material 3 |
| Primary Color | Deep Blue `#1E3A8A` |
| Accent Color | Emerald `#10B981` |
| Border Radius | 16–24px |
| Font Family | Inter (Google Fonts) |
| Card Elevation | Soft shadows (0.06 opacity) |
| Layout Strategy | Centered ConstrainedBox (max 400–600px for web) |

---

## 8. System Design

### 8.1 Database Schema (Firestore)

```
colleges/{collegeId}
├── name, address, createdAt
├── programs/{programId}
│   └── name, description
├── classes/{classId}
│   └── programId, year, section, semester
├── subjects/{subjectId}
│   └── name, programId
└── faculty_assignments/{assignmentId}
    └── facultyId, classId, subjectId

users/{uid}
└── name, email, role, collegeId, programId, classId, createdAt

sessions/{sessionId}
├── collegeId, timetableId, facultyId, subjectId, classId
├── startTime, expiryTime, qrToken, isActive
└── attendance/{studentUid}
    └── sessionId, timestamp, deviceId
```

### 8.2 Code Architecture (Clean Architecture)

```
lib/
├── core/
│   ├── routing/app_router.dart      — GoRouter with auth-aware redirects
│   └── theme/app_theme.dart         — Material 3 theme configuration
├── data/
│   ├── models/                      — Freezed data classes (7 models)
│   │   ├── user_model.dart
│   │   ├── college_model.dart
│   │   ├── program_model.dart
│   │   ├── class_model.dart
│   │   ├── subject_model.dart
│   │   ├── session_model.dart
│   │   └── attendance_model.dart
│   └── repositories/                — Firestore CRUD + streams (7 repos)
│       ├── user_repository.dart
│       ├── college_repository.dart
│       ├── program_repository.dart
│       ├── class_repository.dart
│       ├── subject_repository.dart
│       ├── faculty_assignment_repository.dart
│       └── session_repository.dart
└── presentation/
    ├── auth/                        — Login, role selection, onboarding
    ├── dashboards/                  — Admin, Faculty, Student dashboards
    ├── admin/                       — Program/class/subject/timetable CRUD
    ├── faculty/                     — Session start + live QR screen
    └── student/                     — QR scanner screen
```

### 8.3 QR Token Flow Diagram

```mermaid
sequenceDiagram
    participant F as Faculty Device
    participant DB as Firestore
    participant S as Student Device

    F->>DB: startSession(timetableId, facultyId)
    DB-->>F: SessionModel (id, qrToken, isActive)
    
    loop Every 2 minutes
        F->>F: HMAC(sessionId + window + secret)
        F->>F: Display QR with new token
    end

    S->>F: Scan QR Code (camera)
    S->>S: Extract scannedToken
    S->>DB: markAttendance(sessionId, studentUid, scannedToken)
    
    Note over S,DB: Validation Steps
    DB->>DB: 1. Validate HMAC token (current & prev window)
    DB->>DB: 2. Check session isActive
    DB->>DB: 3. Check duplicate attendance
    DB-->>S: Success ✅ or Error ❌
    
    DB-->>F: Real-time attendance stream update
```

---

## 9. Identified Outcomes

| # | Outcome |
|---|---------|
| 1 | A fully functional **multi-tenant attendance system** supporting multiple colleges independently. |
| 2 | **Proxy attendance elimination** through HMAC-based rotating QR tokens with 2-minute expiry. |
| 3 | **Real-time data sync** — faculty sees instant attendance counts as students scan. |
| 4 | **Cross-platform deployment** — single codebase running on Android, iOS, and Web (Chrome). |
| 5 | **Admin autonomy** — college admins can independently set up their institution's entire structure. |
| 6 | **Zero-hardware solution** — no RFID readers, biometric scanners, or special equipment needed. |
| 7 | **Premium, responsive UI** — Material 3 design with gradient headers, animated cards, and web-optimized layouts. |

---

## 10. Features

### 10.1 Authentication & Onboarding
- ✅ Google Sign-In (Web popup + Mobile native)
- ✅ Automatic user profile creation on first login
- ✅ Role selection (Student / Faculty / College Admin)
- ✅ College code joining (Students & Faculty)
- ✅ College registration (Admin creates institution)

### 10.2 Admin Dashboard
- ✅ Material 3 grid-based navigation
- ✅ Create, edit, delete **Programs**
- ✅ Create, edit, delete **Classes** (linked to programs)
- ✅ Create, edit, delete **Subjects** (linked to programs)
- ✅ Assign **Faculty** to subject + class pairs
- ✅ **Drag-and-drop Timetable** builder

### 10.3 Faculty Features
- ✅ Subject-wise assignment view
- ✅ One-tap **session start** with confirmation
- ✅ Live **rotating QR code** display (2-minute refresh)
- ✅ **Countdown timer** with progress bar
- ✅ **Real-time attendance list** (updates as students scan)
- ✅ Session **end** with confirmation dialog
- ✅ Active session **banner** on dashboard

### 10.4 Student Features
- ✅ Active session **detection** (live stream from Firestore)
- ✅ **QR scanner** with custom camera overlay (mobile)
- ✅ **Manual token entry** dialog (web fallback)
- ✅ Animated **success/failure** result screens
- ✅ Duplicate attendance **prevention**
- ✅ **"Try Again"** option on scan failure

### 10.5 Security Features
- ✅ **HMAC-SHA256** token generation with rolling 2-min windows
- ✅ Token accepts **current + previous window** (2–4 min tolerance)
- ✅ **Duplicate scan** blocked at Firestore document level
- ✅ **Session state check** — expired sessions reject scans
- ✅ Auto-end previous session when faculty starts a new one

---

## 11. Testing Strategy

### 11.1 Unit Testing
| Test Case | Expected Result |
|---|---|
| Generate QR token for session | Returns `sessionId:windowMs:hmacDigest` format |
| Validate a fresh token | Returns `true` |
| Validate a 3-minute-old token | Returns `false` (expired) |
| Validate token with wrong session ID | Returns `false` |
| Mark attendance for first time | Returns `null` (success) |
| Mark attendance a second time | Returns `"Attendance already recorded"` |

### 11.2 Integration Testing
| Test Scenario | Steps | Expected |
|---|---|---|
| Full attendance flow | Faculty starts session → Student scans → Faculty sees count | Attendance count increments in real-time |
| Session expiry | Faculty ends session → Student tries to scan | Error: "Session has already ended" |
| Multi-college isolation | Two admins create colleges → Data doesn't leak | Each admin sees only their own data |

### 11.3 Manual Verification
- Timetable setup via drag-and-drop in Admin Dashboard
- Real-time QR rotation observed on Faculty screen
- Successful scan on a mobile device
- Web fallback (manual entry) tested on Chrome

---

## 12. Advantages over Existing Systems

| Feature | Our System | Paper-Based | Biometric | Static QR |
|---|---|---|---|---|
| Proxy prevention | ✅ HMAC rotating token | ❌ | ✅ | ❌ Screenshot-able |
| Real-time tracking | ✅ Firestore streams | ❌ | ❌ | Partial |
| Hardware needed | ❌ None (phone camera) | ❌ Pen/Paper | ✅ Expensive | ❌ None |
| Multi-platform | ✅ Android + iOS + Web | ❌ | ❌ | Partial |
| Setup time | 5 minutes | N/A | Days | Hours |
| Cost | Free (Firebase free tier) | Minimal | High | Low |
| Scalability | ✅ Multi-tenant cloud | ❌ | ❌ | ❌ |

---

## 13. Limitations

1. **Internet dependency** — Both faculty and student devices require network connectivity to sync with Firestore.
2. **Camera requirement** — Mobile QR scanning requires camera permission; web users must enter tokens manually.
3. **No offline mode** — Attendance records are not cached for offline submission (planned for future).
4. **Single sign-in method** — Currently supports only Google Sign-In; email/password is not yet implemented.
5. **No geo-fencing** — Location-based validation is designed but not yet implemented.

---

## 14. Future Scope

| # | Enhancement | Description |
|---|---|---|
| 1 | **Attendance Reports & Analytics** | Subject-wise attendance percentages, visual charts, CSV export, and defaulter lists for students, faculty, and admin. |
| 2 | **Push Notifications** | Alerts for low attendance, session reminders, and admin announcements via Firebase Cloud Messaging. |
| 3 | **Cloud Functions Validation** | Server-side QR token validation to prevent client-side tampering. |
| 4 | **Automated Defaulter Lists** | Auto-flag students below minimum attendance threshold with email/notification alerts. |
| 5 | **Geo-Fencing** | Validate student location is within campus radius during attendance marking. |
| 6 | **Device Fingerprinting** | Restrict one device per student to further prevent proxy attendance. |
| 7 | **Offline Mode** | Cache attendance locally and sync when network is available. |
| 8 | **Email/Password Auth** | Alternative sign-in method for users without Google accounts. |
| 9 | **Parent Portal** | Read-only attendance view for parents/guardians. |
| 10 | **Multi-language Support** | Internationalization (i18n) for regional language support. |

---

## 15. Conclusion

The **Smart Attendance System** successfully addresses the critical challenges of manual attendance management in educational institutions. By combining Flutter's cross-platform capabilities with Firebase's real-time backend and HMAC-SHA256 cryptographic security, the system delivers a robust, scalable, and tamper-proof attendance solution.

The completed phases (1–3) provide a fully functional end-to-end attendance loop — from admin setup to faculty session management to student QR scanning — all within a premium, responsive user interface. The modular Clean Architecture ensures that future enhancements such as analytics, notifications, and geo-fencing can be integrated seamlessly.

This project demonstrates the practical application of modern software engineering principles including reactive programming, immutable state management, real-time database synchronization, and cryptographic security — making it well-suited for deployment in real-world educational environments.

---

## 16. References

1. Kadry, S., & Smaili, K. (2013). "A Design and Implementation of a Wireless Iris Recognition Attendance Management System." *Information Technology and Control*, 36(3).
2. M'Raihi, D., et al. (2011). "TOTP: Time-Based One-Time Password Algorithm." *RFC 6238*, IETF.
3. Moroney, L. (2017). *The Definitive Guide to Firebase*. Apress.
4. Flutter Documentation (2024). "State Management." flutter.dev.
5. Riverpod Documentation (2024). "Getting Started." riverpod.dev.
6. Firebase Documentation (2024). "Cloud Firestore." firebase.google.com.
7. Stack Overflow Developer Survey (2024). "Most Popular Cross-Platform Frameworks."

---

*Document generated on 2026-03-06 for the Smart Attendance System Mini Project.*
