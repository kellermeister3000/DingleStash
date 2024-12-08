// Import SwiftUI
import SwiftUI

struct AlertsView: View {
    // Properties
    @EnvironmentObject private var lotteryState: LotteryStateManager
    @State private var searchText = ""
    @State private var selectedStatus = "All"
    let statusOptions = ["All", "Pending", "Checked", "Winner", "Expired"]
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Search bar
                SearchBar(text: $searchText)
                    .padding()
                
                // Lottery type picker
                Picker("Lottery Type", selection: $lotteryState.selectedLotteryType) {
                    ForEach(LotteryType.allCases, id: \.self) { type in
                        Text(type.rawValue).tag(type)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                
                // Status filter
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(statusOptions, id: \.self) { status in
                            Button(action: { selectedStatus = status }) {
                                Text(status)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                                    .background(selectedStatus == status ? Color.blue : Color(.systemGray6))
                                    .foregroundColor(selectedStatus == status ? .white : .primary)
                                    .cornerRadius(20)
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                }
                
                // My Tickets section
                VStack(alignment: .leading, spacing: 8) {
                    Text("MY TICKETS")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .padding(.horizontal)
                        .padding(.top)
                    
                    Text("No tickets found")
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            .navigationTitle("Alerts")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {}) {
                        Image(systemName: "plus")
                    }
                }
            }
        }
    }
}

// Preview
struct AlertsView_Previews: PreviewProvider {
    static var previews: some View {
        AlertsView()
            .environmentObject(LotteryStateManager())
    }
}

