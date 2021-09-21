import 'dart:io';

import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdmobHelper {

  

  InterstitialAd _interstitialAd;

  int num_of_attempt_load = 0;

  static initialization(){
    if(MobileAds.instance == null)
      {
        MobileAds.instance.initialize();
      }
  }
   

   // create interstitial ads
  void createInterad(){

    InterstitialAd.load(
        adUnitId: 'ca-app-pub-3940256099942544/1033173712',
        request: AdRequest(),
        adLoadCallback:InterstitialAdLoadCallback(
            onAdLoaded: (InterstitialAd ad){
              _interstitialAd = ad;
              num_of_attempt_load =0;
            },
            onAdFailedToLoad: (LoadAdError error){
              num_of_attempt_load +1;
              _interstitialAd = null;

              if(num_of_attempt_load<=2){
                createInterad();
              }
            }),
    );

  }


// show interstitial ads to user
  void showInterad(){
     if(_interstitialAd == null){
       return;
     }

     _interstitialAd.fullScreenContentCallback = FullScreenContentCallback(

       onAdShowedFullScreenContent: (InterstitialAd ad){
         print("ad onAdshowedFullscreen");
       },
       onAdDismissedFullScreenContent: (InterstitialAd ad){
         print("ad Disposed");
         ad.dispose();
       },
       onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError aderror){
         print('$ad OnAdFailed $aderror');
         ad.dispose();
         createInterad();
       }
     );

     _interstitialAd.show();

     _interstitialAd = null;
  }


} 
class AdState {
  Future<InitializationStatus> Initialization;
  AdState(this.Initialization);

  static String get bannerAdUnitId => Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/6300978111'
      : 'ca-app-pub-3940256099942544/2934735716';

  BannerAdListener get bannerAdListener => _adListner;
  final BannerAdListener _adListner = BannerAdListener(
    // Called when an ad is successfully received.
    onAdLoaded: (Ad ad) => print('Ad loaded.'),
    // Called when an ad request failed.
    onAdFailedToLoad: (Ad ad, LoadAdError error) {
      // Dispose the ad here to free resources.
      ad.dispose();
      print('Ad failed to load: $error');
    },
    // Called when an ad opens an overlay that covers the screen.
    onAdOpened: (Ad ad) => print('Ad opened.'),
    // Called when an ad removes an overlay that covers the screen.
    onAdClosed: (Ad ad) => print('Ad closed.'),
    // Called when an impression occurs on the ad.
    onAdImpression: (Ad ad) => print('Ad impression.'),
  );
}
