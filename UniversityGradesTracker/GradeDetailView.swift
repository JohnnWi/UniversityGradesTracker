import SwiftUI

struct GradeDetailView: View {
    @EnvironmentObject var viewModel: GradesViewModel
    @State private var grade: Grade
    
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    init(grade: Grade) {
        _grade = State(initialValue: grade)
    }
    
    var body: some View {
        Form {
            Section(header: Text("Dettagli Materia")) {
                TextField("Nome Materia", text: $grade.subjectName)
                
                TextField("Voto", value: $grade.grade, format: .number)
                    .keyboardType(.numberPad)
                
                TextField("CFU", value: $grade.credits, format: .number)
                    .keyboardType(.numberPad)
                
                DatePicker("Data", selection: $grade.date, displayedComponents: .date)
                
                TextField("Professore", text: $grade.professor)
                
                TextField("Note", text: $grade.notes)
            }
            
            Button(action: {
                if let index = viewModel.grades.firstIndex(where: { $0.id == grade.id }) {
                    viewModel.grades[index] = grade
                    alertMessage = "Materia modificata con successo!"
                    showAlert = true
                }
            }) {
                Text("Salva Modifiche")
                    .font(.title2)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Risultato"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
            
            Button(action: {
                if let index = viewModel.grades.firstIndex(where: { $0.id == grade.id }) {
                    viewModel.grades.remove(at: index)
                    alertMessage = "Materia eliminata con successo!"
                    showAlert = true
                }
            }) {
                Text("Elimina Materia")
                    .font(.title2)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
        }
        .navigationTitle("Dettagli Materia")
    }
}
