//
//  Detail_TitleSectionView.swift
//  Gwaiil
//
//  Created by 석민솔 on 4/21/25.
//

import Foundation
import SwiftUI

/// 상단 제목이랑 과일 이미지 보여주는 부분
struct Detail_TitleSectionView: View {
    let fruit: FruitData
    
    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 16) {
                Text(fruit.name)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                HStack {
                    // 날짜 텍스트
                    Text(DateUtils.getDateComponentText(startDate: fruit.startDate))
                    
                    // 안끝난 챌린지면 21일 뒤까지 며칠남았나: 디데이
                    if !DateUtils.isFinishedFruit(startDate: fruit.startDate) {
                        Text(DateUtils.getDdayText(until21DaysAfter: fruit.startDate))
                            .foregroundStyle(.green)
                    }
                }
            }
            
            Spacer()
            
            Image(FruitType.getPieceByIndexNType(index: max(0, fruit.pieces.count-1), type: fruit.colorType).fruitImageName)
        }
    }
}
