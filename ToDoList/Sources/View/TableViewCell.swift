//
//  TableViewCell.swift
//  ToDoList
//
//  Created by Nurlybaqyt Begaly on 15.01.2025.
//

import UIKit
import SnapKit

class TableViewCell: UITableViewCell {
    
    private lazy var statusIcon: UIImageView = {
        let icon = UIImageView()
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.contentMode = .scaleAspectFill

        return icon
    }()
    
    private lazy var title: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textAlignment = .left
        label.textColor = .white
        
        return label
    }()
    
    private lazy var detailsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textAlignment = .left
        label.textColor = .white
        
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = .systemFont(ofSize: 12, weight: .regular)
        
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(statusIcon)
        contentView.addSubview(title)
        contentView.addSubview(detailsLabel)
        contentView.addSubview(dateLabel)
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupConstraints() {
        statusIcon.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(18)
            make.width.equalTo(24)
            make.height.equalTo(24)
        }
        title.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(18)
            make.left.equalTo(statusIcon.snp.right).offset(8)
            make.right.equalToSuperview().inset(28)
        }
        detailsLabel.snp.makeConstraints { make in
            make.top.equalTo(title.snp.bottom).offset(10)
            make.left.equalTo(statusIcon.snp.right).offset(8)
            make.right.equalToSuperview().inset(28)
        }
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(detailsLabel.snp.bottom).offset(6)
            make.left.equalTo(statusIcon.snp.right).offset(8)
            make.right.equalToSuperview().inset(28)
        }
    }
    
    public func configure(with task: Task, currentDate: String) {
        let image = task.isCompleted ? "check.circle.fill" : "circle"
        statusIcon.image = UIImage(systemName: image)
        statusIcon.tintColor = task.isCompleted ? .yellow : .gray
        title.text = task.title
        detailsLabel.text = task.details
        dateLabel.text = currentDate
    }
}


