import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:sharely/core/shared_prefs/user_shared_prefs.dart';
import 'package:sharely/core/services/storage/user_session_service.dart';
import 'package:sharely/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:sharely/features/auth/presentation/pages/login_page.dart';
import 'package:sharely/features/dashboard/presentation/pages/dashboard_page.dart';

final splashViewModelProvider = StateNotifierProvider<SplashViewModel, void>((ref) {
  return SplashViewModel(
    userSharedPrefs: ref.watch(userSharedPrefsProvider),
    userSessionService: ref.watch(userSessionServiceProvider),
  );
});

class SplashViewModel extends StateNotifier<void> {
  final UserSharedPrefs _userSharedPrefs;
  final UserSessionService _userSessionService;

  SplashViewModel({
    required UserSharedPrefs userSharedPrefs,
    required UserSessionService userSessionService,
  })  : _userSharedPrefs = userSharedPrefs,
        _userSessionService = userSessionService,
        super(null);

  Future<void> init(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 2));

    final isFirstTimeResult = await _userSharedPrefs.getFirstTime();
    
    // Add mounted check before navigation
    if (!context.mounted) return;

    isFirstTimeResult.fold(
      (failure) {
        // Fallback to onboarding if there's an error
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const OnboardingPage()),
        );
      },
      (isFirstTime) {
        if (isFirstTime) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const OnboardingPage()),
          );
        } else {
          // If not first time, check if logged in
          if (_userSessionService.isLoggedIn()) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const DashboardPage()),
            );
          } else {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const LoginPage()),
            );
          }
        }
      },
    );
  }
}

