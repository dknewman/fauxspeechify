import Foundation
import AVFoundation

/// A manager class that handles text-to-speech functionality using AVSpeechSynthesizer
/// Provides controls for speaking text with customizable voice, rate, and audio session management
final class TextToSpeechManager: NSObject, ObservableObject {
    
    // MARK: - Private Properties
    
    /// The core AVSpeechSynthesizer instance that handles the actual text-to-speech conversion
    private let synthesizer = AVSpeechSynthesizer()
    
    // MARK: - Published Properties
    
    /// Indicates whether text is currently being spoken
    @Published var isSpeaking = false
    
    // MARK: - Initialization
    
    /// Initializes the TextToSpeechManager and configures the audio session
    override init() {
        super.init()
        synthesizer.delegate = self
        
        // Configure audio session for optimal speech playback
        do {
            // Set category to playback with ducking of other audio
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [.duckOthers])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to set up audio session: \(error)")
        }
    }
    
    // MARK: - Public Methods
    
    /// Speaks the provided text using the specified voice and speech rate
    /// - Parameters:
    ///   - text: The text content to be spoken
    ///   - voice: Optional AVSpeechSynthesisVoice to use (defaults to en-US voice)
    ///   - rate: Speech rate from 0.0 (slowest) to 1.0 (fastest), defaults to 0.5
    func speak(text: String, voice: AVSpeechSynthesisVoice? = nil, rate: Float = 0.5) {
        // Validate that text is not empty
        guard !text.isEmpty else { return }
        
        // Stop any currently playing speech
        if synthesizer.isSpeaking {
            synthesizer.stopSpeaking(at: .immediate)
        }
        
        // Create and configure the speech utterance
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = voice ?? AVSpeechSynthesisVoice(language: "en-US")  // Default to English US voice
        utterance.rate = rate                    // Set speech rate
        utterance.pitchMultiplier = 1.0         // Normal pitch
        utterance.volume = 1.0                  // Maximum volume
        
        // Begin speaking the utterance
        synthesizer.speak(utterance)
    }
    
    /// Pauses the current speech playback
    func pause() {
        if synthesizer.isSpeaking {
            synthesizer.pauseSpeaking(at: .word)  // Pause at word boundary for natural break
        }
    }
    
    /// Resumes paused speech playback
    func resume() {
        if synthesizer.isPaused {
            synthesizer.continueSpeaking()
        }
    }
    
    /// Stops all speech playback immediately
    func stop() {
        if synthesizer.isSpeaking || synthesizer.isPaused {
            synthesizer.stopSpeaking(at: .immediate)  // Stop immediately
        }
    }
}

// MARK: - AVSpeechSynthesizerDelegate

/// Extension implementing AVSpeechSynthesizerDelegate to track speech state changes
extension TextToSpeechManager: AVSpeechSynthesizerDelegate {
    
    /// Called when the synthesizer begins speaking an utterance
    /// Updates the isSpeaking published property to reflect the new state
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
        DispatchQueue.main.async {
            self.isSpeaking = true
        }
    }
    
    /// Called when the synthesizer finishes speaking an utterance normally
    /// Updates the isSpeaking published property to reflect completion
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        DispatchQueue.main.async {
            self.isSpeaking = false
        }
    }
    
    /// Called when speech is cancelled (stopped before completion)
    /// Updates the isSpeaking published property to reflect cancellation
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {
        DispatchQueue.main.async {
            self.isSpeaking = false
        }
    }
}