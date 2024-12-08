// Import SwiftUI
import SwiftUI

// Reusable TicketSelectorView
struct TicketSelectorView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var lotteryState: LotteryStateManager
    @Binding var selectedNumbers: Set<Int>
    @Binding var selectedSpecialBall: Int?
    let onSave: () -> Void
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Main numbers selection
                Text("Select 5 Numbers")
                    .font(.headline)
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 10) {
                    ForEach(lotteryState.selectedLotteryType.mainNumbersRange, id: \.self) { number in
                        NumberButton(
                            number: number,
                            isSelected: selectedNumbers.contains(number),
                            maxSelections: 5,
                            selectedCount: selectedNumbers.count
                        ) {
                            if selectedNumbers.contains(number) {
                                selectedNumbers.remove(number)
                            } else if selectedNumbers.count < 5 {
                                selectedNumbers.insert(number)
                            }
                        }
                    }
                }
                .padding()
                
                // Special ball selection
                Text(lotteryState.selectedLotteryType == .megaMillions ? "Select Mega Ball" : "Select Power Ball")
                    .font(.headline)
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 10) {
                    ForEach(lotteryState.selectedLotteryType.specialBallRange, id: \.self) { number in
                        NumberButton(
                            number: number,
                            isSelected: selectedSpecialBall == number,
                            maxSelections: 1,
                            selectedCount: selectedSpecialBall != nil ? 1 : 0
                        ) {
                            selectedSpecialBall = (selectedSpecialBall == number) ? nil : number
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Select Numbers")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        onSave()
                        dismiss()
                    }
                    .disabled(selectedNumbers.count != 5 || selectedSpecialBall == nil)
                }
            }
        }
    }
}

// Helper view for number selection buttons
struct NumberButton: View {
    let number: Int
    let isSelected: Bool
    let maxSelections: Int
    let selectedCount: Int
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text("\(number)")
                .frame(width: 30, height: 30)
                .background(isSelected ? Color.blue : Color.gray.opacity(0.3))
                .foregroundColor(isSelected ? .white : .primary)
                .clipShape(Circle())
        }
        .disabled(!isSelected && selectedCount >= maxSelections)
    }
}

// Preview
struct TicketSelectorView_Previews: PreviewProvider {
    static var previews: some View {
        TicketSelectorView(
            selectedNumbers: .constant([]),
            selectedSpecialBall: .constant(nil),
            onSave: {}
        )
        .environmentObject(LotteryStateManager())
    }
}
