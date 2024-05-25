import SwiftUI

struct AddGradeView: View {
    @State private var subjectName: String = ""
    @State private var grade: String = ""
    @State private var credits: String = ""
    @State private var date: Date = Date()
    @State private var professor: String = ""
    @State private var notes: String = ""
    
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    @EnvironmentObject var viewModel: GradesViewModel
    
    var body: some View {
        Form {
            Section(header: Text("Dettagli Materia")) {
                TextField("Nome Materia", text: $subjectName)
                
                TextField("Voto (0 = Idoneo, 31 = Lode)", text: $grade)
                    .keyboardType(.numberPad)
                
                TextField("CFU", text: $credits)
                    .keyboardType(.numberPad)
                
                DatePicker("Data", selection: $date, displayedComponents: .date)
                
                TextField("Professore", text: $professor)
                
                TextField("Note", text: $notes)
            }
            
            Button(action: {
                if let gradeInt = Int(grade), let creditsInt = Int(credits), !subjectName.isEmpty {
                    viewModel.addGrade(subjectName: subjectName, grade: gradeInt, credits: creditsInt, date: date, professor: professor, notes: notes)
                    alertMessage = "Materia salvata con successo!"
                    showAlert = true
                    // Resetta i campi dopo il salvataggio
                    subjectName = ""
                    grade = ""
                    credits = ""
                    professor = ""
                    notes = ""
                } else {
                    alertMessage = "Assicurati di aver inserito tutti i campi correttamente."
                    showAlert = true
                }
            }) {
                Text("Salva Materia")
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
        }
        .navigationTitle("Aggiungi Materia")
    }
}
