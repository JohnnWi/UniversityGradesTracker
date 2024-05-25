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
    
    var graduationGrade: Double {
        (weightedAverage * 11) / 3
    }
    
    var progress: Double {
        return Double(totalCredits) / 180.0
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 10) { // Spazio tra gli elementi principali ridotto
                    HStack {
                        Text("Traccia Voti")
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

                    VStack(spacing: 5) { // Spazio tra le card ridotto ulteriormente
                        InfoCard(title: "Media Ponderata", value: String(format: "%.2f", weightedAverage), color: .blue, icon: "chart.bar.fill")
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
                    .padding(.leading, 10) // Riduce il padding a sinistra
                
                VStack(alignment: .leading) {
                    Text(title)
                        .font(.headline)
                        .foregroundColor(color)
                    Text(value)
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(color)
                    if let progress = progress {
                        ProgressView(value: progress)
                            .progressViewStyle(LinearProgressViewStyle(tint: color))
                    }
                }
                .padding(.leading, 5) // Riduce il padding a sinistra
                
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
