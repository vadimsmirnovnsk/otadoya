import UIKit

class ColorService {

	static private let colors: [UIColor] = [
		.sunglow,
		.crusta,
		.conifer,
		.cornflowerBlue
	]

	public func color(for index: Int) -> UIColor {
		let count = ColorService.colors.count
		return ColorService.colors[index % count]
	}

}
