

import 'dart:async';

import 'package:encyclopedia_world_stories/utils/const.dart';
import 'package:encyclopedia_world_stories/widgets/Toast.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class BannerAdWidget extends StatefulWidget {
  BannerAdWidget(this.size,this.adWidth,this.adHeight);
  final AdSize size;
  final double adWidth , adHeight ;
  @override
  State<StatefulWidget> createState() => BannerAdState(size,adWidth,adHeight);
}

class BannerAdState extends State<BannerAdWidget> {
  BannerAdState(this.size,this.adWidth,this.adHeight);  final AdSize size;
  final double adWidth , adHeight ;
  BannerAd _bannerAd;

  final Completer<BannerAd> bannerCompleter = Completer<BannerAd>();
  @override
  void initState() {
    super.initState();
    _bannerAd = BannerAd(
      adUnitId:Constants.bannerId,
      request: AdRequest(),
      size: widget.size,
      listener: AdListener(
        onAdLoaded: (Ad ad) {
          print('$BannerAd loaded.');
          bannerCompleter.complete(ad as BannerAd);
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          ad.dispose();
          print('$BannerAd failedToLoad: $error');
          bannerCompleter.completeError(null);
        },
        onAdOpened: (Ad ad) => print('$BannerAd onAdOpened.'),
        onAdClosed: (Ad ad) => print('$BannerAd onAdClosed.'),
        onApplicationExit: (Ad ad) => print('$BannerAd onApplicationExit.'),
      ),
    );
    Future<void>.delayed(Duration(seconds: 1), () => _bannerAd?.load());
  }

  @override
  void dispose() {
    super.dispose();
    _bannerAd?.dispose();
    _bannerAd = null;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<BannerAd>(
      future: bannerCompleter.future,
      builder: (BuildContext context, AsyncSnapshot<BannerAd> snapshot) {
        Widget child;
        bool isBannerAdLoad = false ;

        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
          case ConnectionState.active:
            isBannerAdLoad = false;
            child = Container(color: Colors.yellow,);
            break;
          case ConnectionState.done:
            if (snapshot.hasData) {
              isBannerAdLoad = true ;
              child = AdWidget(ad: _bannerAd);
            } else {
              isBannerAdLoad = false ;
              child = Text('Error loading $BannerAd');
            }
        }

        return Container(
          width: isBannerAdLoad ? adWidth : 0,
          height:isBannerAdLoad? adHeight + 1 : 0,
          child: child,
          color: Theme.of(context).backgroundColor,
        );
      },
    );
  }
}