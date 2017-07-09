import UIKit

class FontService {

	private let fonts: [UIFont]

	init() {
		self.fonts = [
			UIFont.woodFontAlternate(of: 200, alternate: 2),
			UIFont.classicFont(of: 250),
			UIFont.woodFont(of: 200),
			UIFont.woodFontAlternate(of: 200, alternate: 3),
			UIFont.woodFontAlternate(of: 200, alternate: 4),
		]
	}

	public func font(for showingTime: Int) -> UIFont {
		let index = showingTime % self.fonts.count
		let font = self.fonts[index]

		return font
	}

}

