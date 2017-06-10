import UIKit

class SymbolsVM {

	private static let charactersString = "А,Б,В,Г,Д,Е,Ё,Ж,З,И,Й,К,Л,М,Н,О,П,Р,С,Т,У,Ф,Х,Ц,Ч,Ш,Щ,Ъ,Ы,Ь,Э,Ю,Я"
	private static let numbersString = "1,2,3,4,5,6,7,8,9,10"

	public private(set) var symbolVMs: [SymbolVM] = []
	public private(set) var currentSymbolIndex: Int = Int.max // Сначала невозможное значение

	private let colorService: ColorService
	private let audioService: AudioService

	public init(colorService: ColorService, audioService: AudioService) {
		self.colorService = colorService
		self.audioService = audioService

		let characters = SymbolsVM.charactersString.components(separatedBy: ",")
		let numbers = SymbolsVM.numbersString.components(separatedBy: ",")
		let symbols = characters + numbers

		self.symbolVMs = symbols.enumerated().map { (index, symbol) in
			return SymbolVM(symbol: symbol, color: colorService.color(for: index))
		}
	}

	public func didShowCell(with indexPath: IndexPath, bySwipe: Bool) {
		let index = indexPath.row
		guard index != self.currentSymbolIndex || !bySwipe else { return }

		let vm = self.symbolVMs[index]
		self.currentSymbolIndex = index

		vm.didShow()

		if bySwipe {
			self.audioService.playWoosh()
		}
	}

	public func didCatchShakeMotion() {
		self.audioService.playSpring()
	}

}
