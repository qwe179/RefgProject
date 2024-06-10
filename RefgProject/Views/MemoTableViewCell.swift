//
//  MemoTableViewCell.swift
//  RefgProject
//
//  Created by 23 09 on 2024/02/07.
//

import UIKit

class MemoTableViewCell: UITableViewCell {

    var memoData: MemoData? {
        didSet {
            settingMemoData()
        }
    }

    let memoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont(name: "NotoSansKR-Thin_Regular", size: 16)
        label.text = "test"
        return label
    }()

    let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont(name: "NotoSansKR-Thin_Regular", size: 16)
        label.text = "test"
        label.textAlignment = .right
        return label
    }()

    lazy var cellStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .leading
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        stackView.addArrangedSubview(memoLabel)
        stackView.addArrangedSubview(dateLabel)
        return stackView
    }()

    func settingMemoData() {
        memoLabel.text = memoData?.memo
        if let date = memoData?.date {
            dateLabel.text = DateHelper().dateToStringFormat(date: date)
        }
    }

    func setConstraints() {
        self.contentView.addSubview(cellStackView)
        NSLayoutConstraint.activate([
            cellStackView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 30),
            cellStackView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -30),
            cellStackView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10),
            cellStackView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -10)
        ])

    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        setConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
