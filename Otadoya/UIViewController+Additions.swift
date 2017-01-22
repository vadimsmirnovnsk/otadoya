extension UIViewController {

	func trs_showViewControllerInView(_ vc: UIViewController, view: UIView, constraints:(_ make: ConstraintMaker) -> Void) {
		self.addChildViewController(vc)
		vc.view.frame = view.bounds
		view.addSubview(vc.view)
		vc.view.snp.remakeConstraints(constraints)
		vc.didMove(toParentViewController: self)
	}

	func trs_showViewControllerInView(_ vc: UIViewController, view: UIView) {
		self.trs_showViewControllerInView(vc, view: view) { (make) in
			make.edges.equalTo(view)
		}
	}

	func trs_removeViewController(_ vc: UIViewController) {
		vc.trs_removeViewControllerFromParentVC()
	}

	func trs_removeViewControllerFromParentVC() {
		self.willMove(toParentViewController: nil)
		if self.isViewLoaded {
			self.view.removeFromSuperview()
		}
		self.removeFromParentViewController()
	}

	func trs_isVisible() -> Bool {
		return self.isViewLoaded && self.view.window != nil
	}

}
