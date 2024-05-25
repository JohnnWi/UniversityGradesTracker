import SwiftUI
import Charts
import Foundation

struct ContentView: View {
    @EnvironmentObject var viewModel: GradesViewModel
    @AppStorage("isDarkMode") private var isDarkMode = false

    var totalCredits: Int {
        viewModel.grades.reduce(0) { $0 + $1.credits }
    }
    
    var weightedAverage: Double {
        let validGrades = viewModel.grades.filter { $0.grade > 0 }
        let totalWeightedGrades = validGrades.reduce(0) { $0 + ($1.grade * $1.credits) }
        let validCredits = validGrades.reduce(0) { $0 + $1.credits }
        return validCredits > 0 ? Double(totalWeightedGrades) / Double(validCredits) : 0.0
    }
    
    var arithmeticAverage: Double {
        let validGrades = viewModel.grades.filter { $0.grade > 0 }
        let totalGrades = validGrades.reduce(0) { $0 + $1.grade }
        let count = validGrades.count
        return count > 0 ? Double(totalGrades) / Double(count) : 0.0
    }

    var graduationGrade: Double {
        (weightedAverage * 11) / 3
    }
    
    var progress: Double {
        return Double(totalCredits) / 180.0
    }
    
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }

            GradesView()
                .tabItem {
                    Image(systemName: "book.fill")
                    Text("Materie")
                }

            SettingsView()
                .tabItem {
                    Image(systemName: "gearshape.fill")
                    Text("Impostazioni")
                }
        }
        .preferredColorScheme(isDarkMode ? .dark : .light)
    }
}

struct HomeView: View {
    @EnvironmentObject var viewModel: GradesViewModel
    
    var totalCredits: Int {
        viewModel.grades.reduce(0) { $0 + $1.credits }
    }
    
    var weightedAverage: Double {
        let validGrades = viewModel.grades.filter { $0.grade > 0 }
        let totalWeightedGrades = validGrades.reduce(0) { $0 + ($1.grade * $1.credits) }
        let validCredits = validGrades.reduce(0) { $0 + $1.credits }
        return validCredits > 0 ? Double(totalWeightedGrades) / Double(validCredits) : 0.0
    }
    
    var arithmeticAverage: Double {
        let validGrades = viewModel.grades.filter { $0.grade > 0 }
        let totalGrades = validGrades.reduce(0) { $0 + $1.grade }
        let count = validGrades.count
        return count > 0 ? Double(totalGrades) / Double(count) : 0.0
    }

    var graduationGrade: Double {
        (weightedAverage * 11) / 3
    }
    
    var progress: Double {
        return Double(totalCredits) / 180.0
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 10) {
                    HStack {
                        Text("Voti")
                            .font(.largeTitle)
                            .bold()
                            .padding(.leading)
                        Spacer()
                        NavigationLink(destination: AddGradeView()) {
                            Image(systemName: "plus.circle")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .padding(.trailing)
                        }
                    }

                    CombinedInfoCard(
                        leftTitle: "Media Ponderata",
                        leftValue: String(format: "%.2f", weightedAverage),
                        rightTitle: "Media Aritmetica",
                        rightValue: String(format: "%.2f", arithmeticAverage),
                        color: .blue
                    )
                    .padding(.horizontal)

                    VStack(spacing: 5) {
                        InfoCard(title: "CFU Totali", value: "\(totalCredits)/180 CFU", color: .green, icon: "graduationcap.fill", progress: progress)
                        InfoCard(title: "Voto di Laurea Previsione", value: String(format: "%.2f", graduationGrade), color: .purple, icon: "star.fill")
                    }
                    .padding(.horizontal)

                    ChartCard {
                        ChartView()
                            .environmentObject(viewModel)
                    }
                    .padding()
                    
                    Spacer()
                }
            }
            .navigationTitle("")
        }
    }
}

struct CombinedInfoCard: View {
    var leftTitle: String
    var leftValue: String
    var rightTitle: String
    var rightValue: String
    var color: Color
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(color.opacity(0.1))
                .frame(height: 100)
                .shadow(color: color.opacity(0.2), radius: 5, x: 0, y: 5)

            HStack {
                VStack(alignment: .leading) {
                    Text(leftTitle)
                        .font(.headline)
                        .foregroundColor(.primary)
                    Text(leftValue)
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.primary)
                }
                .padding(.leading, 10)

                Spacer()

                Divider()
                    .frame(height: 60)
                    .padding(.horizontal, 10)
                
                VStack(alignment: .leading) {
                    Text(rightTitle)
                        .font(.headline)
                        .foregroundColor(.primary)
                    Text(rightValue)
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.primary)
                }
                .padding(.trailing, 10)

                Spacer()
            }
            .padding(.vertical, 10)
        }
    }
}

struct InfoCard: View {
    var title: String
    var value: String
    var color: Color
    var icon: String
    var progress: Double? = nil
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(color.opacity(0.1))
                .frame(height: 100)
                .shadow(color: color.opacity(0.2), radius: 5, x: 0, y: 5)

            HStack {
                Image(systemName: icon)
                    .foregroundColor(color)
                    .font(.largeTitle)
                    .padding(.leading, 10)
                
                VStack(alignment: .leading) {
                    Text(title)
                        .font(.headline)
                        .foregroundColor(.primary)
                    Text(value)
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.primary)
                    if let progress = progress {
                        ProgressView(value: progress)
                            .progressViewStyle(LinearProgressViewStyle(tint: color))
                    }
                }
                .padding(.leading, 5)
                
                Spacer()
            }
            .padding(.vertical, 10)
        }
    }
}

struct ChartCard<Content: View>: View {
    var content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.gray.opacity(0.1))
                .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 5)

            content
                .padding()
        }
        .frame(height: 300)
    }
}

