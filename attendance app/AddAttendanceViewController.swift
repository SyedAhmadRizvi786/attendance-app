import UIKit

class AddAttendanceViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var employeeIDTextField: UITextField!
    @IBOutlet weak var attendanceSwitch: UISwitch!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var departmentPickerView: UIPickerView!
    @IBOutlet weak var positionPickerView: UIPickerView!
    @IBOutlet weak var employmentStatusPickerView: UIPickerView!
    @IBOutlet weak var absenceReasonPickerView: UIPickerView!
    @IBOutlet weak var workShiftPickerView: UIPickerView!
    
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
        
        profileImageView.image = UIImage(systemName: "person.fill")
        profileImageView.contentMode = .scaleAspectFit
    }
    
    func setupImageView() {
        profileImageView.layer.cornerRadius = profileImageView.frame.height / 2
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.clipsToBounds = true
        profileImageView.image = UIImage(named: "placeholder")
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(selectImageTapped))
        profileImageView.isUserInteractionEnabled = true
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
    
    @IBAction func saveAttendance(_ sender: Any) {
        guard let name = nameTextField.text, !name.isEmpty,
              let employeeID = employeeIDTextField.text, !employeeID.isEmpty else {
            showAlert(message: "Please fill out all fields.")
            return
        }
        
        let departmentIndex = departmentPickerView.selectedRow(inComponent: 0)
        let positionIndex = positionPickerView.selectedRow(inComponent: 0)
        let employmentStatusIndex = employmentStatusPickerView.selectedRow(inComponent: 0)
        let absenceReasonIndex = absenceReasonPickerView.selectedRow(inComponent: 0)
        let workShiftIndex = workShiftPickerView.selectedRow(inComponent: 0)
        
        let department = departmentOptions[departmentIndex]
        let position = positionOptions[positionIndex]
        let employmentStatus = employmentStatusOptions[employmentStatusIndex]
        let absenceReason = absenceReasonOptions[absenceReasonIndex]
        let workShift = workShiftOptions[workShiftIndex]
        
        let employee = Employee(
            name: name,
            employeeID: employeeID,
            department: department,
            position: position,
            hireDate: Date(),
            contactNumber: "",
            email: "",
            address: "",
            profileImageData: selectedImage?.pngData(),
            employmentStatus: employmentStatus,
            supervisorName: nil,
            isAcknowledge: false
        )
        
        let newAttendance = Attendance(
            employee: employee,
            date: Date(),
            isPresent: attendanceSwitch.isOn,
            reasonForAbsence: absenceReason,
            image: selectedImage,
            workShift: workShift
        )
        
        var attendanceList = UserDefaultsHelper.shared.getAttendance()
        attendanceList.append(newAttendance)
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
