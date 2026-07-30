//
//  TextToSpeech.swift
//  UltralyticsYOLO
//
//  Created by Anay Agrawal on 7/30/26.
//

import AVFoundation

class TextToSpeech {
    static let shared = TextToSpeech()
    private let synthesizer = AVSpeechSynthesizer()
    
    init() {
        try? AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: .duckOthers)
    }
    
    func speak(_ text: String) {
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
    
    func stop() {
        synthesizer.stopSpeaking(at: .immediate)
    }
}
