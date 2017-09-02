import UIKit

class SymbolsVM {

	private static let charactersString = "A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z"
	private static let digitsString = "1,2,3,4,5,6,7,8,9,10"
	//"А,Б,В,Г,Д,Е,Ё,Ж,З,И,Й,К,Л,М,Н,О,П,Р,С,Т,У,Ф,Х,Ц,Ч,Ш,Щ,Ъ,Ы,Ь,Э,Ю,Я"

	public private(set) var symbolVMs: [SymbolVM] = []
	public private(set) var currentSymbolIndex: Int = Int.max // Сначала невозможное значение
	public private(set) var willShowIndex: Int = Int.max // Сначала невозможное значение

	private let colorService: ColorService
	private let audioService: AudioService

	public init(colorService: ColorService, audioService: AudioService, fontService: FontService) {
		self.colorService = colorService
		self.audioService = audioService

		let symbols = SymbolsVM.charactersString.components(separatedBy: ",")
		let digits = SymbolsVM.digitsString.components(separatedBy: ",")

		let symbolVMs = symbols.enumerated().map { (index, symbol) in
			return SymbolVM(symbol: symbol,
			                color: colorService.color(for: index),
			                fontService: fontService,
			                audioService: audioService,
			                canPlaySound: true)
		}

		let digitVMs = digits.enumerated().map { (index, symbol) in
			return SymbolVM(symbol: symbol,
			                color: colorService.color(for: index),
			                fontService: fontService,
			                audioService: audioService)
		}

		self.symbolVMs = symbolVMs + digitVMs
	}

	public func willShowCell(with indexPath: IndexPath) {
		let index = indexPath.row
		self.willShowIndex = index
		let vm = self.symbolVMs[index]

		if self.willShowIndex != self.currentSymbolIndex {
			vm.didShow()
		}
	}

	public func didShowCell(with indexPath: IndexPath, bySwipe: Bool) {
		let index = indexPath.row
		guard index != self.currentSymbolIndex || !bySwipe else { return }

		let vm = self.symbolVMs[index]
		self.currentSymbolIndex = index

		if self.willShowIndex != self.currentSymbolIndex {
			vm.didShow()
		}

		if bySwipe {
			self.audioService.playWoosh()
		}
	}

	public func didCatchShakeMotion() {
		self.audioService.playSpring()
	}

	public func didTapSymbol() {
		self.audioService.playDzin()
	}

}
