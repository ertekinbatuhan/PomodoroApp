import SwiftUI

extension View {
    func actionSheetOptions(maxValue: Int, hint: String, onClick: @escaping (Int) -> ()) -> [ActionSheet.Button] {
        var buttons: [ActionSheet.Button] = (0...maxValue).map { value in
            .default(Text("\(value) \(hint)")) {
                onClick(value)
            }
        }
        buttons.append(.cancel())
        return buttons
    }

    func createActionSheet(title: String, maxValue: Int, hint: String, onClick: @escaping (Int) -> ()) -> ActionSheet {
        let buttons = actionSheetOptions(maxValue: maxValue, hint: hint, onClick: onClick)
        return ActionSheet(title: Text(title), buttons: buttons)
    }
}

