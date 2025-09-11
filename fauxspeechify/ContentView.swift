import SwiftUI
import AVFoundation

struct ContentView: View {
    @StateObject private var textToSpeech = TextToSpeechManager()
    @StateObject private var ocrManager = OCRManager()
    @State private var showingCamera = false
    @State private var extractedText = ""
    @State private var speechRate: Float = 0.5
    @State private var selectedVoice: AVSpeechSynthesisVoice?
    @State private var availableVoices: [AVSpeechSynthesisVoice] = []
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Header
                Text("Speechify Clone")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top)
                
                // Camera Button
                HStack(spacing: 15) {
                    Button(action: {
                        showingCamera = true
                    }) {
                        HStack {
                            Image(systemName: "camera.fill")
                            Text("Capture Text")
                        }
                        .font(.title2)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(12)
                    }
                    
                    Button(action: {
                        extractedText = "This is a sample text to test the text-to-speech functionality. You can now play this text to hear how it sounds with different voices and speech rates."
                    }) {
                        HStack {
                            Image(systemName: "text.bubble.fill")
                            Text("Sample Text")
                        }
                        .font(.title2)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.green)
                        .cornerRadius(12)
                    }
                }
                
                // Extracted Text Display
                ScrollView {
                    Text(extractedText.isEmpty ? "No text captured yet. Tap the camera button to get started!" : extractedText)
                        .font(.body)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        .multilineTextAlignment(.leading)
                }
                .frame(maxHeight: 300)
                
                // Voice Selection
                if !availableVoices.isEmpty {
                    VStack(alignment: .leading) {
                        Text("Voice Selection")
                            .font(.headline)
                        
                        Picker("Voice", selection: $selectedVoice) {
                            ForEach(availableVoices, id: \.identifier) { voice in
                                Text(voice.name).tag(voice as AVSpeechSynthesisVoice?)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                    }
                }
                
                // Speech Rate Control
                VStack(alignment: .leading) {
                    Text("Speech Rate: \(String(format: "%.1f", speechRate))")
                        .font(.headline)
                    
                    Slider(value: $speechRate, in: 0.1...1.0, step: 0.1)
                        .accentColor(.blue)
                }
                
                // Audio Controls
                HStack(spacing: 30) {
                    Button(action: {
                        if !extractedText.isEmpty {
                            textToSpeech.speak(text: extractedText,
                                             voice: selectedVoice,
                                             rate: speechRate)
                        }
                    }) {
                        Image(systemName: textToSpeech.isSpeaking ? "pause.circle.fill" : "play.circle.fill")
                            .font(.system(size: 50))
                            .foregroundColor(.blue)
                    }
                    .disabled(extractedText.isEmpty)
                    
                    Button(action: {
                        textToSpeech.stop()
                    }) {
                        Image(systemName: "stop.circle.fill")
                            .font(.system(size: 50))
                            .foregroundColor(.red)
                    }
                    .disabled(!textToSpeech.isSpeaking)
                }
                
                Spacer()
            }
            .padding()
            .sheet(isPresented: $showingCamera) {
                CameraView(extractedText: $extractedText, ocrManager: ocrManager)
            }
            .onChange(of: ocrManager.recognizedText) {
                extractedText = ocrManager.recognizedText
            }
            .onAppear {
                loadAvailableVoices()
            }
        }
    }
    
    private func loadAvailableVoices() {
        availableVoices = AVSpeechSynthesisVoice.speechVoices()
            .filter { $0.language.hasPrefix("en") }
        selectedVoice = availableVoices.first
    }
}

#Preview {
    ContentView()
}
