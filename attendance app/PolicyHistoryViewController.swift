//
//  PolicyHistoryViewController.swift
//  attendance app
//
//  Created by Rizvi MacOs on 04/11/2024.
//

import UIKit

class PolicyHistoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var history: [[String: String]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        loadHistory()
    }
    
    func loadHistory() {
        history = UserDefaults.standard.array(forKey: "policyHistory") as? [[String: String]] ?? []
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return history.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell", for: indexPath)
        let historyEntry = history[indexPath.row]
        
        cell.textLabel?.text = "Version: \(historyEntry["version"] ?? "N/A")"
        cell.detailTextLabel?.text = "Date: \(historyEntry["date"] ?? "Unknown Date")"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedEntry = history[indexPath.row]
        
        let alert = UIAlertController(title: "Policy Version \(selectedEntry["version"] ?? "N/A")",
                                      message: selectedEntry["policy"] ?? "",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Close", style: .cancel))
        present(alert, animated: true)
    }
}
