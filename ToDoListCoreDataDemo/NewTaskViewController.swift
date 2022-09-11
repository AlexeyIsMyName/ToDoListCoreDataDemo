//
//  NewTaskViewController.swift
//  ToDoListCoreDataDemo
//
//  Created by ALEKSEY SUSLOV on 10.09.2022.
//

import UIKit

class NewTaskViewController: UIViewController {
    
    private lazy var taskTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "New Task"
        textField.borderStyle = .roundedRect
        return textField
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupSubviews()
        setConstraints()
    }
    
    private func setupSubviews() {
        view.addSubview(taskTextField)
    }
    
    private func setConstraints() {
        taskTextField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            taskTextField.topAnchor.constraint(equalTo: view.topAnchor,
                                               constant: 80),
            taskTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                                   constant: 40),
            taskTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                                    constant: -40)
        ])
    }
}
