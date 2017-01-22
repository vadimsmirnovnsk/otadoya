import UIKit

class RootVC: UIViewController {

	private let symbolsVC = SymbolsVC()

	override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
		super.init(nibName: nil, bundle: nil)
	}
	
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
