//
//  MemoData+CoreDataProperties.swift
//  MemoApp
//
//  Created by KimChoonSik on 2023/03/02.
//
//

import Foundation
import CoreData


extension MemoData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MemoData> {
        return NSFetchRequest<MemoData>(entityName: "MemoData")
    }
    
    @NSManaged public var memoText: String?
    @NSManaged public var date: Date?
    @NSManaged public var color: Int64


    
    // 셀의 dateLabel에 표시하려면 date를 String으로 바꿔줄 필요가 있음.
    // 이를 위한 계산속성 구현
    
    var dateString: String? {
        //포메터
        let formatter = DateFormatter()
        //m은 시간에서 minutes를 표기하는데 쓰여서 월은 대문자 M사용
        formatter.dateFormat = "yyyy-MM-dd"
        guard let date = date else { return "" }
        let formattedDateString = formatter.string(from: date)
        return formattedDateString
    }
    
}

extension MemoData : Identifiable {

}
