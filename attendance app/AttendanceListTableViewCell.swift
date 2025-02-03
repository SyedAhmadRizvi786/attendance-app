//
//  AttendanceListTableViewCell.swift
//  attendance app
//
//  Created by Rizvi MacOs on 07/11/2024.
//

import UIKit

class AttendanceListTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBOutlet weak var acknowledgmentLabel: UILabel!
    
    func configure(with attendance: Attendance) {
        
        print("----->>>> \(attendance.employee.isAcknowledge)")
        
           nameLabel.text = "Employee: \(attendance.employee.name)"
           statusLabel.text = "Status: \(attendance.isPresent ? "Present" : "Absent")"
        
              // Update acknowledgment text and color based on acknowledgment status
              if attendance.employee.isAcknowledge {
                  acknowledgmentLabel.text = "Policy Acknowledged"
                  acknowledgmentLabel.textColor = UIColor.systemGreen.withAlphaComponent(0.8) // Soft green color
              } else {
                  acknowledgmentLabel.text = "Policy Not Acknowledged"
                  acknowledgmentLabel.textColor = UIColor.systemRed.withAlphaComponent(0.8) // Soft red color
              }
       }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
