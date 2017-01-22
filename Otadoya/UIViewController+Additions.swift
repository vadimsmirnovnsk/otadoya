import UIKit
import SnapKit

extension UIViewController {

	func show(viewController vc: UIViewController, in view: UIView, constraints:(_ make: ConstraintMaker) -> Void) {
		self.addChildViewController(vc)
		vc.view.frame = view.bounds
		view.addSubview(vc.view)
		vc.view.snp.remakeConstraints(constraints)
		vc.didMove(toParentViewController: self)
	}

	func show(viewController vc: UIViewController, in view: UIView) {
		self.show(viewController: vc, in: view) { (make) in
			make.edges.equalTo(view)
		}
	}

	func remove(viewController vc: UIViewController) {
		vc.removeFromParentVC()
	}

	func removeFromParentVC() {
		self.willMove(toParentViewController: nil)
		if self.isViewLoaded {
			self.view.removeFromSuperview()
		}
		self.removeFromParentViewController()
	}

	func isVisible() -> Bool {
		return self.isViewLoaded && self.view.window != nil
	}

}
