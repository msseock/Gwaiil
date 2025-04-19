//
//  FruitCardView.swift
//  Gwaiil
//
//  Created by 석민솔 on 4/19/25.
//

import SwiftUI

/// 홈화면에 들어갈 한 개의 도전(과일) 카드 컴포넌트
struct FruitCardView: View {
    // MARK: - Properties
    /// 카드 정보
    let fruitData: FruitData
    
    /// 완료한 도전인지 아닌지
    let isFinished: Bool
    
    /// 버튼 종류
    enum ButtonType {
        /// 조각 추가하기
        case addPiece
        /// 상세보기
        case detail
    }
    
    /// 조각 추가 sheet 띄우기용
    @State var showAddPieceSheet: Bool = false
    
    
    // MARK: - View
    var body: some View {
        VStack {
            // 완료된 도전인지에 따라 보여주는 카드 종류 다름
            if isFinished {
                finishedFruitCard
            } else {
                ongoingFruitCard
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white)
        )
    }
}


// MARK: - Components
extension FruitCardView {
    /// 진행중인 도전 카드
    private var ongoingFruitCard: some View {
        VStack(spacing: 0) {
            // 과일카드 제목
            Text(fruitData.name)
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 5)
            
            // 날짜
            Text(getDateText())
                .font(.footnote)
                .fontWeight(.light)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 15)
            
            // 과일조각들 보여주는 부분
            PieceLayoutView (
                colorType: fruitData.colorType,
                count: fruitData.pieces.count
            )
            .padding(.bottom, 10)
            
            // 버튼 2개
            HStack(spacing: 10) {
                // 조각 추가하기 버튼
                Button {
                    showAddPieceSheet.toggle()
                } label: {
                    buttonView(type: .addPiece)
                }
                
                // 상세보기 버튼
                NavigationLink {
                    DetailFruit()
                } label: {
                    buttonView(type: .detail)
                }
            }
        }
        .sheet(isPresented: $showAddPieceSheet) {
            PieceSheet()
        }
    }
    
    /// 완료된 도전 카드
    private var finishedFruitCard: some View {
        VStack(spacing: 0) {
            // 과일카드 제목
            Text(fruitData.name)
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 5)
            
            // 날짜
            Text(getDateText())
                .font(.footnote)
                .fontWeight(.light)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 15)
            
            // 얻은 과일 보여주는 부분
            if fruitData.pieces.count == 0 {
                Text("얻은 과일이 없어요 🥲")
                    .font(.callout)
                    .foregroundStyle(Color.secondary)
                    .frame(height: 60)
                    .padding(.bottom, 10)
            }
            else {
                Image(FruitType.getPieceByIndexNType(index: fruitData.pieces.count, type: fruitData.colorType).fruitImageName)
                    .padding(.bottom, 10)
            }
            
            // 상세보기 버튼
            if fruitData.pieces.count > 0 {
                NavigationLink {
                    DetailFruit()
                } label: {
                    buttonView(type: .detail)
                }
            }
        }
    }
    
    /// 카드에서 사용되는 공통 규격 버튼 컴포넌트
    private func buttonView(type: ButtonType) -> some View {
        
        /// 버튼 배경 색상
        let backgroundColor: Color = {
            if type == .detail {
                return Color.yellow20
            }
            else {
                switch self.fruitData.colorType {
                case .yellow:
                    return Color.yellow20
                case .green:
                    return Color.green20
                case .red:
                    return Color.red20
                }
            }
        }()
                
        /// 버튼 스트로크 색상
        let strokeColor: Color = {
            if type == .detail {
                return Color.yellow100
            }
            else {
                switch self.fruitData.colorType {
                case .yellow:
                    return Color.yellow100
                case .green:
                    return Color.green80
                case .red:
                    return Color.red50
                }
            }
        }()
        
        /// 버튼 텍스트 색상
        let textColor: Color = {
            if type == .detail {
                return Color.black
            }
            else {
                switch self.fruitData.colorType {
                case .yellow:
                    return Color.black
                case .green:
                    return Color.greenDark
                case .red:
                    return Color.red100
                }
            }
        }()
        
        /// 버튼 텍스트
        let buttonText: String = type == .detail ? "상세보기" : "조각 추가하기"
        
        return HStack {
            Text(buttonText)
                .font(.subheadline)
                .fontWeight(.bold)
                .foregroundStyle(textColor)
                .padding(.vertical, 14)
                .frame(maxWidth: .infinity, alignment: .center)
                .background(
                    RoundedRectangle(cornerRadius: 40)
                        .fill(backgroundColor) // 배경색
                        .overlay(
                            RoundedRectangle(cornerRadius: 40)
                                .stroke(strokeColor, lineWidth: 2)
                        )
                )
        }
    }
}

// MARK: - Functions
extension FruitCardView {
    /// 과일 완료 여부에 따라 완료 날짜까지 포함된 날짜 텍스트 만들어주기
    func getDateText() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR") // 한국어 요일
        formatter.dateFormat = "yyyy.MM.dd"

        let startString = formatter.string(from: fruitData.startDate)
        
        if isFinished {
            // 21일 뒤 날짜 계산
            if let endDate = Calendar.current.date(byAdding: .day, value: 21, to: fruitData.startDate) {
                let endString = formatter.string(from: endDate)
                return "\(startString) ~ \(endString)"
            }
        }
        
        return "\(startString) ~"
    }
}

#Preview {
    ZStack {
        Color.gray
        
        FruitCardView(
            fruitData: .init(name: "운동하기", colorType: .red),
            isFinished: false
        )
        .padding(.horizontal, 16)
    }
}
