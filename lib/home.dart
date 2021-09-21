import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' as rootBundle;
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:butterflywallpaperapp/ImagesList.dart';
import 'package:butterflywallpaperapp/adMobService.dart';
import 'package:butterflywallpaperapp/download.dart';
import 'package:provider/provider.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  BannerAd banner;
  AdmobHelper admobHelper = new AdmobHelper();
  int tap = 0;
  Timer _timer;
  List<int> verticalData = [];

  final int increment = 4;

  bool isLoadingVertical = false;

  @override
  void initState() {
    admobHelper.createInterad();
    _loadMoreVertical().whenComplete(() => setState(() {}));

    super.initState();
    EasyLoading.addStatusCallback((status) {
      print('EasyLoading Status $status');
      if (status == EasyLoadingStatus.dismiss) {
        _timer?.cancel();
      }
    });

    // EasyLoading.showSuccess('Use in initState');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies;
    final adState = Provider.of<AdState>(context);
    adState.Initialization.then((status) {
      setState(() {
        banner = BannerAd(
          size: AdSize.banner,
          adUnitId: AdState.bannerAdUnitId,
          listener: adState.bannerAdListener,
          request: AdRequest(),
        )..load();
      });
    });
  }

  Future _loadMoreVertical() async {
    setState(() {
      isLoadingVertical = true;
    });

    // Add in an artificial delay
    await new Future.delayed(const Duration(seconds: 2));

    verticalData.addAll(
        List.generate(increment, (index) => verticalData.length + index));

    setState(() {
      isLoadingVertical = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final banner = this.banner;
    return WillPopScope(
      child: Scaffold(
          appBar: AppBar(
            title: Text("Wallpaper Gallery"),
            backgroundColor: Colors.amber,
            centerTitle: true,
          ),
          body: Column(
            children: [
              Expanded(
                child: FutureBuilder(
                  future: ReadJsonData(),
                  builder: (context, data) {
                    if (data.hasError) {
                      return Center(child: Text('${data.error}'));
                    } else if (data.hasData) {
                      var items = data.data as List<ImagesListt>;
                      return Column(
                        children: [
                          Expanded(
                              child: Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: LazyLoadScrollView(
                              isLoading: isLoadingVertical,
                              onEndOfPage: () => _loadMoreVertical(),
                              child: Container(
                                child: GridView.builder(
                                    itemCount: items == null ? 0 : items.length,
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 2,
                                            crossAxisSpacing: 10,
                                            childAspectRatio: 2 / 3,
                                            mainAxisSpacing: 10),
                                    itemBuilder: (context, index) {
                                      return Container(
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(12),
                                          child: InkWell(
                                            onTap: () {
                                              ScreenTap();
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        DownloadImage(
                                                            ImageUrl: items[index]
                                                                .src
                                                                .toString())),
                                              );
                                              print(items[index].src.toString());
                                            },
                                            child: Image(
                                              image: NetworkImage(
                                                  items[index].src.toString()),
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                        ),
                                      );
                                    }),
                              ),
                            ),
                          )),
                          if (banner == null)
                            SizedBox(
                              height: 50,
                            )
                          else
                            Container(
                              height: 50,
                              child: AdWidget(ad: banner),
                            )
                        ],
                      );
                    } else {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
              ),
            ],
          )),
            onWillPop: ()  =>_onBackPressed(context),
    );
  }

   Future<bool> _onBackPressed(con) {
        admobHelper.createInterad();
  return  showDialog(
    context: con,
    builder: (con) => AlertDialog(
      title: Text("Do you really want to exit the app?"),
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            
            admobHelper.showInterad();
            Navigator.pop(con, false);
          },
          child: Text("No"),
        ),
        FlatButton(
          onPressed: () {
            admobHelper.showInterad();
            exit(0);
          },
          child: Text("Yes"),
        ),
      ],
    ),
  );
  // return true;
}


  Future<List<ImagesListt>> ReadJsonData() async {
    final jsondata =
        await rootBundle.rootBundle.loadString('jsonfile/butterfly.json');
    final list = json.decode(jsondata) as List<dynamic>;

    return list.map((e) => ImagesListt.fromJson(e)).toList();
  }

   void ScreenTap() {
    setState(() {
      tap++;
    });
    if (tap == 0) {
      setState(() {
        tap++;
      });
    } else if (tap == 2) {
      setState(() {
        admobHelper.createInterad();
      });
    } else if (tap == 3) {
      setState(() {
        admobHelper.showInterad();
        tap = 0;
      });
    }
  }
}
