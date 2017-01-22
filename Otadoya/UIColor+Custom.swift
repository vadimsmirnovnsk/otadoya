import UIKit

extension UIColor {

	/*! \hue: yellow */
	@nonobjc static let sunglow: UIColor = {
		return UIColor.colorWithHexString("FFCF25")!
	}()

	/*! \hue: orange */
	@nonobjc static let crusta: UIColor = {
		return UIColor.colorWithHexString("FF872C")!
	}()

	/*! \hue: green */
	@nonobjc static let conifer: UIColor = {
		return UIColor.colorWithHexString("A8DA65")!
	}()

	/*! \hue: blue */
	@nonobjc static let cornflowerBlue: UIColor = {
		return UIColor.colorWithHexString("61ACE6")!
	}()

	// Func

	static func trs_color(forString hexString: String) -> UIColor {
		return self.colorWithHexString(hexString) ?? UIColor.clear
	}

}

extension UIColor { // Private

	// Private

	fileprivate static func colorWithHexString(_ hexString:String) -> UIColor?
	{
		return UIColor.colorWithHex(UIColor.hexForHexString(hexString)!)
	}

	fileprivate static func colorWithHex(_ hex:UInt32) -> UIColor
	{
		return UIColor(red: CGFloat((hex & 0xFF0000)  >> 16) / 255,
		               green: CGFloat((hex & 0xFF00)    >>  8) / 255,
		               blue: CGFloat(hex & 0xFF) / 255,
		               alpha: CGFloat(1.0))
	}

	fileprivate static func hexForHexString(_ hexString:String) -> UInt32?
	{
		let unexpectedHexStringLength: Bool = (hexString.characters.count < 6) || (hexString.characters.count > 8)

		if unexpectedHexStringLength
		{
			assert(false, "Invalid hex format")
			return 0
		}

		let scanner: Scanner = Scanner(string: hexString)
		scanner.scanLocation = (hexString.characters.first == "#") ? 1 : 0

		var hex: UInt32 = 0
		if !scanner.scanHexInt32(&hex)
		{
			assert(false, "Invalid Hex Format")
			return 0
		}
		
		return hex
	}

}
