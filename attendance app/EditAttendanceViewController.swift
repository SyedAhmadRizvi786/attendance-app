//
//  EditAttendanceViewController.swift
//  attendance app
//
//  Created by Rizvi MacOs on 05/11/2024.
//

import UIKit

class EditAttendanceViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var employeeIDTextField: UITextField!
    @IBOutlet weak var departmentPickerView: UIPickerView!
    @IBOutlet weak var positionPickerView: UIPickerView!
    @IBOutlet weak var employmentStatusPickerView: UIPickerView!
    @IBOutlet weak var absenceReasonPickerView: UIPickerView!
    @IBOutlet weak var workShiftPickerView: UIPickerView!
    @IBOutlet weak var attendanceSwitch: UISwitch!
    @IBOutlet weak var profileImageView: UIImageView!
    
    var attendance: Attendance?
    var index: Int?
    var selectedImage: UIImage?
    
    let departmentOptions: [Employee.Department] = [.hr, .engineering, .marketing, .sales, .finance]
    let positionOptions: [Employee.Position] = [.manager, .developer, .designer, .analyst, .intern]
    let employmentStatusOptions: [Employee.EmploymentStatus] = [.fullTime, .partTime, .contract]
    let absenceReasonOptions: [Attendance.AbsenceReason] = [.sick, .vacation, .personal, .bereavement, .other]
    let workShiftOptions: [Attendance.WorkShift] = [.morning, .afternoon, .night, .flexible]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupImageView()
        setupPickers()
        loadAttendanceData()
    }
    
    func setupImageView() {
        profileImageView.layer.cornerRadius = profileImageView.frame.height / 2
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.clipsToBounds = true
        profileImageView.isUserInteractionEnabled = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(selectImageTapped))
        profileImageView.addGestureRecognizer(tapGesture)
    }
    
    func setupPickers() {
        departmentPickerView.delegate = self
        departmentPickerView.dataSource = self
        positionPickerView.delegate = self
        positionPickerView.dataSource = self
        employmentStatusPickerView.delegate = self
        employmentStatusPickerView.dataSource = self
        absenceReasonPickerView.delegate = self
        absenceReasonPickerView.dataSource = self
        workShiftPickerView.delegate = self
        workShiftPickerView.dataSource = self
    }
    
    func loadAttendanceData() {
        guard let attendance = attendance else { return }
        
        nameTextField.text = attendance.employee.name
        employeeIDTextField.text = attendance.employee.employeeID
        attendanceSwitch.isOn = attendance.isPresent
        profileImageView.image = attendance.getImage() ?? UIImage(named: "placeholder")
        
        if let departmentIndex = departmentOptions.firstIndex(of: attendance.employee.department) {
            departmentPickerView.selectRow(departmentIndex, inComponent: 0, animated: false)
        }
        if let positionIndex = positionOptions.firstIndex(of: attendance.employee.position) {
            positionPickerView.selectRow(positionIndex, inComponent: 0, animated: false)
        }
        if let employmentStatusIndex = employmentStatusOptions.firstIndex(of: attendance.employee.employmentStatus) {
            employmentStatusPickerView.selectRow(employmentStatusIndex, inComponent: 0, animated: false)
        }
        if let reasonForAbsence = attendance.reasonForAbsence,
           let absenceReasonIndex = absenceReasonOptions.firstIndex(of: reasonForAbsence) {
            absenceReasonPickerView.selectRow(absenceReasonIndex, inComponent: 0, animated: false)
        }
        if let workShiftIndex = workShiftOptions.firstIndex(of: attendance.workShift) {
            workShiftPickerView.selectRow(workShiftIndex, inComponent: 0, animated: false)
        }
    }

    
    @objc func selectImageTapped() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            profileImageView.image = image
            selectedImage = image
        }
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveEdits(_ sender: Any) {
        guard let name = nameTextField.text, !name.isEmpty,
              let employeeID = employeeIDTextField.text, !employeeID.isEmpty,
              let index = index else {
            showAlert(message: "Please fill out all fields.")
            return
        }
        
        let department = departmentOptions[departmentPickerView.selectedRow(inComponent: 0)]
        let position = positionOptions[positionPickerView.selectedRow(inComponent: 0)]
        let employmentStatus = employmentStatusOptions[employmentStatusPickerView.selectedRow(inComponent: 0)]
        let absenceReason = absenceReasonOptions[absenceReasonPickerView.selectedRow(inComponent: 0)]
        let workShift = workShiftOptions[workShiftPickerView.selectedRow(inComponent: 0)]
        
        // Fetch or provide default values for contactNumber, email, and address
        let contactNumber = attendance?.employee.contactNumber ?? ""
        let email = attendance?.employee.email ?? ""
        let address = attendance?.employee.address ?? ""
        
        var attendanceList = UserDefaultsHelper.shared.getAttendance()
        attendanceList[index] = Attendance(
            employee: Employee(
                name: name,
                employeeID: employeeID,
                department: department,
                position: position,
                hireDate: attendance?.employee.hireDate ?? Date(),
                contactNumber: contactNumber,
                email: email,
                address: address,
                profileImageData: selectedImage?.pngData() ?? attendance?.employee.profileImageData,
                employmentStatus: employmentStatus,
                isAcknowledge: attendance?.employee.isAcknowledge ?? false
            ),
            date: attendance?.date ?? Date(),
            isPresent: attendanceSwitch.isOn,
            reasonForAbsence: absenceReason,
            image: selectedImage ?? attendance?.getImage(),
            workShift: workShift
        )
        
        UserDefaultsHelper.shared.saveAttendance(attendanceList)
        navigationController?.popViewController(animated: true)
    }

    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    // MARK: - UIPickerView DataSource and Delegate Methods
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView {
        case departmentPickerView:
            return departmentOptions.count
        case positionPickerView:
            return positionOptions.count
        case employmentStatusPickerView:
            return employmentStatusOptions.count
        case absenceReasonPickerView:
            return absenceReasonOptions.count
        case workShiftPickerView:
            return workShiftOptions.count
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView {
        case departmentPickerView:
            return departmentOptions[row].rawValue
        case positionPickerView:
            return positionOptions[row].rawValue
        case employmentStatusPickerView:
            return employmentStatusOptions[row].rawValue
        case absenceReasonPickerView:
            return absenceReasonOptions[row].rawValue
        case workShiftPickerView:
            return workShiftOptions[row].rawValue
        default:
            return nil
        }
    }
}

