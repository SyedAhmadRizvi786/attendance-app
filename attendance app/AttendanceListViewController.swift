//
//  AttendanceListViewController.swift
//  attendance app
//
//  Created by Rizvi MacOs on 04/11/2024.
//
import UIKit

class AttendanceListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!

    
    var attendanceList: [Attendance] = []
    var filteredAttendanceList: [Attendance] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        
        loadAttendance()
        
        // Add observer to reload table data when acknowledgment is updated
        NotificationCenter.default.addObserver(self, selector: #selector(loadAttendance), name: NSNotification.Name("AcknowledgmentUpdated"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTableView), name: NSNotification.Name("ReloadTableView"), object: nil)
    }
    
    @objc func reloadTableView() {
        loadAttendance()
    }
    
    @IBAction func addAttendance(_ sender: Any) {
        let addVC = storyboard?.instantiateViewController(withIdentifier: "AddAttendanceViewController") as! AddAttendanceViewController
        navigationController?.pushViewController(addVC, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadAttendance()
    }
    
    @objc func loadAttendance() {
        attendanceList = UserDefaultsHelper.shared.getAttendance()
        filteredAttendanceList = attendanceList
        tableView.reloadData()
    }
    
    // MARK: - TableView DataSource Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredAttendanceList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AttendanceCell", for: indexPath) as! AttendanceListTableViewCell
        let attendance = filteredAttendanceList[indexPath.row]
        
        // Configure cell with attendance data
        cell.configure(with: attendance)
        
        return cell
    }
    
    // MARK: - TableView Edit and Delete Actions
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let editAction = UIContextualAction(style: .normal, title: "Edit") { [weak self] (action, view, completionHandler) in
            let editVC = self?.storyboard?.instantiateViewController(withIdentifier: "EditAttendanceViewController") as! EditAttendanceViewController
            editVC.attendance = self?.filteredAttendanceList[indexPath.row]
            editVC.index = indexPath.row
            self?.navigationController?.pushViewController(editVC, animated: true)
            completionHandler(true)
        }
        editAction.backgroundColor = UIColor(hex: "#D2B48C")
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (action, view, completionHandler) in
            UserDefaultsHelper.shared.deleteAttendance(at: indexPath.row)
            self?.loadAttendance()
            completionHandler(true)
        }
        deleteAction.backgroundColor = UIColor(hex: "#FF7F7F")
        
        return UISwipeActionsConfiguration(actions: [editAction, deleteAction])
    }
    
    // MARK: - Navigation on Row Selection
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let attendance = filteredAttendanceList[indexPath.row]
        
        // Instantiate EmployeeDetailViewController programmatically
        let detailVC = storyboard?.instantiateViewController(identifier: "EmployeeDetailViewController") as! EmployeeDetailViewController
        detailVC.employee = attendance.employee
        detailVC.attendanceHistory = [attendance]
        
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    // MARK: - SearchBar Delegate Methods
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredAttendanceList = searchText.isEmpty ? attendanceList : attendanceList.filter { $0.employee.name.lowercased().contains(searchText.lowercased()) }
        tableView.reloadData()
    }
}

// MARK: - UIColor Extension for Hex Colors

extension UIColor {
    convenience init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)
        
        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgb & 0x0000FF) / 255.0
        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
}





