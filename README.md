# Innerspace Co-Working Space App

## Overview
This Flutter application demonstrates a booking system for co-working spaces. Users can browse coworking branches, view details, make bookings, and manage their reservations. Notifications are integrated for booking updates.

**State Management:** Riverpod

## Features
- Splash Screen with animated logo and app name  
- Home Screen listing co-working branches with search and filter  
- Map View for branch locations  
- Branch Detail Screen with detailed info  
- Booking Screen to reserve a space  
- My Bookings Screen to view upcoming and past bookings  
- Notifications Screen for booking alerts  

## Architecture & Folder Structure
lib/
│
├── models/
│ ├── coworking_space.dart
│ ├── booking.dart
│ └── notification_model.dart
│
├── providers/
│ ├── app_providers.dart
│ └── app_providers.g.dart
│
├── screens/
│ ├── splash_screen.dart
│ ├── home_screen.dart
│ ├── map_screen.dart
│ ├── space_detail_screen.dart
│ ├── booking_screen.dart
│ ├── my_bookings_screen.dart
│ └── notifications_screen.dart
│
├── services/
│ └── notification_service.dart
│
├── widgets/
│ ├── loading_widget.dart
│ └── error_widget.dart
│
├── utils/
│ └── date_utils.dart
│
├── constants/
│ └── app_constants.dart
│
└── themes/
└── app_theme.dart

markdown
Copy
Edit
**Folder Responsibilities:**  
- **models/** → Data models used in the app  
- **providers/** → Riverpod providers for state management  
- **screens/** → UI screens of the application  
- **services/** → Service classes (e.g., notifications, API calls)  
- **widgets/** → Reusable UI components  
- **utils/** → Helper functions and utilities  
- **constants/** → App-wide constants  
- **themes/** → Theme and styling  

## Setup Instructions
1. **Clone the repository**  
```bash
git clone https://github.com/gaseer007/machine_test.git
cd machine_test
Install dependencies

bash
Copy
Edit
flutter pub get
Run the app

bash
Copy
Edit
flutter run
Build APK (Optional)

bash
Copy
Edit
flutter build apk --release
Tools & Packages
State Management: Riverpod

Responsive Design: flutter_screenutil

Notifications: flutter_local_notifications

Development Notes
Followed a clean folder separation for maintainable code

Riverpod used for all state-related operations

UI designed with reusable widgets to reduce code repetition

Challenges Faced
Integrating asynchronous booking and notification updates with Riverpod

Ensuring responsive design across multiple screen sizes

Handling state updates efficiently across multiple screens

Time Spent
Approximately 20–25 hours including setup, UI, state management, and testing.

