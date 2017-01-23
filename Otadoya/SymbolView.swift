import UIKit

class SymbolView: UIView {

	let symbolLabel = UILabel()

	override init(frame: CGRect) {
		super.init(frame: frame)

		self.symbolLabel.font = UIFont.woodFont(ofSize: 200.0)
		self.symbolLabel.adjustsFontSizeToFitWidth = true
		self.symbolLabel.textColor = UIColor.white
		self.symbolLabel.textAlignment = .center
		self.addSubview(self.symbolLabel)

		// Layout

		symbolLabel.snp.makeConstraints { (make) in
			make.center.equalTo(self)
			make.width.equalTo(self).multipliedBy(0.5)
		}
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}


}

