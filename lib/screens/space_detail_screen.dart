import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../providers/app_providers.dart';
import '../themes/app_theme.dart';
import '../widgets/loading_widget.dart';

class SpaceDetailScreen extends ConsumerStatefulWidget {
  final String spaceId;

  const SpaceDetailScreen({super.key, required this.spaceId});

  @override
  ConsumerState<SpaceDetailScreen> createState() => _SpaceDetailScreenState();
}

class _SpaceDetailScreenState extends ConsumerState<SpaceDetailScreen>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  int _currentImageIndex = 0;
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOutCubic),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeOutBack),
    );

    _fadeController.forward();
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) _slideController.forward();
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final spacesAsync = ref.watch(coworkingSpacesProvider);

    return spacesAsync.when(
      data: (spaces) {
        final space = spaces.firstWhere((s) => s.id == widget.spaceId);
        return Scaffold(
          backgroundColor: AppTheme.lightGrey,
          body: CustomScrollView(
            slivers: [
              // Brand-aligned App Bar with Image Gallery
              SliverAppBar(
                expandedHeight: 320.h,
                pinned: true,
                elevation: 0,
                backgroundColor: AppTheme.pureWhite,
                surfaceTintColor: Colors.transparent,
                leading: Container(
                  margin: EdgeInsets.all(8.r),
                  decoration: BoxDecoration(
                    color: AppTheme.pureWhite.withOpacity(0.95),
                    shape: BoxShape.circle,
                    boxShadow: [AppTheme.subtleShadow],
                  ),
                  child: IconButton(
                    onPressed: () => context.pop(),
                    icon: Icon(
                      CupertinoIcons.back,
                      color: AppTheme.primaryBlack,
                      size: 20.sp,
                    ),
                  ),
                ),
                actions: [
                  Container(
                    margin: EdgeInsets.all(8.r),
                    decoration: BoxDecoration(
                      color: AppTheme.pureWhite.withOpacity(0.95),
                      shape: BoxShape.circle,
                      boxShadow: [AppTheme.subtleShadow],
                    ),
                    child: IconButton(
                      onPressed: () {
                        setState(() {
                          _isFavorite = !_isFavorite;
                        });
                      },
                      icon: Icon(
                        _isFavorite
                            ? Icons.favorite_rounded
                            : Icons.favorite_border_rounded,
                        color:
                            _isFavorite
                                ? AppTheme.errorRed
                                : AppTheme.primaryBlack,
                        size: 20.sp,
                      ),
                    ),
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    children: [
                      // Image Gallery
                      PageView.builder(
                        controller: _pageController,
                        itemCount: space.images.length,
                        onPageChanged: (index) {
                          setState(() {
                            _currentImageIndex = index;
                          });
                        },
                        itemBuilder: (context, index) {
                          return CachedNetworkImage(
                            imageUrl: space.images[index],
                            fit: BoxFit.cover,
                            placeholder:
                                (context, url) => Container(
                                  color: AppTheme.surfaceVariant,
                                  child: const Center(child: LoadingWidget()),
                                ),
                            errorWidget:
                                (context, url, error) => Container(
                                  color: AppTheme.surfaceVariant,
                                  child: Icon(
                                    Icons.image_not_supported_rounded,
                                    size: 48.sp,
                                    color: AppTheme.darkGrey,
                                  ),
                                ),
                          );
                        },
                      ),

                      // Gradient Overlay
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          height: 100.h,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                AppTheme.primaryBlack.withOpacity(0.6),
                              ],
                            ),
                          ),
                        ),
                      ),

                      // Image Indicators
                      if (space.images.length > 1)
                        Positioned(
                          bottom: 20.h,
                          left: 0,
                          right: 0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children:
                                space.images.asMap().entries.map((entry) {
                                  return Container(
                                    width: 8.w,
                                    height: 8.h,
                                    margin: EdgeInsets.symmetric(
                                      horizontal: 4.w,
                                    ),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color:
                                          _currentImageIndex == entry.key
                                              ? AppTheme.pureWhite
                                              : AppTheme.pureWhite.withOpacity(
                                                0.5,
                                              ),
                                    ),
                                  );
                                }).toList(),
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              // Content Section
              SliverToBoxAdapter(
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: Container(
                      color: AppTheme.lightGrey,
                      child: Column(
                        children: [
                          // Main Info Card
                          Container(
                            margin: EdgeInsets.all(20.r),
                            decoration: AppTheme.logoInspiredDecoration,
                            child: Padding(
                              padding: EdgeInsets.all(24.r),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Title and Price Row
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              space.name,
                                              style: TextStyle(
                                                fontSize: 26.sp,
                                                fontWeight: FontWeight.w700,
                                                color: AppTheme.primaryBlack,
                                                letterSpacing: -0.5,
                                                height: 1.2,
                                              ),
                                            ),
                                            SizedBox(height: 8.h),
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.location_on_rounded,
                                                  color: AppTheme.darkGrey,
                                                  size: 18.sp,
                                                ),
                                                SizedBox(width: 6.w),
                                                Expanded(
                                                  child: Text(
                                                    space.location,
                                                    style: TextStyle(
                                                      fontSize: 15.sp,
                                                      color: AppTheme.darkGrey,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(width: 16.w),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 20.w,
                                          vertical: 12.h,
                                        ),
                                        decoration:
                                            AppTheme.speechBubbleDecoration,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              'PER HOUR',
                                              style: TextStyle(
                                                fontSize: 10.sp,
                                                color: AppTheme.pureWhite
                                                    .withOpacity(0.8),
                                                fontWeight: FontWeight.w600,
                                                letterSpacing: 1.2,
                                              ),
                                            ),
                                            Text(
                                              '₹${space.pricePerHour.toInt()}',
                                              style: TextStyle(
                                                fontSize: 22.sp,
                                                fontWeight: FontWeight.w700,
                                                color: AppTheme.pureWhite,
                                                letterSpacing: -0.3,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),

                                  SizedBox(height: 24.h),

                                  // Rating Section
                                  Row(
                                    children: [
                                      ...List.generate(
                                        5,
                                        (index) => Icon(
                                          Icons.star_rounded,
                                          color:
                                              index < 4
                                                  ? AppTheme.warningAmber
                                                  : AppTheme.mediumGrey,
                                          size: 20.sp,
                                        ),
                                      ),
                                      SizedBox(width: 12.w),
                                      Text(
                                        '4.5',
                                        style: TextStyle(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w700,
                                          color: AppTheme.primaryBlack,
                                        ),
                                      ),
                                      SizedBox(width: 8.w),
                                      Text(
                                        '(124 reviews)',
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          color: AppTheme.darkGrey,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // Description Card
                          _buildInfoCard(
                            title: 'ABOUT THIS SPACE',
                            child: Text(
                              space.description,
                              style: TextStyle(
                                fontSize: 16.sp,
                                color: AppTheme.primaryBlack,
                                fontWeight: FontWeight.w400,
                                height: 1.6,
                              ),
                            ),
                          ),

                          // Amenities Card
                          _buildInfoCard(
                            title: 'AMENITIES',
                            child: Wrap(
                              spacing: 12.w,
                              runSpacing: 12.h,
                              children:
                                  space.amenities.map((amenity) {
                                    return _buildAmenityChip(amenity);
                                  }).toList(),
                            ),
                          ),

                          // Operating Hours Card
                          _buildInfoCard(
                            title: 'OPERATING HOURS',
                            child: Column(
                              children:
                                  space.operatingHours.entries.map((entry) {
                                    return Container(
                                      margin: EdgeInsets.only(bottom: 12.h),
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 16.w,
                                        vertical: 12.h,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppTheme.surfaceVariant,
                                        borderRadius: BorderRadius.circular(
                                          12.r,
                                        ),
                                        border: Border.all(
                                          color: AppTheme.mediumGrey,
                                          width: 0.5,
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            entry.key.toUpperCase(),
                                            style: TextStyle(
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w700,
                                              color: AppTheme.primaryBlack,
                                              letterSpacing: 0.5,
                                            ),
                                          ),
                                          Text(
                                            entry.value,
                                            style: TextStyle(
                                              fontSize: 14.sp,
                                              color: AppTheme.darkGrey,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                            ),
                          ),

                          SizedBox(height: 100.h), // Space for FAB
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          floatingActionButton: Container(
            decoration: AppTheme.speechBubbleDecoration.copyWith(
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: FloatingActionButton.extended(
              onPressed: () => context.push('/booking/${widget.spaceId}'),
              backgroundColor: Colors.transparent,
              foregroundColor: AppTheme.pureWhite,
              elevation: 0,
              label: Text(
                'BOOK NOW',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.0,
                ),
              ),
              icon: Icon(Icons.calendar_today_rounded, size: 20.sp),
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
        );
      },
      loading:
          () => Scaffold(
            backgroundColor: AppTheme.lightGrey,
            body: const Center(child: LoadingWidget()),
          ),
      error:
          (error, stack) => Scaffold(
            backgroundColor: AppTheme.lightGrey,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(24.r),
                    decoration: BoxDecoration(
                      color: AppTheme.errorRed.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.error_outline_rounded,
                      size: 64.sp,
                      color: AppTheme.errorRed,
                    ),
                  ),
                  SizedBox(height: 24.h),
                  Text(
                    'Something went wrong',
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.primaryBlack,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    error.toString(),
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppTheme.darkGrey,
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
    );
  }

  Widget _buildInfoCard({required String title, required Widget child}) {
    return Container(
      margin: EdgeInsets.fromLTRB(20.w, 0, 20.w, 20.h),
      decoration: AppTheme.containerDecoration,
      child: Padding(
        padding: EdgeInsets.all(24.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
                color: AppTheme.primaryBlack,
                letterSpacing: 1.2,
              ),
            ),
            SizedBox(height: 16.h),
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildAmenityChip(String amenity) {
    // Define amenity icons
    IconData getAmenityIcon(String amenity) {
      switch (amenity.toLowerCase()) {
        case 'wifi':
        case 'wi-fi':
          return Icons.wifi_rounded;
        case 'coffee':
          return Icons.coffee_rounded;
        case 'parking':
          return Icons.local_parking_rounded;
        case 'meeting room':
        case 'meeting rooms':
          return Icons.meeting_room_rounded;
        case 'printer':
          return Icons.print_rounded;
        case 'air conditioning':
        case 'ac':
          return Icons.ac_unit_rounded;
        case 'kitchen':
          return Icons.kitchen_rounded;
        case 'reception':
          return Icons.desk_rounded;
        default:
          return Icons.check_circle_rounded;
      }
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: AppTheme.surfaceVariant,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppTheme.mediumGrey, width: 0.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            getAmenityIcon(amenity),
            size: 16.sp,
            color: AppTheme.primaryBlack,
          ),
          SizedBox(width: 8.w),
          Text(
            amenity.toUpperCase(),
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w700,
              color: AppTheme.primaryBlack,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
