//
//  CoreDataManager.swift
//  RefgProject
//
//  Created by 23 09 on 2024/01/26.
//

import UIKit
import CoreData


//MARK: - (코어데이터 관리)

final class MemoDataManager {
    
    // 싱글톤으로 만들기
    static let shared = MemoDataManager()
    private init() {}
    
    // 앱 델리게이트
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    // 임시저장소
    lazy var context = appDelegate?.persistentContainer.viewContext
    
    // 엔터티 이름 (코어데이터에 저장된 객체)
    let modelName: String = "MemoData"
    
    
    // MARK: - [Create] 메모데이터에 메모 생성하기
    func saveMemoData(memo: String, completion: @escaping () -> Void) {
        // 임시저장소 있는지 확인
        if let context = context {
            // 임시저장소에 있는 데이터를 그려줄 형태 파악하기
            if let entity = NSEntityDescription.entity(forEntityName: modelName, in: context) {
                
                // 임시저장소에 올라가게 할 객체만들기 (NSManagedObject ===> ToDoData)
                if let memoObject = NSManagedObject(entity: entity, insertInto: context) as? MemoData {
                    
                    // MARK: - ToDoData에 실제 데이터 할당 ⭐️
                    memoObject.id = UUID()
                    memoObject.date = Date()
                    memoObject.memo = memo
                    memoObject.isEdit = false
                    appDelegate?.saveContext()
                }
            }
        }
        completion()
    }
    
    // MARK: - [Read] 메모데이터에 저장된 데이터 모두 읽어오기
    func getMemoDataFromCoreData() -> [MemoData] {
        var MemoList: [MemoData] = []
        // 임시저장소 있는지 확인
        if let context = context {
            // 요청서
            let request = NSFetchRequest<NSManagedObject>(entityName: modelName)
            // 정렬순서를 정해서 요청서에 넘겨주기
            let dateOrder = NSSortDescriptor(key: "date", ascending: false)
            request.sortDescriptors = [dateOrder]
            
            do {
                // 임시저장소에서 (요청서를 통해서) 데이터 가져오기 (fetch메서드)
                if let fetchedMemoList = try context.fetch(request) as? [MemoData] {
                    MemoList = fetchedMemoList
                }
            } catch {
                print("가져오는 것 실패")
            }
        }
        return MemoList
    }
    
    func getMemoDataBySearching(memo: String) -> [MemoData] {
        var MemoList: [MemoData] = []
        // 임시저장소 있는지 확인
        if let context = context {
            // 요청서
            let request = NSFetchRequest<NSManagedObject>(entityName: modelName)
            request.predicate = NSPredicate(format: "memo MATCHES[c] %@", ".*\(memo).*")
            // 정렬순서를 정해서 요청서에 넘겨주기
            let dateOrder = NSSortDescriptor(key: "date", ascending: false)
            request.sortDescriptors = [dateOrder]
            
            do {
                // 임시저장소에서 (요청서를 통해서) 데이터 가져오기 (fetch메서드)
                if let fetchedMemoList = try context.fetch(request) as? [MemoData] {
                    MemoList = fetchedMemoList
                }
            } catch {
                print("가져오는 것 실패")
            }
        }
        return MemoList
    }
    
    // MARK: - 메모 id로 메모 삭제

    func deleteMemoByID(id: UUID, completion: @escaping () -> Void) {
        // 임시저장소 있는지 확인
        if let context = context {
            // 요청서
            let request = NSFetchRequest<NSManagedObject>(entityName: modelName)
            // 단서 / 찾기 위한 조건 설정
            request.predicate = NSPredicate(format: "id = %@", id as CVarArg)
            
            do {
                // 요청서를 통해서 데이터 가져오기 (조건에 일치하는 데이터 찾기) (fetch메서드)
                if let fetchedMemoList = try context.fetch(request) as? [MemoData] {
                    
                    // 임시저장소에서 (요청서를 통해서) 데이터 삭제하기 (delete메서드)
                    if let targetMemo = fetchedMemoList.first {
                        print(fetchedMemoList)
                        context.delete(targetMemo)
                        appDelegate?.saveContext()
                    }
                }
                completion()
            } catch {
                print("지우는 것 실패")
                completion()
            }
        }
    }
    
    
    // MARK: - [Update] 코어데이터에서 데이터 수정하기 (일치하는 데이터 찾아서 ===> 수정)
    func updateMemoDatas(memoData: MemoData, completion: @escaping () -> Void) {
        guard let id = memoData.id else { return }
        
        // 임시저장소 있는지 확인
        if let context = context {
            // 요청서
            let request = NSFetchRequest<NSManagedObject>(entityName: modelName)
            // 단서 / 찾기 위한 조건 설정
            request.predicate = NSPredicate(format: "id = %@", id as CVarArg)
//
            do {
                // 요청서를 통해서 데이터 가져오기
                if let fetchedMemoDatas = try context.fetch(request) as? [MemoData] {
                    // 배열의 첫번째
                    if var targetMemo = fetchedMemoDatas.first {
                        
                        // MARK: - ToDoData에 실제 데이터 재할당(바꾸기) ⭐️
                        targetMemo = memoData
                        appDelegate?.saveContext()
                    }
                }
                completion()
            } catch {
                print("지우는 것 실패")
            }
        }
    }

}
