import Foundation

struct Grade: Identifiable {
    let id = UUID()
    var subjectName: String
    var grade: Int
    var credits: Int
    var date: Date
    var professor: String
    var notes: String

    var isPassed: Bool {
        return grade == 0
    }
}

class GradesViewModel: ObservableObject {
    @Published var grades: [Grade] = []
    
    func addGrade(subjectName: String, grade: Int, credits: Int, date: Date, professor: String, notes: String) {
        let newGrade = Grade(subjectName: subjectName, grade: grade, credits: credits, date: date, professor: professor, notes: notes)
        grades.append(newGrade)
    }
    
    func updateGrade(grade: Grade, newSubjectName: String, newGrade: Int, newCredits: Int, newDate: Date, newProfessor: String, newNotes: String) {
        if let index = grades.firstIndex(where: { $0.id == grade.id }) {
            grades[index].subjectName = newSubjectName
            grades[index].grade = newGrade
            grades[index].credits = newCredits
            grades[index].date = newDate
            grades[index].professor = newProfessor
            grades[index].notes = newNotes
        }
    }
}
