<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Innerspace Co-Working Space App</title>
<style>
  body {
    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
    background-color: #f9f9f9;
    color: #333;
    line-height: 1.6;
    padding: 20px;
  }
  h1, h2, h3 {
    color: #0a66c2;
  }
  h1 {
    text-align: center;
    font-size: 2.5em;
    margin-bottom: 0;
  }
  h2 {
    border-bottom: 2px solid #0a66c2;
    padding-bottom: 5px;
  }
  a {
    color: #0a66c2;
    text-decoration: none;
  }
  a:hover {
    text-decoration: underline;
  }
  pre {
    background: #1e1e1e;
    color: #d4d4d4;
    padding: 10px;
    border-radius: 5px;
    overflow-x: auto;
  }
  code {
    font-family: 'Courier New', Courier, monospace;
  }
  ul {
    margin-top: 0;
  }
  .folder-structure {
    background: #eef6fc;
    border-left: 4px solid #0a66c2;
    padding: 10px 15px;
    border-radius: 5px;
    margin: 10px 0;
  }
  .note {
    background: #fff4e5;
    border-left: 4px solid #ff8c00;
    padding: 10px 15px;
    border-radius: 5px;
    margin: 10px 0;
  }
</style>
</head>
<body>

<h1>Innerspace Co-Working Space App</h1>

<h2>Overview</h2>
<p>This Flutter application demonstrates a booking system for co-working spaces. Users can browse coworking branches, view details, make bookings, and manage their reservations. Notifications are integrated for booking updates.</p>
<p><strong>State management:</strong> Riverpod</p>

<h2>Features</h2>
<ul>
  <li>Splash Screen with animated logo and app name</li>
  <li>Home Screen listing co-working branches with search and filter</li>
  <li>Map View for branch locations</li>
  <li>Branch Detail Screen</li>
  <li>Booking Screen to reserve a space</li>
  <li>My Bookings Screen to view reservations</li>
  <li>Notifications Screen for booking alerts</li>
</ul>

<h2>Architecture & Folder Structure</h2>
<div class="folder-structure">
<pre>
lib/
│
├── models/
│   ├── coworking_space.dart
│   ├── booking.dart
│   └── notification_model.dart
│
├── providers/
│   ├── app_providers.dart
│   └── app_providers.g.dart
│
├── screens/
│   ├── splash_screen.dart
│   ├── home_screen.dart
│   ├── map_screen.dart
│   ├── space_detail_screen.dart
│   ├── booking_screen.dart
│   ├── my_bookings_screen.dart
│   └── notifications_screen.dart
│
├── services/
│   └── notification_service.dart
│
├── widgets/
│   ├── loading_widget.dart
│   └── error_widget.dart
│
├── utils/
│   └── date_utils.dart
│
├── constants/
│   └── app_constants.dart
│
└── themes/
    └── app_theme.dart
</pre>
</div>

<h2>Setup Instructions</h2>
<pre>
git clone &lt;your-repo-link&gt;
cd &lt;repo-folder&gt;

flutter pub get
flutter run

# Build APK (optional)
flutter build apk --release
</pre>

<h2>Tools & Packages</h2>
<ul>
  <li>State Management: Riverpod</li>
  <li>Responsive Design: flutter_screenutil</li>
  <li>Notifications: flutter_local_notifications</li>
</ul>

<h2>Development Notes</h2>
<ul>
  <li>Followed clean folder separation for maintainable code</li>
  <li>Riverpod used for all state-related operations</li>
  <li>UI designed with reusable widgets to reduce code repetition</li>
</ul>

<h2>Challenges Faced</h2>
<ul>
  <li>Integrating asynchronous booking and notification updates with Riverpod</li>
  <li>Ensuring responsive design across multiple screen sizes</li>
  <li>Handling state updates efficiently across multiple screens</li>
</ul>

<h2>Time Spent</h2>
<p>Approximately <strong>20–25 hours</strong> including setup, UI, state management, and testing.</p>

</body>
</html>
