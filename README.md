# FauxSpeechify

A SwiftUI-based iOS application that provides text-to-speech functionality with OCR (Optical Character Recognition) capabilities. Capture text from images using your device's camera and have it read aloud with customizable voice settings.

## Features

- **Camera Text Capture**: Use your device's camera to capture text from physical documents, signs, or any printed material
- **OCR Text Recognition**: Powered by Apple's Vision framework for accurate text extraction from images
- **Text-to-Speech**: Convert captured or sample text to natural-sounding speech
- **Voice Customization**: Choose from available English voices on your device
- **Speech Rate Control**: Adjust playback speed from 0.1x to 1.0x with a simple slider
- **Audio Controls**: Play, pause, and stop functionality for speech playback
- **Sample Text**: Test the functionality with built-in sample text

## Requirements

- iOS 18.5+
- Xcode 15.0+
- Swift 5.0+
- Device with camera (for text capture functionality)

## Installation

1. Clone the repository:
   ```bash
   git clone <repository-url>
   cd fauxspeechify
   ```

2. Open the project in Xcode:
   ```bash
   open fauxspeechify.xcodeproj
   ```

3. Build and run the project on your iOS device or simulator

## Usage

1. **Capture Text**: Tap the "Capture Text" button to open the camera and capture text from images
2. **Use Sample Text**: Tap "Sample Text" to load example text for testing
3. **Select Voice**: Choose your preferred voice from the dropdown menu
4. **Adjust Speed**: Use the slider to control speech rate
5. **Play Audio**: Tap the play button to start text-to-speech conversion
6. **Control Playback**: Use pause and stop buttons to control audio playback

## Project Structure

```
fauxspeechify/
├── fauxspeechifyApp.swift          # Main app entry point
├── ContentView.swift               # Primary user interface
├── TextToSpeechManager.swift       # Text-to-speech functionality
├── OCRManager.swift                # OCR text recognition
├── CameraView.swift                # Camera interface for text capture
├── fauxspeechifyTests/             # Unit tests
└── fauxspeechifyUITests/           # UI tests
```

## Key Components

### TextToSpeechManager
- Manages AVSpeechSynthesizer for text-to-speech conversion
- Configures audio session for optimal playback
- Provides controls for play, pause, and stop functionality
- Supports customizable voice selection and speech rate

### OCRManager
- Utilizes Apple's Vision framework for text recognition
- Processes UIImage inputs to extract text content
- Provides real-time processing status updates
- Optimized for accuracy with language correction enabled

### ContentView
- Main user interface built with SwiftUI
- Integrates camera, OCR, and text-to-speech functionality
- Provides intuitive controls for voice and speed customization
- Responsive design supporting both iPhone and iPad

## Version

- **Current Version**: 1.0
- **Bundle Identifier**: pro.davidnewman.fauxspeechify
- **Swift Version**: 5.0

## Author

Created by David Newman

## License

This project is available under the MIT license.
