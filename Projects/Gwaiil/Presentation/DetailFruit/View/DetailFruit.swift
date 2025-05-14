//
//  DetailFruit.swift
//  Gwaiil
//
//  Created by 석민솔 on 4/19/25.
//

import SwiftUI
import SwiftData

struct DetailFruit: View {
    // MARK: - Properties
    /// 상세 페이지에서 보여줄 데이터
    @Query var fruitData: [FruitData]
        
    /// 화면 빠져나가기용
    @Environment(\.dismiss) var dismiss
    /// model context
    @Environment(\.modelContext) var context
    
    // MARK: sheet & alert용 변수들
    @State var showSheet: Bool = false
    
    @State var sheetToShow: DetailFruitSheetType?
        
    /// 수정할 조각 index 저장용
    @State var selectedPieceIndex: Int?
    
    /// 삭제 컨펌 alert 띄우기용
    @State var showDeleteAlert: Bool = false
    
    // MARK: - init
    init(fruitID: UUID) {
        // ID로 필터링하는 predicate
        let predicate = #Predicate<FruitData> {
            $0.id == fruitID
        }
        
        // Query 초기화 - predicate 적용
        _fruitData = Query(filter: predicate)
    }
    
    // MARK: - View
    var body: some View {
        VStack(spacing: 20) {
            if let fruit = fruitData.first {
                // MARK: 과일 제목 섹션
                Detail_TitleSectionView(fruit: fruit)
                    .padding(.vertical, 20)
                
                // MARK: 과일 추가하기 버튼 섹션
                if DateUtils.isFinishedFruit(startDate: fruit.startDate) {
                    // 끝난 도전이면 어떤 과일 획득했는지 보여주는 박스
                    Detail_EarnedFruitBoxView(
                        pieceCount: fruit.pieces.count,
                        colorType: fruit.colorType
                    )
                } else {
                    // 조각 추가하기 버튼
                    Detail_AddPieceButton(
                        colorType: fruit.colorType,
                        showSheet: $showSheet,
                        sheetToShow: $sheetToShow
                    )
                    .opacity(DateUtils.hasPiece(on: Date(), in: fruit.pieces) ? 0.5 : 1)
                    .disabled(DateUtils.hasPiece(on: Date(), in: fruit.pieces))
                }
                
                // MARK: 과일 조각 모여있는 박스 보여주는 뷰
                Detail_PiecesBoxView(
                    colorType: fruit.colorType,
                    count: fruit.pieces.count
                )
                
                // MARK: 과일 조각 리스트뷰
                Detail_PiecesListView(
                    fruitData: fruit,
                    selectedPieceIndex: $selectedPieceIndex,
                    showSheet: $showSheet,
                    sheetToShow: $sheetToShow
                )
            } else {
                Text("어라?")
            }
        }
        .padding(.horizontal, 16)
        // MARK: Sheets
        .sheet(isPresented: $showSheet) {
            // 과일 수정
            if sheetToShow == .fruitEdit {
                FruitSheet(fruit: fruitData.first)
                    .presentationDetents([.height(500)])
            }
            // 조각 추가
            else if sheetToShow == .pieceAdd {
                PieceSheet(pieceIndex: nil, fruitData: fruitData.first!)
                    .presentationDetents([.height(220)])
            }
            // 조각 수정
            else if sheetToShow == .pieceEdit {
                if let selectedPieceIndex {
                    PieceSheet(pieceIndex: selectedPieceIndex, fruitData: fruitData.first!)
                        .presentationDetents([.height(220)])
                }
            }
        }
        // MARK: NavigationBar
        .navigationTitle("도전목표")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Menu {
                    // 과일 수정
                    Button {
                        // 과일 수정 sheet 띄우기
                        sheetToShow = .fruitEdit
                        showSheet.toggle()
                    } label: {
                        Label("수정", systemImage: "pencil")
                    }
                    
                    // 과일 삭제
                    Button(role: .destructive) {
                        // 정말 삭제하시겠습니까 alert 띄우기
                        showDeleteAlert.toggle()
                    } label: {
                        Label("삭제", systemImage: "trash")
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                }
            }
        }
        // MARK: 도전목표 삭제 Alert
        .alert("도전목표 삭제", isPresented: $showDeleteAlert) {
            Button("예", role: .destructive) {
                if let fruit = fruitData.first {
                    context.delete(fruit)
                    dismiss()
                }
            }
        } message: {
            Text("정말 목표를 삭제하시겠습니까?")
        }
    }
}

#Preview {
    DetailFruit(fruitID: .init())
}

enum DetailFruitSheetType {
    case fruitEdit
    case pieceAdd
    case pieceEdit
}
