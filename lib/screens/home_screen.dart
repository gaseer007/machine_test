import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../models/coworking_space.dart';
import '../providers/app_providers.dart';
import '../themes/app_theme.dart';
import '../widgets/loading_widget.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  late AnimationController _animationController;
  late AnimationController _logoAnimationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _logoAnimation;
  bool _showFilters = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _logoAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );
    _logoAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoAnimationController,
        curve: Curves.elasticOut,
      ),
    );

    // Staggered animations
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) _logoAnimationController.forward();
    });
    _animationController.forward();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _animationController.dispose();
    _logoAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final spacesAsync = ref.watch(filteredSpacesProvider);
    final searchQuery = ref.watch(searchQueryProvider);
    final cityFilter = ref.watch(cityFilterProvider);
    final priceFilter = ref.watch(priceFilterProvider);
    final unreadCount = ref.watch(
      notificationsProvider.select(
        (state) => state.value?.where((notif) => !notif.isRead).length ?? 0,
      ),
    );

    return Scaffold(
      backgroundColor: AppTheme.lightGrey,
      body: CustomScrollView(
        slivers: [
          // Brand-aligned App Bar
          SliverAppBar(
            expandedHeight: _showFilters ? 320.h : 260.h,
            floating: false,
            pinned: true,
            elevation: 0,
            surfaceTintColor: Colors.transparent,
            backgroundColor: AppTheme.pureWhite,
            flexibleSpace: Container(
              decoration: BoxDecoration(
                color: AppTheme.pureWhite,
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryBlack.withOpacity(0.08),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: FlexibleSpaceBar(
                titlePadding: EdgeInsets.zero,
                title: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Row(
                    children: [
                      // Logo with animation
                      ScaleTransition(
                        scale: _logoAnimation,
                        child: Container(
                          width: 32.w,
                          height: 32.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.r),
                            boxShadow: [AppTheme.subtleShadow],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.r),
                            child: Image.asset(
                              'assets/logo.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Text(
                        'INNER SPACE',
                        style: TextStyle(
                          color: AppTheme.primaryBlack,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
                background: Container(
                  padding: EdgeInsets.fromLTRB(20.w, 90.h, 20.w, 20.h),
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: Column(
                      children: [
                        // Welcome Section with Speech Bubble Inspiration
                        Container(
                          margin: EdgeInsets.only(bottom: 20.h),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Find Your Perfect',
                                      style: TextStyle(
                                        fontSize: 18.sp,
                                        color: AppTheme.darkGrey,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      'Coworking Space',
                                      style: TextStyle(
                                        fontSize: 20.sp,
                                        color: AppTheme.primaryBlack,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Enhanced Search Bar with Brand Colors
                        Container(
                          decoration: BoxDecoration(
                            color: AppTheme.pureWhite,
                            borderRadius: BorderRadius.circular(16.r),
                            border: Border.all(
                              color: AppTheme.mediumGrey,
                              width: 1,
                            ),
                            boxShadow: [AppTheme.elevatedShadow],
                          ),
                          child: TextField(
                            controller: _searchController,
                            onChanged: (value) {
                              ref
                                  .read(searchQueryProvider.notifier)
                                  .updateQuery(value);
                            },
                            style: TextStyle(
                              color: AppTheme.primaryBlack,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Search spaces, cities...',
                              hintStyle: TextStyle(
                                color: AppTheme.darkGrey.withOpacity(0.7),
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w400,
                              ),
                              prefixIcon: Container(
                                padding: EdgeInsets.all(8.r),
                                child: Icon(
                                  Icons.search_rounded,
                                  color: AppTheme.primaryBlack,
                                  size: 18.sp,
                                ),
                              ),
                              suffixIcon: Container(
                                margin: EdgeInsets.all(4.r),
                                decoration: BoxDecoration(
                                  color:
                                      _showFilters
                                          ? AppTheme.primaryBlack
                                          : AppTheme.surfaceVariant,
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                child: IconButton(
                                  icon: Icon(
                                    Icons.tune_rounded,
                                    color:
                                        _showFilters
                                            ? AppTheme.pureWhite
                                            : AppTheme.primaryBlack,
                                    size: 16.sp,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _showFilters = !_showFilters;
                                    });
                                  },
                                ),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16.r),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 20.w,
                                vertical: 8.h,
                              ),
                            ),
                          ),
                        ),

                        // Brand-Aligned Filters Section
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeOutCubic,
                          height: _showFilters ? 65.h : 0,

                          child: AnimatedOpacity(
                            duration: const Duration(milliseconds: 300),
                            opacity: _showFilters ? 1.0 : 0.0,
                            child: Container(
                              margin: EdgeInsets.only(top: 5.h),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: _buildBrandFilterDropdown(
                                      value: cityFilter,
                                      hint: 'City',
                                      icon: Icons.location_city_rounded,
                                      items: [
                                        const DropdownMenuItem(
                                          value: null,
                                          child: Text('All Cities'),
                                        ),
                                        ...[
                                          'Kochi',
                                          'Thiruvananthapuram',
                                          'Kozhikode',
                                          'Thrissur',
                                          'Kannur',
                                        ].map(
                                          (city) => DropdownMenuItem(
                                            value: city,
                                            child: Text(city),
                                          ),
                                        ),
                                      ],
                                      onChanged: (value) {
                                        ref
                                            .read(cityFilterProvider.notifier)
                                            .updateCity(value);
                                      },
                                    ),
                                  ),
                                  SizedBox(width: 16.w),
                                  Expanded(
                                    flex: 2,
                                    child: _buildBrandFilterDropdown(
                                      value: priceFilter,
                                      hint: 'Price',
                                      icon: Icons.currency_rupee_rounded,
                                      items: [
                                        const DropdownMenuItem(
                                          value: null,
                                          child: Text('Any Price'),
                                        ),
                                        const DropdownMenuItem(
                                          value: 100.0,
                                          child: Text('₹100'),
                                        ),
                                        const DropdownMenuItem(
                                          value: 150.0,
                                          child: Text('₹150'),
                                        ),
                                        const DropdownMenuItem(
                                          value: 200.0,
                                          child: Text('₹200'),
                                        ),
                                      ],
                                      onChanged: (value) {
                                        ref
                                            .read(priceFilterProvider.notifier)
                                            .updatePrice(value);
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            actions: [
              _buildBrandActionButton(
                icon: Icons.map_outlined,
                onPressed: () => context.push('/map'),
              ),
              _buildNotificationButton(unreadCount),
              _buildBrandActionButton(
                icon: Icons.bookmark_outline_rounded,
                onPressed: () => context.push('/my-bookings'),
              ),
              SizedBox(width: 16.w),
            ],
          ),

          // Content Section
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
            sliver: spacesAsync.when(
              data:
                  (spaces) =>
                      spaces.isEmpty
                          ? SliverFillRemaining(child: _buildEmptyState())
                          : SliverList(
                            delegate: SliverChildBuilderDelegate((
                              context,
                              index,
                            ) {
                              final space = spaces[index];
                              return TweenAnimationBuilder<double>(
                                duration: Duration(
                                  milliseconds: 400 + (index * 100),
                                ),
                                tween: Tween(begin: 0.0, end: 1.0),
                                curve: Curves.easeOutBack,
                                builder: (context, value, child) {
                                  return Transform.translate(
                                    offset: Offset(0, 50 * (1 - value)),
                                    child: BrandSpaceCard(
                                      space: space,
                                      index: index,
                                    ),
                                  );
                                },
                              );
                            }, childCount: spaces.length),
                          ),
              loading: () => const SliverFillRemaining(child: LoadingWidget()),
              error:
                  (error, stack) => SliverFillRemaining(
                    child: _buildErrorState(error.toString()),
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBrandFilterDropdown<T>({
    required T? value,
    required String hint,
    required IconData icon,
    required List<DropdownMenuItem<T>> items,
    required void Function(T?) onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.pureWhite,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppTheme.mediumGrey, width: 0.5),
        boxShadow: [AppTheme.subtleShadow],
      ),
      child: DropdownButtonFormField<T>(
        value: value,
        hint: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18.sp, color: AppTheme.darkGrey),
            SizedBox(width: 8.w),
            Text(
              hint,
              style: TextStyle(
                fontSize: 14.sp,
                color: AppTheme.darkGrey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 12.h,
          ),
        ),
        items: items,
        onChanged: onChanged,
        icon: Icon(Icons.keyboard_arrow_down, color: AppTheme.primaryBlack),
        style: TextStyle(
          color: AppTheme.primaryBlack,
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildBrandActionButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      decoration: BoxDecoration(
        color: AppTheme.surfaceVariant,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppTheme.mediumGrey, width: 0.5),
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, color: AppTheme.primaryBlack),
        iconSize: 22.sp,
      ),
    );
  }

  Widget _buildNotificationButton(int unreadCount) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      decoration: BoxDecoration(
        color: AppTheme.surfaceVariant,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppTheme.mediumGrey, width: 0.5),
      ),
      child: Stack(
        children: [
          IconButton(
            onPressed: () => context.push('/notifications'),
            icon: Icon(
              Icons.notifications_outlined,
              color: AppTheme.primaryBlack,
            ),
            iconSize: 22.sp,
          ),
          if (unreadCount > 0)
            Positioned(
              right: 8.w,
              top: 8.h,
              child: Container(
                padding: EdgeInsets.all(6.r),
                decoration: BoxDecoration(
                  color: AppTheme.primaryBlack,
                  shape: BoxShape.circle,
                ),
                constraints: BoxConstraints(minWidth: 18.r, minHeight: 18.r),
                child: Text(
                  unreadCount > 99 ? '99+' : '$unreadCount',
                  style: TextStyle(
                    color: AppTheme.pureWhite,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(24.r),
            decoration: BoxDecoration(
              color: AppTheme.surfaceVariant,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.search_off_rounded,
              size: 64.sp,
              color: AppTheme.darkGrey,
            ),
          ),
          SizedBox(height: 24.h),
          Text(
            'No spaces found',
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.w700,
              color: AppTheme.primaryBlack,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Try adjusting your filters or search terms',
            style: TextStyle(
              fontSize: 16.sp,
              color: AppTheme.darkGrey,
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
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
              fontSize: 24.sp,
              fontWeight: FontWeight.w700,
              color: AppTheme.primaryBlack,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            error,
            style: TextStyle(
              fontSize: 14.sp,
              color: AppTheme.darkGrey,
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class BrandSpaceCard extends StatefulWidget {
  final CoworkingSpace space;
  final int index;

  const BrandSpaceCard({super.key, required this.space, required this.index});

  @override
  State<BrandSpaceCard> createState() => _BrandSpaceCardState();
}

class _BrandSpaceCardState extends State<BrandSpaceCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.98,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            margin: EdgeInsets.only(bottom: 20.h),
            decoration: AppTheme.logoInspiredDecoration,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => context.push('/space/${widget.space.id}'),
                onTapDown: (_) => _controller.forward(),
                onTapUp: (_) => _controller.reverse(),
                onTapCancel: () => _controller.reverse(),
                borderRadius: BorderRadius.circular(16.r),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Enhanced Image Section
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(14.r),
                          ),
                          child: CachedNetworkImage(
                            imageUrl: widget.space.images.first,
                            height: 200.h,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            placeholder:
                                (context, url) => Container(
                                  height: 200.h,
                                  decoration: BoxDecoration(
                                    color: AppTheme.surfaceVariant,
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(14.r),
                                    ),
                                  ),
                                  child: const Center(child: LoadingWidget()),
                                ),
                            errorWidget:
                                (context, url, error) => Container(
                                  height: 200.h,
                                  color: AppTheme.surfaceVariant,
                                  child: Icon(
                                    Icons.image_not_supported_rounded,
                                    size: 48.sp,
                                    color: AppTheme.darkGrey,
                                  ),
                                ),
                          ),
                        ),

                        // Speech Bubble Inspired Favorite Button
                        Positioned(
                          top: 16.h,
                          right: 16.w,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _isFavorite = !_isFavorite;
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.all(10.r),
                              decoration: AppTheme.speechBubbleDecoration
                                  .copyWith(
                                    color: AppTheme.pureWhite.withOpacity(0.95),
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                              child: Icon(
                                _isFavorite
                                    ? Icons.favorite_rounded
                                    : Icons.favorite_border_rounded,
                                color:
                                    _isFavorite
                                        ? AppTheme.errorRed
                                        : AppTheme.darkGrey,
                                size: 20.sp,
                              ),
                            ),
                          ),
                        ),

                        // City Badge with Brand Styling
                        Positioned(
                          top: 16.h,
                          left: 16.w,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 8.h,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryBlack,
                              borderRadius: BorderRadius.circular(20.r),
                              boxShadow: [AppTheme.subtleShadow],
                            ),
                            child: Text(
                              widget.space.city.toUpperCase(),
                              style: TextStyle(
                                color: AppTheme.pureWhite,
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    // Enhanced Content Section
                    Padding(
                      padding: EdgeInsets.all(20.r),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title and Rating Row
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  widget.space.name,
                                  style: TextStyle(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w700,
                                    color: AppTheme.primaryBlack,
                                    letterSpacing: -0.2,
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12.w,
                                  vertical: 6.h,
                                ),
                                decoration: BoxDecoration(
                                  color: AppTheme.warningAmber.withOpacity(
                                    0.15,
                                  ),
                                  borderRadius: BorderRadius.circular(12.r),
                                  border: Border.all(
                                    color: AppTheme.warningAmber.withOpacity(
                                      0.3,
                                    ),
                                    width: 0.5,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.star_rounded,
                                      color: AppTheme.warningAmber,
                                      size: 16.sp,
                                    ),
                                    SizedBox(width: 4.w),
                                    Text(
                                      '4.5',
                                      style: TextStyle(
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.w700,
                                        color: AppTheme.primaryBlack,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: 12.h),

                          // Location Row
                          Row(
                            children: [
                              Icon(
                                Icons.location_on_rounded,
                                size: 18.sp,
                                color: AppTheme.darkGrey,
                              ),
                              SizedBox(width: 8.w),
                              Expanded(
                                child: Text(
                                  widget.space.location,
                                  style: TextStyle(
                                    color: AppTheme.darkGrey,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: 20.h),

                          // Price and Book Button Row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'STARTING FROM',
                                    style: TextStyle(
                                      fontSize: 11.sp,
                                      color: AppTheme.darkGrey,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 1.2,
                                    ),
                                  ),
                                  SizedBox(height: 4.h),
                                  Text(
                                    '₹${widget.space.pricePerHour.toInt()}/hr',
                                    style: TextStyle(
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.w700,
                                      color: AppTheme.primaryBlack,
                                      letterSpacing: -0.3,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                decoration: AppTheme.speechBubbleDecoration,
                                child: ElevatedButton(
                                  onPressed:
                                      () => context.push(
                                        '/space/${widget.space.id}',
                                      ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    foregroundColor: AppTheme.pureWhite,
                                    elevation: 0,
                                    shadowColor: Colors.transparent,
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 24.w,
                                      vertical: 12.h,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12.r),
                                    ),
                                  ),
                                  child: Text(
                                    'VIEW DETAILS',
                                    style: TextStyle(
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 0.8,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
