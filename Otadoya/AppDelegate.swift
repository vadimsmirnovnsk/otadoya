import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

		let rootVC = RootVC()

		self.window = UIWindow()
		self.window?.rootViewController = rootVC

		self.window?.makeKeyAndVisible()

		UIFont.listOfFonts()

        return true
    }

}

