//
//  Detail_PiecesBoxView.swift
//  Gwaiil
//
//  Created by 석민솔 on 4/21/25.
//

import SwiftUI

/// 조각들 있는 박스 컴포넌트
struct Detail_PiecesBoxView: View {
    let colorType: FruitColorType
    let count: Int
    
    var body: some View {
        VStack {
            // 조각 있으면 조각 개수만큼 보여주는 레이아웃뷰
            if count > 0 {
                PieceLayoutView(colorType: self.colorType, count: self.count)
            }
            // 조각 없으면 안내멘트
            else {
                Text("조각 추가 버튼을 눌러서\n실천한 내용을 적어주세요")
                    .multilineTextAlignment(.center)
                    .foregroundStyle(Color(UIColor.secondaryLabel))
                    .padding(.vertical, 10)
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.black.opacity(0.1), lineWidth: 2)
        )
    }
}

#Preview {
    Detail_PiecesBoxView(colorType: .yellow, count: 10)
}
