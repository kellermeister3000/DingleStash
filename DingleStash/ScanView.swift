// Import required frameworks
import SwiftUI
import PhotosUI
import Vision

// ScanView implementation
struct ScanView: View {
    // Add environment object
    @EnvironmentObject private var lotteryState: LotteryStateManager
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var scannedText = ""
    @State private var showAlert = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Add Picker for lottery type
                Picker("Lottery Type", selection: $lotteryState.selectedLotteryType) {
                    ForEach(LotteryType.allCases, id: \.self) { type in
                        Text(type.rawValue).tag(type)
                    }
                }
                .pickerStyle(.segmented)
                .padding()
                
                if !scannedText.isEmpty {
                    Text("Scanned \(lotteryState.selectedLotteryType.rawValue) Ticket:")
                        .font(.headline)
                    Text(scannedText)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)
                }
                
                Spacer()
                
                PhotosPicker(
                    selection: $selectedItem,
                    matching: .images
                ) {
                    HStack {
                        Image(systemName: "camera")
                            .font(.system(size: 20))
                        Text("Pick Ticket Photo")
                            .font(.headline)
                    }
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
                }
                .onChange(of: selectedItem, initial: false) { oldValue, newValue in
                    Task {
                        if let data = try? await newValue?.loadTransferable(type: Data.self),
                           let image = UIImage(data: data),
                           let cgImage = image.cgImage {
                            await processImage(cgImage)
                        }
                    }
                }
            }
            .padding()
            .navigationTitle("Scan Ticket")
        }
    }
    
    // Process image function remains the same
    private func processImage(_ cgImage: CGImage) async {
        let requestHandler = VNImageRequestHandler(cgImage: cgImage)
        let request = VNRecognizeTextRequest { request, error in
            guard let observations = request.results as? [VNRecognizedTextObservation],
                  error == nil else { return }
            
            let text = observations.compactMap { observation in
                observation.topCandidates(1).first?.string
            }.joined(separator: "\n")
            
            DispatchQueue.main.async {
                self.scannedText = text
            }
        }
        
        request.recognitionLanguages = ["en-US"]
        request.recognitionLevel = .accurate
        
        do {
            try requestHandler.perform([request])
        } catch {
            print("Error performing OCR: \(error)")
        }
    }
}

// Preview remains the same
struct ScanView_Previews: PreviewProvider {
    static var previews: some View {
        ScanView()
            .environmentObject(LotteryStateManager())
    }
}
