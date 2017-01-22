import UIKit

class SymbolCell: UICollectionViewCell {

	let symbolLabel = UILabel()

	override init(frame: CGRect) {
		super.init(frame: frame)

		self.symbolLabel.font = UIFont.woodFont(ofSize: 200.0)
		self.symbolLabel.adjustsFontSizeToFitWidth = true
		self.symbolLabel.textColor = UIColor.white
		self.symbolLabel.textAlignment = .center
		self.contentView.addSubview(self.symbolLabel)

		// Layput

		symbolLabel.snp.makeConstraints { (make) in
			make.center.equalTo(self.contentView)
			make.width.equalTo(self.contentView).multipliedBy(0.5)
		}
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

}

