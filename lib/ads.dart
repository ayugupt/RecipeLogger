import 'package:firebase_admob/firebase_admob.dart';

class Ads {
  MobileAdTargetingInfo mobileAdTargetingInfo =
      new MobileAdTargetingInfo(childDirected: false);

  static BannerAd bannerAd;

  static Future<void> giveBannerAd(String unitID,double anchorOffset,
      double horizontalCenterOffset, AnchorType anchorType) async {
    await FirebaseAdMob.instance
        .initialize(appId: "ca-app-pub-8930861278958842~4256621542");

    bannerAd = new BannerAd(adUnitId: unitID, size: AdSize.banner);
    await bannerAd.load();
    await bannerAd.show(
      anchorType: anchorType,
      anchorOffset: anchorOffset,
      horizontalCenterOffset: horizontalCenterOffset,
    );
  }

  Future<InterstitialAd> giveInterstitialAd(String unitId, double anchorOffset,
      double horizontalCenterOffset, AnchorType anchorType) async {
    
    await FirebaseAdMob.instance
        .initialize(appId: "ca-app-pub-8930861278958842~4256621542");

    InterstitialAd interstitialAd = new InterstitialAd(
        adUnitId: unitId, targetingInfo: mobileAdTargetingInfo);

    await interstitialAd.load();
    await interstitialAd.show(
        anchorOffset: anchorOffset,
        horizontalCenterOffset: horizontalCenterOffset,
        anchorType: anchorType);
    return interstitialAd;
  }
}
