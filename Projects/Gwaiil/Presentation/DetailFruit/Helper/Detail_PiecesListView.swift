//
//  Detail_PiecesListView.swift
//  Gwaiil
//
//  Created by 석민솔 on 4/21/25.
//

import SwiftUI

/// 조각 정보 리스트
struct Detail_PiecesListView: View {
    // MARK: Properties
    let fruitData: FruitData
    
    @Binding var selectedPieceIndex: Int?
    
    @Binding var showSheet: Bool
    @Binding var sheetToShow: DetailFruitSheetType?

    var colorType: FruitColorType {
        fruitData.colorType
    }
    var pieces: [PieceData] {
        fruitData.pieces
    }
    
    // MARK: View
    var body: some View {
        List {
            ForEach(Array(fruitData.pieces.enumerated()), id: \.offset) { index, piece in
                Detail_PieceListRowView(
                    colorType: colorType,
                    piece: piece,
                    index: index
                )
                .contentShape(Rectangle()) // 전체 영역을 탭 가능하게 함
                .onTapGesture {
                    // 조각 수정 sheet 보여줌
                    selectedPieceIndex = index
                    sheetToShow = .pieceEdit
                    showSheet.toggle()
                }
                // 스와이프해서 조각 삭제하기
                .swipeActions(edge: .trailing) {
                    Button(role: .destructive) {
                        withAnimation {
                            deletePiece(index)
                        }
                    } label: {
                        Label("삭제", systemImage: "trash")
                    }
                }
            }
        }
        .listStyle(.plain)
        .padding(.horizontal, -16)
    }
    
    // MARK: Methods
    /// 특정 조각 없애기
    func deletePiece(_ index: Int) {
        fruitData.pieces.remove(at: index)
    }
}

#Preview {
    Detail_PiecesListView(fruitData: FruitData(name: "", colorType: .yellow), selectedPieceIndex: .constant(5), showSheet: .constant(false), sheetToShow: .constant(.fruitEdit))
}
