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
    
    // 부모 뷰에게 전달해줄 값들
    @Binding var selectedPieceIndex: Int?
    @Binding var showSheet: Bool
    @Binding var sheetToShow: DetailFruitSheetType?
    
    /// 내림차순으로 정렬된 조각데이터
    var pieces: [PieceData] {
        fruitData.pieces.sorted { $0.date > $1.date }
    }
    
    // MARK: View
    var body: some View {
        List {
            // MARK: 진행중인 도전일 때의 리스트
            if !DateUtils.isFinishedFruit(startDate: fruitData.startDate) {
                ForEach(Array(pieces.enumerated()), id: \.offset) { index, piece in
                    // fruitData.pieces 배열에서 인덱스 구하기
                    let arrayIndex = fruitData.pieces.firstIndex(of: piece)!
                    
                    Detail_PieceListRowView(
                        colorType: fruitData.colorType,
                        piece: piece,
                        index: pieces.count - index - 1
                    )
                    .contentShape(Rectangle()) // 전체 영역을 탭 가능하게 함
                    .onTapGesture {
                        // 조각 수정 sheet 보여줌
                        selectedPieceIndex = arrayIndex
                        sheetToShow = .pieceEdit
                        showSheet.toggle()
                    }
                    // 스와이프해서 조각 삭제하기
                    .swipeActions(edge: .trailing) {
                        Button(role: .destructive) {
                            withAnimation {
                                deletePiece(at: arrayIndex)
                            }
                        } label: {
                            Label("삭제", systemImage: "trash")
                        }
                    }
                }
            }
            // MARK: 21일 지난 도전일 때의 리스트(완료된 도전)
            else {
                ForEach(Array(pieces.enumerated()), id: \.offset) { index, piece in
                    Detail_PieceListRowView(
                        colorType: fruitData.colorType,
                        piece: piece,
                        index: pieces.count - index - 1
                    )
                }
            }
        }
        .listStyle(.plain)
        .padding(.horizontal, -16)
    }
    
    // MARK: Methods
    /// 특정 조각 없애기
    func deletePiece(at index: Int) {
        fruitData.pieces.remove(at: index)
    }
}

#Preview {
    Detail_PiecesListView(
        fruitData: FruitData(name: "이름", colorType: .green),
        selectedPieceIndex: .constant(5),
        showSheet: .constant(false),
        sheetToShow: .constant(.fruitEdit)
    )
}
