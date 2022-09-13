//
//  ToDoListViewController.swift
//  ToDoListCoreDataDemo
//
//  Created by ALEKSEY SUSLOV on 10.09.2022.
//

import UIKit

class ToDoListViewController: UITableViewController {
    
    private let cellID = "Cell"
    private var taskList: [Task] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        setupNavigationBar()
        taskList = StorageManager.shared.fetchData()
    }
    
    private func setupNavigationBar() {
        title = "ToDoList"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // UINavigationBarAppearance
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        
        navBarAppearance.titleTextAttributes = [
            .foregroundColor: UIColor.white
        ]
        
        navBarAppearance.largeTitleTextAttributes = [
            .foregroundColor: UIColor.white
        ]
        
        navBarAppearance.backgroundColor = UIColor(
            red: 21/255,
            green: 101/255,
            blue: 192/255,
            alpha: 194/255
        )
        
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        
        // Add Button to navigation bar
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addNewTask)
        )
        
        navigationController?.navigationBar.tintColor = .white
    }
    
    @objc private func addNewTask() {
        showAlert(with: "New Task", and: "What do you want to do?")
    }
    
    private func showAlert(with title: String, and message: String, edit taskName: String? = nil, at index: Int? = nil) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save",
                                       style: .default) { _ in
            guard let task = alert.textFields?.first?.text, !task.isEmpty else {
                return
            }
            
            if let _ = taskName, let index = index {
                self.edit(task, at: index)
            } else {
                self.save(task)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .destructive)
        
        alert.addTextField { textField in
            if taskName != nil {
                textField.text = taskName
            } else {
                textField.placeholder = "Write new task"
            }
        }
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    private func save(_ taskName: String) {
        print("SAVE")
        if let task = StorageManager.shared.save(taskName) {
            taskList.append(task)
            
            let cellIndex = IndexPath(row: taskList.count - 1, section: 0)
            tableView.insertRows(at: [cellIndex], with: .automatic)
        }
    }
    
    private func edit(_ taskName: String, at index: Int) {
        print("EDIT")
        taskList[index].name = taskName
        if StorageManager.shared.saveContext() {
            let cellIndex = IndexPath(row: index, section: 0)
            tableView.reloadRows(at: [cellIndex], with: .automatic)
        }
    }
    
}

// MARK: - Table view data source
extension ToDoListViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        taskList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        var content = cell.defaultContentConfiguration()
        let task = taskList[indexPath.row]
        content.text = task.name
        cell.contentConfiguration = content
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if StorageManager.shared.delete(task: taskList.remove(at: indexPath.row)) {
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        }
    }
}

// MARK: - Table view delegate
extension ToDoListViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let taskName = taskList[indexPath.row].name
        showAlert(with: "Edit Task", and: "What do you want to edit?", edit: taskName, at: indexPath.row)
    }
}
