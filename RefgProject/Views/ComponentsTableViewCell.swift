//
//  ComponentsTableViewCell.swift
//  RefgProject
//
//  Created by 23 09 on 2024/02/02.
//

import UIKit

class ComponentsTableViewCell: UITableViewCell {
    
    
    var componentsData: ComponentData? {
        didSet {
            configureUIwithData()
        }
    }
    
    let freezingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.getCustomColor()
        label.text = "냉동"
        label.font = UIFont(name: "NotoSansKR-Thin_Regular", size: 12)
        label.backgroundColor = UIColor(hexString: "E5FDF0")
        
        label.clipsToBounds = true //해줘야 코너라디우스 변경됨
        label.layer.cornerRadius = 5
        label.textAlignment = .center
        return label
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont(name: "NotoSansKR-Thin_Medium", size: 14)
        label.text = "이름입니다."
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()
    
    let memoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont(name: "NotoSansKR-Thin_Regular", size: 14)
        label.text = "메모입니다"
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    let registerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(hexString: "999999")
        label.font = UIFont(name: "NotoSansKR-Thin_Regular", size: 12)
        label.text = "등록일자 "
        return label
    }()
    let expireLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(hexString: "999999")
        label.font = UIFont(name: "NotoSansKR-Thin_Regular", size: 12)
        label.text = "  소비기한  "
        return label
    }()
    
    let registerDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(hexString: "999999")
        label.font = UIFont(name: "NotoSansKR-Thin_Regular", size: 12)
        label.text = "등록일입니다"
        return label
    }()
    let expireDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(hexString: "999999")
        label.font = UIFont(name: "NotoSansKR-Thin_Regular", size: 12)
        label.text = "만료일입니다"
        return label
    }()
    
    lazy var cellStackView: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .vertical
        sv.alignment = .leading
        sv.spacing = 4
        sv.distribution = .fill
        sv.addArrangedSubview(nameStackView)
        sv.addArrangedSubview(memoLabel)
        sv.addArrangedSubview(dateStackView)
        return sv
    }()
    
    lazy var nameStackView: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .horizontal
        sv.alignment = .center
        sv.distribution = .fill
        sv.addArrangedSubview(freezingLabel)
        sv.addArrangedSubview(nameLabel)
        sv.spacing = 4
        return sv
    }()
    lazy var dateStackView: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .horizontal
        sv.alignment = .center
        sv.distribution = .fill
        sv.addArrangedSubview(registerLabel)
        sv.addArrangedSubview(registerDateLabel)
        sv.addArrangedSubview(expireLabel)
        sv.addArrangedSubview(expireDateLabel)
        return sv
    }()
    
    
    func setupStackView() {
        
        // self.addSubview보다 self.contentView.addSubview로 잡는게 더 정확함 ⭐️
        // (cell은 기본뷰로 contentView를 가지고 있기 때문)
        self.contentView.addSubview(cellStackView)
        //self.addSubview(mainImageView)
        
        // self.contentView.addSubview로 잡는게 더 정확함 ⭐️
        //self.addSubview(stackView)
    
    }
    
    
    // 데이터를 가지고 적절한 UI 표시하기
    func configureUIwithData() {
        if componentsData?.isFreezer == "Y" {
            freezingLabel.text = "냉동"
        } else {
            freezingLabel.text = "냉장"
        }
  
        nameLabel.text = componentsData?.name
        memoLabel.text = componentsData?.memo
        if memoLabel.text == "" {
            memoLabel.isHidden = true
        } else {
            memoLabel.isHidden = false
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"
        if let registerday = componentsData?.registerDay {         registerDateLabel.text = dateFormatter.string(from:registerday )}
        if let dueDay = componentsData?.dueDay{          expireDateLabel.text = dateFormatter.string(from:dueDay )}
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        setupStackView()
        
        // 셀 오토레이아웃 일반적으로 생성자에서 잡으면 됨 ⭐️⭐️⭐️
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            freezingLabel.widthAnchor.constraint(equalToConstant: 26),
            nameLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            memoLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            
            
            cellStackView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 0),
            cellStackView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: 0),
            cellStackView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 4),
            cellStackView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -10)
        ])
        
    }

}
