//
//  FruitSheet.swift
//  Gwaiil
//
//  Created by 석민솔 on 4/19/25.
//

import SwiftUI
import SwiftData

/// 목표 과일 추가 및 수정하는 sheet
struct FruitSheet: View {
    // MARK: - Properties
    /// 수정 시, 필요한 과일정보
    let fruit: FruitData?
    
    /// sheet 제목
    private var editorTitle: String {
        fruit == nil ? "도전 과일 만들기" : "도전 과일 수정"
    }
    
    /// 작성 || 수정할 목표 이름
    @State private var name: String = ""
    /// 작성 || 수정할 과일 세트 색상
    @State private var selectedColorType: FruitColorType = .yellow
    
    /// swiftdata model context
    @Environment(\.modelContext) private var context
    /// sheet 화면 없애기용
    @Environment(\.dismiss) private var dismiss
    
    // MARK: - View
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 8) {
                // MARK: 목표 이름 입력 섹션
                Text("목표 정하기")
                    .font(.title3)
                    .fontWeight(.semibold)
                
                Text("21일 동안 도전할 목표를 만들어봅시다!")
                
                HStack {
                    Text("이름")
                        .frame(width: 100, alignment: .leading)
                    
                    TextField("도전의 이름을 알려주세요", text: $name)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 11)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(.white)
                )
                .padding(.bottom, 22)
                
                // MARK: 과일 색상 입력 섹션
                HStack {
                    Text("과일 세트 색상 선택하기")
                        .font(.title3)
                        .fontWeight(.semibold)
                    
                    Spacer()
                    
                    Picker("색상", selection: $selectedColorType) {
                        ForEach(FruitColorType.allCases, id: \.self) { colorType in
                            Text(colorType.rawValue)
                        }
                    }
                }
                
                SelectedFruitSetCard(colorType: selectedColorType)
                    .animation(.bouncy, value: selectedColorType)
                
                Spacer()
            }
            .padding([.top, .horizontal])
            .background(Color(.systemGray6).ignoresSafeArea())
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
                    .disabled(name.isEmpty)
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
                if let fruit {
                    name = fruit.name
                    selectedColorType = fruit.colorType
                }
            }
        }
    }
}

// MARK: - View Components
extension FruitSheet {
    /// 선택된 색상타입에 맞는 과일 3종 보여주는 뷰
    struct SelectedFruitSetCard: View {
        let colorType: FruitColorType
        
        var body: some View {
            HStack(alignment: .bottom, spacing: 30) {
                ForEach(0..<3) { level in
                    Image(FruitType.getPieceByLevelNType(level: level, type: colorType).fruitImageName)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: 140, alignment: .center)
            .padding(.vertical, 20)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(.white)
            )
            
            Text("조각을 모을수록 큰 과일이 돼요")
                .font(.subheadline)
                .frame(maxWidth: .infinity, alignment: .center)
        }
    }
}

// MARK: - Methods
extension FruitSheet {
    /// sheet의 완료 버튼 눌렀을 때 경우에 따라 수정 또는 추가해주기
    private func save() {
        if let fruit {
            // 과일정보 수정
            fruit.name = name
            fruit.colorType = selectedColorType
        } else {
            // 과일 추가
            let newFruit = FruitData(name: name, colorType: selectedColorType)
            context.insert(newFruit)
        }
    }
}

#Preview {
    FruitSheet(fruit: nil)
}
