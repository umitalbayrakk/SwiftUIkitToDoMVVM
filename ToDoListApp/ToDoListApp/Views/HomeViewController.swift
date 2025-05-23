//
//  ViewController.swift
//  ToDoListApp
//
//  Created by umitalbayrak on 23.05.2025.
//

import UIKit

class HomeViewController: UIViewController {
    private let viewModel = TodoViewModel()
    private let textField = UITextField()
    private let addButton = UIButton(type: .system)
    private let tableView = UITableView()
        

    

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupViewModel()
    }
    private func setupUI() {
        view.backgroundColor = .orange
        navigationItem.title = Constants.appTitle
        //MARK: TextField
        textField.placeholder = Constants.textFieldPlaceholder
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(textField)
        //MARK: Add Button
        addButton.setTitle(Constants.appTitle, for: .normal)
        addButton.backgroundColor = Constants.buttonColor
        addButton.setTitleColor(.white, for: .normal)
        addButton.layer.cornerRadius = 8
        addButton.addTarget(self, action: #selector(addTodo), for: .touchUpInside)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(addButton)
        //MARK: TableView
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Constants.cellIdentifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        //MARK: Auto Layout
        NSLayoutConstraint.activate([
                    textField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
                    textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
                    textField.trailingAnchor.constraint(equalTo: addButton.leadingAnchor, constant: -8),
                    addButton.centerYAnchor.constraint(equalTo: textField.centerYAnchor),
                    addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
                    addButton.widthAnchor.constraint(equalToConstant: 60),
                    addButton.heightAnchor.constraint(equalToConstant: 40),
                    tableView.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 16),
                    tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                    tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                    tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
                ])
                
    }
    
    private func setupViewModel() {
          viewModel.onTodosUpdated = { [weak self] in
              self?.tableView.reloadData()
          }
      }
    
    @objc private func addTodo() {
          guard let title = textField.text, !title.isEmpty else { return }
          viewModel.addTodo(title: title)
          textField.text = ""
          textField.resignFirstResponder()
      }


}
extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.todoCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifier , for: indexPath)
        let todo = viewModel.todo(at: indexPath.row)
        cell.textLabel?.text = todo.title
        cell.textLabel?.textColor = .label
        cell.textLabel?.attributedText = NSAttributedString(
                    string: todo.title,
                    attributes: [.strikethroughStyle: todo.isCompleted ? NSUnderlineStyle.single.rawValue : 0]
                )
                cell.accessoryType = todo.isCompleted ? .checkmark : .none
                return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.toggleCompletion(at: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete  // veya .insert, .none
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel.deleteTodo(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
}
