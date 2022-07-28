import SwiftUI
import UIKit

struct Progress: View {
    var width: CGFloat = 319
    var height: CGFloat = 7
    var percentage: CGFloat = 69
    var body: some View {
        let multiplier = width / 100
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: height, style: .continuous)
                .frame(width: width, height: height)
            .foregroundColor(Color.black.opacity(0.5))
            RoundedRectangle(cornerRadius: height, style: .continuous)
                    .frame(width: percentage * multiplier, height: height)
                    .foregroundColor(.blue)
           
        }
    }
}

struct Progress_Previews: PreviewProvider {
    static var previews: some View {
        Progress()
    }
}
