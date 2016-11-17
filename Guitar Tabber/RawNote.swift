import Foundation
import QuartzCore

public class RawNote {
    public var pitch: Int
    public internal(set) var octave: Int
    
    internal var startTime: Double
    internal var endTime: Double
    
    public var duration: Float {
        get {
            return (Float) (endTime - startTime)
        }
    }
    
    public func setPitch(pitch p: String) {
        self.pitch = convertPitch(pitch: p)
    }
    
    private func convertPitch(pitch p: String) -> Int {
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
        return pitch
    }

    public let notes = ["C", "C♯","D","D♯","E","F","F♯","G","G♯","A","A♯","B"]

    init(pitch p: String, octave o: Int) {
        octave = o
        startTime = CACurrentMediaTime()
        endTime = 0
        pitch = 0
        pitch = self.convertPitch(pitch: p)
    }
    
    public func finish() {
        endTime = CACurrentMediaTime()
    }
}
