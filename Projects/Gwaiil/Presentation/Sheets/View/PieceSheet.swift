//
//  PieceSheet.swift
//  Gwaiil
//
//  Created by 석민솔 on 4/19/25.
//

import SwiftUI

/// 과일 조각 추가 및 수정하는 sheet
struct PieceSheet: View {
    // MARK: - Properties
    /// 과일조각 배열에서 수정할 조각의 인덱스
    /// - 수정 시에 사용할 값. 생성 시에는 nil로 입력해주면 됩니다.
    let pieceIndex: Int?
    
    /// 수정 시, 필요한 조각 정보
    var piece: PieceData? {
        if let pieceIndex {
            return fruitData.pieces[pieceIndex]
        } else { return nil }
    }

    /// 조각이 속해있는 과일 정보
    let fruitData: FruitData

    /// sheet 제목
    private var editorTitle: String {
        pieceIndex == nil ? "과일조각 추가" : "과일조각 수정"
    }

    /// 수정할 수 있는 날짜인지 확인하고 경고 메시지 띄워주기
    /// - piece 배열에 저장되어 있는 날짜 중에 동일한 날짜가 있으면 수정 불가능한 날짜
    var isItOkayToChangeDate: Bool {
        // 수정모드
        if let piece {
            // 기존 날짜랑 같은 날짜면 오케이
            if DateUtils.isSameDay(date1: piece.date, date2: selectedDate) {
                return true
            }
            // 다른 날짜면 조각 배열에 이미 등록된 날짜 있는지 체크
            else {
                let hasPieceOnSameDay = DateUtils.hasPiece(on: selectedDate, in: fruitData.pieces)
                return !hasPieceOnSameDay
            }
        }
        // 생성모드
        else {
            // 조각 배열에 이미 등록된 날짜 있는지 체크
            let hasPieceOnSameDay = DateUtils.hasPiece(on: selectedDate, in: fruitData.pieces)
            return !hasPieceOnSameDay
        }
    }

    /// 작성 || 수정할 활동 이름
    @State private var text: String = ""
    /// 작성 || 수정할 활동 날짜
    @State private var selectedDate: Date = Date()

    /// swiftdata model context
    @Environment(\.modelContext) private var context
    /// sheet 화면 없애기용
    @Environment(\.dismiss) private var dismiss

    // MARK: - View
    var body: some View {
        NavigationStack {
            VStack {
                // 활동기록이랑 일시 기록
                InputForm(
                    text: $text,
                    selectedDate: $selectedDate,
                    startDate: fruitData.startDate
                )

                // MARK: 경고메시지
                // 등록하려는 날짜에 이미 기존 기록이 있으면 변경 불가능하다는 메시지 띄워주기
                Text("이미 기록이 있는 날이에요")
                    .font(.subheadline)
                    .foregroundStyle(Color.red100)
                    .opacity(isItOkayToChangeDate ? 0 : 1)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .animation(.easeInOut, value: isItOkayToChangeDate)

                Spacer()

            }
            .padding(.horizontal)
            .background(Color(.systemGray6)/*.ignoresSafeArea()*/)
            // MARK: 상단바
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(editorTitle)
                        .fontWeight(.semibold)
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("완료") {
                        withAnimation {
                            save()
                            dismiss()
                        }
                    }
                    // Require a category to save changes.
                    .disabled(text.isEmpty || !isItOkayToChangeDate)
                }

                ToolbarItem(placement: .cancellationAction) {
                    Button("취소", role: .cancel) {
                        dismiss()
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                // 수정모드일 때 기존값 입력되도록
                if let piece {
                    text = piece.text
                    selectedDate = piece.date
                }
            }
        }

    }
}

// MARK: - View Components
extension PieceSheet {
    /// 활동기록이랑 일시 기록하는 뷰
    struct InputForm: View {
        /// 작성 || 수정할 활동 이름
        @Binding var text: String
        /// 작성 || 수정할 활동 날짜
        @Binding var selectedDate: Date

        /// 목표 도전 시작일
        let startDate: Date

        /// startDate부터 해당하는 날 사이의 dateRange
        var dateRange: ClosedRange<Date> {
            let min = startDate
            let max = Date()

            return min...max
        }

        var body: some View {
            VStack(spacing: 0) {
                // MARK: 활동내역
                TextField("어떤 활동을 했는지 기록해보세요", text: $text)
                    .padding(.vertical, 11)

                Divider()
                    .padding(.trailing, -16)

                // MARK: 날짜 기록
                DatePicker(
                    "일시",
                    selection: $selectedDate,
                    in: dateRange
                )
                .padding(.vertical, 5)
            }
            .padding(.horizontal, 16)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.white)
            )
        }
    }
}

// MARK: - Methods
extension PieceSheet {
    /// sheet의 완료 버튼 눌렀을 때 경우에 따라 수정 또는 추가해주기
    private func save() {
        if let piece {
            // 조각 정보 수정
            piece.text = text
            piece.date = selectedDate
            
            print("pieces 배열")
            for piece in fruitData.pieces {
                print(piece.date, piece.text)
            }
        } else {
            // 조각 정보 추가
            let newPiece = PieceData(text: text, date: selectedDate)
            fruitData.pieces.append(newPiece)
        }
    }
}

#Preview {
    PieceSheet(
        pieceIndex: nil,
        fruitData: FruitData(name: "name", colorType: .yellow)
    )
}
