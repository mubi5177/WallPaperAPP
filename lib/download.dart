import 'dart:typed_data';
import 'package:butterflywallpaperapp/adMobService.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

import 'package:permission_handler/permission_handler.dart';
import 'package:image_downloader/image_downloader.dart';

class DownloadImage extends StatefulWidget {
  var ImageUrl;

  DownloadImage({this.ImageUrl});

  @override
  _DownloadImageState createState() => _DownloadImageState();
}

class _DownloadImageState extends State<DownloadImage> {
   int tap=0;
   AdmobHelper admobHelper = new AdmobHelper();
  Image_Downloader() async {
    try {
      EasyLoading.show(status: 'Downloading...');

      var imageId = await ImageDownloader.downloadImage(widget.ImageUrl,
          destination: AndroidDestinationType.directoryDownloads
            ..subDirectory('flutter.png'));

      EasyLoading.showSuccess('Great Success!');
      EasyLoading.dismiss();
      // ,

      if (imageId == null) {
        return;
      }

      var fileName = await ImageDownloader.findName(imageId);

      var path = await ImageDownloader.findPath(imageId);
      var size = await ImageDownloader.findByteSize(imageId);
      var mimeType = await ImageDownloader.findMimeType(imageId);
    } on PlatformException catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Download Wallpaper "),
          centerTitle: true,
        ),
        // bottomNavigationBar: Container(
        //   height: 50,
        //   child: AdWidget(
        //     ad: AdMobService.createBannerAd()..load(),
        //     key: UniqueKey(),
        //   ),
        // ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                GestureDetector(
                  onTap:(){
                    ScreenTap();
                  },
                  child: Container(
                    width: 500,
                    height: 430,
                    child: Image(
                      image: NetworkImage(widget.ImageUrl),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                FlatButton.icon(
                    color: Colors.blue,
                    onPressed: () {
                      ScreenTap();
                      Image_Downloader();
                    },
                    icon: Icon(Icons.download),
                    label: Text("Download"))
              ],
            ),
          ),
        ));
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
