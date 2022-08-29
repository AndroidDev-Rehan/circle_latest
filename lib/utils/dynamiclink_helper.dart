import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

class DynamicLinkHelper{

  static Future<String> createDynamicLink(String circleId) async {
    print("staring  ..");
    final dynamicLinkParams = DynamicLinkParameters(
      link: Uri.parse("https://circledev.page.link/circle?id=$circleId"),
      uriPrefix: "https://circledev.page.link",
      androidParameters: const AndroidParameters(
          packageName: "com.example.circle", minimumVersion: 1),
      iosParameters: const IOSParameters(bundleId: "com.zaradustraglobal.circle",appStoreId: "1634147359"),
      // longDynamicLink: Uri.parse("https://circledev.page.link/circle?id=120")
    );

    final Uri dynamicLink =
    await FirebaseDynamicLinks.instance.buildLink(dynamicLinkParams);
    print(dynamicLink);

    // final ShortDynamicLink shortenedLink = await FirebaseDynamicLinks.instance.buildShortLink(dynamicLinkParams);

    // final PendingDynamicLinkData? x =
    // await FirebaseDynamicLinks.instance.getDynamicLink(dynamicLink);
    // final PendingDynamicLinkData? y = await FirebaseDynamicLinks.instance
    //     .getDynamicLink(Uri.parse("https://circledev.page.link/circles"));
    // final PendingDynamicLinkData? z = await FirebaseDynamicLinks.instance.getDynamicLink(shortenedLink.shortUrl);

    // print(x);
    // print(y);
    // print(z);

    // print("short url : $z");

    // return shortenedLink.shortUrl;

    return dynamicLink.toString();

  }

}