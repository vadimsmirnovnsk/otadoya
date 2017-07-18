import UIKit
import SnapKit

class SymbolsVC: UIViewController {

	public let viewModel: SymbolsVM

	public let bgView = UIView()
	public let frontView = UIView()

	fileprivate var isAnimating = false

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

	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		if !self.isAnimating {
			self.isAnimating = true

			self.viewModel.didTapSymbol()
			self.showRandomSymbol(byShake: false)
		}
	}
}

extension SymbolsVC { // Shake and dzin

	override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if event?.subtype == UIEventSubtype.motionShake, !self.isAnimating {
			self.isAnimating = true

			self.viewModel.didCatchShakeMotion()
			self.showRandomSymbol(byShake: true)
        }
    }

	fileprivate func showRandomSymbol(byShake: Bool) {
		let nextSymbolView = SymbolView(frame: UIScreen.main.bounds)
		let randomIndex = self.randomIndex()

		let currentSymbolView = SymbolView(frame: UIScreen.main.bounds)
		let currentSymbolIndex = self.viewModel.currentSymbolIndex == Int.max ? 0 : self.viewModel.currentSymbolIndex
		currentSymbolView.viewModel = self.viewModel.symbolVMs[currentSymbolIndex]

		let randomIndexPath = IndexPath(row: randomIndex, section: 0)
		self.viewModel.didShowCell(with: randomIndexPath, bySwipe: false)
		nextSymbolView.viewModel = self.viewModel.symbolVMs[randomIndexPath.row]

		self.view.addSubview(nextSymbolView)
		self.view.addSubview(currentSymbolView)

		if byShake {
			self.showRandomSymbolByShake(nextSymbolView: nextSymbolView,
			                             currentSymbolView: currentSymbolView,
			                             randomIndexPath: randomIndexPath)
		} else {
			self.showRandomSymbolByDzin(nextSymbolView: nextSymbolView,
			                            currentSymbolView: currentSymbolView,
			                            randomIndexPath: randomIndexPath)
		}

	}

	private func showRandomSymbolByShake(nextSymbolView: SymbolView,
	                                     currentSymbolView: SymbolView,
	                                     randomIndexPath: IndexPath) {
		self.symbolsCollectionView.alpha = 0.0

		nextSymbolView.transform = CGAffineTransform.init(translationX: 0.0, y: -UIScreen.main.bounds.height)
		nextSymbolView.alpha = 0.0
		self.view.addSubview(currentSymbolView)

		self.bgView.backgroundColor = currentSymbolView.viewModel?.color
		self.frontView.backgroundColor = nextSymbolView.viewModel?.color
		self.bgView.alpha = 1.0
		self.frontView.alpha = 0.0

		UIView.animate(withDuration: 0.7, delay: 0.0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.7, options: [.curveEaseInOut], animations: {
			nextSymbolView.transform = CGAffineTransform.identity
			currentSymbolView.transform = CGAffineTransform.init(translationX: 0.0, y: UIScreen.main.bounds.height)
			nextSymbolView.alpha = 1.0
			currentSymbolView.alpha = 0.0
			self.frontView.alpha = 1.0
		}) { (_) in
			let scrollPosition = UICollectionViewScrollPosition(rawValue: 0)

			self.symbolsCollectionView.scrollToItem(at: randomIndexPath, at: scrollPosition, animated: false)
			nextSymbolView.removeFromSuperview()
			currentSymbolView.removeFromSuperview()
			self.symbolsCollectionView.alpha = 1.0

			// Фикс бага с пропадающим символом
			DispatchQueue.main.async { [weak self] in
				guard let this = self else { return }

				this.scrollViewDidScroll(this.symbolsCollectionView)
				this.isAnimating = false
			}
		}
	}

	private func showRandomSymbolByDzin(nextSymbolView: SymbolView,
										currentSymbolView: SymbolView,
										randomIndexPath: IndexPath) {
		self.symbolsCollectionView.alpha = 0.0

		nextSymbolView.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
		nextSymbolView.alpha = 0.0

		self.bgView.backgroundColor = currentSymbolView.viewModel?.color
		self.frontView.backgroundColor = nextSymbolView.viewModel?.color
		self.bgView.alpha = 1.0
		self.frontView.alpha = 0.0

		UIView.animate(withDuration: 0.7, delay: 0.0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.7, options: [.curveEaseInOut], animations: {
			nextSymbolView.transform = CGAffineTransform.identity

			currentSymbolView.alpha = 0.0
			nextSymbolView.alpha = 1.0
			self.frontView.alpha = 1.0
		}) { (_) in
			let scrollPosition = UICollectionViewScrollPosition(rawValue: 0)

			self.symbolsCollectionView.scrollToItem(at: randomIndexPath, at: scrollPosition, animated: false)
			currentSymbolView.removeFromSuperview()
			nextSymbolView.removeFromSuperview()
			self.symbolsCollectionView.alpha = 1.0

			// Фикс бага с пропадающим символом
			DispatchQueue.main.async { [weak self] in
				guard let this = self else { return }

				this.scrollViewDidScroll(this.symbolsCollectionView)
				this.isAnimating = false
			}
		}
	}

	private func randomIndex() -> Int {
		guard self.viewModel.symbolVMs.count > 3 else { return 0 }

		var randomIndex = Int(arc4random_uniform(UInt32(self.viewModel.symbolVMs.count)))
		// Не показываем соседние буквы
		if abs(randomIndex - self.viewModel.currentSymbolIndex) < 2 {
			randomIndex = self.randomIndex()
		}

		return randomIndex
	}

}
