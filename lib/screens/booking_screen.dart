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

class BookingScreen extends ConsumerStatefulWidget {
  final String spaceId;

  const BookingScreen({super.key, required this.spaceId});

  @override
  ConsumerState<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends ConsumerState<BookingScreen>
    with TickerProviderStateMixin {
  DateTime selectedDate = DateTime.now();
  String? selectedTimeSlot;
  int duration = 1;
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final List<String> timeSlots = [
    '9:00 AM - 10:00 AM',
    '10:00 AM - 11:00 AM',
    '11:00 AM - 12:00 PM',
    '12:00 PM - 1:00 PM',
    '2:00 PM - 3:00 PM',
    '3:00 PM - 4:00 PM',
    '4:00 PM - 5:00 PM',
    '5:00 PM - 6:00 PM',
  ];

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
    );

    // Start animations
    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
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
          appBar: _buildModernAppBar(),
          body: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSpaceInfoCard(space),
                    SizedBox(height: 24.h),
                    _buildDateSelector(),
                    SizedBox(height: 24.h),
                    _buildTimeSlotSelector(),
                    SizedBox(height: 24.h),
                    _buildDurationSelector(),
                    SizedBox(height: 24.h),
                    _buildPricingSummary(space),
                    SizedBox(height: 32.h),
                    _buildConfirmButton(),
                    SizedBox(height: 24.h),
                  ],
                ),
              ),
            ),
          ),
        );
      },
      loading:
          () => Scaffold(
            backgroundColor: AppTheme.lightGrey,
            body: const LoadingWidget(),
          ),
      error:
          (error, stack) => Scaffold(
            backgroundColor: AppTheme.lightGrey,
            body: Center(
              child: Container(
                margin: EdgeInsets.all(16.w),
                decoration: AppTheme.containerDecoration,
                padding: EdgeInsets.all(24.w),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 48.w,
                      color: AppTheme.primaryBlack,
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      'Oops! Something went wrong',
                      style: Theme.of(context).textTheme.headlineSmall,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      error.toString(),
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
    );
  }

  AppBar _buildModernAppBar() {
    return AppBar(
      leading: Container(
        margin: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          color: AppTheme.pureWhite,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [AppTheme.subtleShadow],
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
      title: Text(
        'BOOK SPACE',
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w700,
          letterSpacing: 1.5,
        ),
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
    );
  }

  Widget _buildSpaceInfoCard(space) {
    return Container(
      decoration: AppTheme.logoInspiredDecoration,
      padding: EdgeInsets.all(24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: AppTheme.speechBubbleDecoration,
                child: Text(
                  'PREMIUM',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppTheme.pureWhite,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              const Spacer(),
              Icon(Icons.verified, color: AppTheme.accentBlue, size: 20.w),
            ],
          ),
          SizedBox(height: 16.h),
          Text(
            space.name,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
              letterSpacing: -0.5,
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
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: AppTheme.darkGrey),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: AppTheme.accentBlue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: AppTheme.accentBlue.withOpacity(0.2)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.currency_rupee,
                  size: 20.w,
                  color: AppTheme.accentBlue,
                ),
                Text(
                  '${space.pricePerHour.toInt()}',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppTheme.accentBlue,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  '/hour',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: AppTheme.accentBlue),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Text(
            'SELECT DATE',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
            ),
          ),
        ),
        SizedBox(height: 12.h),
        Container(
          decoration: AppTheme.containerDecoration,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: _selectDate,
              borderRadius: BorderRadius.circular(16.r),
              child: Padding(
                padding: EdgeInsets.all(20.w),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryBlack.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Icon(
                        Icons.calendar_today_outlined,
                        size: 20.w,
                        color: AppTheme.primaryBlack,
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Booking Date',
                            style: Theme.of(
                              context,
                            ).textTheme.bodySmall?.copyWith(
                              color: AppTheme.darkGrey,
                              letterSpacing: 0.5,
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            DateFormat('EEEE, MMMM d, y').format(selectedDate),
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 16.w,
                      color: AppTheme.darkGrey,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimeSlotSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Text(
            'SELECT TIME SLOT',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
            ),
          ),
        ),
        SizedBox(height: 12.h),
        Container(
          decoration: AppTheme.containerDecoration,
          padding: EdgeInsets.all(16.w),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 2.8,
              crossAxisSpacing: 12.w,
              mainAxisSpacing: 12.h,
            ),
            itemCount: timeSlots.length,
            itemBuilder: (context, index) {
              final slot = timeSlots[index];
              final isSelected = selectedTimeSlot == slot;

              return AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => _selectTimeSlot(slot),
                    borderRadius: BorderRadius.circular(12.r),
                    child: Container(
                      decoration: BoxDecoration(
                        color:
                            isSelected
                                ? AppTheme.primaryBlack
                                : AppTheme.lightGrey,
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color:
                              isSelected
                                  ? AppTheme.primaryBlack
                                  : AppTheme.mediumGrey,
                          width: 1.5,
                        ),
                        boxShadow: isSelected ? [AppTheme.subtleShadow] : null,
                      ),
                      child: Center(
                        child: Text(
                          slot,
                          style: Theme.of(
                            context,
                          ).textTheme.labelLarge?.copyWith(
                            color:
                                isSelected
                                    ? AppTheme.pureWhite
                                    : AppTheme.primaryBlack,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.2,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDurationSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Text(
            'DURATION',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
            ),
          ),
        ),
        SizedBox(height: 12.h),
        Container(
          decoration: AppTheme.containerDecoration,
          padding: EdgeInsets.all(24.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildDurationButton(
                icon: Icons.remove,
                onPressed: duration > 1 ? () => _updateDuration(-1) : null,
              ),
              Column(
                children: [
                  Text(
                    '$duration',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppTheme.primaryBlack,
                    ),
                  ),
                  Text(
                    duration > 1 ? 'HOURS' : 'HOUR',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      letterSpacing: 1.5,
                      color: AppTheme.darkGrey,
                    ),
                  ),
                ],
              ),
              _buildDurationButton(
                icon: Icons.add,
                onPressed: duration < 8 ? () => _updateDuration(1) : null,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDurationButton({
    required IconData icon,
    required VoidCallback? onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: onPressed != null ? AppTheme.primaryBlack : AppTheme.mediumGrey,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: onPressed != null ? [AppTheme.subtleShadow] : null,
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, color: AppTheme.pureWhite, size: 20.w),
        style: IconButton.styleFrom(
          backgroundColor: Colors.transparent,
          minimumSize: Size(48.w, 48.h),
        ),
      ),
    );
  }

  Widget _buildPricingSummary(space) {
    final totalAmount = space.pricePerHour * duration;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.accentBlue.withOpacity(0.1),
            AppTheme.primaryBlack.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppTheme.accentBlue.withOpacity(0.2)),
      ),
      padding: EdgeInsets.all(24.w),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Price per hour',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Text(
                '₹${space.pricePerHour.toInt()}',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Duration', style: Theme.of(context).textTheme.bodyMedium),
              Text(
                '$duration hour${duration > 1 ? 's' : ''}',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 16.h),
            child: Divider(color: AppTheme.mediumGrey),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'TOTAL AMOUNT',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                ),
              ),
              Row(
                children: [
                  Icon(
                    Icons.currency_rupee,
                    size: 24.w,
                    color: AppTheme.accentBlue,
                  ),
                  Text(
                    '${totalAmount.toInt()}',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppTheme.accentBlue,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmButton() {
    final isEnabled = selectedTimeSlot != null;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: double.infinity,
      height: 56.h,
      decoration: BoxDecoration(
        gradient:
            isEnabled
                ? LinearGradient(
                  colors: [AppTheme.primaryBlack, AppTheme.speechBubbleBlack],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
                : null,
        color: isEnabled ? null : AppTheme.mediumGrey,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: isEnabled ? [AppTheme.elevatedShadow] : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isEnabled ? _confirmBooking : null,
          borderRadius: BorderRadius.circular(16.r),
          child: Center(
            child: Text(
              'CONFIRM BOOKING',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppTheme.pureWhite,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.5,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: AppTheme.primaryBlack,
              onPrimary: AppTheme.pureWhite,
              surface: AppTheme.pureWhite,
              onSurface: AppTheme.primaryBlack,
            ),
          ),
          child: child!,
        );
      },
    );
    if (date != null) {
      setState(() {
        selectedDate = date;
        selectedTimeSlot = null;
      });
    }
  }

  void _selectTimeSlot(String slot) {
    setState(() {
      selectedTimeSlot = slot;
    });
  }

  void _updateDuration(int change) {
    setState(() {
      duration += change;
    });
  }

  void _confirmBooking() async {
    final spacesAsync = ref.read(coworkingSpacesProvider);
    final spaces = spacesAsync.value!;
    final space = spaces.firstWhere((s) => s.id == widget.spaceId);

    final booking = Booking(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      spaceId: space.id,
      spaceName: space.name,
      date: selectedDate,
      timeSlot: selectedTimeSlot!,
      totalAmount: space.pricePerHour * duration,
      status: BookingStatus.upcoming,
      createdAt: DateTime.now(),
    );

    await ref.read(bookingsProvider.notifier).addBooking(booking);

    if (mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder:
            (context) => AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.r),
              ),
              title: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      color: AppTheme.accentBlue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Icon(
                      Icons.check_circle,
                      color: AppTheme.accentBlue,
                      size: 24.w,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Text(
                    'BOOKING CONFIRMED!',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Your booking has been successfully confirmed.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  SizedBox(height: 16.h),
                  Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: AppTheme.lightGrey,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          space.name,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          '${DateFormat('MMMM d, y').format(selectedDate)} at $selectedTimeSlot',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: AppTheme.darkGrey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    context.push('/home');
                  },
                  child: Text(
                    'HOME',
                    style: TextStyle(
                      color: AppTheme.darkGrey,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    context.push('/my-bookings');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryBlack,
                    foregroundColor: AppTheme.pureWhite,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  child: Text(
                    'VIEW BOOKINGS',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
      );
    }
  }
}
