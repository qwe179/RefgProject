//
//  JasonCodingHelper.swift
//  RefgProject
//
//  Created by 23 09 on 2024/01/27.
//

import UIKit

final class JasonCodingHelper {

    
    // 데이터를 Data로 인코딩하는 함수
    static func encodeData<T: Codable>(_ value: T) -> Data? {
        let encoder = JSONEncoder()
        do {
            return try encoder.encode(value)
        } catch {
            print("Error encoding data: \(error)")
            return nil
        }
    }

    // Data를 원래 데이터 타입으로 디코딩하는 함수
    static func decodeData<T: Codable>(_ type: T.Type, from data: Data) -> T? {
        let decoder = JSONDecoder()
        do {
            return try decoder.decode(type, from: data)
        } catch {
            print("Error decoding data: \(error)")
            return nil
        }
    }
    
    
    
}
