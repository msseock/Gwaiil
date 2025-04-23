//
//  Detail_EarnedFruitBoxView.swift
//  Gwaiil
//
//  Created by 석민솔 on 4/22/25.
//

import SwiftUI

/// 도전으로 얻은 과일 정리해서 박스로 텍스트 보여주는 뷰
struct Detail_EarnedFruitBoxView: View {
    let pieceCount: Int
    let colorType: FruitColorType
    
    var body: some View {
        Text("이번 도전으로 \(FruitType.getPieceByIndexNType(index: pieceCount-1, type: colorType).koreanNamePlusJosa) 얻었어요!")
            .font(.headline)
            .padding(.vertical, 14)
            .frame(maxWidth: .infinity, alignment: .center)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(colorType.color, lineWidth: 2)
            )
    }
}

#Preview {
    Detail_EarnedFruitBoxView(pieceCount: 10, colorType: .green)
}
