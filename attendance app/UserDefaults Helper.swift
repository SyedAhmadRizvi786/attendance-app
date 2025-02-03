import Foundation

//class UserDefaultsHelper {
//    static let shared = UserDefaultsHelper()
//    
//    private let attendanceKey = "attendanceList"
//    
//    // Save attendance list to UserDefaults
//    func saveAttendance(_ attendanceList: [Attendance]) {
//        do {
//            let data = try JSONEncoder().encode(attendanceList)
//            UserDefaults.standard.set(data, forKey: attendanceKey)
//        } catch {
//            print("Failed to encode attendance list:", error)
//        }
//    }
//    
//    // Retrieve attendance list from UserDefaults
//    func getAttendance() -> [Attendance] {
//        guard let data = UserDefaults.standard.data(forKey: attendanceKey) else { return [] }
//        do {
//            return try JSONDecoder().decode([Attendance].self, from: data)
//        } catch {
//            print("Failed to decode attendance list:", error)
//            return []
//        }
//    }
//    
//    // Delete a specific attendance record from UserDefaults
//    func deleteAttendance(at index: Int) {
//        var attendanceList = getAttendance()
//        guard index < attendanceList.count else { return }
//        attendanceList.remove(at: index)
//        saveAttendance(attendanceList)
//    }
//}
//import Foundation
//
//class UserDefaultsHelper {
//    static let shared = UserDefaultsHelper()
//    
//    private let attendanceKey = "attendanceList"
//    private let employeesKey = "employeesList"  // New key for employees
//    
//    // MARK: - Attendance Methods
//    
//    // Save attendance list to UserDefaults
//    func saveAttendance(_ attendanceList: [Attendance]) {
//        do {
//            let data = try JSONEncoder().encode(attendanceList)
//            UserDefaults.standard.set(data, forKey: attendanceKey)
//        } catch {
//            print("Failed to encode attendance list:", error)
//        }
//    }
//    
//    // Retrieve attendance list from UserDefaults
//    func getAttendance() -> [Attendance] {
//        guard let data = UserDefaults.standard.data(forKey: attendanceKey) else { return [] }
//        do {
//            return try JSONDecoder().decode([Attendance].self, from: data)
//        } catch {
//            print("Failed to decode attendance list:", error)
//            return []
//        }
//    }
//    
//    // Delete a specific attendance record from UserDefaults
//    func deleteAttendance(at index: Int) {
//        var attendanceList = getAttendance()
//        guard index < attendanceList.count else { return }
//        attendanceList.remove(at: index)
//        saveAttendance(attendanceList)
//    }
//    
//    // MARK: - Employee Methods
//    
//    // Save an individual employee to UserDefaults
//    func saveEmployee(_ employee: Employee) {
//        var employees = getEmployees()
//        
//        // Check if employee already exists, and update it
//        if let index = employees.firstIndex(where: { $0.employeeID == employee.employeeID }) {
//            employees[index] = employee
//        } else {
//            employees.append(employee)
//        }
//        
//        do {
//            let data = try JSONEncoder().encode(employees)
//            UserDefaults.standard.set(data, forKey: employeesKey)
//        } catch {
//            print("Failed to encode employee list:", error)
//        }
//    }
//    
//    // Retrieve the list of all employees from UserDefaults
//    func getEmployees() -> [Employee] {
//        guard let data = UserDefaults.standard.data(forKey: employeesKey) else { return [] }
//        do {
//            return try JSONDecoder().decode([Employee].self, from: data)
//        } catch {
//            print("Failed to decode employee list:", error)
//            return []
//        }
//    }
//    
//    // Retrieve a specific employee by employee ID
//    func getEmployee(by employeeID: String) -> Employee? {
//        return getEmployees().first { $0.employeeID == employeeID }
//    }
//}
import Foundation

class UserDefaultsHelper {
    static let shared = UserDefaultsHelper()
    
    private let attendanceKey = "attendanceList"
    private let employeesKey = "employeesList"
    private let employeeNamesKey = "employeeNames"
    
    // MARK: - Attendance Methods
    
    // Save attendance list to UserDefaults
    func saveAttendance(_ attendanceList: [Attendance]) {
        do {
            let data = try JSONEncoder().encode(attendanceList)
            UserDefaults.standard.set(data, forKey: attendanceKey)
            
            // Extract employee names and save them to `employeeNamesKey`
            let employeeNames = attendanceList.map { $0.employee.name }
            UserDefaults.standard.set(employeeNames, forKey: employeeNamesKey)
        } catch {
            print("Failed to encode attendance list:", error)
        }
    }
    
    // Retrieve attendance list from UserDefaults
    func getAttendance() -> [Attendance] {
        guard let data = UserDefaults.standard.data(forKey: attendanceKey) else { return [] }
        do {
            return try JSONDecoder().decode([Attendance].self, from: data)
        } catch {
            print("Failed to decode attendance list:", error)
            return []
        }
    }
    
    // Delete a specific attendance record from UserDefaults
    func deleteAttendance(at index: Int) {
        var attendanceList = getAttendance()
        guard index < attendanceList.count else { return }
        attendanceList.remove(at: index)
        saveAttendance(attendanceList)
    }
    
    // MARK: - Employee Methods
    
    // Save an individual employee to UserDefaults
    func saveEmployee(_ employee: Employee) {
        var employees = getEmployees()
        
        // Check if employee already exists, and update it
        if let index = employees.firstIndex(where: { $0.employeeID == employee.employeeID }) {
            employees[index] = employee
        } else {
            employees.append(employee)
        }
        
        do {
            let data = try JSONEncoder().encode(employees)
            UserDefaults.standard.set(data, forKey: employeesKey)
            
            // Update employee names as well
            let employeeNames = employees.map { $0.name }
            UserDefaults.standard.set(employeeNames, forKey: employeeNamesKey)
        } catch {
            print("Failed to encode employee list:", error)
        }
    }
    
    // Retrieve the list of all employees from UserDefaults
    func getEmployees() -> [Employee] {
        guard let data = UserDefaults.standard.data(forKey: employeesKey) else { return [] }
        do {
            return try JSONDecoder().decode([Employee].self, from: data)
        } catch {
            print("Failed to decode employee list:", error)
            return []
        }
    }
    
    // Retrieve a specific employee by employee ID
    func getEmployee(by employeeID: String) -> Employee? {
        return getEmployees().first { $0.employeeID == employeeID }
    }
    
    // Retrieve employee names from UserDefaults
    func getEmployeeNames() -> [String] {
        return UserDefaults.standard.stringArray(forKey: employeeNamesKey) ?? []
    }
}

