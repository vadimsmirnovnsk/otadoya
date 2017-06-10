import UIKit

class SymbolVM {

	public let symbol: String
	public let color: UIColor
	public var font: UIFont

	public private(set) var showCounter = 0

	public init(symbol: String, color: UIColor) {
		self.symbol = symbol
		self.color = color
		self.font = UIFont.woodFont(ofSize: 200.0)
	}

	public func didShow() {
		self.showCounter = self.showCounter.advanced(by: 1);

		print(">>> `\(self.symbol)` did show \(self.showCounter) time")
	}

}

