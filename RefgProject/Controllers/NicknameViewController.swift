//
//  NicknameViewController.swift
//  What's-in-my-refrigerator
//
//  Created by 23 09 on 2024/01/17.
//

import UIKit

class NicknameViewController: UIViewController {
    
    var fridgeDescription: String?
    
    private let nickNameView = NickNameView()
//    private let refrigeratorManager = RefrigeratorManager.shared
    private let coreDataManager =  CoreDataManager.shared
    
    
    override func loadView() {
        view = nickNameView
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        nickNameView.startButton.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        // 특정 텍스트 필드에 포커스를 주어 키보드가 자동으로 올라오게 함
//        nickNameView.nickNameOfRef.becomeFirstResponder()

    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)


    }
    // MARK: - 뷰가 나타난뒤 키보드 올려야 안버벅거림

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        nickNameView.nickNameTextField.becomeFirstResponder()
    }
    
    // MARK: - 탭바 컨트롤러 생성해서 설정

    func settingTapBarContoller() -> UITabBarController? {
        // 각각의 뷰 컨트롤러를 생성
        // MARK: -다음 네비게이션컨트롤러의 루트뷰컨트롤러 설정
        let mapViewController = UINavigationController(rootViewController: RefrigratorMapViewController())
        //let memoViewController = MemoViewController()
        let memoViewController = UINavigationController(rootViewController: MemoViewController())        //메모뷰 컨트롤러도 네비게이션추가
        let settingViewController = UINavigationController(rootViewController: SettingViewController())        //설정뷰 컨트롤러도 네비게이션추가
        

       // let settingViewController = SettingViewController()
        
        // 각 뷰 컨트롤러에 타이틀 설정
        mapViewController.title = "냉장고지도"
        memoViewController.title = "메모"
        settingViewController.title = "설정"
        
        // 탭 바 컨트롤러 생성
        let tabBarController = UITabBarController()
        tabBarController.setViewControllers([mapViewController, memoViewController, settingViewController], animated: false)
        tabBarController.modalPresentationStyle = .fullScreen
        tabBarController.tabBar.backgroundColor = .white
        
        // 탭 바 아이템 이미지 및 텍스트 속성 설정
        let items = tabBarController.tabBar.items ?? []
        let attributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12.0)
        ]
        
        tabBarController.tabBar.tintColor = UIColor(hexString: "3CB175") //탭바 선택했을 때의 색깔
        
        for (index, item) in items.enumerated() {
            switch index {
            case 0:
                item.image = UIImage(named: "location_on.png")?.resize(targetSize: CGSize(width: 24, height: 24))
            case 1:
                item.image = UIImage(systemName: "note.text")?.resize(targetSize: CGSize(width: 24, height: 24))
            case 2:
                item.image = UIImage(systemName: "gearshape")?.resize(targetSize: CGSize(width: 24, height: 24))
             //   item.imageInsets = UIEdgeInsets(top: 3, left: 0, bottom: 0, right: 30)
            default:
                break
            }
            item.setTitleTextAttributes(attributes, for: .normal)
        }
        

        return tabBarController
    }
    // MARK: - 알람띄우기

    func showAlert() {
        // UIAlertController 생성
        let alertController = UIAlertController(title: "알림", message: "별명을 입력해주세요.", preferredStyle: .alert)
        
        // 알림에 추가할 액션 정의 (버튼)
        let okAction = UIAlertAction(title: "확인", style: .default, handler: { action in
            // "확인" 버튼이 눌렸을 때 수행할 동작
            print("확인 버튼 눌림")
        })
        
        // 액션을 알림에 추가
        alertController.addAction(okAction)
        
        // 알림을 화면에 표시
        present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - 다음 컨트롤러로 이동


    @objc func startButtonTapped () {
        guard let nickName = nickNameView.nickNameTextField.text, nickName != ""  else{
            showAlert()
            return }
        
        //닉네임으로 냉장고 생성 후 코어데이터에 저장
//        coreDataManager.deleteAllData {
//            print("전체데이터 삭제 성공")
//        }
        coreDataManager.saveFridgeData(refID: UUID().uuidString, refName: nickName, refType: fridgeDescription!, completion: {
            print("닉네임 CoreData 저장 성공")
        })
  
        print("Nickname: \(nickName)")
        
        present(settingTapBarContoller()!, animated: true, completion: nil)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // MARK: - 퍼스트리스폰더리자인 안먹힐때
        nickNameView.nickNameTextField.resignFirstResponder()
        //self.view.endEditing(true)
    }
}


