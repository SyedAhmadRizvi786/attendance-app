//import Foundation
//import UIKit
//
//struct Employee: Codable {
//    var name: String
//    var employeeID: String
//    var department: String
//    var isAcknowledge : Bool
//}
//
//// Update Attendance struct to include optional image data property
//struct Attendance: Codable {
//    var employee: Employee
//    var date: Date
//    var isPresent: Bool
//    var imageData: Data?  // Optional property to store image data
//    
//    // Custom initializer to set the image from UIImage
//    init(employee: Employee, date: Date, isPresent: Bool, image: UIImage? = nil) {
//        self.employee = employee
//        self.date = date
//        self.isPresent = isPresent
//        self.imageData = image?.pngData()  // Convert UIImage to Data
//    }
//    
//    // Helper function to retrieve the image as UIImage
//    func getImage() -> UIImage? {
//        guard let data = imageData else { return nil }
//        return UIImage(data: data)
//    }
//}
import Foundation
import UIKit

struct Employee: Codable {
    var id = UUID()
    var name: String
    var employeeID: String
    var department: Department
    var position: Position
    var hireDate: Date
    var contactNumber: String
    var email: String
    var address: String
    var profileImageData: Data?
    var employmentStatus: EmploymentStatus
    var supervisorName: String?
    var isAcknowledge: Bool
    
    // Computed property to retrieve profile image as UIImage
    func getProfileImage() -> UIImage? {
        guard let data = profileImageData else { return nil }
        return UIImage(data: data)
    }
    
    enum Department: String, Codable {
        case hr = "HR"
        case engineering = "Engineering"
        case marketing = "Marketing"
        case sales = "Sales"
        case finance = "Finance"
    }
    
    enum Position: String, Codable {
        case manager = "Manager"
        case developer = "Developer"
        case designer = "Designer"
        case analyst = "Analyst"
        case intern = "Intern"
    }
    
    enum EmploymentStatus: String, Codable {
        case fullTime = "Full-Time"
        case partTime = "Part-Time"
        case contract = "Contract"
    }
}


struct Attendance: Codable {
    var employee: Employee
    var date: Date
    var isPresent: Bool
    var checkInTime: Date?
    var checkOutTime: Date?
    var location: String?
    var reasonForAbsence: AbsenceReason?
    var imageData: Data?
    var notes: String?
    var workShift: WorkShift
    var overtimeHours: Double?
    var taskSummary: String?
    
    init(employee: Employee, date: Date, isPresent: Bool, checkInTime: Date? = nil, checkOutTime: Date? = nil, location: String? = nil, reasonForAbsence: AbsenceReason? = nil, image: UIImage? = nil, notes: String? = nil, workShift: WorkShift, overtimeHours: Double? = nil, taskSummary: String? = nil) {
        self.employee = employee
        self.date = date
        self.isPresent = isPresent
        self.checkInTime = checkInTime
        self.checkOutTime = checkOutTime
        self.location = location
        self.reasonForAbsence = reasonForAbsence
        self.imageData = image?.pngData()
        self.notes = notes
        self.workShift = workShift
        self.overtimeHours = overtimeHours
        self.taskSummary = taskSummary
    }
    
    func getImage() -> UIImage? {
        guard let data = imageData else { return nil }
        return UIImage(data: data)
    }
    
    enum AbsenceReason: String, Codable {
        case sick = "Sick"
        case vacation = "Vacation"
        case personal = "Personal"
        case bereavement = "Bereavement"
        case other = "Other"
    }
    
    enum WorkShift: String, Codable {
        case morning = "Morning"
        case afternoon = "Afternoon"
        case night = "Night"
        case flexible = "Flexible"
    }
}
