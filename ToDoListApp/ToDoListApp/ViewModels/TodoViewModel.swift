//
//  TodoViewModel.swift
//  ToDoListApp
//
//  Created by umitalbayrak on 23.05.2025.
//

// MARK: TodoViewModel

class TodoViewModel {
    private var todos : [TodoItem] = []
    var onTodosUpdated: (() -> Void)?
    
    var todoCount : Int {
        return todos.count
    }
    
    
    func todo(at index: Int) -> TodoItem {
        return todos[index]
    }
    
    func addTodo(title: String) {
        let newTodo = TodoItem(title: title, isCompleted: false)
        todos.append(newTodo)
        onTodosUpdated?()
    }
    
    func toggleCompletion(at index: Int) {
        todos[index].isCompleted.toggle()
        onTodosUpdated?()
    }
    
    func deleteTodo(at index: Int) {
        todos.remove(at: index)
        onTodosUpdated?()
    }

}
