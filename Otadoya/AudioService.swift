import AVFoundation

class AudioService {

	private var audioPlayer = AVAudioPlayer()

	public func playWoosh() {
		self.playFile(named: "woosh")
	}

	public func playSpring() {
		self.playFile(named: "spring")
	}

	public func playSound(for symbol: String) {

	}

	private func playFile(named fileName: String) {
		let audioFilePath = Bundle.main.path(forResource: fileName, ofType: "wav")
		let audioFileUrl = NSURL.fileURL(withPath: audioFilePath!)

		do {
			self.audioPlayer = try AVAudioPlayer(contentsOf: audioFileUrl)

			self.audioPlayer.prepareToPlay()
			self.audioPlayer.play()
		} catch let error {
			print(error.localizedDescription)
		}
	}

}
