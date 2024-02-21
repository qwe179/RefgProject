//
//  SettingViewTableViewCell.swift
//  RefgProject
//
//  Created by 23 09 on 2024/02/08.
//

import UIKit

class SettingTableViewCell: UITableViewCell {
    
//    let button: UIButton = {
//        let btn = UIButton()
//        btn.translatesAutoresizingMaskIntoConstraints = false
//        btn.setTitleColor(.black, for: .normal)
//        btn.setTitle("hh", for: .normal)
//        btn.titleLabel?.font = UIFont(name: "NotoSansKR-Thin_Regular", size: 14)
//        return btn
//    }()
    
    var settings: Settings? {
        willSet {
            label.text = newValue?.settingName
        }
    }
    
    let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.text = ""
        label.font = UIFont(name: "NotoSansKR-Thin_Regular", size: 16)
        return label
    }()
    
    lazy var  stackView: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .vertical
        sv.alignment = .fill
        sv.distribution = .fill
        sv.addArrangedSubview(label)
        return sv
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setConstraints() {
        self.contentView.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -20),
            stackView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10),
            stackView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -10)
        ])
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
