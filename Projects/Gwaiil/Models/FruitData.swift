//
//  FruitData.swift
//  Gwaiil
//
//  Created by 석민솔 on 4/18/25.
//

import Foundation
import SwiftData
import SwiftUI

/// 목표(과일) 데이터 모델
@Model
class FruitData: Identifiable {
    var id: UUID
    
    /// 목표이름
    var name: String
    
    /// 색상타입(노랑 초록 빨강 중1)
    var colorType: FruitColorType
    
    /// 시작날짜
    var startDate: Date
    
    /// 목표별 조각들(실행한 행동 리스트)
    @Relationship(deleteRule: .cascade)
    var pieces: [PieceData]
    
    /// 생성자
    init(name: String, colorType: FruitColorType) {
        self.id = UUID()
        self.name = name
        self.colorType = colorType
        self.startDate = Calendar.current.startOfDay(for: Date())
        self.pieces = []
    }
}

/// 과일 색상타입 3종
enum FruitColorType: String, CaseIterable, Codable {
    case yellow = "노랑"
    case green = "초록"
    case red = "빨강"
    
    /// 색상별 메인컬러
    var color: Color {
        switch self {
        case .yellow:
            .yellow100
        case .green:
            .green80
        case .red:
            .red100
        }
    }
}

/// 과일 9종
enum FruitType: String, CaseIterable {
    // yellow
    case lemon
    case starfruit
    case pineapple
    
    // green
    case lime
    case greenApple
    case melon
    
    // red
    case cherryTomato
    case peach
    case redApple
    
    /// 한국이름 + 을/를
    var koreanNamePlusJosa: String {
        switch self {
        case .lemon:
            "레몬을"
        case .starfruit:
            "스타후르츠를"
        case .pineapple:
            "파인애플을"
        case .lime:
            "라임을"
        case .greenApple:
            "청사과를"
        case .melon:
            "멜론을"
        case .cherryTomato:
            "방울토마토를"
        case .peach:
            "납작복숭아를"
        case .redApple:
            "사과를"
        }
    }
    
    /// 전체과일 이미지
    var fruitImageName: String {
        return self.rawValue
    }
    
    /// 조각 이미지
    var pieceImageName: String {
        return "piece_\(self.rawValue)"
    }
    
    /// 과일별 색상타입
    var colorType: FruitColorType {
        switch self {
        case .lemon, .starfruit, .pineapple: .yellow
        case .lime, .greenApple, .melon: .green
        case .cherryTomato, .peach, .redApple: .red
        }
    }
    
    /// 진화단계
    var level: Int {
        switch self {
        case .lemon, .lime, .cherryTomato:
            0
        case .starfruit, .greenApple, .peach:
            1
        case .pineapple, .melon, .redApple:
            2
        }
    }
    
    /// 색상타입별 진화 단계로 과일정보 얻기
    static func getPieceByLevelNType(level: Int, type: FruitColorType) -> FruitType {
        return FruitType.allCases.first {
            $0.level == level && $0.colorType == type
        } ?? .lemon
    }
    
    /// 인덱스랑 색상타입으로 과일정보 얻기
    static func getPieceByIndexNType(index: Int, type: FruitColorType) -> FruitType {
        switch index {
        case 0..<7:
            return FruitType.allCases.first {
                $0.level == 0 && $0.colorType == type
            } ?? .lemon
        case 7..<14:
            return FruitType.allCases.first {
                $0.level == 1 && $0.colorType == type
            } ?? .starfruit
        default:
            return FruitType.allCases.first {
                $0.level == 2 && $0.colorType == type
            } ?? .pineapple
        }
    }
}
