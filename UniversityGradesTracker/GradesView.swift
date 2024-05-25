import SwiftUI
import Foundation

struct GradesView: View {
    @EnvironmentObject var viewModel: GradesViewModel
    @State private var isEditing = false
    @State private var showDeleteAlert = false
    @State private var selectedGrades = Set<UUID>()

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    ForEach(viewModel.grades) { grade in
                        GradeCard(grade: grade, isSelected: selectedGrades.contains(grade.id))
                            .onTapGesture {
                                if isEditing {
                                    if selectedGrades.contains(grade.id) {
                                        selectedGrades.remove(grade.id)
                                    } else {
                                        selectedGrades.insert(grade.id)
                                    }
                                }
                            }
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical)
                .navigationTitle("Materie")
                .toolbar {
                    ToolbarItemGroup(placement: .navigationBarTrailing) {
                        Button(action: {
                            isEditing.toggle()
                            if !isEditing {
                                selectedGrades.removeAll()
                            }
                        }) {
                            Text(isEditing ? "Done" : "Edit")
                        }
                        
                        NavigationLink(destination: AddGradeView()) {
                            Image(systemName: "plus.circle")
                                .resizable()
                                .frame(width: 20, height: 20)
                        }
                    }
                    ToolbarItem(placement: .navigationBarLeading) {
                        if isEditing {
                            Button(action: {
                                showDeleteAlert = true
                            }) {
                                Image(systemName: "trash")
                            }
                        }
                    }
                }
                .alert(isPresented: $showDeleteAlert) {
                    Alert(
                        title: Text("Conferma Eliminazione"),
                        message: Text("Sei sicuro di voler eliminare le materie selezionate?"),
                        primaryButton: .destructive(Text("Elimina")) {
                            viewModel.deleteGrades(withIDs: Array(selectedGrades))
                            selectedGrades.removeAll()
                            isEditing = false
                        },
                        secondaryButton: .cancel()
                    )
                }
            }
        }
    }
}

struct GradeCard: View {
    @EnvironmentObject var viewModel: GradesViewModel
    var grade: Grade
    var isSelected: Bool
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.gray.opacity(isSelected ? 0.3 : 0.1))
                .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 5)

            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 5) {
                    Text(grade.subjectName)
                        .font(.title2) // Aumenta la dimensione del nome della materia
                        .bold()
                        .foregroundColor(.blue)
                    Text("Data: \(grade.date, formatter: dateFormatter)")
                        .foregroundColor(.gray)
                    if !grade.professor.isEmpty {
                        Text("Professore: \(grade.professor)")
                            .foregroundColor(.gray)
                    }
                    if !grade.notes.isEmpty {
                        Text("Note: \(grade.notes)")
                            .foregroundColor(.gray)
                    }
                }
                .padding(.leading, 10)
                .padding(.vertical, 10)
                
                Spacer()
                
                VStack {
                    Text(grade.grade == 0 ? "Id" : "\(grade.grade)")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(grade.grade == 0 ? .red : .blue)
                    Text("\(grade.credits) CFU")
                        .font(.headline)
                        .bold()
                        .foregroundColor(.green)
                }
                .padding(.trailing, 10)
                .padding(.top, 10)
            }
            .padding(.horizontal, 10) // Riduce il padding orizzontale
            .padding(.vertical, 10) // Riduce il padding verticale
        }
    }
}

extension GradesViewModel {
    func deleteGrades(withIDs ids: [UUID]) {
        grades.removeAll { ids.contains($0.id) }
    }
}
