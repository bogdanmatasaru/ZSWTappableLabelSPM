import ZSWTappableLabel
import ZSWTaggedString

public struct ZSWTappableLabelSPM {
    public private(set) var text = "Hello, World!"
    
    let test = ZSWTappableLabel(frame: .zero)
    let testString = ZSWTaggedString(string: "test")
    
    public init() {
    }
}
