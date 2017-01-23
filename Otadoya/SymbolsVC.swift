import UIKit
import SnapKit
import AVFoundation

class SymbolsVC: UIViewController {

	private static let charactersString = "А,Б,В,Г,Д,Е,Ё,Ж,З,И,Й,К,Л,М,Н,О,П,Р,С,Т,У,Ф,Х,Ц,Ч,Ш,Щ,Ъ,Ы,Ь,Э,Ю,Я"
	private static let numbersString = "0,1,2,3,4,5,6,7,8,9"

	fileprivate var symbolsCollectionView: UICollectionView!
	private let characters: Array<String>
	private let numbers: Array<String>
	fileprivate var symbols: Array<String>!
	fileprivate let colors = [
		UIColor.sunglow,
		UIColor.crusta,
		UIColor.conifer,
		UIColor.cornflowerBlue
	]

	fileprivate var audioPlayer = AVAudioPlayer()
	fileprivate var shouldDzin = true
	fileprivate var lastIndexPath: IndexPath?

	override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {

		self.characters = SymbolsVC.charactersString.components(separatedBy: ",")
		self.numbers = SymbolsVC.numbersString.components(separatedBy: ",")

		super.init(nibName: nil, bundle: nil)

		self.symbolsCollectionView = UICollectionView.init(frame: .zero, collectionViewLayout: self.layout())
		self.symbols = self.characters + self.numbers
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		symbolsCollectionView.backgroundColor = UIColor.conifer
		symbolsCollectionView.isPagingEnabled = true

		symbolsCollectionView.delegate = self
		symbolsCollectionView.dataSource = self

		symbolsCollectionView.register(SymbolCell.self, forCellWithReuseIdentifier: "cell")

		self.view.addSubview(symbolsCollectionView)

		// Layout

		self.symbolsCollectionView.snp.makeConstraints { (make) in
			make.edges.equalTo(self.view)
		}
	}

	override var preferredStatusBarStyle: UIStatusBarStyle {
		return .lightContent
	}
	
}

extension SymbolsVC { // Private

	fileprivate func layout() -> UICollectionViewFlowLayout {
		let layout = UICollectionViewFlowLayout.init()
		layout.itemSize = UIScreen.main.bounds.size
		layout.scrollDirection = .horizontal
		layout.minimumLineSpacing = 0.0

		return layout
	}

}

extension SymbolsVC: UICollectionViewDelegate, UICollectionViewDataSource {

	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 1
	}

	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return self.symbols.count
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! SymbolCell

		cell.contentView.backgroundColor = self.colors[indexPath.row % 4]
		cell.symbolLabel.text = self.symbols[indexPath.row]
		return cell
	}

	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let nextItemRow = indexPath.row + 1 == self.symbols.count ? 0 : indexPath.row + 1
		let ip = IndexPath.init(row: nextItemRow, section: indexPath.section)
		let scrollPosition = UICollectionViewScrollPosition.init(rawValue: 0)
		collectionView.scrollToItem(at: ip, at: scrollPosition, animated: true)
	}

	func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
		playDzin()
	}

	func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
		self.shouldDzin = true
	}

	private func playDzin() {
		guard self.shouldDzin else { return }

		let audioFilePath = Bundle.main.path(forResource: "dzin", ofType: "wav")
		let audioFileUrl = NSURL.fileURL(withPath: audioFilePath!)

		do {

			audioPlayer = try AVAudioPlayer(contentsOf: audioFileUrl)

			audioPlayer.prepareToPlay()
			audioPlayer.play()
		} catch let error {
			print(error.localizedDescription)
		}
	}

}

extension SymbolsVC { // Shake

	override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if(event?.subtype == UIEventSubtype.motionShake) {
			self.moveToRandomSymbol()
			self.playSpringSound()
        }
    }

	private func moveToRandomSymbol() {
		let randomIndex = Int(arc4random_uniform(UInt32(self.symbols.count - 1)))
		let randomIndexPath = IndexPath.init(row: randomIndex, section: 0)
		let scrollPosition = UICollectionViewScrollPosition.init(rawValue: 0)
		self.symbolsCollectionView.scrollToItem(at: randomIndexPath, at: scrollPosition, animated: true)
	}

	private func playSpringSound() {
		self.shouldDzin = false

		AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
		let audioFilePath = Bundle.main.path(forResource: "spring", ofType: "wav")
		let audioFileUrl = NSURL.fileURL(withPath: audioFilePath!)

		do {
			audioPlayer = try AVAudioPlayer(contentsOf: audioFileUrl)

			audioPlayer.prepareToPlay()
			audioPlayer.play()
		} catch let error {
			print(error.localizedDescription)
		}
	}

}
