import 'dart:io';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'logging_service.dart';
import '../utils/platform_utils.dart';

class AdService {
  final Ref _ref;

  AdService(this._ref);

  // Initialize Ads SDK
  Future<void> init() async {
    if (!isMobilePlatform) return;
    final log = _ref.read(loggerProvider);
    log.i("Initializing Google Mobile Ads SDK...");
    try {
      await MobileAds.instance.initialize();
      log.i("Google Mobile Ads SDK initialized successfully.");
    } catch (e, stack) {
      log.e("Error initializing Mobile Ads SDK", e, stack);
    }
  }

  // Get Test Banner Ad Unit ID
  String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/6300978111'; // Android Test Banner ID
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/2934735716'; // iOS Test Banner ID
    }
    return '';
  }

  // Load a Banner Ad
  BannerAd? loadBannerAd({
    required AdSize size,
    required void Function(Ad ad) onAdLoaded,
    required void Function(Ad ad, LoadAdError error) onAdFailedToLoad,
  }) {
    if (!isMobilePlatform) return null;
    final log = _ref.read(loggerProvider);
    log.i("Loading Banner Ad with unit ID: $bannerAdUnitId");

    return BannerAd(
      adUnitId: bannerAdUnitId,
      size: size,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          log.i("Banner Ad loaded successfully.");
          onAdLoaded(ad);
        },
        onAdFailedToLoad: (ad, error) {
          log.w("Banner Ad failed to load: ${error.message}");
          ad.dispose();
          onAdFailedToLoad(ad, error);
        },
      ),
    );
  }
}

// Provider for AdService
final adServiceProvider = Provider<AdService>((ref) => AdService(ref));
