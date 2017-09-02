import UIKit

class SymbolView: UIView {

	public var viewModel: SymbolVM? {
		didSet {
			self.updateContent()
		}
	}

	private let symbolLabel = UILabel()
	private let button = UIButton()
	private let animationView = AnimationView()

	override init(frame: CGRect) {
		super.init(frame: frame)

		self.backgroundColor = UIColor.clear

		self.symbolLabel.adjustsFontSizeToFitWidth = true
		self.symbolLabel.textColor = UIColor.white
		self.symbolLabel.textAlignment = .center
		self.addSubview(self.symbolLabel)

		self.addSubview(animationView)

		self.button.addTarget(self, action: #selector(SymbolView.didTapSoundButton), for: .touchUpInside)
		self.addSubview(button)

		// Layout

		self.animationView.snp.makeConstraints { (make) in
			make.centerX.equalTo(self)
			make.bottom.equalTo(self).offset(-40)
		} 

		self.symbolLabel.snp.makeConstraints { (make) in
			make.centerY.equalTo(self).multipliedBy(0.8)
			make.centerX.equalTo(self)
			make.width.equalTo(self).multipliedBy(0.5)
		}

		self.button.snp.makeConstraints { (make) in
			make.centerX.equalTo(self.animationView)
			make.top.equalTo(self.animationView)
			make.width.equalTo(self)
			make.bottom.equalTo(self)
		}

		NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "didStopPlayingSound"), object: nil, queue: nil) { [weak self] (notification) in
			guard let this = self else { return }

			DispatchQueue.main.async {
				this.animationView.stopAnimation()
			}
		}

		NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "didStartPlayingSound"), object: nil, queue: nil) { [weak self] (notification) in
			guard let this = self else { return }

			DispatchQueue.main.async {
				this.animationView.startAnimation()
			}
		}
	}


	deinit {
		NotificationCenter.default.removeObserver(self)
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func updateContent() {
		self.symbolLabel.font = self.viewModel?.font
		self.symbolLabel.text = self.viewModel?.symbol

		let showButton = self.viewModel?.canPlaySound ?? true
		self.animationView.isHidden = !showButton
		self.button.isHidden = !showButton
	}

	private dynamic func didTapSoundButton() {
		self.viewModel?.didTapSoundButton()
	}

}

