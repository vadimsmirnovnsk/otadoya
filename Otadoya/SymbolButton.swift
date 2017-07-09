import UIKit

class SymbolButton: UIButton {

	override var isHighlighted: Bool {
		set {
			super.isHighlighted = newValue
			self.alpha = newValue ? 0.5 : 1.0
		}
		get {
			return super.isHighlighted
		}
	}

	override init(frame: CGRect) {
		super.init(frame: frame)

		self.setImage(UIImage(named: "soundButton"), for: .normal)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

}
