import Foundation

public enum TextType: String, Codable {
    case text
    case ssml
}

public enum AudioFormat: String, Codable {
    case mp3
}

public enum SpeechGender: String, Codable {
    case female
    case male
    case neuter
}

public enum SpeechVolume : String, Codable {
    case none
    case silent
    case x_soft = "x-soft"
    case soft
    case medium
    case loud
    case x_loud = "x-loud"
}

open class SpeechOptions: Codable {
    public init(text: String) {
        self.text = text
        textType = .text
    }
    
    public init(ssml: String) {
        self.text = ssml
        textType = .ssml
    }
    
    public convenience init(text: String, volume : SpeechVolume) {
        self.init(ssml: text)
        self.speechVolume = volume
    }
    
    /**
     `String` to create audiofile for. Can either be plain text or [`SSML`](https://en.wikipedia.org/wiki/Speech_Synthesis_Markup_Language).
     
     If `SSML` is provided, `TextType` must be `TextType.ssml`.
     */
    open var text: String
    
    /**
     Type of text to synthesize.
     
     `SSML` text must be valid `SSML` for request to work.
     */
    let textType: TextType
    
    /**
     Audio format for outputted audio file.
     */
    open var outputFormat: AudioFormat = .mp3
    
    /**
     The locale in which the audio is spoken.
     
     By default, the user's system locale will be used to decide upon an appropriate voice.
     */
    open var locale: Locale = .autoupdatingCurrent
    
    /**
     Gender of voice speeking text.
     
     Note: not all languages have both genders.
     */
    open var speechGender: SpeechGender = .neuter
    
    
    var speechVolume : SpeechVolume = .none
    
    /**
     The path of the request URL, not including the hostname or any parameters.
     */
    internal var path: String {
        var characterSet = CharacterSet.urlPathAllowed
        characterSet.remove(charactersIn: "/")
        if speechVolume != .none { return "voice/v1/speak/\(ssmlFromText.addingPercentEncoding(withAllowedCharacters: characterSet)!)" }
        else { return "voice/v1/speak/\(text.addingPercentEncoding(withAllowedCharacters: characterSet)!)" }
        
    }
    
    /**
     An array of URL parameters to include in the request URL.
     */
    internal var params: [URLQueryItem] {
        var params: [URLQueryItem] = [
            URLQueryItem(name: "textType", value: String(describing: textType)),
            URLQueryItem(name: "language", value: locale.identifier),
            URLQueryItem(name: "outputFormat", value: String(describing: outputFormat))
        ]
        
        if speechGender != .neuter {
            params.append(URLQueryItem(name: "gender", value: String(describing: speechGender)))
        }
        
        return params
    }
    
    
    var ssmlFromText : String {
        if speechVolume != .none {
            return "<speak><prosody volume=\"\(speechVolume.rawValue)\">\(self.text)</prosody></speak>"
        } else {
            return "<speak>\(self.text)</speak>"
        }
    }
}
