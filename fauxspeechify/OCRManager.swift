import Foundation
import Vision
import UIKit

/// A manager class responsible for performing Optical Character Recognition (OCR) on images
/// using Apple's Vision framework to extract text content.
final class OCRManager: ObservableObject {
    
    // MARK: - Published Properties
    
    /// The text that was recognized from the most recent image analysis
    @Published var recognizedText = ""
    
    /// Indicates whether the OCR processing is currently in progress
    @Published var isProcessing = false
    
    // MARK: - Public Methods
    
    /// Performs OCR on the provided image to extract text content
    /// - Parameter image: The UIImage to analyze for text recognition
    func recognizeText(from image: UIImage) {
        // Convert UIImage to CGImage for Vision framework processing
        guard let cgImage = image.cgImage else {
            print("Failed to get CGImage from UIImage")
            return
        }
        
        // Update UI to show processing state
        DispatchQueue.main.async {
            self.isProcessing = true
        }
        
        // Create the Vision request handler with the image
        let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        
        // Create the text recognition request with completion handler
        let request = VNRecognizeTextRequest { [weak self] request, error in
            self?.handleTextRecognitionResult(request: request, error: error)
        }
        
        // Configure request for optimal text recognition
        request.recognitionLevel = .accurate        // Use highest accuracy mode
        request.usesLanguageCorrection = true      // Enable language correction for better results
        
        // Perform the text recognition request
        do {
            try requestHandler.perform([request])
        } catch {
            print("Failed to perform text recognition: \(error)")
            // Reset processing state on failure
            DispatchQueue.main.async {
                self.isProcessing = false
            }
        }
    }
    
    // MARK: - Private Methods
    
    /// Handles the result of the text recognition request
    /// - Parameters:
    ///   - request: The completed VNRequest containing recognition results
    ///   - error: Any error that occurred during processing
    private func handleTextRecognitionResult(request: VNRequest, error: Error?) {
        // Handle any errors that occurred during text recognition
        if let error = error {
            print("Text recognition error: \(error)")
            DispatchQueue.main.async {
                self.isProcessing = false
            }
            return
        }
        
        // Cast the request results to the expected type
        guard let observations = request.results as? [VNRecognizedTextObservation] else {
            print("No text recognition results")
            DispatchQueue.main.async {
                self.isProcessing = false
            }
            return
        }
        
        // Extract the most confident text candidate from each observation
        let recognizedStrings = observations.compactMap { observation in
            return observation.topCandidates(1).first?.string
        }
        
        // Combine all recognized text strings into a single text block
        let fullText = recognizedStrings.joined(separator: "\n")
        
        // Update the UI with the recognized text and reset processing state
        DispatchQueue.main.async {
            self.recognizedText = fullText
            self.isProcessing = false
        }
    }
}