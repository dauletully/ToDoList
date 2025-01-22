//
//  TaskEditViewController.swift
//  ToDoList
//
//  Created by Nurlybaqyt Begaly on 22.01.2025.
//

import UIKit
import SnapKit

class TaskEditViewController: UIViewController {
    var task: Task?
    var onTaslUpdate: ((Task) -> Void)?
    
    private lazy var titleTextView: UITextField = {
        let textField = UITextField()
        textField.font = .systemFont(ofSize: 34, weight: .bold)
        textField.textColor = .white
        
        return textField
    }()
    
    private lazy var detailsTextView: UITextView = {
        let textView = UITextView()
        textView.textColor = .white
        textView.font = .systemFont(ofSize: 17)
        textView.isScrollEnabled = false
        
        return textView
    }()
    
     override func viewDidLoad() {
        super.viewDidLoad()
         setupUI()
         setupConstraints()
         loadTaskData()
    }
    private func setupUI() {
        view.addSubview(titleTextView)
        view.addSubview(detailsTextView)
    }
    
    private func setupConstraints() {
        titleTextView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(100)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().inset(20)
            make.width.equalTo(320)
        }
        
        detailsTextView.snp.makeConstraints { make in
            make.top.equalTo(titleTextView.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().inset(20)
            make.width.equalTo(320)
        }
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveChanges))
    }
    
    private func loadTaskData() {
        guard let task = task else { return }
        self.titleTextView.text = task.title
        self.detailsTextView.text = task.details
    }
    
    @objc func saveChanges() {
        guard let task = task else { return }
        task.title = titleTextView.text
        task.details = detailsTextView.text
        
        onTaslUpdate?(task)
        navigationController?.popViewController(animated: true)
    }
    
}
