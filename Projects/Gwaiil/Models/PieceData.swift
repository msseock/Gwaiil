//
//  PieceData.swift
//  Gwaiil
//
//  Created by 석민솔 on 4/18/25.
//

import Foundation
import SwiftData

/// 목표 실행 행동(과일 조각) 데이터 모델
@Model
class PieceData: Identifiable {
    var id: UUID
    
    /// 조각 텍스트
    var text: String
    
    /// 일시
    var date: Date
    
    init(text: String, date: Date) {
        self.id = UUID()
        self.text = text
        self.date = date
    }
}

