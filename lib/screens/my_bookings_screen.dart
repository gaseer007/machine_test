import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../models/booking.dart';
import '../providers/app_providers.dart';
import '../themes/app_theme.dart';
import '../widgets/loading_widget.dart';

class MyBookingsScreen extends ConsumerStatefulWidget {
  const MyBookingsScreen({super.key});

  @override
  ConsumerState<MyBookingsScreen> createState() => _MyBookingsScreenState();
}

class _MyBookingsScreenState extends ConsumerState<MyBookingsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bookingsAsync = ref.watch(bookingsProvider);

    return Scaffold(
      backgroundColor: AppTheme.lightGrey,
      appBar: AppBar(
        leading: Container(
          margin: EdgeInsets.all(8.r),
          decoration: BoxDecoration(
            color: AppTheme.surfaceVariant,
            borderRadius: BorderRadius.circular(12.r),
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
        title: Text(
          'MY BOOKINGS',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
            color: AppTheme.primaryBlack,
          ),
        ),
        backgroundColor: AppTheme.pureWhite,
        foregroundColor: AppTheme.primaryBlack,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      body: bookingsAsync.when(
        data: (bookings) {
          if (bookings.isEmpty) {
            return FadeTransition(
              opacity: _fadeAnimation,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.all(32.r),
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceVariant,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.bookmark_outline_rounded,
                        size: 64.sp,
                        color: AppTheme.darkGrey,
                      ),
                    ),
                    SizedBox(height: 24.h),
                    Text(
                      'No bookings yet',
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.primaryBlack,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'Your future bookings will appear here',
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: AppTheme.darkGrey,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          final sortedBookings = List<Booking>.from(bookings)
            ..sort((a, b) => b.date.compareTo(a.date));

          return FadeTransition(
            opacity: _fadeAnimation,
            child: ListView.builder(
              padding: EdgeInsets.all(20.r),
              itemCount: sortedBookings.length,
              itemBuilder: (context, index) {
                return TweenAnimationBuilder<double>(
                  duration: Duration(milliseconds: 300 + (index * 100)),
                  tween: Tween(begin: 0.0, end: 1.0),
                  curve: Curves.easeOutBack,
                  builder: (context, value, child) {
                    return Transform.translate(
                      offset: Offset(0, 30 * (1 - value)),
                      child: BrandBookingCard(booking: sortedBookings[index]),
                    );
                  },
                );
              },
            ),
          );
        },
        loading: () => const Center(child: LoadingWidget()),
        error:
            (error, stack) => Center(
              child: Text(
                'Error: $error',
                style: TextStyle(color: AppTheme.errorRed, fontSize: 16.sp),
              ),
            ),
      ),
    );
  }
}

class BrandBookingCard extends StatelessWidget {
  final Booking booking;

  const BrandBookingCard({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    final statusColor =
        booking.status == BookingStatus.upcoming
            ? AppTheme.warningAmber
            : booking.status == BookingStatus.completed
            ? AppTheme.successGreen
            : AppTheme.errorRed;

    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: AppTheme.logoInspiredDecoration,
      child: Padding(
        padding: EdgeInsets.all(20.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    booking.spaceName,
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
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: statusColor.withOpacity(0.3),
                      width: 0.5,
                    ),
                  ),
                  child: Text(
                    booking.status.name.toUpperCase(),
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 16.h),

            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8.r),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceVariant,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Icon(
                    Icons.calendar_today_rounded,
                    size: 16.sp,
                    color: AppTheme.primaryBlack,
                  ),
                ),
                SizedBox(width: 12.w),
                Text(
                  DateFormat('MMMM d, y').format(booking.date),
                  style: TextStyle(
                    color: AppTheme.primaryBlack,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),

            SizedBox(height: 12.h),

            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8.r),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceVariant,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Icon(
                    Icons.access_time_rounded,
                    size: 16.sp,
                    color: AppTheme.primaryBlack,
                  ),
                ),
                SizedBox(width: 12.w),
                Text(
                  booking.timeSlot,
                  style: TextStyle(
                    color: AppTheme.primaryBlack,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),

            SizedBox(height: 20.h),

            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              decoration: AppTheme.speechBubbleDecoration,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'TOTAL PAID',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: AppTheme.pureWhite.withOpacity(0.8),
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.0,
                    ),
                  ),
                  Text(
                    '₹${booking.totalAmount.toInt()}',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.pureWhite,
                      letterSpacing: -0.2,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 12.h),

            Text(
              'BOOKED ON ${DateFormat('MMM d').format(booking.createdAt).toUpperCase()}',
              style: TextStyle(
                color: AppTheme.darkGrey,
                fontSize: 10.sp,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
