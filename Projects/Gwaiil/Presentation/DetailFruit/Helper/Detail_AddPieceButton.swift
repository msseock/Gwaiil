//
//  Detail_AddPieceButton.swift
//  Gwaiil
//
//  Created by 석민솔 on 4/21/25.
//

import SwiftUI

/// 조각 추가하기 버튼
struct Detail_AddPieceButton: View {
    let colorType: FruitColorType
    
    @Binding var showSheet: Bool
    @Binding var sheetToShow: DetailFruitSheetType?
            
    var buttonBcgColor: Color {
        switch colorType {
        case .yellow:
            .yellow100
        case .green:
            .green80
        case .red:
                .red50
        }
    }
    
    var body: some View {
        Button {
            sheetToShow = .pieceAdd
            showSheet.toggle()
        } label: {
            HStack {
                Image(systemName: "plus.circle.fill")
                Text("조각 추가하기")
                
            }
            .font(.headline)
            .foregroundStyle(Color.black)
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.vertical, 14)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(buttonBcgColor)
            )
        }
    }
}

#Preview {
    Detail_AddPieceButton(colorType: FruitColorType.green, showSheet: .constant(false), sheetToShow: .constant(.pieceAdd))
}
