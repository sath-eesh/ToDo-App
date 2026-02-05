import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel = TodoListViewModel()
    @State private var newTaskTitle: String = ""
    
    @Query private var items: [TodoItem]
    
    init() {
        let now = Date()
        let startOfDay = Calendar.current.startOfDay(for: now)
        let descriptor = FetchDescriptor<TodoItem>(
            predicate: #Predicate { $0.createdAt >= startOfDay }
        )

        _items = Query(filter: #Predicate { item in
             item.createdAt >= startOfDay
        }, sort: \.createdAt)
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                // Add Task Input
                HStack {
                    TextField("New Task for Today", text: $newTaskTitle)
                        .textFieldStyle(.roundedBorder)
                        .onSubmit(addTask)
                    
                    Button(action: addTask) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                    }
                    .disabled(newTaskTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
                .padding()
                
                if items.isEmpty {
                    ContentUnavailableView(
                        "No Tasks for Today",
                        systemImage: "checklist",
                        description: Text("Add a task to get started on your day.")
                    )
                } else {
                    List {
                        ForEach(items) { item in
                            TaskRowView(item: item) {
                                viewModel.toggleCompletion(for: item)
                            }
                            .swipeActions(edge: .trailing) {
                                Button(role: .destructive) {
                                    viewModel.deleteTask(item: item)
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Today")
            .onAppear {
                viewModel.modelContext = modelContext
                viewModel.cleanUpOldTasks()
            }
        }
    }
    
    private func addTask() {
        viewModel.addTask(title: newTaskTitle)
        newTaskTitle = ""
    }
}

#Preview {
    ContentView()
        .modelContainer(for: TodoItem.self, inMemory: true)
}
