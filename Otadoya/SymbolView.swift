import UIKit

class SymbolView: UIView {

	public var viewModel: SymbolVM? {
		didSet {
			self.updateContent()
		}
	}

	private let symbolLabel = UILabel()

	override init(frame: CGRect) {
		super.init(frame: frame)

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

	private func updateContent() {
		self.symbolLabel.font = self.viewModel?.font
		self.symbolLabel.text = self.viewModel?.symbol

		print(self.symbolLabel.font!)
		self.backgroundColor = self.viewModel?.color
	}

}

