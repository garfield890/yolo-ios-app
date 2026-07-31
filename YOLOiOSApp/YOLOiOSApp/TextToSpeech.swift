//
//  TextToSpeech.swift
//  UltralyticsYOLO
//
//  Created by Anay Agrawal on 7/30/26.
//

import AVFoundation

class TextToSpeech: NSObject, AVSpeechSynthesizerDelegate, @unchecked Sendable {
    static let shared = TextToSpeech()
    private let synthesizer = AVSpeechSynthesizer()
    private var onSpeechFinished: (@Sendable () -> Void)?
    
    override init() {
        super.init()
        synthesizer.delegate = self
        try? AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: .duckOthers)
    }
    
    func speak(_ text: String, completion: (@Sendable () -> Void)? = nil) {
        self.onSpeechFinished = completion
        
        if synthesizer.isSpeaking {
            synthesizer.stopSpeaking(at: .immediate)
        }
        
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(identifier: "com.apple.ttsbundle.siri_female_en-US_compact")
        utterance.rate = AVSpeechUtteranceDefaultSpeechRate
        utterance.pitchMultiplier = 1.0
        utterance.volume = 1.0
        
        synthesizer.speak(utterance)
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        onSpeechFinished?()
        onSpeechFinished = nil
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {
        onSpeechFinished = nil
    }
    
    func stop() {
        onSpeechFinished = nil
        synthesizer.stopSpeaking(at: .immediate)
    }
}
