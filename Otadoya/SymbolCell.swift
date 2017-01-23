import UIKit

class SymbolCell: UICollectionViewCell {

	let symbolView = SymbolView(frame: .zero)

	override init(frame: CGRect) {
		super.init(frame: frame)

		self.contentView.addSubview(self.symbolView)

		// Layout

		symbolView.snp.makeConstraints { (make) in
			make.edges.equalTo(self.contentView)
		}
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

}

