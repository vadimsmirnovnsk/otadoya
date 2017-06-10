import UIKit

class SymbolVM {

	public let symbol: String
	public let color: UIColor
	public private(set) var font: UIFont

	public private(set) var showCounter = 0

	private let fontService: FontService

	public init(symbol: String, color: UIColor, fontService: FontService) {
		self.symbol = symbol
		self.color = color
		self.fontService = fontService
		self.font = UIFont.woodFont(of: 200)
	}

	public func didShow() {
		self.showCounter = self.showCounter.advanced(by: 1)
		self.font = self.fontService.font(for: self.showCounter)
	}

}

