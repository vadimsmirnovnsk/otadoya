import UIKit

class SymbolVM {

	public let symbol: String
	public let color: UIColor
	public private(set) var font: UIFont

	public private(set) var showCounter = 0
	public private(set) var playSoundCounter = 0

	private let fontService: FontService
	private let audioService: AudioService

	public init(symbol: String, color: UIColor, fontService: FontService, audioService: AudioService) {
		self.symbol = symbol
		self.color = color
		self.fontService = fontService
		self.audioService = audioService
		self.font = UIFont.woodFont(of: 200)
	}

	public func didShow() {
		self.showCounter = self.showCounter.advanced(by: 1)
		self.font = self.fontService.font(for: self.showCounter)
	}

	public func didTapSoundButton() {
		self.audioService.playSound(for: self.symbol, modify: playSoundCounter)

		self.playSoundCounter = self.playSoundCounter.advanced(by: 1)
	}

}

