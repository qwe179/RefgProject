//
//  CoreDataManager.swift
//  RefgProject
//
//  Created by 23 09 on 2024/01/26.
//

import UIKit
import CoreData

// MARK: - (코어데이터 관리)
final class CoreDataManager {

    // 싱글톤으로 만들기
    static let shared = CoreDataManager()
    private init() {}

    // 앱 델리게이트
    let appDelegate = UIApplication.shared.delegate as? AppDelegate

    // 임시저장소
    lazy var context = appDelegate?.persistentContainer.viewContext

    // 엔터티 이름 (코어데이터에 저장된 객체)
   // let modelName: String = "RefrigeratorData"

    enum ModelName: String {
        case RefrigeratorData
        case ComponentData
    }
    // MARK: - [Read] 코어데이터에 저장된 데이터 모두 읽어오기
    func getFridgeDataFromCoreData() -> [RefrigeratorData] {
        var fridgeList: [RefrigeratorData] = []
        // 임시저장소 있는지 확인
        if let context = context {
            // 요청서
            let request = NSFetchRequest<NSManagedObject>(entityName: ModelName.RefrigeratorData.rawValue)
            // 정렬순서를 정해서 요청서에 넘겨주기
            let dateOrder = NSSortDescriptor(key: "date", ascending: true)
            request.sortDescriptors = [dateOrder]

            do {
                // 임시저장소에서 (요청서를 통해서) 데이터 가져오기 (fetch메서드)
                if let fetchedToDoList = try context.fetch(request) as? [RefrigeratorData] {
                    fridgeList = fetchedToDoList
                }
            } catch {
                print("가져오는 것 실패")
            }
        }

        return fridgeList
    }

    // MARK: - 냉장고 재료 정보 가져오기
    /// 재료를 가져오는 함수
    /// - Parameters:
    ///   - fridgeID: id
    ///   - sortType: dueDay, name, nil
    /// - Returns: components
    func getComponentsFromCoreData(_ fridgeID: String?, _ sortType: String?) -> [ComponentData] {
        var toDoList: [ComponentData] = []
        // 임시저장소 있는지 확인
        if let context = context {
            // 요청서
            let request = NSFetchRequest<NSManagedObject>(entityName: ModelName.ComponentData.rawValue)
            if let refID = fridgeID {
                request.predicate = NSPredicate(format: "refID = %@", refID as CVarArg)
            }

            // 정렬순서를 정해서 요청서에 넘겨주기
            if let sortType = sortType {
                if sortType == "dueDay" {
                    let dateOrder = NSSortDescriptor(key: "dueDay", ascending: true)
                    request.sortDescriptors = [dateOrder]
                } else if sortType == "name" {
                    let nameorder = NSSortDescriptor(key: "name", ascending: true)
                    request.sortDescriptors = [nameorder]
                }
            } else {
                let dateOrder = NSSortDescriptor(key: "registerDay", ascending: false)
                request.sortDescriptors = [dateOrder]
            }

            do {
                // 임시저장소에서 (요청서를 통해서) 데이터 가져오기 (fetch메서드)
                if let fetchedToDoList = try context.fetch(request) as? [ComponentData] {
                    toDoList = fetchedToDoList
                }
            } catch {
                print("가져오는 것 실패")
            }
        }

        return toDoList
    }

    // MARK: - [Create] 코어데이터에 데이터 생성하기
    func saveFridgeData(refID: String, refName: String, refType: String, completion: @escaping () -> Void) {
        // 임시저장소 있는지 확인
        if let context = context {
            // 임시저장소에 있는 데이터를 그려줄 형태 파악하기
            if let entity = NSEntityDescription.entity(
                forEntityName: ModelName.RefrigeratorData.rawValue,
                in: context
            ) {
                // 임시저장소에 올라가게 할 객체만들기 (NSManagedObject ===> ToDoData)
                if let fridge = NSManagedObject(entity: entity, insertInto: context) as? RefrigeratorData {
                    // MARK: - ToDoData에 실제 데이터 할당 ⭐️
                    fridge.refID = refID
                    fridge.refName = refName
                    fridge.refType = refType
                    fridge.date = Date()
                    if context.hasChanges {
                        do {
                            try context.save()
                            completion()
                        } catch {
                            print(error)
                            completion()
                        }
                    }
                }
            }
        }
        completion()
    }

    // MARK: - [Delete] 코어데이터에서 데이터 삭제하기 (일치하는 데이터 찾아서 ===> 삭제)
    func deleteFridgeByID(data: RefrigeratorData, completion: @escaping () -> Void) {
        // 날짜 옵셔널 바인딩
        guard let refID = data.refID else {
            completion()
            return
        }

        // 임시저장소 있는지 확인
        if let context = context {
            // 요청서
            let request = NSFetchRequest<NSManagedObject>(entityName: ModelName.RefrigeratorData.rawValue)
            // 단서 / 찾기 위한 조건 설정

            request.predicate = NSPredicate(format: "refID = %@", refID as CVarArg)

            do {
                // 요청서를 통해서 데이터 가져오기 (조건에 일치하는 데이터 찾기) (fetch메서드)
                if let fetchedToDoList = try context.fetch(request) as? [RefrigeratorData] {
                    // 임시저장소에서 (요청서를 통해서) 데이터 삭제하기 (delete메서드)
                    if let targetToDo = fetchedToDoList.first {
                        context.delete(targetToDo)
                        if context.hasChanges {
                            do {
                                try context.save()
                                completion()
                            } catch {
                                print(error)
                                completion()
                            }
                        }
                    }
                }
                completion()
            } catch {
                print("지우는 것 실패")
                completion()
            }
        }
    }
    // MARK: - [Delete] 코어데이터에서 데이터 삭제하기 (일치하는 데이터 찾아서 ===> 삭제)
    func deleteComponentsByRefID(refID: String?, completion: @escaping () -> Void) {
        // 날짜 옵셔널 바인딩
        guard let refID = refID else {
            completion()
            return
        }

        // 임시저장소 있는지 확인
        if let context = context {
            // 요청서
            let request = NSFetchRequest<NSManagedObject>(entityName: ModelName.ComponentData.rawValue)
            // 단서 / 찾기 위한 조건 설정

            request.predicate = NSPredicate(format: "refID = %@", refID as CVarArg)

            do {
                // 요청서를 통해서 데이터 가져오기 (조건에 일치하는 데이터 찾기) (fetch메서드)
                if let fetchedToDoList = try context.fetch(request) as? [ComponentData] {

                    // 임시저장소에서 (요청서를 통해서) 데이터 삭제하기 (delete메서드)
                    if let targetToDo = fetchedToDoList.first {
                        context.delete(targetToDo)
                        if context.hasChanges {
                            do {
                                try context.save()
                                completion()
                            } catch {
                                print(error)
                                completion()
                            }
                        }
                    }
                }
                completion()
            } catch {
                print("지우는 것 실패")
                completion()
            }
        }
    }

    // MARK: - 모든 데이터 삭제
    func deleteAllDataOfFridge(completion: @escaping () -> Void) {
        // 임시저장소 있는지 확인
        guard let context = context else {
            completion()
            return
        }

        // 요청서
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: ModelName.RefrigeratorData.rawValue)

        do {
            // 요청서를 통해서 모든 데이터 가져오기
            let allData = try context.fetch(request)

            // 모든 데이터를 삭제
            for data in allData {
                if let objectData = data as? NSManagedObject {
                    context.delete(objectData)
                }
            }

            // 변경사항을 저장
            if context.hasChanges {
                do {
                    try context.save()
                    completion()
                } catch {
                    print(error)
                    completion()
                }
            }
        } catch {
            print("전체 삭제 실패")
            completion()
        }
    }

    // MARK: - 컴포넌트 전체 삭제
    func deleteAllOfComponents(completion: @escaping () -> Void) {
        // 임시저장소 있는지 확인
        guard let context = context else {
            completion()
            return
        }

        // 요청서
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: ModelName.ComponentData.rawValue)

        do {
            // 요청서를 통해서 모든 데이터 가져오기
            let allData = try context.fetch(request)

            // 모든 데이터를 삭제
            for data in allData {
                if let objectData = data as? NSManagedObject {
                    context.delete(objectData)
                }
            }

            // 변경사항을 저장
            if context.hasChanges {
                do {
                    try context.save()
                    completion()
                } catch {
                    print(error)
                    completion()
                }
            }
        } catch {
            print("전체 삭제 실패")
            completion()
        }
    }
    // MARK: - [Update] 코어데이터에서 데이터 수정하기 (일치하는 데이터 찾아서 ===> 수정)
    func updateFridgeDatas(fridgeData: RefrigeratorData, completion: @escaping () -> Void) {
        // 아이디 옵셔널 바인딩
        guard let refID = fridgeData.refID else {
            completion()
            return
        }

        // 임시저장소 있는지 확인
        if let context = context {
            // 요청서
            let request = NSFetchRequest<NSManagedObject>(entityName: ModelName.RefrigeratorData.rawValue)
            // 단서 / 찾기 위한 조건 설정
            request.predicate = NSPredicate(format: "refID = %@", refID as CVarArg)
            do {
                // 요청서를 통해서 데이터 가져오기
                if let fetchedFridgeDatas = try context.fetch(request) as? [RefrigeratorData] {
                    // 배열의 첫번째
                    if var targetToDo = fetchedFridgeDatas.first {
                        // MARK: - ToDoData에 실제 데이터 재할당(바꾸기) ⭐️
                        targetToDo = fridgeData
                        if context.hasChanges {
                            do {
                                try context.save()
                                completion()
                            } catch {
                                print(error)
                                completion()
                            }
                        }
                    }
                }
                completion()
            } catch {
                print("지우는 것 실패")
                completion()
            }
        }
    }

    func addComponentsOnFridge (
        refID: String,
        id: String,
        name: String,
        registerDay: String,
        dueDay: String,
        isFreezer: String,
        memo: String,
        tagColor: String,
        coordinates: String,
        completion: @escaping () -> Void) {
        if let context = context {
            if let entity = NSEntityDescription.entity(forEntityName: ModelName.ComponentData.rawValue, in: context) {
                if let component = NSManagedObject(entity: entity, insertInto: context) as? ComponentData {

                    // MARK: - ToDoData에 실제 데이터 할당 ⭐️
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy.MM.dd"

                    guard let registerDay = dateFormatter.date(from: registerDay) else { return }
                    guard let dueDay = dateFormatter.date(from: dueDay) else { return }

                    component.refID = refID
                    component.id = id
                    component.name = name
                    component.registerDay = registerDay
                    component.dueDay = dueDay
                    component.isFreezer = isFreezer
                    component.memo = memo
                    component.tagColor = tagColor
                    component.coordinates = coordinates

                    appDelegate?.saveContext() // 앱델리게이트의 메서드로 해도됨
                }
            }
        }
        completion()
    }

    func updateCoordinatesOfComponents (refID: String, id: String, coordinates: String, completion: @escaping () -> Void) {
        // 임시저장소 있는지 확인
        if let context = context {
            // 요청서
            let request = NSFetchRequest<NSManagedObject>(entityName: ModelName.ComponentData.rawValue)
            // 단서 / 찾기 위한 조건 설정
            request.predicate = NSPredicate(format: "id = %@", id as CVarArg)
            do {
                // 요청서를 통해서 데이터 가져오기
                if let fetchedComponentList = try context.fetch(request) as? [ComponentData] {
                    // 배열의 첫번째
                    if let targetConponent = fetchedComponentList.first {
                        // MARK: - ToDoData에 실제 데이터 재할당(바꾸기) ⭐️
                        targetConponent.coordinates = coordinates
                        if context.hasChanges {
                            do {
                                try context.save()
                                completion()
                            } catch {
                                print(error)
                                completion()
                            }
                        }
                    }
                }
                completion()
            } catch {
                print("업데이트 실패")
                completion()
            }
        }
    }

    // MARK: - 재료 id로 재료 삭제
    func deleteComponentsByID(id: String, completion: @escaping () -> Void) {
        // 임시저장소 있는지 확인
        if let context = context {
            // 요청서
            let request = NSFetchRequest<NSManagedObject>(entityName: ModelName.ComponentData.rawValue)
            // 단서 / 찾기 위한 조건 설정
            request.predicate = NSPredicate(format: "id = %@", id as CVarArg)
            do {
                // 요청서를 통해서 데이터 가져오기 (조건에 일치하는 데이터 찾기) (fetch메서드)
                if let fetchedToDoList = try context.fetch(request) as? [ComponentData] {
                    // 임시저장소에서 (요청서를 통해서) 데이터 삭제하기 (delete메서드)
                    if let targetToDo = fetchedToDoList.first {
                        print(fetchedToDoList)
                        context.delete(targetToDo)
                        if context.hasChanges {
                            do {
                                try context.save()
                                completion()
                            } catch {
                                print(error)
                                completion()
                            }
                        }
                    }
                }
                completion()
            } catch {
                print("지우는 것 실패")
                completion()
            }
        }
    }
}
