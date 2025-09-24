//
//  TaskView.swift
//  InterviewPrep
//
//  Created by Nick Deda on 9/24/25.
//

/*
 Header
 A title at the top: “My Tasks”.
 A button on the trailing side of the header that says “+ Add”.
 Task List
 A vertical list of tasks.
 Each task should show:
 A circle that can be tapped to mark the task complete/incomplete.
 The task title (strikethrough if completed).
 A small tag with the task’s priority (High, Medium, Low).
 Empty State
 If there are no tasks, show a placeholder illustration (or Image(systemName:)) with text like “No tasks yet. Add one!”.
 Footer
 At the bottom, show a summary like:
 “3 of 5 tasks completed”.
 */

import SwiftUI
import Observation

struct Task: Identifiable {
  var id = UUID()
  var text: String
  var isComplete: Bool
}

@Observable
final class TaskModel {
  
  var tasks: [Task] = [
    Task(text: "Add your first task", isComplete: false)
  ]
  var showingAddTaskSheet = false
  var addTaskText = ""
  
  func addTask(_ text: String) {
    tasks.append(Task(text: text, isComplete: false))
  }
}

struct TaskView: View {
  @Bindable var model = TaskModel()
  var body: some View {
    NavigationStack {
      VStack {
        List {
          ForEach(model.tasks) { task in
            HStack(spacing: 12) {
              Image(systemName: task.isComplete ? "checkmark.circle.fill" : "circle")
                .foregroundStyle(task.isComplete ? .blue : .secondary)
              Text(task.text)
                .strikethrough(task.isComplete)
                .foregroundStyle(task.isComplete ? .secondary : .primary)
              Spacer()
            }
            .contentShape(Rectangle())
            .onTapGesture {
              if let index = model.tasks.firstIndex(where: { $0.id == task.id }) {
                model.tasks[index].isComplete.toggle()
              }
            }
          }
        }
        .toolbar {
          ToolbarItemGroup(placement: .bottomBar) {
            let done = model.tasks.filter { $0.isComplete }.count
            let total = model.tasks.count
            Text("\(done) of \(total) tasks completed")
              .frame(maxWidth: .infinity)
          }
        }
      }
      .navigationTitle("My Tasks")
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        Button {
          model.showingAddTaskSheet = true
        } label: {
          Image(systemName: "plus")
        }
        .sheet(isPresented: $model.showingAddTaskSheet) {
          VStack {
            HStack {
              Button("Cancel") {
                model.showingAddTaskSheet = false
                model.addTaskText = ""
              }
              .frame(maxWidth: .infinity, alignment: .leading)
              Text("Add Task")
                .font(.headline)
              Button("Add") {
                model.addTask(model.addTaskText)
                model.addTaskText = ""
                model.showingAddTaskSheet = false
              }
              .frame(maxWidth: .infinity, alignment: .trailing)
            }
            VStack(spacing: 12) {
              TextField("Enter Task Here", text: $model.addTaskText)
                .font(.headline)
                .multilineTextAlignment(.center)
            }
            .padding(.top, 60)
          }
          .presentationDetents([.fraction(0.25), .medium])
          .padding()
        }
      }
    }
  }
}

#Preview {
  TaskView()
}
