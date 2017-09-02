import UIKit
import SnapKit

class AnimationView: UIView {

	private static let kBarsCount = 7

	private lazy var bars: [UIView] = {
		var bars: [UIView] = []

		for i in 0..<AnimationView.kBarsCount {
			let barView = UIView()
			barView.layer.cornerRadius = 2.0
			barView.backgroundColor = .black
			bars.append(barView)
		}

		return bars
	}()

	let barHeights: [[CGFloat]] = [
		[8, 16, 8, 4],
		[17, 11, 17, 9],
		[14, 27, 14, 18],
		[21, 6, 21, 24],
		[14, 27, 14, 18],
		[17, 11, 17, 9],
		[8, 16, 8, 4],
	]

	private var step = 0
	private var shouldRepeat = false

	override init(frame: CGRect) {
		super.init(frame: frame)

		var previousBar: UIView!
		for (index, bar) in bars.enumerated() {
			self.addSubview(bar)

			bar.snp.makeConstraints({ (make) in
				make.width.equalTo(4.0)
				make.height.equalTo(4.0)
				make.centerY.equalTo(self)
			})

			if index == 0 {
				bar.snp.makeConstraints({ (make) in
					make.leading.equalTo(self)
				})
			} else {
				bar.snp.makeConstraints({ (make) in
					make.leading.equalTo(previousBar.snp.trailing).offset(2)
				})
			}

			if index == bars.count - 1 {
				bar.snp.makeConstraints({ (make) in
					make.trailing.equalTo(self)
				})
			}

			previousBar = bar
		}
		
		self.snp.makeConstraints { (make) in
			make.height.equalTo(40)
		}

		self.setNeedsUpdateConstraints()
		self.updateConstraintsIfNeeded()
		self.setNeedsLayout()
		self.layoutIfNeeded()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func updateConstraints() {
		self.applyAnimation(step: self.step)

		super.updateConstraints()
	}

	public func stopAnimation() {
		self.shouldRepeat = false
	}

	public func startAnimation() {
		self.step = 0
		self.setNeedsUpdateConstraints()

		let duration: TimeInterval = 0.5
		let damping: CGFloat = 0.5
		let velocity: CGFloat = 5.0

		UIView.animate(withDuration: duration,
		               delay: 0.0,
		               usingSpringWithDamping: damping,
		               initialSpringVelocity: velocity,
		               options: .curveEaseOut, animations:
		{
			self.updateConstraintsIfNeeded()
			self.layoutIfNeeded()
		}) { _ in
			self.step = 1
			self.setNeedsUpdateConstraints()

			UIView.animate(withDuration: duration,
			               delay: 0.0,
			               usingSpringWithDamping: damping,
			               initialSpringVelocity: velocity,
			               options: .curveEaseOut, animations:
				{
					self.updateConstraintsIfNeeded()
					self.layoutIfNeeded()
			}) { _ in
				self.step = 2
				self.setNeedsUpdateConstraints()

				UIView.animate(withDuration: duration,
				               delay: 0.0,
				               usingSpringWithDamping: damping,
				               initialSpringVelocity: velocity,
				               options: .curveEaseOut, animations:
					{
						self.updateConstraintsIfNeeded()
						self.layoutIfNeeded()
				}) { _ in
					self.step = 3
					self.setNeedsUpdateConstraints()

					UIView.animate(withDuration: duration,
					               delay: 0.0,
					               usingSpringWithDamping: damping,
					               initialSpringVelocity: velocity,
					               options: .curveEaseOut, animations:
						{
							self.updateConstraintsIfNeeded()
							self.layoutIfNeeded()
					}) { _ in
						if self.shouldRepeat {
							self.startAnimation()
						} else {
							self.step = 0
							self.setNeedsUpdateConstraints()

							UIView.animate(withDuration: duration,
							               delay: 0.0,
							               usingSpringWithDamping: damping,
							               initialSpringVelocity: velocity,
							               options: .curveEaseOut, animations:
								{
									self.updateConstraintsIfNeeded()
									self.layoutIfNeeded()
							}) { _ in }
						}
					}
				}
			}
		}
	}

	private func applyAnimation(step: Int) {
		guard step < bars.count else { return }

		for (index, bar) in bars.enumerated() {
			let barHeights = self.barHeights[index]
			let barHeight = barHeights[step]

			bar.snp.updateConstraints({ (make) in
				make.height.equalTo(barHeight)
			})
		}
	}

}
