// Import SwiftUI
import SwiftUI

// TicketsView implementation
struct TicketsView: View {
    // Properties
    @EnvironmentObject private var lotteryState: LotteryStateManager
    @State private var selectedStatus = TicketStatus.all
    @State private var tickets: [LotteryTicket] = []
    @State private var searchText = ""
    @State private var showingTicketSelector = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Search bar
                SearchBar(text: $searchText)
                    .padding()
                
                // Lottery type selector
                Picker("Lottery Type", selection: $lotteryState.selectedLotteryType) {
                    ForEach(LotteryType.allCases, id: \.self) { type in
                        Text(type.rawValue).tag(type)
                    }
                }
                .pickerStyle(.segmented)
                .padding()
                
                // Ticket status filter
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 15) {
                        ForEach(TicketStatus.allCases, id: \.self) { status in
                            Button(action: { selectedStatus = status }) {
                                Text(status.rawValue)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                                    .background(selectedStatus == status ? Color.blue : Color(.systemGray6))
                                    .foregroundColor(selectedStatus == status ? .white : .primary)
                                    .cornerRadius(20)
                            }
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 8)
                
                // Title
                HStack {
                    Text("MY TICKETS")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .padding(.horizontal)
                        .padding(.top)
                    Spacer()
                }
                
                // Tickets list
                if tickets.isEmpty {
                    VStack {
                        Spacer()
                        Text("No tickets found")
                            .foregroundColor(.gray)
                        Spacer()
                    }
                } else {
                    List(tickets) { ticket in
                        TicketRowView(ticket: ticket)
                    }
                }
            }
            .navigationTitle("DingleStache")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingTicketSelector = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingTicketSelector) {
                TicketSelectorView(
                    selectedNumbers: .constant([]),
                    selectedSpecialBall: .constant(nil),
                    onSave: {}
                )
            }
        }
    }
}

// Helper view for ticket row
struct TicketRowView: View {
    let ticket: LotteryTicket
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(ticket.type.rawValue)
                .font(.headline)
            HStack {
                Text("Numbers: \(ticket.mainNumbers.map { String($0) }.joined(separator: ", "))")
                Text("\(ticket.type == .megaMillions ? "Mega Ball" : "Power Ball"): \(ticket.specialBall)")
                    .foregroundColor(.blue)
            }
            Text("Draw Date: \(ticket.drawDate.formatted())")
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
}

// Preview
struct TicketsView_Previews: PreviewProvider {
    static var previews: some View {
        TicketsView()
            .environmentObject(LotteryStateManager())
    }
}
