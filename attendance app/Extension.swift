
import Foundation
import UIKit

@IBDesignable
class DesignableView: UIView {
}

@IBDesignable
class DesignableButton: UIButton {
}

@IBDesignable
class DesignableLabel: UILabel {
}


extension UIView {
  
  @IBInspectable
  var cornerRadius: CGFloat {
    get {
      return layer.cornerRadius
    }
    set {
      layer.cornerRadius = newValue
    }
  }
  
  @IBInspectable
  var borderWidth: CGFloat {
    get {
      return layer.borderWidth
    }
    set {
      layer.borderWidth = newValue
    }
  }
  
  @IBInspectable
  var borderColor: UIColor? {
    get {
      if let color = layer.borderColor {
        return UIColor(cgColor: color)
      }
      return nil
    }
    set {
      if let color = newValue {
        layer.borderColor = color.cgColor
      } else {
        layer.borderColor = nil
      }
    }
  }
  
  @IBInspectable
  var shadowRadius: CGFloat {
    get {
      return layer.shadowRadius
    }
    set {
      layer.shadowRadius = newValue
    }
  }
  
  @IBInspectable
  var shadowOpacity: Float {
    get {
      return layer.shadowOpacity
    }
    set {
      layer.shadowOpacity = newValue
    }
  }
  
  @IBInspectable
  var shadowOffset: CGSize {
    get {
      return layer.shadowOffset
    }
    set {
      layer.shadowOffset = newValue
    }
  }
  
  @IBInspectable
  var shadowColor: UIColor? {
    get {
      if let color = layer.shadowColor {
        return UIColor(cgColor: color)
      }
      return nil
    }
    set {
      if let color = newValue {
        layer.shadowColor = color.cgColor
      } else {
        layer.shadowColor = nil
      }
    }
  }
}

@IBDesignable class RatingControl: UIStackView {

//MARK: Properties

private var ratingButtons = [UIButton]()

var rating = 0 {
    didSet {
        updateButtonSelectionStates()
    }
}

@IBInspectable var starSize: CGSize = CGSize(width: 44.0, height: 44.0) {
    didSet {
        setupButtons()
    }
}

@IBInspectable var starCount: Int = 5 {
    didSet {
        setupButtons()
    }
}

//MARK: Initialization

override init(frame: CGRect) {
    super.init(frame: frame)
    setupButtons()
}

required init(coder: NSCoder) {
    super.init(coder: coder)
    setupButtons()
}

//MARK: Button Action

    @objc func ratingButtonTapped(button: UIButton) {
        guard let index = ratingButtons.firstIndex(of: button) else {
        fatalError("The button, \(button), is not in the ratingButtons array: \(ratingButtons)")
    }

    // Calculate the rating of the selected button
    let selectedRating = index + 1

    if selectedRating == rating {
        // If the selected star represents the current rating, reset the rating to 0.
        rating = 0
    } else {
        // Otherwise set the rating to the selected star
        rating = selectedRating
    }

    print(selectedRating)
}


//MARK: Private Methods

private func setupButtons() {

    // Clear any existing buttons
    for button in ratingButtons {
        removeArrangedSubview(button)
        button.removeFromSuperview()
    }
    ratingButtons.removeAll()

    // Load Button Images
    let bundle = Bundle(for: type(of: self))
    let filledStar = UIImage(named: "filledStar", in: bundle, compatibleWith: self.traitCollection)
    let emptyStar = UIImage(named:"emptyStar", in: bundle, compatibleWith: self.traitCollection)
    let highlightedStar = UIImage(named:"highlightedStar", in: bundle, compatibleWith: self.traitCollection)

    for index in 0..<starCount {
        // Create the button
        let button = UIButton()

        // Set the button images
        button.setImage(emptyStar, for: .normal)
        button.setImage(filledStar, for: .selected)
        button.setImage(highlightedStar, for: .highlighted)
        button.setImage(highlightedStar, for: [.highlighted, .selected])

        // Add constraints
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: starSize.height).isActive = true
        button.widthAnchor.constraint(equalToConstant: starSize.width).isActive = true

        // Set the accessibility label
        button.accessibilityLabel = "Set \(index + 1) star rating"

        // Setup the button action
        button.addTarget(self, action: #selector(RatingControl.ratingButtonTapped(button:)), for: .touchUpInside)

        // Add the button to the stack
        addArrangedSubview(button)

        // Add the new button to the rating button array
        ratingButtons.append(button)
    }

    updateButtonSelectionStates()
}

private func updateButtonSelectionStates() {
    for (index, button) in ratingButtons.enumerated() {
        // If the index of a button is less than the rating, that button should be selected.
        button.isSelected = index < rating

        // Set accessibility hint and value
        let hintString: String?
        if rating == index + 1 {
            hintString = "Tap to reset the rating to zero."
        } else {
            hintString = nil
        }

        let valueString: String
        switch (rating) {
        case 0:
            valueString = "No rating set."
        case 1:
            valueString = "1 star set."
        default:
            valueString = "\(rating) stars set."
        }

        button.accessibilityHint = hintString
        button.accessibilityValue = valueString
    }
  }
}

extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}

extension String {
  var isEmail: Bool {
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
    let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailTest.evaluate(with: self)
  }
}


extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tapGesture = UITapGestureRecognizer(target: self,
                         action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }

    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
}
