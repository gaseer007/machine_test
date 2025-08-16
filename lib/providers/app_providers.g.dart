// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$filteredSpacesHash() => r'6e30ea7a225b85a78058aabde4401febe67b48fd';

/// See also [filteredSpaces].
@ProviderFor(filteredSpaces)
final filteredSpacesProvider =
    AutoDisposeFutureProvider<List<CoworkingSpace>>.internal(
      filteredSpaces,
      name: r'filteredSpacesProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$filteredSpacesHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FilteredSpacesRef = AutoDisposeFutureProviderRef<List<CoworkingSpace>>;
String _$coworkingSpacesHash() => r'50104b546fa5e4045ba003090fffd3afe67daee4';

/// See also [CoworkingSpaces].
@ProviderFor(CoworkingSpaces)
final coworkingSpacesProvider = AutoDisposeAsyncNotifierProvider<
  CoworkingSpaces,
  List<CoworkingSpace>
>.internal(
  CoworkingSpaces.new,
  name: r'coworkingSpacesProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$coworkingSpacesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$CoworkingSpaces = AutoDisposeAsyncNotifier<List<CoworkingSpace>>;
String _$bookingsHash() => r'1c62d291302555ea8443429a5d73f515259f60c2';

/// See also [Bookings].
@ProviderFor(Bookings)
final bookingsProvider =
    AutoDisposeAsyncNotifierProvider<Bookings, List<Booking>>.internal(
      Bookings.new,
      name: r'bookingsProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product') ? null : _$bookingsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$Bookings = AutoDisposeAsyncNotifier<List<Booking>>;
String _$notificationsHash() => r'f6e130ff6c286453ff548966875da21327c97678';

/// See also [Notifications].
@ProviderFor(Notifications)
final notificationsProvider = AutoDisposeAsyncNotifierProvider<
  Notifications,
  List<NotificationModel>
>.internal(
  Notifications.new,
  name: r'notificationsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$notificationsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$Notifications = AutoDisposeAsyncNotifier<List<NotificationModel>>;
String _$searchQueryHash() => r'32848c18dd36b350439a45fa6338bf2df6758978';

/// See also [SearchQuery].
@ProviderFor(SearchQuery)
final searchQueryProvider =
    AutoDisposeNotifierProvider<SearchQuery, String>.internal(
      SearchQuery.new,
      name: r'searchQueryProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$searchQueryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$SearchQuery = AutoDisposeNotifier<String>;
String _$cityFilterHash() => r'7d30d4abd34701a20743b3b038d639cbea84abaf';

/// See also [CityFilter].
@ProviderFor(CityFilter)
final cityFilterProvider =
    AutoDisposeNotifierProvider<CityFilter, String?>.internal(
      CityFilter.new,
      name: r'cityFilterProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$cityFilterHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$CityFilter = AutoDisposeNotifier<String?>;
String _$priceFilterHash() => r'c5d8580fcb570feefad32678394d67a59889400f';

/// See also [PriceFilter].
@ProviderFor(PriceFilter)
final priceFilterProvider =
    AutoDisposeNotifierProvider<PriceFilter, double?>.internal(
      PriceFilter.new,
      name: r'priceFilterProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$priceFilterHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$PriceFilter = AutoDisposeNotifier<double?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
