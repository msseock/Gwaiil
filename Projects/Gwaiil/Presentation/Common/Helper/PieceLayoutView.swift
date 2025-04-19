//
//  PieceLayoutView.swift
//  Gwaiil
//
//  Created by 석민솔 on 4/19/25.
//

import SwiftUI

/// 과일 조각들만 보여주는 뷰
struct PieceLayoutView: View {
    // MARK: - Properties
    /// 과일 색상 타입
    let colorType: FruitColorType
    
    /// 조각 개수
    let count: Int
    
    // MARK: - View
    var body: some View {
        WrapLayout() {
            // 0개면 placeholder로 과일조각 1개 보여주기
            if count == 0 {
                Image(FruitType.getPieceByIndexNType(index: 0, type: self.colorType).pieceImageName)
                    .resizable()
                    .scaledToFit()
                    .opacity(0.5)
            }
            else {
                ForEach(0..<count, id: \.self) { index in
                    Image(FruitType.getPieceByIndexNType(index: index, type: self.colorType).pieceImageName)
                        .resizable()
                        .scaledToFit()
                }
            }
        }
        .frame(minWidth:270, maxWidth: 350)
    }
}

#Preview {
    PieceLayoutView(colorType: .yellow, count: 21)
}
