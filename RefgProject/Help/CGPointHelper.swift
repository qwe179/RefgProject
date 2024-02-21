//
//  CGPointHelper.swift
//  RefgProject
//
//  Created by 23 09 on 2024/02/01.
//

import Foundation


extension CGPoint {
    // CGPoint를 문자열로 변환
    func toString() -> String {
        return "\(self.x),\(self.y)"
    }

    // 문자열을 CGPoint로 변환
    static func fromString(_ string: String) -> CGPoint? {
        let components = string.components(separatedBy: ",")
        if components.count == 2,
            let x = Double(components[0]),
            let y = Double(components[1]) {
            return CGPoint(x: x, y: y)
        } else {
            return nil
        }
    }
}
