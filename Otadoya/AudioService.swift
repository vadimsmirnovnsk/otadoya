import AVFoundation

class AudioService {

	static private let modifiers = [
		"F-",
		"M-",
		"KID-",
	]

	private var audioPlayer = AVAudioPlayer()

	public func playWoosh() {
		self.playFile(named: "woosh")
	}

	public func playSpring() {
		self.playFile(named: "spring")
	}

	public func playSound(for symbol: String, modify: Int) {
		let modifier = self.modifier(for: modify)
		let fileName = modifier + symbol

		self.playFile(named: fileName)
	}

	private func modifier(for modify: Int) -> String {
		let index = modify % AudioService.modifiers.count
		return AudioService.modifiers[index]
	}

	private func playFile(named fileName: String) {
		guard let audioFilePath = Bundle.main.path(forResource: fileName, ofType: "wav") else { return }

		let audioFileUrl = NSURL.fileURL(withPath: audioFilePath)

		do {
			self.audioPlayer = try AVAudioPlayer(contentsOf: audioFileUrl)

			self.audioPlayer.prepareToPlay()
			self.audioPlayer.play()
		} catch let error {
			print(error.localizedDescription)
		}
	}

}
