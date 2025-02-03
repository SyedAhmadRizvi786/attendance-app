
import UIKit

class EmployeeDetailViewController: UIViewController {
    
    // UI Outlets
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var employeeIDLabel: UILabel!
    @IBOutlet weak var departmentLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var positionLabel: UILabel!
    @IBOutlet weak var EmploymentStatusLabel: UILabel!
    @IBOutlet weak var AbsenceReasonLabel: UILabel!
    @IBOutlet weak var WorkShiftLabel: UILabel!
    
    // Employee and Attendance Data
    var employee: Employee?
    var attendanceHistory: [Attendance] = []
    var index: Int = 0
    
    @IBOutlet weak var AttendanceHistoryButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load employee details and attendance history
        loadEmployeeDetails()
        loadAttendanceHistory()
    }
    
    func loadEmployeeDetails() {
        guard let employee = employee else { return }
        
        // Set employee information labels
        nameLabel.text = "Name: \(employee.name)"
        employeeIDLabel.text = "ID: \(employee.employeeID)"
        departmentLabel.text = "Dept: \(employee.department)"
        positionLabel.text = "Position: \(employee.position)"
        EmploymentStatusLabel.text = "Employment Status: \(employee.employmentStatus.rawValue)"
        
        // Check if the employee has an absence reason and set the label
        if let firstAttendance = attendanceHistory.first {
            AbsenceReasonLabel.text = "Absence Reason: \(firstAttendance.reasonForAbsence?.rawValue ?? "None")"
            WorkShiftLabel.text = "Work Shift: \(firstAttendance.workShift.rawValue)"
        } else {
            AbsenceReasonLabel.text = "Absence Reason: None"
            WorkShiftLabel.text = "Work Shift: Not Assigned"
        }
        
        // Set the profile image based on attendance or use placeholder
        if let firstAttendance = attendanceHistory.first, let image = firstAttendance.getImage() {
            profileImageView.image = image
        } else {
            profileImageView.image = UIImage(named: "profile_placeholder") // Placeholder image
        }
    }
    
    func loadAttendanceHistory() {
        guard let employee = employee else { return }
        
        // Get all attendance records and filter by employee's ID
        let allRecords = UserDefaultsHelper.shared.getAttendance()
        attendanceHistory = allRecords.filter { $0.employee.employeeID == employee.employeeID }
    }
    @IBAction func attendanceHistoryTapped(_ sender: UIBarButtonItem) {
        // Navigate to AttendanceHistoryViewController
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let attendanceHistoryVC = storyboard.instantiateViewController(withIdentifier: "AttendanceHistoryViewController") as? AttendanceHistoryViewController {
            attendanceHistoryVC.attendanceHistory = attendanceHistory // Pass the data
            navigationController?.pushViewController(attendanceHistoryVC, animated: true)
        }
    }

}


