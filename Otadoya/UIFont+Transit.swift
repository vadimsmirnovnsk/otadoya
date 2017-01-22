import UIKit

extension UIFont {

	static func woodFont(ofSize size: CGFloat) -> UIFont {
		return UIFont(name: "WoodkitPrintPro-Letterpress", size: size)!
	}

	static func listOfFonts() {

		var output = ""
		for familyName in UIFont.familyNames {
			let title = "Family name: \(familyName)"
			let content = "Fonts: \(UIFont.fontNames(forFamilyName: familyName))"
			output = output + "\n" + title + "\n" + content + "\n"
		}

		print(">>> \(output)")
	}

}
