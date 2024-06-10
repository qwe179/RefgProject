//
//  NicknameViewController.swift
//  What's-in-my-refrigerator
//
//  Created by 23 09 on 2024/01/17.
//

import UIKit

final class NicknameViewController: UIViewController {

    private var fridgeDescription: String?
    private let nickNameView = NickNameView()
    private let coreDataManager =  CoreDataManager.shared

    override func loadView() {
        view = nickNameView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        nickNameView.startButton.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        nickNameView.nickNameTextField.becomeFirstResponder()
    }

    func setFridgeDescription(_ label: String) {
        fridgeDescription = label
    }

    // MARK: - 탭바 컨트롤러 생성해서 설정
    func settingTapBarContoller() -> UITabBarController? {
        // 각각의 뷰 컨트롤러를 생성
        // MARK: 다음 네비게이션컨트롤러의 루트뷰컨트롤러 설정
        let mapViewController = UINavigationController(rootViewController: RefrigratorMapViewController())
        let memoViewController = UINavigationController(rootViewController: MemoViewController())
        let settingViewController = UINavigationController(rootViewController: SettingViewController())
        let tabBarController = UITabBarController()
        mapViewController.title = "냉장고지도"
        memoViewController.title = "메모"
        settingViewController.title = "설정"
        tabBarController.setViewControllers(
            [
                mapViewController,
                memoViewController,
                settingViewController
            ],
            animated: false
        )
        tabBarController.modalPresentationStyle = .fullScreen
        tabBarController.tabBar.backgroundColor = .white
        // 탭 바 아이템 이미지 및 텍스트 속성 설정
        let items = tabBarController.tabBar.items ?? []
        let attributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12.0)
        ]
        tabBarController.tabBar.tintColor = UIColor(hexString: "3CB175") // 탭바 선택했을 때의 색깔
        items[0].image = UIImage(named: "location_on.png")?.resize(targetSize: CGSize(width: 24, height: 24))
        items[1].image = UIImage(systemName: "note.text")?.resize(targetSize: CGSize(width: 24, height: 24))
        items[2].image = UIImage(systemName: "gearshape")?.resize(targetSize: CGSize(width: 24, height: 24))
        items.forEach { $0.setTitleTextAttributes(attributes, for: .normal)}
        return tabBarController
    }
    // MARK: 알람띄우기
    func showAlert() {
        let alertController = UIAlertController(title: "알림", message: "별명을 입력해주세요.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default, handler: { _ in
            print("확인 버튼 눌림")
        })
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }

    // MARK: - 다음 컨트롤러로 이동
    @objc func startButtonTapped () {
        guard let nickName = nickNameView.nickNameTextField.text, nickName != ""  else {
            showAlert()
            return }

        // 닉네임으로 냉장고 생성 후 코어데이터에 저장
        coreDataManager.saveFridgeData(
            refID: UUID().uuidString,
            refName: nickName,
            refType: fridgeDescription!,
            completion: {
                print("닉네임 CoreData 저장 성공")
            }
        )
        present(settingTapBarContoller()!, animated: true, completion: nil)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        nickNameView.nickNameTextField.resignFirstResponder()
    }
}
