//
//  CoreDataManager.swift
//  MemoApp
//
//  Created by KimChoonSik on 2023/03/07.
//

import UIKit
import CoreData

//MARK: - Memo 데이터 관리 메니저 (코어데이터 관리 ⭐️)
//CURD 구현

final class CoreDataManager {
    
    // 여럭 객체에서 접근해 데이터를 전달받아야 하기에 싱글톤 패턴으로 구현
    static let shared = CoreDataManager()
    private init() {}
    
    
    // 앱 델리게이트에 코어데이터를 생성하면서 persistentContainer, saveContext()가 구현되어 있음
    // context(임시 저장소)에 접근하기 위해 앱 델리게이트를 참조해야함 코어데이터 구성 다시 복습하기🤔
    
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    //임시저장소
    lazy var context = appDelegate?.persistentContainer.viewContext
    
    //엔티티 이름 (코어데이터에 저장된 객체)
    
    let modelName: String = "MemoData"
    
    
    //MARK: - [Read] 코어데이터에 저장된 데이터 모두 읽어오기
    
    func getMemoDataList() -> [MemoData] {
        var memoData: [MemoData] = []
        //임시저장소 존재 여부 확인
        if let context = context {
            // 데이터 요청서
            let request = NSFetchRequest<NSManagedObject>(entityName: self.modelName)
            // 정렬 순서를 정해서 요청서에 넘겨줌( 어떤 순서로 데이터를 가져올 것인가)
            // 아래는 코어 데이터의 date속성을 정렬 기준으로 잡고, 내림차순으로 하는 코드
            let dateOrder = NSSortDescriptor(key: "date", ascending: false)
            request.sortDescriptors = [dateOrder]
            
            // context.fetch()가 에러를 던지기에 에러처리 필요
            //사전에 정렬 순서를 정해 만들어둔 요청서에 따라 임시저장소에서 데이터(가 있다면?)를 받아와 원하는 데이터의 형태[MemoData]로 타입캐스팅
            do {
                if let fetchedMemoList = try context.fetch(request) as? [MemoData] {
                    memoData = fetchedMemoList
                }
            } catch {
                print("데이터 로드 실패")
            }
        }
        return memoData
    }
    
    //MARK: - [Create] 코어데이터에 데이터 생성
    //코어데이터는 entity -> NSManagedObject -> context -> persistentContainer -> persistent store의 형태로 관리됨을 참고
    //이에 맞게 차근 차근 코드를 짜는것
    
    // 데이터 저장이 오래걸려 비동기로 처리해야할수도 있기에 콜백함수를 내장해둔 코드
    func saveMemoData(memoText: String?, colorInt: Int64, completion: @escaping () -> Void) {
        
        //임시 저장소 존재 여부 확인
        if let context = context {
            
            //provides a blueprint for creating a Core Data entity, which defines the attributes and relationships of objects that you want to store in a persistent store.
            // 영구저장소에 저장하기 원하는 객체들, 즉 코어데이터 엔티티의 청사진을 그리는 코드
            if let entity = NSEntityDescription.entity(forEntityName: self.modelName, in: context) {
                
                //임시 저장소에 올릴 객체 만들기(NSManagedObject)
                if let memoData = NSManagedObject(entity: entity, insertInto: context) as? MemoData {
                    
                    //MARK: - MemoData에 실제 데이터 할당
                    memoData.memoText = memoText
                    memoData.date = Date() //날짜는 저장하는 순간의 날짜로 생성
                    memoData.color = colorInt
                    
                    //appDelegate?.saveContext() 사용가능(코어데이터를 만들면서 앱델리게이트 파일에 자동으로 구현되어 있음.)
                    // 혹은 임시저장소(NSManagedObject가 모여있는) Context에 변화가 있을 경우 저장하는 방식으로 구현(Bool타입 프로퍼티가 있음)
                    if context.hasChanges {
                        do {
                            try context.save()
                            completion()
                        } catch {
                            print(error.localizedDescription)
                            completion()
                        }
                    }
                }
            }
        }
        completion()
    }
    
    // [Delete] 코어데이터에서 데이터 삭제 (일치하는 데이터 찾아서 삭제 - 날짜를 기준으로)
    func deleteMemo(data: MemoData, completion: @escaping () -> Void) {
        //날짜를 통해 데이터를 확인하기에 날짜를 먼저 확인
        guard let date = data.date else {
            completion()
            return
        }
        
        //임시저장소 존재 여부 확인
        if let context = context {
            
            //요청서
            //NSFetchRequest -> 코어데이터 영구저장소에서 데이터를 가져오기 위한 필터를 정의하기 위한 코드
            //creates an NSPredicate instance that filters data based on whether the date attribute of the entity is equal to a specific Date value, and then substitutes the Date value into the predicate using the %@ placeholder.
            let request = NSFetchRequest<NSManagedObject>(entityName: self.modelName)
            // 단서/ 찾기 위한 조건
            request.predicate = NSPredicate(format: "date = %@", date as CVarArg)
            
            
            do {
                //요청서를 통해 데이터 가져오기(조건에 일치하는 데이터 찾기_ fetch)
                if let fetchedMemoList = try context.fetch(request) as? [MemoData] {
                    //임시 저장소(context)에서 데이터 삭제하기 (delete)
                    if let targetMemo = fetchedMemoList.first {
                        context.delete(targetMemo)
                        
                        //appDelegate?.saveContext()로도 가능
                        
                        if context.hasChanges {
                            do {
                                try context.save()
                                completion()
                            } catch {
                                print(error.localizedDescription)
                                completion()
                            }
                        }
                    }
                }
            } catch {
                print("삭제 실패")
                completion()
            }
        }
    }
    
    //MARK: - [Update] 코어데이터에서 데이터 수정하기 (일치하는 데이터 찾아서 수정_ 날짜를 기준으로)
    /* 기본적인 절차
     0. 데이터를 확인할 기준 체크
     1. NSManagedObejctContext(임시저장소) 확인
     2. NSFetchRequest<NSManagedObject>(entityName: self.modelName)(요청서 작성)
     3. NSPredicate(데이터 찾기 위한 조건,단서 설정)
     4. context.fetch (요청서를 통해 데이터 가져오기)
     5. 데이터 재할당(update)
     */
    
    func updateMemo(newMemoData: MemoData, completion: @escaping () -> Void) {
        
        guard let date = newMemoData.date else {
            completion()
            return
        }
        
        if let context = context {
            //요청서
            let request = NSFetchRequest<NSManagedObject>(entityName: self.modelName)
            request.predicate = NSPredicate(format: "date = %@", date as CVarArg)
            
            do {
                if let fetchedMemoDataList = try context.fetch(request) as? [MemoData] {
                    //배열의 첫번째에 접근
                    if var targetMemo = fetchedMemoDataList.first {
                        //MARK: - 바꿀 데이터로 재할당
                        targetMemo = newMemoData
                        //                        appDelegate?.saveContext()
                        if context.hasChanges {
                            do {
                                try context.save()
                                completion()
                            } catch {
                                print(error.localizedDescription)
                                completion()
                            }
                        }
                    }
                }
                completion()
            } catch {
                print(error.localizedDescription)
                print("업데이트 안됨")
                completion()
            }
        }
    }
}
