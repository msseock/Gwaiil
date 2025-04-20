//
//  Home.swift
//  Gwaiil
//
//  Created by 석민솔 on 4/19/25.
//

import SwiftData
import SwiftUI

/// 메인 홈화면
struct Home: View {
    // MARK: - Properties
    /// model context
    @Environment(\.modelContext) private var context

    /// 전체 도전 데이터
    @Query var allFruits: [FruitData]

    /// 진행 중인 도전
    var ongoingFruits: [FruitData] {
        let fruits =
            allFruits
            .filter { !DateUtils.isFinishedFruit(startDate: $0.startDate) }
            .sorted {
                $0.pieces.last?.date ?? $0.startDate > $1.pieces.last?.date
                    ?? $1.startDate
            }

        return fruits
    }

    /// 완료한 도전
    var finishedFruits: [FruitData] {
        let fruits =
            allFruits
            .filter { DateUtils.isFinishedFruit(startDate: $0.startDate) }
            .sorted { $0.startDate > $1.startDate }

        return fruits
    }

    /// 도전 과일 만들기 sheet 띄우기용
    @State var showAddFruitSheet: Bool = false

    // MARK: - View
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    TitleBar(showAddFruitSheet: $showAddFruitSheet)

                    // 아무런 도전도 추가되어 있지 않을 때
                    if ongoingFruits.isEmpty && finishedFruits.isEmpty {
                        NoFruitsView()
                    } else {
                        // 진행 중인 도전이 있을 때
                        if !ongoingFruits.isEmpty {
                            FruitCardListView(
                                isForFinishedFruit: false,
                                fruitData: ongoingFruits)
                        }

                        // 완료한 도전이 있을 때
                        if !finishedFruits.isEmpty {
                            FruitCardListView(
                                isForFinishedFruit: true,
                                fruitData: finishedFruits)
                        }
                    }
                }
                .padding([.top, .horizontal], 16)
            }
            .background(Color(.systemGray6).ignoresSafeArea())
            .sheet(isPresented: $showAddFruitSheet) {
                FruitSheet(fruit: nil)
                    .presentationDetents([.height(500)]) // 화면 전체 말고 필요한 만큼만 올라오도록 설정
            }
        }
    }
}

// MARK: - View Components
extension Home {
    /// 홈화면 상단 바
    struct TitleBar: View {
        /// 도전 과일 만들기 sheet 띄우기용
        @Binding var showAddFruitSheet: Bool

        var body: some View {
            HStack {
                Spacer()

                // 추가 레몬 버튼
                Button {
                    showAddFruitSheet.toggle()

                } label: {
                    Image("lemonPlusButton")
                        .shadow(
                            color: .black.opacity(0.2), radius: 2, x: 0, y: 0)
                }
            }
        }
    }

    /// 추가되어 있는 과일이 없을 때의 뷰
    struct NoFruitsView: View {
        var body: some View {
            Text("🍋\n레몬을 눌러서\n새로운 도전을 시작해보세요")
                .foregroundStyle(Color(UIColor.secondaryLabel))
                .multilineTextAlignment(.center)
                .padding(.top, 50)
        }
    }

    /// 제목 & 과일카드 리스트뷰
    struct FruitCardListView: View {
        /// 완료한 도전리스트 모드인지 체크
        let isForFinishedFruit: Bool
        
        /// 리스트에 띄워줄 데이터
        let fruitData: [FruitData]

        /// 제목 텍스트
        var listTitle: String {
            isForFinishedFruit ? "완료한 도전" : "진행 중인 도전"
        }

        var body: some View {
            VStack(spacing: 16) {
                Text(listTitle)
                    .font(.title)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 4)
                
                ForEach(fruitData) { fruitData in
                    FruitCardView(
                        fruitData: fruitData, isFinished: isForFinishedFruit)
                }
            }
        }
    }
}

#Preview {
    Home()
}
