import UIKit

extension UIFont {

	static func woodFont(of size: CGFloat) -> UIFont {
		return UIFont(name: "WoodkitPrintPro-Letterpress", size: size)!
	}

	static func woodFontAlternate(of size: CGFloat, alternate: Int) -> UIFont {
		let woodFontDescriptor = UIFont.woodFont(of: size).fontDescriptor
		let alternateDescriptor = woodFontDescriptor.addingAttributes([
			UIFontDescriptorFeatureSettingsAttribute: [[
				UIFontFeatureTypeIdentifierKey: kCharacterAlternativesType,
				UIFontFeatureSelectorIdentifierKey: alternate,
			],
		]])

		return UIFont(descriptor: alternateDescriptor, size: size)
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
