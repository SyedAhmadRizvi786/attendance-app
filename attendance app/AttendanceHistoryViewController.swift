//
//  AttendanceHistoryViewController.swift
//  attendance app
//
//  Created by Rizvi on 14/11/2024.
//
import UIKit

class AttendanceHistoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var attendanceHistory: [Attendance] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the table view's data source and delegate
        tableView.dataSource = self
        tableView.delegate = self
    }

    // Table View Data Source Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return attendanceHistory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AttendanceCell", for: indexPath)
        
        // Get the attendance record for the current row
        let attendance = attendanceHistory[indexPath.row]
        
        // Set cell title to the date and subtitle to the presence status
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        cell.textLabel?.text = dateFormatter.string(from: attendance.date)
        
        // Show if the employee is present or absent in the subtitle
        if attendance.isPresent {
            cell.detailTextLabel?.text = "Status: Present"
        } else {
            let reason = attendance.reasonForAbsence?.rawValue ?? "No Reason Provided"
            cell.detailTextLabel?.text = "Status: Absent (\(reason))"
        }
        
        return cell
    }
}
