import UIKit
import SnapKit

class SymbolsVC: UIViewController {

	public let viewModel: SymbolsVM

	public let bgView = UIView()
	public let frontView = UIView()

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
		symbolsCollectionView.backgroundColor = UIColor.clear
		symbolsCollectionView.isPagingEnabled = true

		symbolsCollectionView.delegate = self
		symbolsCollectionView.dataSource = self

		symbolsCollectionView.register(SymbolCell.self, forCellWithReuseIdentifier: "cell")

		self.view.addSubview(self.bgView)
		self.view.addSubview(self.frontView)
		self.view.addSubview(symbolsCollectionView)

		// Layout

		self.bgView.snp.makeConstraints { (make) in
			make.edges.equalTo(self.view)
		}

		self.frontView.snp.makeConstraints { (make) in
			make.edges.equalTo(self.view)
		}

		self.symbolsCollectionView.snp.makeConstraints { (make) in
			make.edges.equalTo(self.view)
		}

		// Скажем, что показали первый символ
//		let indexPath = IndexPath(row: 0, section: 0)
//		self.viewModel.didShowCell(with: indexPath, bySwipe: false)

		let bgColor = self.viewModel.symbolVMs[0].color
		self.bgView.backgroundColor = bgColor
		self.frontView.backgroundColor = bgColor
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

	func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
		if let symbolsCell = cell as? SymbolCell {
			self.viewModel.willShowCell(with: indexPath)

			let cellVM = self.viewModel.symbolVMs[indexPath.row]
			symbolsCell.viewModel = cellVM

			print(">>> Collection view will show `\(cellVM.symbol)` for \(cellVM.showCounter) time")
		}
	}

	func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
		let point = targetContentOffset.pointee
		let showIndex = Int(point.x / self.view.bounds.width)

		let showIndexPath = IndexPath(row: showIndex, section: 0)
		self.viewModel.didShowCell(with: showIndexPath, bySwipe: true)
	}

	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		let offset = scrollView.contentOffset.x
		let cells = self.symbolsCollectionView.visibleCells

		for (index, cell) in cells.enumerated() {
			let symbolCell = cell as! SymbolCell
			var absoluteOffset = abs((offset - symbolCell.frame.origin.x) / symbolCell.frame.width)

			absoluteOffset = absoluteOffset > 1.0 ? 0.0 : absoluteOffset

			print("OFFSET: \(absoluteOffset)")
			let alpha = 1.0 - absoluteOffset
			symbolCell.symbolView.alpha = 1.0 - absoluteOffset

			if index == 0 {
				self.bgView.backgroundColor = symbolCell.viewModel?.color
			} else {
				self.frontView.backgroundColor = symbolCell.viewModel?.color
				self.frontView.alpha = alpha
			}
		}
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
		let randomIndex = self.randomIndex()

		let randomIndexPath = IndexPath(row: randomIndex, section: 0)
		self.viewModel.didShowCell(with: randomIndexPath, bySwipe: false)
		symbolView.viewModel = self.viewModel.symbolVMs[randomIndexPath.row]

		let symbolDropView = SymbolView(frame: UIScreen.main.bounds)
		symbolDropView.viewModel = self.viewModel.symbolVMs[self.viewModel.currentSymbolIndex]
		self.view.addSubview(symbolDropView)
		self.symbolsCollectionView.alpha = 0.0

		symbolView.transform = CGAffineTransform.init(translationX: 0.0, y: -UIScreen.main.bounds.height)
		symbolView.alpha = 0.0
		self.view.addSubview(symbolView)

		self.bgView.backgroundColor = symbolDropView.viewModel?.color
		self.frontView.backgroundColor = symbolView.viewModel?.color
		self.bgView.alpha = 1.0
		self.frontView.alpha = 0.0

		UIView.animate(withDuration: 0.7, delay: 0.0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.7, options: [.curveEaseInOut], animations: {
				symbolView.transform = CGAffineTransform.identity
				symbolDropView.transform = CGAffineTransform.init(translationX: 0.0, y: UIScreen.main.bounds.height)
				symbolDropView.alpha = 0.0
				symbolView.alpha = 1.0
				self.frontView.alpha = 1.0
		}) { (_) in
			let scrollPosition = UICollectionViewScrollPosition(rawValue: 0)
			self.symbolsCollectionView.scrollToItem(at: randomIndexPath, at: scrollPosition, animated: false)
			symbolView.removeFromSuperview()
			symbolDropView.removeFromSuperview()
			self.symbolsCollectionView.alpha = 1.0
		}
	}

	private func randomIndex() -> Int {
		guard self.viewModel.symbolVMs.count > 3 else { return 0 }

		var randomIndex = Int(arc4random_uniform(UInt32(self.viewModel.symbolVMs.count - 1)))
		// Не показываем соседние буквы
		if abs(randomIndex - self.viewModel.currentSymbolIndex) < 2 {
			randomIndex = self.randomIndex()
		}

		return randomIndex
	}

}
