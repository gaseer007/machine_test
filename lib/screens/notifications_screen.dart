import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../models/notification_model.dart';
import '../providers/app_providers.dart';
import '../themes/app_theme.dart';
import '../widgets/loading_widget.dart';

class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({super.key});

  @override
  ConsumerState<NotificationsScreen> createState() =>
      _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  bool _showUnreadOnly = false;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
    );

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
    final notificationsAsync = ref.watch(notificationsProvider);

    return Scaffold(
      backgroundColor: AppTheme.lightGrey,
      appBar: _buildModernAppBar(notificationsAsync),
      body: notificationsAsync.when(
        data: (notifications) {
          final filteredNotifications =
              _showUnreadOnly
                  ? notifications.where((n) => !n.isRead).toList()
                  : notifications;

          if (notifications.isEmpty) {
            return _buildEmptyState();
          }

          if (filteredNotifications.isEmpty && _showUnreadOnly) {
            return _buildNoUnreadState();
          }

          return FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: Column(
                children: [
                  _buildFilterSection(notifications),
                  Expanded(
                    child: _buildNotificationsList(filteredNotifications),
                  ),
                ],
              ),
            ),
          );
        },
        loading:
            () => Scaffold(
              backgroundColor: AppTheme.lightGrey,
              body: const LoadingWidget(),
            ),
        error: (error, stack) => _buildErrorState(error),
      ),
    );
  }

  AppBar _buildModernAppBar(AsyncValue notificationsAsync) {
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
        'NOTIFICATIONS',
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w700,
          letterSpacing: 1.5,
        ),
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      actions: [
        Container(
          margin: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: AppTheme.pureWhite,
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: [AppTheme.subtleShadow],
          ),
          child: IconButton(
            onPressed: () => _markAllAsRead(notificationsAsync),
            icon: const Icon(Icons.done_all, size: 20),
            style: IconButton.styleFrom(
              backgroundColor: Colors.transparent,
              foregroundColor: AppTheme.primaryBlack,
            ),
            tooltip: 'Mark all as read',
          ),
        ),
      ],
    );
  }

  Widget _buildFilterSection(List<NotificationModel> notifications) {
    final unreadCount = notifications.where((n) => !n.isRead).length;

    return Container(
      margin: EdgeInsets.all(16.w),
      decoration: AppTheme.containerDecoration,
      padding: EdgeInsets.all(16.w),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.filter_list_outlined,
                size: 20.w,
                color: AppTheme.darkGrey,
              ),
              SizedBox(width: 8.w),
              Text(
                'FILTER',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                ),
              ),
              const Spacer(),
              if (unreadCount > 0)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: AppTheme.speechBubbleDecoration,
                  child: Text(
                    '$unreadCount NEW',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppTheme.pureWhite,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Expanded(
                child: _buildFilterChip(
                  label: 'All (${notifications.length})',
                  isSelected: !_showUnreadOnly,
                  onTap: () => setState(() => _showUnreadOnly = false),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _buildFilterChip(
                  label: 'Unread ($unreadCount)',
                  isSelected: _showUnreadOnly,
                  onTap: () => setState(() => _showUnreadOnly = true),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12.r),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
            decoration: BoxDecoration(
              color: isSelected ? AppTheme.primaryBlack : AppTheme.lightGrey,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: isSelected ? AppTheme.primaryBlack : AppTheme.mediumGrey,
                width: 1.5,
              ),
            ),
            child: Center(
              child: Text(
                label,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color:
                      isSelected ? AppTheme.pureWhite : AppTheme.primaryBlack,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.3,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationsList(List<NotificationModel> notifications) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        final notification = notifications[index];
        return AnimatedContainer(
          duration: Duration(milliseconds: 200 + (index * 50)),
          curve: Curves.easeOutCubic,
          child: NotificationTile(notification: notification, index: index),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Center(
        child: Container(
          margin: EdgeInsets.all(32.w),
          decoration: AppTheme.containerDecoration,
          padding: EdgeInsets.all(32.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(24.w),
                decoration: BoxDecoration(
                  color: AppTheme.primaryBlack.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.notifications_none_outlined,
                  size: 48.w,
                  color: AppTheme.primaryBlack,
                ),
              ),
              SizedBox(height: 24.h),
              Text(
                'NO NOTIFICATIONS YET',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8.h),
              Text(
                'You\'ll see important updates and messages here when they arrive.',
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

  Widget _buildNoUnreadState() {
    return Center(
      child: Container(
        margin: EdgeInsets.all(32.w),
        decoration: AppTheme.containerDecoration,
        padding: EdgeInsets.all(32.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(24.w),
              decoration: BoxDecoration(
                color: AppTheme.accentBlue.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check_circle_outline,
                size: 48.w,
                color: AppTheme.accentBlue,
              ),
            ),
            SizedBox(height: 24.h),
            Text(
              'ALL CAUGHT UP!',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8.h),
            Text(
              'No unread notifications at the moment.',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppTheme.darkGrey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(dynamic error) {
    return Center(
      child: Container(
        margin: EdgeInsets.all(32.w),
        decoration: AppTheme.containerDecoration,
        padding: EdgeInsets.all(32.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(24.w),
              decoration: BoxDecoration(
                color: AppTheme.errorRed.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.error_outline,
                size: 48.w,
                color: AppTheme.errorRed,
              ),
            ),
            SizedBox(height: 24.h),
            Text(
              'SOMETHING WENT WRONG',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
              ),
              textAlign: TextAlign.center,
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
    );
  }

  void _markAllAsRead(AsyncValue notificationsAsync) {
    notificationsAsync.whenData((notifications) {
      for (final notif in notifications) {
        if (!notif.isRead) {
          ref.read(notificationsProvider.notifier).markAsRead(notif.id);
        }
      }

      // Show feedback
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'All notifications marked as read',
            style: Theme.of(context).snackBarTheme.contentTextStyle,
          ),
          backgroundColor: AppTheme.primaryBlack,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
      );
    });
  }
}

class NotificationTile extends ConsumerStatefulWidget {
  final NotificationModel notification;
  final int index;

  const NotificationTile({
    super.key,
    required this.notification,
    required this.index,
  });

  @override
  ConsumerState<NotificationTile> createState() => _NotificationTileState();
}

class _NotificationTileState extends ConsumerState<NotificationTile>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isUnread = !widget.notification.isRead;

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTapDown: (_) => _scaleController.forward(),
            onTapUp: (_) => _scaleController.reverse(),
            onTapCancel: () => _scaleController.reverse(),
            onTap: () => _handleNotificationTap(),
            borderRadius: BorderRadius.circular(16.r),
            child: Container(
              decoration: BoxDecoration(
                color: AppTheme.pureWhite,
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(
                  color:
                      isUnread
                          ? AppTheme.accentBlue.withOpacity(0.3)
                          : AppTheme.mediumGrey,
                  width: isUnread ? 1.5 : 0.5,
                ),
                boxShadow: [
                  if (isUnread)
                    AppTheme.elevatedShadow
                  else
                    AppTheme.subtleShadow,
                ],
              ),
              child: Padding(
                padding: EdgeInsets.all(20.w),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildNotificationIcon(isUnread),
                    SizedBox(width: 16.w),
                    Expanded(child: _buildNotificationContent()),
                    if (isUnread) _buildUnreadIndicator(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationIcon(bool isUnread) {
    IconData iconData;
    Color backgroundColor;

    // Different icons based on notification type (you can enhance this)
    switch (widget.notification.title) {
      case 'booking':
        iconData = Icons.event_available;
        backgroundColor = AppTheme.accentBlue;
        break;
      case 'reminder':
        iconData = Icons.access_time;
        backgroundColor = AppTheme.warningAmber;
        break;
      case 'system':
        iconData = Icons.info;
        backgroundColor = AppTheme.darkGrey;
        break;
      default:
        iconData = Icons.notifications;
        backgroundColor = isUnread ? AppTheme.primaryBlack : AppTheme.darkGrey;
    }

    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: backgroundColor.withOpacity(isUnread ? 1.0 : 0.6),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Icon(iconData, color: AppTheme.pureWhite, size: 20.w),
    );
  }

  Widget _buildNotificationContent() {
    final isUnread = !widget.notification.isRead;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.notification.title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: isUnread ? FontWeight.w700 : FontWeight.w600,
            color: AppTheme.primaryBlack,
            letterSpacing: 0.1,
          ),
        ),
        SizedBox(height: 6.h),
        Text(
          widget.notification.body,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppTheme.darkGrey,
            height: 1.4,
          ),
        ),
        SizedBox(height: 8.h),
        Row(
          children: [
            Icon(
              Icons.schedule,
              size: 12.w,
              color: AppTheme.darkGrey.withOpacity(0.7),
            ),
            SizedBox(width: 4.w),
            Text(
              _formatTimestamp(widget.notification.createdAt),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppTheme.darkGrey.withOpacity(0.8),
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildUnreadIndicator() {
    return Container(
      width: 8.w,
      height: 8.h,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppTheme.accentBlue, AppTheme.primaryBlack],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppTheme.accentBlue.withOpacity(0.3),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return DateFormat('MMM d, y').format(timestamp);
    }
  }

  void _handleNotificationTap() {
    if (!widget.notification.isRead) {
      ref
          .read(notificationsProvider.notifier)
          .markAsRead(widget.notification.id);

      // Haptic feedback
      // HapticFeedback.lightImpact(); // Uncomment if you want haptic feedback
    }
  }
}
