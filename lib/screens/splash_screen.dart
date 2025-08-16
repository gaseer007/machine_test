// import 'dart:async';
//
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
//
// class InnerSpaceSplashScreen extends StatefulWidget {
//   const InnerSpaceSplashScreen({Key? key}) : super(key: key);
//
//   @override
//   State<InnerSpaceSplashScreen> createState() => _InnerSpaceSplashScreenState();
// }
//
// class _InnerSpaceSplashScreenState extends State<InnerSpaceSplashScreen>
//     with TickerProviderStateMixin {
//   late AnimationController _logoController;
//   late AnimationController _textController;
//   late AnimationController _backgroundController;
//
//   late Animation<double> _logoScaleAnimation;
//   late Animation<double> _logoOpacityAnimation;
//   late Animation<double> _textOpacityAnimation;
//   late Animation<Offset> _textSlideAnimation;
//   late Animation<double> _backgroundAnimation;
//
//   @override
//   void initState() {
//     super.initState();
//
//     // Initialize animation controllers
//     _logoController = AnimationController(
//       duration: const Duration(milliseconds: 1200),
//       vsync: this,
//     );
//
//     _textController = AnimationController(
//       duration: const Duration(milliseconds: 800),
//       vsync: this,
//     );
//
//     _backgroundController = AnimationController(
//       duration: const Duration(milliseconds: 2500),
//       vsync: this,
//     );
//
//     // Logo animations
//     _logoScaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(
//         parent: _logoController,
//         curve: const Interval(0.0, 0.6, curve: Curves.elasticOut),
//       ),
//     );
//
//     _logoOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(
//         parent: _logoController,
//         curve: const Interval(0.0, 0.4, curve: Curves.easeIn),
//       ),
//     );
//
//     // Text animations
//     _textOpacityAnimation = Tween<double>(
//       begin: 0.0,
//       end: 1.0,
//     ).animate(CurvedAnimation(parent: _textController, curve: Curves.easeIn));
//
//     _textSlideAnimation = Tween<Offset>(
//       begin: const Offset(0, 0.3),
//       end: Offset.zero,
//     ).animate(
//       CurvedAnimation(parent: _textController, curve: Curves.easeOutCubic),
//     );
//
//     // Background animation
//     _backgroundAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(parent: _backgroundController, curve: Curves.easeInOut),
//     );
//
//     // Start animations sequence
//     _startAnimations();
//   }
//
//   void _startAnimations() async {
//     // Start background animation immediately
//     _backgroundController.forward();
//
//     // Start logo animation after a short delay
//     await Future.delayed(const Duration(milliseconds: 200));
//     _logoController.forward();
//
//     // Start text animation after logo
//     await Future.delayed(const Duration(milliseconds: 600));
//     _textController.forward();
//
//     // Navigate to next screen after 2.5 seconds
//     Timer(const Duration(milliseconds: 2500), () {
//       // Replace with your navigation logic
//       // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomeScreen()));
//       if (mounted) {
//         context.go('/home');
//       }
//     });
//   }
//
//   @override
//   void dispose() {
//     _logoController.dispose();
//     _textController.dispose();
//     _backgroundController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: AnimatedBuilder(
//         animation: Listenable.merge([
//           _logoController,
//           _textController,
//           _backgroundController,
//         ]),
//         builder: (context, child) {
//           return Container(
//             width: double.infinity,
//             height: double.infinity,
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//                 colors: [
//                   Color.lerp(
//                     const Color(0xFF1a1a1a),
//                     const Color(0xFF2d2d2d),
//                     _backgroundAnimation.value,
//                   )!,
//                   Color.lerp(
//                     const Color(0xFF0a0a0a),
//                     const Color(0xFF1a1a1a),
//                     _backgroundAnimation.value,
//                   )!,
//                 ],
//               ),
//             ),
//             child: SafeArea(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   const Spacer(flex: 2),
//
//                   // Logo Container with Animation
//                   Transform.scale(
//                     scale: _logoScaleAnimation.value,
//                     child: Opacity(
//                       opacity: _logoOpacityAnimation.value,
//                       child: Container(
//                         width: 200,
//                         height: 200,
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(20),
//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors.white.withOpacity(
//                                 0.3 * _logoOpacityAnimation.value,
//                               ),
//                               blurRadius: 30,
//                               spreadRadius: 5,
//                             ),
//                           ],
//                         ),
//                         child: Padding(
//                           padding: const EdgeInsets.all(20),
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               // INNER SPACE text
//                               const Text(
//                                 'INNER\nSPACE',
//                                 textAlign: TextAlign.center,
//                                 style: TextStyle(
//                                   fontSize: 28,
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.black,
//                                   height: 0.9,
//                                   letterSpacing: -1,
//                                 ),
//                               ),
//                               const SizedBox(height: 12),
//                               // Speech bubble
//                               Container(
//                                 width: 40,
//                                 height: 25,
//                                 decoration: const BoxDecoration(
//                                   color: Colors.black,
//                                   borderRadius: BorderRadius.only(
//                                     topLeft: Radius.circular(8),
//                                     topRight: Radius.circular(8),
//                                     bottomLeft: Radius.circular(8),
//                                   ),
//                                 ),
//                               ),
//                               // COWORKING text
//                               const Padding(
//                                 padding: EdgeInsets.only(top: 8),
//                                 child: Text(
//                                   'COWORKING',
//                                   style: TextStyle(
//                                     fontSize: 9,
//                                     fontWeight: FontWeight.bold,
//                                     color: Colors.black,
//                                     letterSpacing: 3,
//                                   ),
//                                 ),
//                               ),
//                               const Text(
//                                 '®',
//                                 style: TextStyle(
//                                   fontSize: 8,
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.black,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//
//                   const SizedBox(height: 40),
//
//                   // Animated text content
//                   SlideTransition(
//                     position: _textSlideAnimation,
//                     child: FadeTransition(
//                       opacity: _textOpacityAnimation,
//                       child: Column(
//                         children: [
//                           const Text(
//                             'INNERSPACE',
//                             style: TextStyle(
//                               fontSize: 32,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.white,
//                               letterSpacing: 4,
//                             ),
//                           ),
//                           const SizedBox(height: 8),
//                           const Text(
//                             'CO-WORKING SPACE',
//                             style: TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.w300,
//                               color: Colors.white70,
//                               letterSpacing: 2,
//                             ),
//                           ),
//                           const SizedBox(height: 24),
//                           Container(
//                             width: 60,
//                             height: 2,
//                             decoration: BoxDecoration(
//                               color: Colors.white,
//                               borderRadius: BorderRadius.circular(1),
//                             ),
//                           ),
//                           const SizedBox(height: 24),
//                           const Padding(
//                             padding: EdgeInsets.symmetric(horizontal: 40),
//                             child: Text(
//                               'Where ideas flourish and collaboration thrives.\nYour premium workspace awaits.',
//                               textAlign: TextAlign.center,
//                               style: TextStyle(
//                                 fontSize: 14,
//                                 fontWeight: FontWeight.w300,
//                                 color: Colors.white60,
//                                 height: 1.5,
//                                 letterSpacing: 0.5,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//
//                   const Spacer(flex: 3),
//
//                   // Loading indicator
//                   FadeTransition(
//                     opacity: _textOpacityAnimation,
//                     child: Container(
//                       width: 30,
//                       height: 30,
//                       child: CircularProgressIndicator(
//                         strokeWidth: 2,
//                         valueColor: AlwaysStoppedAnimation<Color>(
//                           Colors.white.withOpacity(0.6),
//                         ),
//                       ),
//                     ),
//                   ),
//
//                   const SizedBox(height: 40),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class InnerSpaceSplashScreen extends StatefulWidget {
  const InnerSpaceSplashScreen({Key? key}) : super(key: key);

  @override
  State<InnerSpaceSplashScreen> createState() => _InnerSpaceSplashScreenState();
}

class _InnerSpaceSplashScreenState extends State<InnerSpaceSplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _textController;
  late AnimationController _backgroundController;

  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoOpacityAnimation;
  late Animation<double> _textOpacityAnimation;
  late Animation<Offset> _textSlideAnimation;
  late Animation<double> _backgroundAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize animation controllers
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _textController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _backgroundController = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    );

    // Logo animations
    _logoScaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.0, 0.6, curve: Curves.elasticOut),
      ),
    );

    _logoOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.0, 0.4, curve: Curves.easeIn),
      ),
    );

    // Text animations
    _textOpacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _textController, curve: Curves.easeIn));

    _textSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeOutCubic),
    );

    // Background animation
    _backgroundAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _backgroundController, curve: Curves.easeInOut),
    );

    // Start animations sequence
    _startAnimations();
  }

  void _startAnimations() async {
    // Start background animation immediately
    _backgroundController.forward();

    // Start logo animation after a short delay
    await Future.delayed(const Duration(milliseconds: 200));
    _logoController.forward();

    // Start text animation after logo
    await Future.delayed(const Duration(milliseconds: 600));
    _textController.forward();

    // Navigate to next screen after 2.5 seconds
    Timer(const Duration(milliseconds: 2500), () {
      if (mounted) {
        context.go('/home');
      }
    });
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    _backgroundController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: Listenable.merge([
          _logoController,
          _textController,
          _backgroundController,
        ]),
        builder: (context, child) {
          return Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color.lerp(
                    const Color(0xFF1a1a1a),
                    const Color(0xFF2d2d2d),
                    _backgroundAnimation.value,
                  )!,
                  Color.lerp(
                    const Color(0xFF0a0a0a),
                    const Color(0xFF1a1a1a),
                    _backgroundAnimation.value,
                  )!,
                ],
              ),
            ),
            child: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(flex: 2),

                  // Logo Container with Animation + Asset Image
                  Transform.scale(
                    scale: _logoScaleAnimation.value,
                    child: Opacity(
                      opacity: _logoOpacityAnimation.value,
                      child: Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white.withOpacity(
                                0.3 * _logoOpacityAnimation.value,
                              ),
                              blurRadius: 30,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Image.asset(
                            'assets/logo.png', // <-- use your logo here
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Animated text content
                  SlideTransition(
                    position: _textSlideAnimation,
                    child: FadeTransition(
                      opacity: _textOpacityAnimation,
                      child: Column(
                        children: const [
                          Text(
                            'INNERSPACE',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 4,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'CO-WORKING SPACE',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w300,
                              color: Colors.white70,
                              letterSpacing: 2,
                            ),
                          ),
                          SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),

                  const Spacer(flex: 3),

                  FadeTransition(
                    opacity: _textOpacityAnimation,
                    child: SizedBox(
                      width: 30,
                      height: 30,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.white54,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
