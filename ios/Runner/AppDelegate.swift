import UIKit
import Flutter
import WidgetKit

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      GeneratedPluginRegistrant.register(with: self)
      
      let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
              let channel = FlutterMethodChannel(name: "com.kyoichi.moneyManagementApp/widget",
                                          binaryMessenger: controller.binaryMessenger)
              channel.setMethodCallHandler({
                  (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in

                  if call.method == "setDataForWidgetKit"  {
                      self.setUserDefaultsForAppGroup(result: result)

                  }

                  result(FlutterMethodNotImplemented)
              })
        
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
    

    private func setUserDefaultsForAppGroup(result: FlutterResult) {

            guard let userDefaults = UserDefaults(suiteName: "group.com.kyoichi.moneyManagementApp") else {
                return result(FlutterError(code: "UNAVAILABLE",
                                           message: "setUserDefaultsForAppGroup Failed",
                                           details: nil))
            }

            let defaults = UserDefaults.standard
            let availableMoney = defaults.value(forKey: "flutter.AVAILABLE_MONEY_PREF") as? Int

            userDefaults.setValue(availableMoney, forKey: "AVAILABLE_MONEY_PREF")

            if #available(iOS 14.0, *) {
                WidgetCenter.shared.reloadAllTimelines()
            }
            result(true)

        }
    
    
}
