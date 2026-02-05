import SwiftUI

struct CheckBoxView: View {
    let isCompleted: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: isCompleted ? "checkmark.circle.fill" : "circle")
                .font(.system(size: 24))
                .foregroundColor(isCompleted ? .green : .gray)
        }
        .buttonStyle(.plain)
    }
}
