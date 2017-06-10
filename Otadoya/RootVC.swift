import UIKit

class RootVC: UIViewController {

	private let symbolsVC: SymbolsVC

	override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
		let symbolsVM = SymbolsVM(colorService: ColorService(),
		                          audioService: AudioService(),
		                          fontService: FontService())
		self.symbolsVC = SymbolsVC(viewModel: symbolsVM)

		super.init(nibName: nil, bundle: nil)
	}

	@available(*, unavailable, message:"init is unavailable")
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		self.show(viewController: self.symbolsVC, in: self.view)
	}

	override var preferredStatusBarStyle: UIStatusBarStyle {
		return .lightContent
	}

}
