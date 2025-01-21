//
//  TaskListViewController.swift
//  ToDoList
//
//  Created by Nurlybaqyt Begaly on 15.01.2025.
//

import UIKit
import SnapKit

class TaskListViewController: UIViewController {
    
    private let viewModel = TaskViewModel()
    
    private lazy var titleText: UILabel = {
        let title = UILabel()
        title.text = "Notes"
        title.font = .systemFont(ofSize: 34, weight: .bold)
        title.textAlignment = .left
        
        return title
    }()
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.searchBarStyle = .prominent
        searchBar.placeholder = "Search..."
        searchBar.isTranslucent = true
        searchBar.backgroundImage = UIImage()
        searchBar.searchTextField.backgroundColor = .gray
        searchBar.searchTextField.textColor = .white
        searchBar.delegate = self
        
        
        return searchBar
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(TableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 90
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = .lightGray
        
        return tableView
    }()
    
    private let  bottomPanel: UIView = {
        let view = UIView()
        view.backgroundColor = .darkGray
        
        return view
    }()
    
    private lazy var taskCountLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .medium)
        label.textColor = .white
        label.text = "0 tasks"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var addButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "square.and.pencil"), for: .normal)
        button.tintColor = .yellow
        button.addTarget(self, action: #selector(addTask), for: .touchUpInside)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        bindViewModel()
        viewModel.fetchTasks()
    }
    
    func bindViewModel() {
        viewModel.onTaskUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.taskCountLabel.text = "\(self?.viewModel.tasks.count ?? 0) tasks"
                self?.tableView.reloadData()
            }
            
        }
    }
    
    func setupUI() {
        view.addSubview(titleText)
        view.addSubview(searchBar)
        view.addSubview(tableView)
        view.addSubview(bottomPanel)
        view.addSubview(taskCountLabel)
        view.addSubview(addButton)
    }
    
    func setupConstraints() {
        titleText.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(80)
            make.left.equalToSuperview().offset(22)
        }
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(titleText.snp.bottom).offset(10)
            make.left.right.equalToSuperview().offset(15).inset(15)
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(15)
            make.leading.trailing.bottom.equalToSuperview()
        }
        bottomPanel.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(100)
        }
        taskCountLabel.snp.makeConstraints { make in
            make.centerX.equalTo(bottomPanel.snp.centerX)
            make.centerY.equalTo(bottomPanel.snp.centerY).offset(-10)
        }
        addButton.snp.makeConstraints { make in
            make.left.equalTo(taskCountLabel.snp.right).offset(100)
            make.centerY.equalTo(bottomPanel.snp.centerY).offset(-10)
            make.height.width.equalTo(40)
            
        }
    }
    
    @objc private func addTask() {
        let alert = UIAlertController(title: "New Task", message: nil, preferredStyle: .alert)
        alert.addTextField { $0.placeholder = "Title" }
        alert.addTextField { $0.placeholder = "Details" }
        let addAction = UIAlertAction(title: "Add", style: .default) { _ in
            let title = alert.textFields?[0].text ?? ""
            let details = alert.textFields?[1].text ?? ""
            self.viewModel.addTask(title: title, details: details)
        }
        alert.addAction(addAction)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
    
}
extension TaskListViewController: UITableViewDataSource,UITableViewDelegate, UISearchBarDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.filteredTasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? TableViewCell else { return UITableViewCell() }
        let task = viewModel.filteredTasks[indexPath.row]
        cell.configure(with: task, currentDate: viewModel.getFormattedDate(for: task))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.filterTask(by: searchText)
        bindViewModel()
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.tableView.beginUpdates()
            self.viewModel.deleteTask(at: indexPath.row)
            self.viewModel.tasks.remove(at: indexPath.row)
            self.viewModel.filteredTasks.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
            self.tableView.endUpdates()
            self.tableView.reloadData()
        }
        bindViewModel()
    }
}
