import UIKit

class SymbolCell: UICollectionViewCell {

	public var viewModel: SymbolVM? {
		didSet {
			self.updateContent()
		}
	}

	public let symbolView = SymbolView(frame: .zero)

	override init(frame: CGRect) {
		super.init(frame: frame)

		self.contentView.backgroundColor = UIColor.clear
		self.contentView.addSubview(self.symbolView)

		// Layout

		symbolView.snp.makeConstraints { (make) in
			make.edges.equalTo(self.contentView)
		}
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func updateContent() {
		self.symbolView.viewModel = self.viewModel
	}

}

