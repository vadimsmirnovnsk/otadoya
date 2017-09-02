import AVFoundation

class AudioService: NSObject {

	static private let modifiers = [
		"KID2-",
		"F-",
		"M-",
	]

	private var audioPlayer: AVAudioPlayer? = nil
	private var audioQueue = DispatchQueue(label: "xyz.nazabore.otadoya.audio")

	public func playWoosh() {
		_ = self.playFile(named: "woosh", of: "wav", playForce: true)
	}

	public func playSpring() {
		_ = self.playFile(named: "spring", of: "wav", playForce: true)
	}

	public func playDzin() {
		_ = self.playFile(named: "dzin", of: "wav", playForce: true)
	}

	public func playSound(for symbol: String, modify: Int) -> Bool {
		let modifier = self.modifier(for: modify)
		let fileName = modifier + symbol

		let isPlaying = self.playFile(named: fileName, of: "mp3", playForce: false)
		if isPlaying {
			NotificationCenter.default.post(name: NSNotification.Name(rawValue: "didStartPlayingSound"),
			                                object: nil)
		}

		return isPlaying
	}

	private func modifier(for modify: Int) -> String {
		let index = modify % AudioService.modifiers.count
		return AudioService.modifiers[index]
	}

	private func playFile(named fileName: String, of type: String, playForce: Bool) -> Bool {
		guard let audioFilePath = Bundle.main.path(forResource: fileName, ofType: type) else { return false }
		if let audioPlayer = self.audioPlayer, audioPlayer.isPlaying, !playForce { return false }

		self.audioQueue.async {
			let audioFileUrl = NSURL.fileURL(withPath: audioFilePath)

			do {
				self.audioPlayer = try AVAudioPlayer(contentsOf: audioFileUrl)

				self.audioPlayer?.delegate = self
				self.audioPlayer?.prepareToPlay()
				self.audioPlayer?.play()
			} catch let error {
				print(error.localizedDescription)
			}
		}

		return true
	}

}

extension AudioService: AVAudioPlayerDelegate {

	func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
		NotificationCenter.default.post(name: NSNotification.Name(rawValue: "didStopPlayingSound"), object: nil)
	}

}
