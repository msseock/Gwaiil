//
//  WrapLayout.swift
//  Gwaiil
//
//  Created by 석민솔 on 4/19/25.
//

import SwiftUI

/// 7개 과일을 한 줄에 배치하고 다음 줄로 넘어가는 레이아웃
struct WrapLayout: Layout {
    var alignment: Alignment = .center
    var itemsPerRow: Int = 7

    /// 레이아웃 전체 크기(너비, 높이) 정해주기
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        guard let containerWidth = proposal.width else { return .zero }

        let horizontalSpacing = calculateSpacing(for: containerWidth)
        let itemWidth = calculateItemWidth(containerWidth: containerWidth, horizontalSpacing: horizontalSpacing)
        let proposedSize = ProposedViewSize(width: itemWidth, height: nil)

        var totalHeight: CGFloat = 0
        var currentRowMaxHeight: CGFloat = 0

        for (index, subview) in subviews.enumerated() {
            let size = subview.sizeThatFits(proposedSize)
            currentRowMaxHeight = max(currentRowMaxHeight, size.height)

            if (index + 1) % itemsPerRow == 0 || index == subviews.count - 1 {
                totalHeight += currentRowMaxHeight
                if index < subviews.count - 1 {
                    totalHeight += horizontalSpacing
                }
                currentRowMaxHeight = 0
            }
        }

        return CGSize(width: containerWidth, height: totalHeight)
    }

    /// 실제 뷰마다 위치 할당해주기
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let containerWidth = bounds.width
        let spacing = calculateSpacing(for: containerWidth)
        let itemWidth = calculateItemWidth(containerWidth: containerWidth, horizontalSpacing: spacing)
        let proposedSize = ProposedViewSize(width: itemWidth, height: nil)

        var originY = bounds.minY
        var index = 0

        while index < subviews.count {
            let endIndex = min(index + itemsPerRow, subviews.count)
            let rowSubviews = subviews[index..<endIndex]

            let rowHeights = rowSubviews.map { $0.sizeThatFits(proposedSize).height }
            let rowMaxHeight = rowHeights.max() ?? 0

            let rowItemCount = rowSubviews.count
            let totalRowWidth = CGFloat(rowItemCount) * itemWidth + CGFloat(rowItemCount - 1) * spacing

            let startX: CGFloat
            switch alignment {
            case .center:
                startX = bounds.minX + (containerWidth - totalRowWidth) / 2
            case .trailing:
                startX = bounds.maxX - totalRowWidth
            default:
                startX = bounds.minX
            }

            var originX = startX
            for subview in rowSubviews {
                subview.place(at: CGPoint(x: originX, y: originY), proposal: proposedSize)
                originX += itemWidth + spacing
            }

            originY += rowMaxHeight + spacing
            index = endIndex
        }
    }

    /// spacing을 화면 크기에 따라 12~15 사이로 조절
    private func calculateSpacing(for width: CGFloat) -> CGFloat {
        let minSpacing: CGFloat = 12
        let maxSpacing: CGFloat = 15
        let minWidth: CGFloat = 320
        let maxWidth: CGFloat = 600

        let clampedWidth = min(max(width, minWidth), maxWidth)
        let ratio = (clampedWidth - minWidth) / (maxWidth - minWidth)

        return minSpacing + (maxSpacing - minSpacing) * ratio
    }

    /// 화면 크기에 따라 7개 아이템 자체의 크기 조정
    private func calculateItemWidth(containerWidth: CGFloat, horizontalSpacing: CGFloat) -> CGFloat {
        let totalSpacing = CGFloat(itemsPerRow - 1) * horizontalSpacing
        return (containerWidth - totalSpacing) / CGFloat(itemsPerRow)
    }
}
