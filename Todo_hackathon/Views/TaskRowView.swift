import SwiftUI

struct TaskRowView: View {
    let item: TodoItem
    let toggleAction: () -> Void
    
    var body: some View {
        HStack {
            CheckBoxView(isCompleted: item.isCompleted, action: toggleAction)
            
            Text(item.title)
                .strikethrough(item.isCompleted)
                .foregroundColor(item.isCompleted ? .gray : .primary)
            
            Spacer()
        }
        .padding(.vertical, 8)
    }
}
