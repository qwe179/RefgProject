//
//  refrigratorAdsOffViewController.swift
//  What's-in-my-refrigerator
//
//  Created by 23 09 on 2024/01/17.
//

import UIKit
import DropDown
import GoogleMobileAds

final class RefrigratorMapViewController: UIViewController, UISheetPresentationControllerDelegate {

    private var tmpIngredientButton: UIButton?
    private var tmpIngredientButtonColor: UIColor?
    private let refrigratorView = RefrigratorView()
    private let componentDetailView = ComponentDetailView()
    private let coreDataManager = CoreDataManager.shared
    private var fridgesData: [RefrigeratorData] = []
    private var currentFridgeData: RefrigeratorData?
    private var shouldRemoveComponentsList: [ComponentData] = []
    private var sortType: String?

    // MARK: - 라이프사이클
    func setFridgeData() {
        fridgesData = coreDataManager.getFridgeDataFromCoreData()
        currentFridgeData = fridgesData[0]
    }

    func setTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        tapGesture.cancelsTouchesInView = false
        tapGesture.delegate = self
        view.addGestureRecognizer(tapGesture)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view = refrigratorView
        setFridgeData()
        makeNavi()
        setTargets()
        setupTableView()
        setTapGesture()
        setupBannerView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        for cell in refrigratorView.tableView.visibleCells {
            cell.contentView.backgroundColor = .clear
        }
        setDropDownData()
        if let refType = currentFridgeData?.refType {
            refrigratorView.fridgeName = refType
        }
        clearIngredientButtons()
        refrigratorView.ingredientButtons.forEach { view in
             view.removeFromSuperview()
         }
        refrigratorView.ingredientButtons = []
        // 데이터 다시 가져오기
        isListSwitchOn(refrigratorView.switchList.isOn)
        refrigratorView.tableView.reloadData()
        reloadViewLayout(view)
    }

    func isListSwitchOn(_ isOn: Bool) {
        if isOn {
            refrigratorView.removeSubviews()
            refrigratorView.setupListUI()
        } else {
            setComponentOfFridge()
        }
    }

    func clearIngredientButtons() {
        refrigratorView.ingredientButtons.forEach { $0.removeFromSuperview() }
        refrigratorView.ingredientButtons.removeAll()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        hidesBottomBarWhenPushed = false
    }

    // MARK: - 네비게이션
    func makeNavi() {
        let appearance = UINavigationBarAppearance()
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: refrigratorView.dropDownButton)
        if IsPremium.isPremium {
            navigationItem.rightBarButtonItems = [
                UIBarButtonItem(customView: refrigratorView.listButton),
                UIBarButtonItem(customView: refrigratorView.plusButton)
            ]
        } else {
            navigationItem.rightBarButtonItem = UIBarButtonItem(customView: refrigratorView.listButton)
        }
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        appearance.shadowColor = .white
        appearance.titleTextAttributes = [.font: UIFont.systemFont(ofSize: 5)]
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        backBarButtonItem.tintColor = .black
        self.navigationItem.backBarButtonItem = backBarButtonItem
    }

    // MARK: - 냉장고 닉네임
    func setDropDownData() {
        let fridgeNickNames = fridgesData.map { $0.refName! }
        refrigratorView.dropDown.dataSource = fridgeNickNames
        refrigratorView.dropDownButton.setTitle(currentFridgeData?.refName, for: .normal)
        refrigratorView.dropDown.selectionAction = { [weak self] (index: Int, item: String) in
            guard let self = self else { return }
            refrigratorView.dropDownButton.setTitle(item, for: .normal)
            self.updateFridgeData(at: index)
        }
    }

    func updateFridgeData(at index: Int) {
        self.currentFridgeData = self.fridgesData[index]
        self.clearIngredientButtons()
        if let fridgeType = currentFridgeData?.refType {
            refrigratorView.fridgeName = fridgeType
        }
        isListSwitchOn(refrigratorView.switchList.isOn)
        shouldRemoveComponentsList = []
        self.refrigratorView.tableView.reloadData()
        self.reloadViewLayout(view)
    }

    func setComponentOfFridge() {
        let components = coreDataManager.getComponentsFromCoreData(currentFridgeData?.refID, nil)
        components.enumerated().forEach { (index, componentData) in
            let gesture = UIPanGestureRecognizer(target: self, action: #selector(draggingView))
            let button = refrigratorView.createComponentButton(gesture, componentData, index)
            button.addTarget(self, action: #selector(componentButtonTapped), for: .touchUpInside)
            refrigratorView.setComponentButtonLayout(button: button, componentData: componentData)
        }
    }

    func setTargets() {
        refrigratorView.dropDownButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        refrigratorView.switchList.addTarget(self, action: #selector(switchListTapped(_: )), for: .valueChanged)
        refrigratorView.plusButton.addTarget(self, action: #selector(plusButtonTapped), for: .touchUpInside)
        refrigratorView.listButton.addTarget(self, action: #selector(listButtonTapped), for: .touchUpInside)
        refrigratorView.addListButton.addTarget(self, action: #selector(addListButtonTapped), for: .touchUpInside)
        refrigratorView.addListButton.addTarget(self, action: #selector(addListButtonTapped), for: .touchUpInside)
        refrigratorView.sortDeleteButton.addTarget(self, action: #selector(sortDeleteButtonTapped), for: .touchUpInside)
        refrigratorView.sortButton.addTarget(self, action: #selector(sortButtonTapped), for: .touchUpInside)
        componentDetailView.deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
    }

    func setupTableView() {
        refrigratorView.tableView.dataSource = self
        refrigratorView.tableView.delegate = self
        refrigratorView.tableView.register(ComponentsTableViewCell.self, forCellReuseIdentifier: "ComponentCell")
    }
    // 재료 태그 드래그 할 시 이벤트
    @objc func draggingView(_ sender: UIPanGestureRecognizer) {
        let point = sender.location(in: view)
        var finalPoint = point
        let draggedView = sender.view!
        let safeAreaHeight = self.view.safeAreaLayoutGuide.layoutFrame.origin
        // 제스쳐 상태 처리 코드
        switch sender.state {
        case .began:
            componentDetailView.isHidden = true
        case .changed:
            if point.y > safeAreaHeight.y + 50 {
                draggedView.center = point
            }
        case .ended:
            if point.y > safeAreaHeight.y + 50 {
                draggedView.center = point
            } else {
                finalPoint.y = safeAreaHeight.y + 49
            }
            let components = coreDataManager.getComponentsFromCoreData(currentFridgeData?.refID, nil)
            components[draggedView.tag].coordinates = finalPoint.toString()
            guard let refID = currentFridgeData?.refID else { return }
            guard let id = components[draggedView.tag].id else { return }
            guard let coordinates = components[draggedView.tag].coordinates else { return }
            self.coreDataManager.updateCoordinatesOfComponents(
                refID: refID,
                id: id,
                coordinates: coordinates,
                completion: {}
            )
            refrigratorView.ingredientButtons.forEach { view in
                view.removeFromSuperview()
            }
            refrigratorView.ingredientButtons = []
            setComponentOfFridge()
        default:
            break
        }
    }

    @objc func buttonTapped() {
        refrigratorView.dropDown.show()
    }

    @objc func switchListTapped(_ sender: UISwitch) {
        refrigratorView.ingredientButtons.forEach { view in
            view.removeFromSuperview()
        }
        refrigratorView.ingredientButtons = []
   //     isListSwitchOn(sender.isOn)
        if sender.isOn {
            refrigratorView.removeSubviews()
            refrigratorView.setupListUI()
            refrigratorView.tableView.reloadData()
        } else {
            refrigratorView.removeSubviews()
            refrigratorView.setupUI()
            setComponentOfFridge() // 스위치 꺼지면 재료뷰 셋팅해야함
        }
        reloadViewLayout(view)
    }
    // MARK: - 냉장고 추가 버튼

    @objc func plusButtonTapped(_ sender: UISwitch) {
        let nextVC = RefrigeratorAddViewController()
        nextVC.delegate = self
        hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(nextVC, animated: true)
    }
    // MARK: - 냉장고 편집 버튼

    @objc func listButtonTapped(_ sender: UISwitch) {
        let nextVC = RefrigeratorEditViewController()
        nextVC.delegate = self
        nextVC.currentFridgeData = self.currentFridgeData // 현재 냉장고 데이터 전달
        nextVC.refrigeratorEditView.nickNameTextField.text = self.currentFridgeData?.refName
        hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(nextVC, animated: true)
    }
    // MARK: - 재료 추가 버튼

    @objc func addListButtonTapped() {
        let nextVC = AddComponentsViewController()
        nextVC.delegate = self

        nextVC.currentFridgeData = self.currentFridgeData

        hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(nextVC, animated: true)
    }

    // MARK: - 재료 클릭 이벤트
    @objc func componentButtonTapped(_ sender: UIButton) {
        componentDetailView.removeFromSuperview()
        self.view.addSubview(componentDetailView)
        tmpIngredientButton = sender
        tmpIngredientButtonColor = sender.backgroundColor
        sender.backgroundColor = UIColor.getCustomColor() // 재료 버튼 색깔 초록색으로 표시
        let data = coreDataManager.getComponentsFromCoreData(currentFridgeData?.refID, nil)
        componentDetailView.registerDateLabel.text = DateHelper().dateToStringFormat(date: data[sender.tag].registerDay)
        componentDetailView.expireDateLabel.text = DateHelper().dateToStringFormat(date: data[sender.tag].dueDay)
        componentDetailView.memoContentLabel.text = data[sender.tag].memo
        componentDetailView.deleteButton.tag = sender.tag
        componentDetailView.topAnchor.constraint(equalTo: sender.bottomAnchor, constant: -7).isActive = true
        componentDetailView.widthAnchor.constraint(equalToConstant: 160).isActive = true
        componentDetailView.leadingAnchor.constraint(equalTo: sender.leadingAnchor).isActive = true
        componentDetailView.bottomAnchor.constraint(
            equalTo: componentDetailView.deleteButtonStackView.bottomAnchor,
            constant: 10
        ).isActive = true
        componentDetailView.isHidden = false
        reloadViewLayout(componentDetailView)
    }

    func reloadViewLayout(_ view: UIView) {
        view.setNeedsLayout()
        view.setNeedsDisplay()
    }

    // MARK: - 터치이벤트

    @objc func handleTap(_ gesture: UITapGestureRecognizer) {
        // 재료 디테일 뷰 숨기기
        componentDetailView.isHidden = true
        // 재료 버튼 색깔 다시 복구
        guard let ingredientbutton = tmpIngredientButton else { return }
        ingredientbutton.backgroundColor = tmpIngredientButtonColor
    }

    @objc func deleteButtonTapped(_ sender: UIButton) {
        let data = coreDataManager.getComponentsFromCoreData(currentFridgeData?.refID, nil)
        coreDataManager.deleteComponentsByID(id: data[sender.tag].id!, completion: { })
        componentDetailView.isHidden = true
        clearIngredientButtons()
        setComponentOfFridge()
        reloadViewLayout(view)
    }

    @objc func sortDeleteButtonTapped(_ sender: UIButton) {
        for component in shouldRemoveComponentsList {
            if let id = component.id {
                coreDataManager.deleteComponentsByID(id: id, completion: { })
            }
            // 삭제할 재료들 초기화(테이블뷰)
            shouldRemoveComponentsList = []
            for cell in  refrigratorView.tableView.visibleCells {
                cell.contentView.backgroundColor = .clear
            }
        }
        refrigratorView.tableView.reloadData()
    }

    @objc func sortButtonTapped(_ sender: UIButton) {
        let nextVC = SortingPopUpViewController()
        nextVC.modalPresentationStyle = .pageSheet
        if let sheetPresentationController = nextVC.sheetPresentationController {
            // MARK: - 모달 팝업 크기 조절 관련 코드.. 변수 등 메모해놓으면 도움 될 것 같다
            let multiplier = 0.3
            let fraction = UISheetPresentationController.Detent.custom { _ in
                nextVC.view.frame.height * multiplier
            }
            sheetPresentationController.detents = [fraction]
            sheetPresentationController.delegate = self
        }
        nextVC.sortingType = self.sortType
        nextVC.delegate = self
        present(nextVC, animated: true, completion: nil)
    }
}

// MARK: - 델리게이트

extension RefrigratorMapViewController: ComponentDelegate, UIGestureRecognizerDelegate {
    func addNewComponent(_ component: Component) {
        coreDataManager.addComponentsOnFridge(
            refID: component.refID,
            id: component.id,
            name: component.name,
            registerDay: component.registerDay,
            dueDay: component.dueDay,
            isFreezer: component.isFreezer,
            memo: component.memo,
            tagColor: component.tagColor,
            coordinates: component.coordinates,
            completion: {
                print("재료 추가 성공")
            }
        )
    }
    func deleteComponent(index: Int, _ component: Component) {
        print("do something")
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return !self.componentDetailView.bounds.contains(touch.location(in: self.componentDetailView))
    }
}

extension RefrigratorMapViewController: FridgeDelegate {
    func setCurruntFridge(_ fridgeData: RefrigeratorData) {
        self.currentFridgeData = fridgeData
    }
}
// MARK: - 테이블뷰 델리게이트

extension RefrigratorMapViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coreDataManager.getComponentsFromCoreData(currentFridgeData?.refID, nil).count

    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "ComponentCell",
            for: indexPath
        ) as? ComponentsTableViewCell else {
            fatalError("셀을 ComponentsTableViewCell로 캐스팅할 수 없습니다.")
        }
        if self.sortType != nil {
            if self.sortType == "dueDay" {
                let componentsData = coreDataManager.getComponentsFromCoreData(currentFridgeData?.refID, "dueDay")
                cell.componentsData = componentsData[indexPath.row]
            } else {
                let componentsData = coreDataManager.getComponentsFromCoreData(currentFridgeData?.refID, "name")
                cell.componentsData = componentsData[indexPath.row]
            }

        } else {
            let componentsData = coreDataManager.getComponentsFromCoreData(currentFridgeData?.refID, nil)
            cell.componentsData = componentsData[indexPath.row]
        }
        cell.selectionStyle = .none
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? ComponentsTableViewCell {
            if cell.contentView.backgroundColor == UIColor(hexString: "E5FDF0") {
                cell.contentView.backgroundColor = .white
                // 재료 삭제 취소
                shouldRemoveComponentsList.removeAll { $0 == cell.componentsData! }
            } else {
                cell.contentView.backgroundColor = UIColor(hexString: "E5FDF0")
                // 삭제할 재료 추가
                shouldRemoveComponentsList.append(cell.componentsData!)
            }
        }
    }
}

extension RefrigratorMapViewController: ModalPopUpDelegate {

    func setupSortingType(sortType: String?) {
        self.sortType = sortType
        // 정렬 버튼 이름 설정
        if let sortType = sortType {
            if sortType == "dueDay" {
                self.refrigratorView.sortButton.setTitle("소비기한 적게 남은 순", for: .normal)
            } else {
                self.refrigratorView.sortButton.setTitle("식재료 이름(ㄱ-ㅎ)", for: .normal)
            }
        } else {
            self.refrigratorView.sortButton.setTitle("최근 등록 순", for: .normal)
        }
    }

    func reloadTableView() {
        refrigratorView.tableView.reloadData()
        self.view.setNeedsLayout()
        self.view.setNeedsDisplay()
    }
}

extension RefrigratorMapViewController: GADBannerViewDelegate {

    private func setupBannerView() {
        refrigratorView.bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        refrigratorView.bannerView.rootViewController = self
        refrigratorView.bannerView.load(GADRequest())
        refrigratorView.bannerView.delegate = self
    }
}
