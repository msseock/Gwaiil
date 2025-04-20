//
//  DateUtils.swift
//  Gwaiil
//
//  Created by 석민솔 on 4/20/25.
//

import Foundation

/// 날짜 관련된 모든 기능은 DateUtils로 통한다!
enum DateUtils {
    
    // MARK: - 날짜 계산 (기간 관련)
    
    /// 오늘로부터 21일 전 날짜 구하기
    static func getTwentyOneDaysAgo() -> Date {
        Calendar.current.date(byAdding: .day, value: -21, to: Date()) ?? Date()
    }
    
    /// 도전 시작일 가지고 끝나는 날 구하기 (21일 후)
    static func getEndDateByStartDate(_ startDate: Date) -> Date? {
        Calendar.current.date(byAdding: .day, value: 21, to: startDate)
    }
    
    /// 날짜 상으로 시작한 날짜가 현재 날짜로부터 21일 이상 지났는지 확인
    static func isFinishedFruit(startDate: Date) -> Bool {
        let start = DateUtils.getDateIntForCalc(startDate)
        let twentyOneDaysAgo = DateUtils.getDateIntForCalc(DateUtils.getTwentyOneDaysAgo())
        return start <= twentyOneDaysAgo
    }
    
    
    // MARK: - 날짜 → 텍스트 변환
    
    /// Date 객체를 2025.04.20 형태 문자열로 만들어주기
    static func getDateText(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy.MM.dd"
        return formatter.string(from: date)
    }
    
    /// Date 객체를 Int비교할 수 있도록 만들어주기
    static func getDateIntForCalc(_ date: Date) -> Int {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyyMMdd"
        return Int(formatter.string(from: date))!
    }
    
    /// UI에 표시될 시작날짜 ~ (끝나는 날짜) 텍스트
    static func getDateComponentText(startDate: Date) -> String {
        var DateComponentText: String = "\(getDateText(startDate)) ~ "
        if isFinishedFruit(startDate: startDate) {
            if let endDate = DateUtils.getEndDateByStartDate(startDate) {
                let endString = DateUtils.getDateText(endDate)
                DateComponentText += endString
            }
        }
        return DateComponentText
    }
    
    
    // MARK: - 날짜 비교 / 포함 여부
    
    /// pieces 배열 안에 date와 같은 날짜를 가진 객체가 있는지 확인
    static func hasPiece(on date: Date, in pieces: [PieceData]) -> Bool {
        pieces.contains { piece in
            let calendar = Calendar.current
            return calendar.isDate(piece.date, inSameDayAs: date)
        }
    }
}
