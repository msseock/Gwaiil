//
//  FruitCardView.swift
//  Gwaiil
//
//  Created by 석민솔 on 4/19/25.
//

import SwiftData
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

    /// 오늘 추가된 조각이 있는지 확인용
    var hasAddedPieceToday: Bool {
        DateUtils.hasPiece(on: Date(), in: fruitData.pieces)
    }

    /// 카드 삭제를 위한 model context
    @Environment(\.modelContext) private var context

    /// 정말 삭제할건지 물어보는 alert
    @State var showDeleteAlert: Bool = false

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
            Text(DateUtils.getDateComponentText(startDate: fruitData.startDate))
                .font(.footnote)
                .fontWeight(.light)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 15)

            // 과일조각들 보여주는 부분
            PieceLayoutView(
                colorType: fruitData.colorType,
                count: fruitData.pieces.count
            )
            .padding(.bottom, 15)

            // 버튼 2개
            HStack(spacing: 10) {
                // 조각 추가하기 버튼
                Button {
                    showAddPieceSheet.toggle()
                } label: {
                    buttonView(
                        buttonType: .addPiece,
                        colorType: fruitData.colorType
                    )
                    .opacity(hasAddedPieceToday ? 0.5 : 1)  // 오늘 날짜에 추가된 조각이 있으면 조각 추가하기 버튼 비활성화
                }
                // 오늘 날짜에 추가된 조각이 있으면 조각 추가하기 버튼 비활성화
                .disabled(hasAddedPieceToday)

                // 상세보기 버튼
                NavigationLink {
                    DetailFruit(fruitID: fruitData.id)
                        .toolbarRole(.editor)
                } label: {
                    buttonView(
                        buttonType: .detail,
                        colorType: nil
                    )
                }
            }
        }
        .sheet(isPresented: $showAddPieceSheet) {
            // 조각 추가 모드로 sheet 띄우기
            PieceSheet(
                pieceIndex: nil,
                fruitData: fruitData
            )
            .presentationDetents([.height(220)])
        }
    }

    /// 완료된 도전 카드
    private var finishedFruitCard: some View {
        VStack(spacing: 0) {
            // 제목 바
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 0) {
                    // 과일카드 제목
                    Text(fruitData.name)
                        .font(.headline)
                        .padding(.bottom, 5)

                    // 날짜
                    Text(
                        DateUtils.getDateComponentText(
                            startDate: fruitData.startDate)
                    )
                    .font(.footnote)
                    .fontWeight(.light)
                    .padding(.bottom, 15)
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                // 얻은 과일이 없으면 삭제할 수 있는 버튼 보여주기
                if fruitData.pieces.count == 0 {
                    Button {
                        // 조각 삭제하기
                        showDeleteAlert.toggle()
                    } label: {
                        Image(systemName: "trash")
                            .foregroundStyle(.red)
                    }
                }
            }

            // 얻은 과일 보여주는 부분
            if fruitData.pieces.count == 0 {
                Text("얻은 과일이 없어요 🥲")
                    .font(.callout)
                    .foregroundStyle(Color.secondary)
                    .frame(height: 60)
                    .padding(.bottom, 10)
            } else {
                Image(
                    FruitType.getPieceByIndexNType(
                        index: fruitData.pieces.count, type: fruitData.colorType
                    ).fruitImageName
                )
                .padding(.bottom, 10)
            }

            // 상세보기 버튼
            if fruitData.pieces.count > 0 {
                NavigationLink {
                    DetailFruit(fruitID: fruitData.id)
                        .toolbarRole(.editor)
                } label: {
                    buttonView(
                        buttonType: .detail, colorType: nil
                    )
                }
            }
        }
        // MARK: 도전목표 삭제 Alert
        .alert("도전목표 삭제", isPresented: $showDeleteAlert) {
            Button("예", role: .destructive) {
                context.delete(fruitData)
            }
        } message: {
            Text("정말 목표를 삭제하시겠습니까?")
        }
    }

    /// 카드에서 사용되는 공통 규격 버튼 컴포넌트
    struct buttonView: View {
        // MARK: Properties
        /// 버튼 종류: 조각 추가하기 || 상세보기
        let buttonType: ButtonType

        /// 버튼 종류가 조각 추가하기 버튼일 경우, 과일 색상타입에 맞춰서 버튼 스타일 변경을 위해 받아오는 변수
        let colorType: FruitColorType?

        /// 버튼 배경 색상
        var backgroundColor: Color {
            if buttonType == .detail {
                return Color.yellow20
            } else {
                switch colorType! {
                case .yellow:
                    return Color.yellow20
                case .green:
                    return Color.green20
                case .red:
                    return Color.red20
                }
            }
        }

        /// 버튼 스트로크 색상
        var strokeColor: Color {
            if buttonType == .detail {
                return Color.yellow100
            } else {
                switch colorType! {
                case .yellow:
                    return Color.yellow100
                case .green:
                    return Color.green80
                case .red:
                    return Color.red50
                }
            }
        }

        /// 버튼 텍스트 색상
        var textColor: Color {
            if buttonType == .detail {
                return Color.black
            } else {
                switch colorType! {
                case .yellow:
                    return Color.black
                case .green:
                    return Color.greenDark
                case .red:
                    return Color.red100
                }
            }
        }

        /// 버튼 텍스트
        var buttonText: String {
            buttonType == .detail ? "상세보기" : "조각 추가하기"
        }

        // MARK: View
        var body: some View {
            HStack {
                Text(buttonText)
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundStyle(textColor)
                    .padding(.vertical, 14)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .background(
                        RoundedRectangle(cornerRadius: 40)
                            .fill(backgroundColor)  // 배경색
                            .overlay(
                                RoundedRectangle(cornerRadius: 40)
                                    .stroke(strokeColor, lineWidth: 2)
                            )
                    )
            }
        }
    }
}

#Preview("진행중인데 조각 없는 뷰") {
    ZStack {
        Color.gray

        FruitCardView(
            fruitData: .init(name: "운동하기", colorType: .red),
            isFinished: false
        )
        .padding(.horizontal, 16)
    }
}

#Preview("완료했는데 조각 없는 뷰") {
    ZStack {
        Color.gray

        FruitCardView(
            fruitData: .init(name: "운동하기", colorType: .red),
            isFinished: true
        )
        .padding(.horizontal, 16)
    }
}
