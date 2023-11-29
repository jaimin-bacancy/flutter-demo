// import 'package:device_info_plus/device_info_plus.dart';
import 'package:awesome_app/app/presentation/screens/startup/startup_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';

class DeviceInfo {
  int deviceType = 0;
  String deviceToken = '';

  DeviceInfo({required this.deviceType, required this.deviceToken});
}

class CommonMethods {
  CommonMethods._();

  // Get device information
  // static Future<DeviceInfo> getDeviceInfo() async {
  //   DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  //   DeviceInfo deviceInfo;
  //   if (Platform.isIOS) {
  //     var info = await deviceInfoPlugin.iosInfo;
  //     deviceInfo =
  //         DeviceInfo(deviceType: 2, deviceToken: info.identifierForVendor!);
  //   } else {
  //     var info = await deviceInfoPlugin.androidInfo;
  //     deviceInfo = DeviceInfo(deviceType: 1, deviceToken: info.id);
  //   }
  //   return deviceInfo;
  // }

  // Get mobile number in 164 format
  static String getMobileNumber(
      {required String mobile, required int countryCode}) {
    return '+ $countryCode $mobile';
  }

  // To dismiss keyboard
  static hideKeyBoard() {
    WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
  }

  // To go back
  static onBackPress() async {
    SystemNavigator.pop();
  }

  static showAlert(BuildContext context, String content) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text(content),
          );
        });
  }

  static resetToStartUp(BuildContext context) {
    final storage = GetStorage();
    storage.erase();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const StartupScreen(),
      ),
    );
  }
}
