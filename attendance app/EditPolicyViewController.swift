//
//  EditPolicyViewController.swift
//  attendance app
//
//  Created by Rizvi MacOs on 04/11/2024.
//

import UIKit

class EditPolicyViewController: UIViewController {
    
    @IBOutlet weak var policyTextView: UITextView!
    @IBOutlet weak var versionTextField: UITextField!
    @IBOutlet weak var effectiveDatePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadPolicy()
    }
    
    @IBAction func savePolicy(_ sender: Any) {
        savePolicyHistory()
        
        UserDefaults.standard.set(policyTextView.text, forKey: "policy")
        UserDefaults.standard.set(versionTextField.text ?? "1.0", forKey: "policyVersion")
        UserDefaults.standard.set(dateFormatter().string(from: effectiveDatePicker.date), forKey: "policyEffectiveDate")
        
        navigationController?.popViewController(animated: true)
    }
    
    func loadPolicy() {
        policyTextView.text = UserDefaults.standard.string(forKey: "policy") ?? ""
        versionTextField.text = UserDefaults.standard.string(forKey: "policyVersion") ?? "1.0"
        
        if let effectiveDateStr = UserDefaults.standard.string(forKey: "policyEffectiveDate"),
           let effectiveDate = dateFormatter().date(from: effectiveDateStr) {
            effectiveDatePicker.date = effectiveDate
        }
    }
    
    private func savePolicyHistory() {
        var history = UserDefaults.standard.array(forKey: "policyHistory") as? [[String: String]] ?? []
        
        let newHistoryEntry: [String: String] = [
            "version": versionTextField.text ?? "1.0",
            "policy": policyTextView.text,
            "date": dateFormatter().string(from: Date())
        ]
        
        history.append(newHistoryEntry)
        UserDefaults.standard.set(history, forKey: "policyHistory")
    }
    
    private func dateFormatter() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }
}
