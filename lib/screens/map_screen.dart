// // Map screen
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
//
// import '../models/coworking_space.dart';
// import '../providers/app_providers.dart';
// import '../widgets/loading_widget.dart';
//
// class MapScreen extends ConsumerStatefulWidget {
//   const MapScreen({super.key});
//
//   @override
//   ConsumerState<MapScreen> createState() => _MapScreenState();
// }
//
// class _MapScreenState extends ConsumerState<MapScreen> {
//   GoogleMapController? _controller;
//   final Set<Marker> _markers = {};
//
//   static const CameraPosition _initialPosition = CameraPosition(
//     target: LatLng(10.8505, 76.2711), // Center of Kerala
//     zoom: 7,
//   );
//
//   @override
//   Widget build(BuildContext context) {
//     final spacesAsync = ref.watch(coworkingSpacesProvider);
//
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           onPressed: context.pop,
//
//           icon: Icon(CupertinoIcons.back),
//         ),
//         title: const Text('Map View'),
//         backgroundColor: const Color(0xFF2196F3),
//         foregroundColor: Colors.white,
//       ),
//       body: spacesAsync.when(
//         data: (spaces) {
//           _updateMarkers(spaces);
//           return GoogleMap(
//             initialCameraPosition: _initialPosition,
//             markers: _markers,
//             onMapCreated: (GoogleMapController controller) {
//               _controller = controller;
//             },
//           );
//         },
//         loading: () => LoadingWidget(),
//         error: (error, stack) => Center(child: Text('Error: $error')),
//       ),
//     );
//   }
//
//   void _updateMarkers(List<CoworkingSpace> spaces) {
//     _markers.clear();
//     for (final space in spaces) {
//       _markers.add(
//         Marker(
//           markerId: MarkerId(space.id),
//           position: LatLng(space.latitude, space.longitude),
//           infoWindow: InfoWindow(
//             title: space.name,
//             snippet: '₹${space.pricePerHour.toInt()}/hr',
//             onTap: () => context.push('/space/${space.id}'),
//           ),
//         ),
//       );
//     }
//   }
// }
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../models/coworking_space.dart';
import '../providers/app_providers.dart';
import '../themes/app_theme.dart';
import '../widgets/loading_widget.dart';

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen>
    with TickerProviderStateMixin {
  GoogleMapController? _controller;
  final Set<Marker> _markers = {};
  CoworkingSpace? _selectedSpace;

  late AnimationController _slideController;
  late AnimationController _fadeController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  bool _isCardExpanded = false;

  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(10.8505, 76.2711), // Center of Kerala
    zoom: 8.5,
  );

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _slideController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final spacesAsync = ref.watch(coworkingSpacesProvider);

    return Scaffold(
      backgroundColor: AppTheme.lightGrey,
      extendBodyBehindAppBar: true,
      appBar: _buildModernAppBar(),
      body: spacesAsync.when(
        data: (spaces) {
          _updateMarkers(spaces);
          return Stack(
            children: [
              _buildGoogleMap(),
              _buildTopSpaceCard(spaces),
              _buildMapControls(),
            ],
          );
        },
        loading:
            () => Container(
              color: AppTheme.lightGrey,
              child: const LoadingWidget(),
            ),
        error: (error, stack) => _buildErrorState(error),
      ),
    );
  }

  PreferredSizeWidget _buildModernAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: Container(
        margin: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          color: AppTheme.pureWhite.withOpacity(0.9),
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [AppTheme.subtleShadow],
          border: Border.all(color: AppTheme.mediumGrey.withOpacity(0.3)),
        ),
        child: IconButton(
          onPressed: context.pop,
          icon: const Icon(CupertinoIcons.back, size: 20),
          style: IconButton.styleFrom(
            backgroundColor: Colors.transparent,
            foregroundColor: AppTheme.primaryBlack,
          ),
        ),
      ),
      title: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: AppTheme.pureWhite.withOpacity(0.9),
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [AppTheme.subtleShadow],
          border: Border.all(color: AppTheme.mediumGrey.withOpacity(0.3)),
        ),
        child: Text(
          'EXPLORE SPACES',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
            color: AppTheme.primaryBlack,
          ),
        ),
      ),
      centerTitle: true,
      actions: [
        Container(
          margin: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: AppTheme.pureWhite.withOpacity(0.9),
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: [AppTheme.subtleShadow],
            border: Border.all(color: AppTheme.mediumGrey.withOpacity(0.3)),
          ),
          child: IconButton(
            onPressed: _showMapOptions,
            icon: const Icon(Icons.layers_outlined, size: 20),
            style: IconButton.styleFrom(
              backgroundColor: Colors.transparent,
              foregroundColor: AppTheme.primaryBlack,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGoogleMap() {
    return GoogleMap(
      initialCameraPosition: _initialPosition,
      markers: _markers,
      onMapCreated: (GoogleMapController controller) {
        _controller = controller;
        _setMapStyle();
      },
      zoomControlsEnabled: false,
      mapToolbarEnabled: false,
      myLocationButtonEnabled: false,
      compassEnabled: false,
      onTap: (_) => _hideSpaceCard(),
      style: _getMapStyle(),
    );
  }

  Widget _buildTopSpaceCard(List<CoworkingSpace> spaces) {
    return Positioned(
      top: kToolbarHeight + MediaQuery.of(context).padding.top + 16.h,
      left: 16.w,
      right: 16.w,
      child: Column(
        children: [
          if (_selectedSpace != null)
            SlideTransition(
              position: _slideAnimation,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: _buildSpaceDetailCard(_selectedSpace!),
              ),
            ),
          SizedBox(height: 16.h),
          _buildSpacesList(spaces),
        ],
      ),
    );
  }

  Widget _buildSpaceDetailCard(CoworkingSpace space) {
    return Container(
      decoration: AppTheme.logoInspiredDecoration.copyWith(
        boxShadow: [AppTheme.elevatedShadow],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => context.push('/space/${space.id}'),
          borderRadius: BorderRadius.circular(16.r),
          child: Padding(
            padding: EdgeInsets.all(20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 4.h,
                      ),
                      decoration: AppTheme.speechBubbleDecoration,
                      child: Text(
                        'SELECTED',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppTheme.pureWhite,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: _hideSpaceCard,
                      icon: Icon(
                        Icons.close,
                        size: 20.w,
                        color: AppTheme.darkGrey,
                      ),
                      style: IconButton.styleFrom(
                        backgroundColor: AppTheme.lightGrey,
                        minimumSize: Size(32.w, 32.h),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                Text(
                  space.name,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.3,
                  ),
                ),
                SizedBox(height: 8.h),
                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 16.w,
                      color: AppTheme.darkGrey,
                    ),
                    SizedBox(width: 4.w),
                    Expanded(
                      child: Text(
                        space.location,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.darkGrey,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                Row(
                  children: [
                    Expanded(
                      child: _buildInfoChip(
                        icon: Icons.currency_rupee,
                        label: '${space.pricePerHour.toInt()}/hr',
                        color: AppTheme.accentBlue,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: _buildInfoChip(
                        icon: Icons.star,
                        label: '${space.name}',
                        color: AppTheme.warningAmber,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: _buildInfoChip(
                        icon: Icons.people,
                        label: space.city,
                        color: AppTheme.primaryBlack,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _navigateToSpace(space),
                        icon: Icon(Icons.directions, size: 18.w),
                        label: Text('DIRECTIONS'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryBlack,
                          foregroundColor: AppTheme.pureWhite,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    ElevatedButton(
                      onPressed: () => context.push('/space/${space.id}'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.accentBlue,
                        foregroundColor: AppTheme.pureWhite,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 20.w,
                          vertical: 12.h,
                        ),
                      ),
                      child: Text('BOOK'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16.w, color: color),
          SizedBox(width: 4.w),
          SizedBox(
            width: 45.w,
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpacesList(List<CoworkingSpace> spaces) {
    return Container(
      height: 120.h,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(16.r)),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: spaces.length,
        padding: EdgeInsets.symmetric(horizontal: 8.w),
        itemBuilder: (context, index) {
          final space = spaces[index];
          final isSelected = _selectedSpace?.id == space.id;

          return Container(
            width: 280.w,
            margin: EdgeInsets.symmetric(horizontal: 8.w),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => _selectSpace(space),
                borderRadius: BorderRadius.circular(12.r),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppTheme.pureWhite,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color:
                          isSelected
                              ? AppTheme.accentBlue
                              : AppTheme.mediumGrey.withOpacity(0.5),
                      width: isSelected ? 2 : 1,
                    ),
                    boxShadow: [
                      if (isSelected)
                        AppTheme.elevatedShadow
                      else
                        AppTheme.subtleShadow,
                    ],
                  ),
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              space.name,
                              style: Theme.of(
                                context,
                              ).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                                color:
                                    isSelected
                                        ? AppTheme.accentBlue
                                        : AppTheme.primaryBlack,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (isSelected)
                            Icon(
                              Icons.location_on,
                              color: AppTheme.accentBlue,
                              size: 20.w,
                            ),
                        ],
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        space.location,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.darkGrey,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 12.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '₹${space.pricePerHour.toInt()}/hr',
                            style: Theme.of(
                              context,
                            ).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: AppTheme.accentBlue,
                            ),
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.star,
                                color: AppTheme.warningAmber,
                                size: 16.w,
                              ),
                              Icon(
                                Icons.star,
                                color: AppTheme.warningAmber,
                                size: 16.w,
                              ),
                              Icon(
                                Icons.star,
                                color: AppTheme.warningAmber,
                                size: 16.w,
                              ),
                              SizedBox(width: 2.w),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMapControls() {
    return Positioned(
      bottom: 32.h,
      right: 16.w,
      child: Column(
        children: [
          _buildMapControlButton(
            icon: Icons.my_location,
            onPressed: _moveToCurrentLocation,
          ),
          SizedBox(height: 8.h),
          _buildMapControlButton(icon: Icons.zoom_in, onPressed: _zoomIn),
          SizedBox(height: 8.h),
          _buildMapControlButton(icon: Icons.zoom_out, onPressed: _zoomOut),
        ],
      ),
    );
  }

  Widget _buildMapControlButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.pureWhite,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [AppTheme.elevatedShadow],
        border: Border.all(color: AppTheme.mediumGrey.withOpacity(0.2)),
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, size: 22.w),
        style: IconButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: AppTheme.primaryBlack,
          minimumSize: Size(48.w, 48.h),
        ),
      ),
    );
  }

  Widget _buildErrorState(dynamic error) {
    return Container(
      color: AppTheme.lightGrey,
      child: Center(
        child: Container(
          margin: EdgeInsets.all(32.w),
          decoration: AppTheme.containerDecoration,
          padding: EdgeInsets.all(32.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.map_outlined, size: 64.w, color: AppTheme.darkGrey),
              SizedBox(height: 24.h),
              Text(
                'MAP UNAVAILABLE',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                error.toString(),
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: AppTheme.darkGrey),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _updateMarkers(List<CoworkingSpace> spaces) {
    _markers.clear();
    for (final space in spaces) {
      _markers.add(
        Marker(
          markerId: MarkerId(space.id),
          position: LatLng(space.latitude, space.longitude),
          onTap: () => _selectSpace(space),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            _selectedSpace?.id == space.id
                ? BitmapDescriptor.hueBlue
                : BitmapDescriptor.hueRed,
          ),
        ),
      );
    }
  }

  void _selectSpace(CoworkingSpace space) {
    setState(() {
      _selectedSpace = space;
    });

    _slideController.forward();
    _fadeController.forward();

    // Move camera to selected space
    _controller?.animateCamera(
      CameraUpdate.newLatLngZoom(LatLng(space.latitude, space.longitude), 10.0),
    );
  }

  void _hideSpaceCard() {
    _slideController.reverse();
    _fadeController.reverse();

    setState(() {
      _selectedSpace = null;
    });
  }

  void _navigateToSpace(CoworkingSpace space) {
    // This would typically open Google Maps or Apple Maps
    // For demo purposes, just show a snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Navigating to ${space.name}...'),
        backgroundColor: AppTheme.primaryBlack,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _moveToCurrentLocation() {
    // Move to current location - you'd need location permissions
    _controller?.animateCamera(
      CameraUpdate.newLatLngZoom(
        const LatLng(10.8505, 76.2711), // Demo location
        12.0,
      ),
    );
  }

  void _zoomIn() {
    _controller?.animateCamera(CameraUpdate.zoomIn());
  }

  void _zoomOut() {
    _controller?.animateCamera(CameraUpdate.zoomOut());
  }

  void _showMapOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder:
          (context) => Container(
            decoration: BoxDecoration(
              color: AppTheme.pureWhite,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  margin: EdgeInsets.only(top: 12.h),
                  width: 40.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: AppTheme.mediumGrey,
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(24.w),
                  child: Column(
                    children: [
                      Text(
                        'MAP OPTIONS',
                        style: Theme.of(
                          context,
                        ).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.2,
                        ),
                      ),
                      SizedBox(height: 24.h),
                      // Add map type options here
                      ListTile(
                        leading: Icon(Icons.map, color: AppTheme.primaryBlack),
                        title: Text('Satellite View'),
                        onTap: () => Navigator.pop(context),
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.traffic,
                          color: AppTheme.primaryBlack,
                        ),
                        title: Text('Traffic Layer'),
                        onTap: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
    );
  }

  void _setMapStyle() async {
    // You can set custom map style here
    // String style = await DefaultAssetBundle.of(context).loadString('assets/map_style.json');
    // _controller?.setMapStyle(style);
  }

  String? _getMapStyle() {
    // Return custom map style JSON if you have one
    return null;
  }
}
