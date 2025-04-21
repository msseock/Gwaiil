//
//  Detail_PieceListRowView.swift
//  Gwaiil
//
//  Created by 석민솔 on 4/21/25.
//

import SwiftUI

/// 리스트 한 줄 컴포넌트 뷰
struct Detail_PieceListRowView: View {
    let colorType: FruitColorType
    let piece: PieceData
    let index: Int
    
    var body: some View {
        HStack(alignment: .center) {
            // 과일 아이콘
            Image(FruitType.getPieceByIndexNType(index: index, type: colorType).pieceImageName)
                .resizable()
                .scaledToFit()
                .frame(maxWidth: 25)
                .frame(width: 50)
            
            // 리스트 정보
            VStack(alignment: .leading) {
                Text(piece.text)
                
                Text(DateUtils.getDescriptiveText(piece.date))
                    .font(.callout)
                    .foregroundStyle(Color.secondary)
            }
            
            Spacer()
        }
    }
}

#Preview {
    Detail_PieceListRowView(colorType: .green, piece: PieceData(text: "어쩌구", date: Date()), index: 5)
}
