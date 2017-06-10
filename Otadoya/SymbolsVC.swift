import UIKit
import SnapKit

class SymbolsVC: UIViewController {

	public let viewModel: SymbolsVM
	fileprivate var symbolsCollectionView: UICollectionView!

	public required init(viewModel: SymbolsVM) {
		self.viewModel = viewModel

		super.init(nibName: nil, bundle: nil)
	}

	@available(*, unavailable, message:"init is unavailable")
	override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
		fatalError("init has not been implemented")
	}

	@available(*, unavailable, message:"init is unavailable")
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		self.symbolsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: self.layout())
		symbolsCollectionView.backgroundColor = UIColor.conifer
		symbolsCollectionView.isPagingEnabled = true

		symbolsCollectionView.delegate = self
		symbolsCollectionView.dataSource = self

		symbolsCollectionView.register(SymbolCell.self, forCellWithReuseIdentifier: "cell")

		self.view.addSubview(symbolsCollectionView)

		// Layout

		self.symbolsCollectionView.snp.makeConstraints { (make) in
			make.edges.equalTo(self.view)
		}

		// Скажем, что показали первый символ
		let indexPath = IndexPath(row: 0, section: 0)
		self.viewModel.didShowCell(with: indexPath, bySwipe: false)
	}

	override var preferredStatusBarStyle: UIStatusBarStyle {
		return .lightContent
	}

	private func layout() -> UICollectionViewFlowLayout {
		let layout = UICollectionViewFlowLayout.init()

		layout.itemSize = UIScreen.main.bounds.size
		layout.scrollDirection = .horizontal
		layout.minimumLineSpacing = 0.0

		return layout
	}
	
}

extension SymbolsVC: UICollectionViewDelegate, UICollectionViewDataSource {

	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 1
	}

	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return self.viewModel.symbolVMs.count
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! SymbolCell

		cell.viewModel = self.viewModel.symbolVMs[indexPath.row]
		return cell
	}

	func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
		let point = targetContentOffset.pointee
		let showIndex = Int(point.x / self.view.bounds.width)

		let showIndexPath = IndexPath(row: showIndex, section: 0)
		self.viewModel.didShowCell(with: showIndexPath, bySwipe: true)
	}

}

extension SymbolsVC { // Shake

	override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if(event?.subtype == UIEventSubtype.motionShake) {
			self.viewModel.didCatchShakeMotion()
			self.showRandomSymbol()
        }
    }

	private func showRandomSymbol() {
		let symbolView = SymbolView(frame: UIScreen.main.bounds)
		let randomIndex = Int(arc4random_uniform(UInt32(self.viewModel.symbolVMs.count - 1)))
		let randomIndexPath = IndexPath(row: randomIndex, section: 0)
		symbolView.viewModel = self.viewModel.symbolVMs[randomIndexPath.row]

		symbolView.transform = CGAffineTransform.init(translationX: 0.0, y: -UIScreen.main.bounds.height)
		self.view.addSubview(symbolView)

		UIView.animate(withDuration: 0.8, delay: 0.0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.4, options: [.curveEaseInOut], animations: { 
				symbolView.transform = CGAffineTransform.identity
		}) { (_) in
			let scrollPosition = UICollectionViewScrollPosition(rawValue: 0)
			self.symbolsCollectionView.scrollToItem(at: randomIndexPath, at: scrollPosition, animated: false)
			self.viewModel.didShowCell(with: randomIndexPath, bySwipe: false)
			symbolView.removeFromSuperview()
		}
	}

}
