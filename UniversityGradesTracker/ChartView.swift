import SwiftUI
import Charts

struct ChartView: View {
    @EnvironmentObject var viewModel: GradesViewModel

    var body: some View {
        Chart {
            ForEach(viewModel.grades.filter { $0.grade != 0 }) { grade in
                LineMark(
                    x: .value("Data", grade.date),
                    y: .value("Voto", grade.grade)
                )
                .foregroundStyle(grade.grade == 0 ? .red : .blue)
                .symbol(Circle())
            }
        }
        .frame(height: 250)
    }
}
