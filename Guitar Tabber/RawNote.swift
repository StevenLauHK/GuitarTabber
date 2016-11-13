import Foundation

public class RawNote {
    public internal(set) var pitch: Int
    public internal(set) var octave: Int
    
    internal var startTime: Double
    internal var endTime: Double
    
    public var duration: Float {
        get {
            return (Float) (endTime - startTime)
        }
    }

    public let notes = ["C", "C♯","D","D♯","E","F","F♯","G","G♯","A","A♯","B"]

    init(pitch p: String, octave o: Int) {
        octave = o
        startTime = NSTimeIntervalSince1970
        endTime = startTime
        switch p {
        case notes[0]:
          pitch = 0
        case notes[1]:
          pitch = 1
        case notes[2]:
          pitch = 2
        case notes[3]:
          pitch = 3
        case notes[4]:
          pitch = 4
        case notes[5]:
          pitch = 5
        case notes[6]:
          pitch = 6
        case notes[7]:
          pitch = 7
        case notes[8]:
          pitch = 8
        case notes[9]:
          pitch = 9
        case notes[9]:
          pitch = 9
        case notes[10]:
          pitch = 10
        case notes[11]:
          pitch = 11
        default:
          pitch = -1
        }
    }
    
    public func finish() {
        endTime = NSTimeIntervalSince1970
    }
}
