import UIKit

class GeneralPolicyViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var policyLabel: UITextView!
    @IBOutlet weak var versionLabel: UILabel!
    @IBOutlet weak var effectiveDateLabel: UILabel!
    @IBOutlet weak var acknowledgmentButton: UIButton!
    @IBOutlet weak var employeePickerView: UIPickerView! // Picker view outlet
    
    var employeeNames: [String] = []
    var selectedEmployeeIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadPolicy()
        loadPolicyMetadata()
        
        employeePickerView.delegate = self
        employeePickerView.dataSource = self
        loadEmployeeNames()
        
        // Select the first employee by default if no selection is made
        if selectedEmployeeIndex == nil && !employeeNames.isEmpty {
            selectedEmployeeIndex = 0
            employeePickerView.selectRow(0, inComponent: 0, animated: false)
        }
    }
    
    // Add this to refresh data each time view appears
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadPolicy()
        loadPolicyMetadata()
        loadEmployeeNames()
    }
    
    func loadEmployeeNames() {
        employeeNames = UserDefaultsHelper.shared.getEmployeeNames()
        employeePickerView.reloadAllComponents()
    }
    
    // MARK: UIPickerViewDataSource
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return employeeNames.count
    }
    
    // MARK: UIPickerViewDelegate
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return employeeNames[row]
    }
    
    // Load and display the policy text and metadata
    func loadPolicy() {
        let policyText = UserDefaults.standard.string(forKey: "policy") ?? "Default company policy"
        policyLabel.text = policyText
    }
    
    func loadPolicyMetadata() {
        let version = UserDefaults.standard.string(forKey: "policyVersion") ?? "1.0"
        let effectiveDate = UserDefaults.standard.string(forKey: "policyEffectiveDate") ?? "Not Set"
        
        versionLabel.text = "Version: \(version)"
        effectiveDateLabel.text = "Effective Date: \(effectiveDate)"
        
        updateAcknowledgmentButton()
    }
    
    func updateAcknowledgmentButton() {
        let isAcknowledged = UserDefaults.standard.bool(forKey: "policyAcknowledged")
        acknowledgmentButton.setTitle(isAcknowledged ? "Acknowledged" : "Acknowledge Policy", for: .normal)
    }
    
    @IBAction func acknowledgePolicy(_ sender: Any) {
        // Ensure there's a selected employee in the picker view
        if let selectedIndex = selectedEmployeeIndex {
            // Get the selected employee's name
            let selectedEmployeeName = employeeNames[selectedIndex]
            
            // Retrieve the attendance list from UserDefaults
            var attendanceList = UserDefaultsHelper.shared.getAttendance()
            
            // Find the selected employee in the attendance list
            if let employeeIndex = attendanceList.firstIndex(where: { $0.employee.name == selectedEmployeeName }) {
                // Update the employee's acknowledgment status
                var employee = attendanceList[employeeIndex].employee
                employee.isAcknowledge.toggle() // Toggle acknowledgment status
                attendanceList[employeeIndex].employee = employee // Update employee in list
                
                // Save the updated attendance list back to UserDefaults
                UserDefaultsHelper.shared.saveAttendance(attendanceList)
                
                // Notify other parts of the app to refresh views
                NotificationCenter.default.post(name: NSNotification.Name("AcknowledgmentUpdated"), object: nil)
                NotificationCenter.default.post(name: NSNotification.Name("ReloadTableView"), object: nil)
            }
        }
        
        // Update the acknowledgment status for the policy in UserDefaults
        let currentStatus = UserDefaults.standard.bool(forKey: "policyAcknowledged")
        UserDefaults.standard.set(!currentStatus, forKey: "policyAcknowledged") // Toggle policy acknowledgment status
        updateAcknowledgmentButton()
    }

    
    // MARK: - PickerView Selection
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedEmployeeIndex = row // Store the selected index
    }
    
    // Navigation actions to Edit and History view controllers
    @IBAction func editPolicy(_ sender: Any) {
        let editVC = storyboard?.instantiateViewController(withIdentifier: "EditPolicyViewController") as! EditPolicyViewController
        navigationController?.pushViewController(editVC, animated: true)
    }
    
    @IBAction func viewHistory(_ sender: Any) {
        let historyVC = storyboard?.instantiateViewController(withIdentifier: "PolicyHistoryViewController") as! PolicyHistoryViewController
        navigationController?.pushViewController(historyVC, animated: true)
    }
}
