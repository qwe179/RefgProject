//
//  DateHelper.swift
//  RefgProject
//
//  Created by 23 09 on 2024/01/24.
//

import Foundation

final class DateHelper {
    let dateFormatter = DateFormatter()
    let todayString: String
    init() {
        dateFormatter.dateFormat = "yyyy.MM.dd"
        self.todayString = dateFormatter.string(from: Date())
    }
    func getTodayTime() -> String {
        return todayString
    }
    func calculateDate(day: Int) -> String {
        let calDay = Calendar.current.date(byAdding: .day, value: day, to: Date())
        return dateFormatter.string(from: calDay!)
    }
    func dateToStringFormat(date: Date) -> String {
        return dateFormatter.string(from: date)
    }
    func dateToStringFormat(date: Date?) -> String {
        guard let date = date else { return ""}
        return dateFormatter.string(from: date)
    }
}
