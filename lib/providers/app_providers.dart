import 'dart:convert';
import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/booking.dart';
import '../models/coworking_space.dart';
import '../models/notification_model.dart';
import '../services/notification_service.dart';

part 'app_providers.g.dart';

// Mock data for Kerala-based co-working spaces
final _mockSpaces = [
  CoworkingSpace(
    id: '1',
    name: 'TechHub Kochi',
    location: 'Marine Drive, Kochi',
    city: 'Kochi',
    pricePerHour: 150.0,
    images: [
      'https://images.unsplash.com/photo-1497366216548-37526070297c?w=800',
      'https://images.unsplash.com/photo-1497366754035-f200968a6e72?w=800',
    ],
    description:
        'Modern co-working space with stunning backwater views. Perfect for professionals and startups.',
    amenities: [
      'High-speed WiFi',
      'Meeting Rooms',
      'Coffee Bar',
      'Parking',
      'AC',
    ],
    operatingHours: {
      'Monday': '9:00 AM - 9:00 PM',
      'Tuesday': '9:00 AM - 9:00 PM',
      'Wednesday': '9:00 AM - 9:00 PM',
      'Thursday': '9:00 AM - 9:00 PM',
      'Friday': '9:00 AM - 9:00 PM',
      'Saturday': '10:00 AM - 6:00 PM',
      'Sunday': 'Closed',
    },
    latitude: 9.9312,
    longitude: 76.2673,
  ),
  CoworkingSpace(
    id: '2',
    name: 'Startup Nest Thiruvananthapuram',
    location: 'Technopark, Thiruvananthapuram',
    city: 'Thiruvananthapuram',
    pricePerHour: 120.0,
    images: [
      'https://images.unsplash.com/photo-1524758631624-e2822e304c36?w=800',
      'https://images.unsplash.com/photo-1497366811353-6870744d04b2?w=800',
    ],
    description:
        'Located in the heart of Technopark, ideal for tech professionals and entrepreneurs.',
    amenities: [
      '24/7 Access',
      'High-speed WiFi',
      'Phone Booths',
      'Printer',
      'Cafeteria',
    ],
    operatingHours: {
      'Monday': '8:00 AM - 10:00 PM',
      'Tuesday': '8:00 AM - 10:00 PM',
      'Wednesday': '8:00 AM - 10:00 PM',
      'Thursday': '8:00 AM - 10:00 PM',
      'Friday': '8:00 AM - 10:00 PM',
      'Saturday': '9:00 AM - 7:00 PM',
      'Sunday': '9:00 AM - 7:00 PM',
    },
    latitude: 8.5241,
    longitude: 76.9366,
  ),
  CoworkingSpace(
    id: '3',
    name: 'Creative Spaces Kozhikode',
    location: 'SM Street, Kozhikode',
    city: 'Kozhikode',
    pricePerHour: 100.0,
    images: [
      'https://images.unsplash.com/photo-1497366412874-3415097a27e7?w=800',
      'https://images.unsplash.com/photo-1519389950473-47ba0277781c?w=800',
    ],
    description:
        'Creative hub for designers, writers, and freelancers in the cultural heart of Kerala.',
    amenities: ['Design Studio', 'WiFi', 'Library', 'Event Space', 'Parking'],
    operatingHours: {
      'Monday': '9:00 AM - 8:00 PM',
      'Tuesday': '9:00 AM - 8:00 PM',
      'Wednesday': '9:00 AM - 8:00 PM',
      'Thursday': '9:00 AM - 8:00 PM',
      'Friday': '9:00 AM - 8:00 PM',
      'Saturday': '10:00 AM - 6:00 PM',
      'Sunday': 'Closed',
    },
    latitude: 11.2588,
    longitude: 75.7804,
  ),
  CoworkingSpace(
    id: '4',
    name: 'Business Bay Thrissur',
    location: 'Round South, Thrissur',
    city: 'Thrissur',
    pricePerHour: 80.0,
    images: [
      'https://images.unsplash.com/photo-1556761175-b413da4baf72?w=800',
      'https://images.unsplash.com/photo-1517502884422-41eaead166d4?w=800',
    ],
    description:
        'Affordable co-working space in the cultural capital, perfect for small businesses.',
    amenities: ['WiFi', 'Meeting Room', 'Printing', 'Tea/Coffee', 'Parking'],
    operatingHours: {
      'Monday': '9:00 AM - 7:00 PM',
      'Tuesday': '9:00 AM - 7:00 PM',
      'Wednesday': '9:00 AM - 7:00 PM',
      'Thursday': '9:00 AM - 7:00 PM',
      'Friday': '9:00 AM - 7:00 PM',
      'Saturday': '9:00 AM - 5:00 PM',
      'Sunday': 'Closed',
    },
    latitude: 10.5276,
    longitude: 76.2144,
  ),
  CoworkingSpace(
    id: '5',
    name: 'Innovation Hub Kannur',
    location: 'Fort Road, Kannur',
    city: 'Kannur',
    pricePerHour: 90.0,
    images: [
      'https://images.unsplash.com/photo-1497366858526-0766cadbe8fa?w=800',
      'https://images.unsplash.com/photo-1604328698692-f76ea9498e76?w=800',
    ],
    description:
        'Modern workspace promoting innovation and collaboration in North Kerala.',
    amenities: [
      'High-speed WiFi',
      'Conference Room',
      'Lounge',
      'Parking',
      'Security',
    ],
    operatingHours: {
      'Monday': '8:30 AM - 8:30 PM',
      'Tuesday': '8:30 AM - 8:30 PM',
      'Wednesday': '8:30 AM - 8:30 PM',
      'Thursday': '8:30 AM - 8:30 PM',
      'Friday': '8:30 AM - 8:30 PM',
      'Saturday': '9:00 AM - 6:00 PM',
      'Sunday': 'Closed',
    },
    latitude: 11.8745,
    longitude: 75.3704,
  ),
];

@riverpod
class CoworkingSpaces extends _$CoworkingSpaces {
  @override
  Future<List<CoworkingSpace>> build() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    return _mockSpaces;
  }

  List<CoworkingSpace> filterSpaces(
    List<CoworkingSpace> spaces,
    String query,
    String? cityFilter,
    double? maxPrice,
  ) {
    return spaces.where((space) {
      final matchesQuery =
          query.isEmpty ||
          space.name.toLowerCase().contains(query.toLowerCase()) ||
          space.location.toLowerCase().contains(query.toLowerCase()) ||
          space.city.toLowerCase().contains(query.toLowerCase());

      final matchesCity = cityFilter == null || space.city == cityFilter;
      final matchesPrice = maxPrice == null || space.pricePerHour <= maxPrice;

      return matchesQuery && matchesCity && matchesPrice;
    }).toList();
  }
}

@riverpod
class Bookings extends _$Bookings {
  @override
  Future<List<Booking>> build() async {
    final prefs = await SharedPreferences.getInstance();
    final bookingsJson = prefs.getStringList('bookings') ?? [];

    return bookingsJson
        .map((json) => Booking.fromJson(jsonDecode(json)))
        .toList();
  }

  Future<void> addBooking(Booking booking) async {
    final prefs = await SharedPreferences.getInstance();
    final currentBookings = await future;
    final updatedBookings = [...currentBookings, booking];

    final bookingsJson =
        updatedBookings.map((booking) => jsonEncode(booking.toJson())).toList();

    await prefs.setStringList('bookings', bookingsJson);

    // Show notification
    await NotificationService.showNotification(
      id: booking.hashCode,
      title: 'Booking Confirmed!',
      body:
          'Your booking for ${booking.spaceName} on ${booking.date.day}/${booking.date.month} is confirmed.',
    );

    // Add to notifications
    ref
        .read(notificationsProvider.notifier)
        .addNotification(
          NotificationModel(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            title: 'Booking Confirmed',
            body:
                'Your booking for ${booking.spaceName} has been confirmed for ${booking.timeSlot} on ${booking.date.day}/${booking.date.month}/${booking.date.year}',
            createdAt: DateTime.now(),
          ),
        );

    state = AsyncData(updatedBookings);
  }
}

@riverpod
class Notifications extends _$Notifications {
  @override
  Future<List<NotificationModel>> build() async {
    final prefs = await SharedPreferences.getInstance();
    final notificationsJson = prefs.getStringList('notifications') ?? [];

    return notificationsJson
        .map((json) => NotificationModel.fromJson(jsonDecode(json)))
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  Future<void> addNotification(NotificationModel notification) async {
    final prefs = await SharedPreferences.getInstance();
    final currentNotifications = await future;
    final updatedNotifications = [notification, ...currentNotifications];

    final notificationsJson =
        updatedNotifications
            .map((notif) => jsonEncode(notif.toJson()))
            .toList();

    await prefs.setStringList('notifications', notificationsJson);
    state = AsyncData(updatedNotifications);
  }

  Future<void> markAsRead(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final currentNotifications = await future;
    final updatedNotifications =
        currentNotifications
            .map(
              (notif) => notif.id == id ? notif.copyWith(isRead: true) : notif,
            )
            .toList();

    final notificationsJson =
        updatedNotifications
            .map((notif) => jsonEncode(notif.toJson()))
            .toList();

    await prefs.setStringList('notifications', notificationsJson);
    state = AsyncData(updatedNotifications);
  }

  int get unreadCount {
    return state.value?.where((notif) => !notif.isRead).length ?? 0;
  }
}

// Search and filter providers
@riverpod
class SearchQuery extends _$SearchQuery {
  @override
  String build() => '';

  void updateQuery(String query) {
    state = query;
  }
}

@riverpod
class CityFilter extends _$CityFilter {
  @override
  String? build() => null;

  void updateCity(String? city) {
    state = city;
  }
}

@riverpod
class PriceFilter extends _$PriceFilter {
  @override
  double? build() => null;

  void updatePrice(double? price) {
    state = price;
  }
}

// Filtered spaces provider
@riverpod
Future<List<CoworkingSpace>> filteredSpaces(FilteredSpacesRef ref) async {
  final spaces = await ref.watch(coworkingSpacesProvider.future);
  final query = ref.watch(searchQueryProvider);
  final cityFilter = ref.watch(cityFilterProvider);
  final priceFilter = ref.watch(priceFilterProvider);

  return ref
      .read(coworkingSpacesProvider.notifier)
      .filterSpaces(spaces, query, cityFilter, priceFilter);
}
