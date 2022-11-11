//
//  CreateSocialVC.swift
//  MDB Social
//
//  Created by Ethan Kuo on 11/10/22.
//

import Foundation
import UIKit

class CreateSocialVC: UIViewController {
    
    private let stack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        stack.spacing = 25

        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Create an event"
        lbl.textColor = .primaryText
        lbl.font = .systemFont(ofSize: 30, weight: .semibold)
        
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private let titleSecLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "For your friends to RSVP"
        lbl.textColor = .secondaryText
        lbl.font = .systemFont(ofSize: 17, weight: .medium)
        
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private let contentEdgeInset = UIEdgeInsets(top: 120, left: 40, bottom: 30, right: 40)
    
    let nameTextField: AuthTextField = {
        let tf = AuthTextField(title: "Event Name")
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    private let uploadPictureButton: HorizontalActionLabel = {
        let actionLabel = HorizontalActionLabel(
            label: "Have a picture of your event?",
            buttonTitle: "Upload")
        
        actionLabel.translatesAutoresizingMaskIntoConstraints = false
        return actionLabel
    }()
    
    private var eventImageView: UIImageView = {
        let image = UIImageView()
        image.tintColor = .white
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let descriptionTextField: AuthTextField = {
        let tf = AuthTextField(title: "Description")
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.locale = .current
        datePicker.datePickerMode = .dateAndTime
        datePicker.preferredDatePickerStyle = .compact
        datePicker.tintColor = .systemBlue
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        return datePicker
    }()
    
    @objc private func didTapUploadPicture(_ sender: UIButton) {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideKeyboardWhenTappedAround()
        view.backgroundColor = .background
        
        view.addSubview(titleLabel)
        view.addSubview(titleSecLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,
                                            constant: contentEdgeInset.top),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                                constant: contentEdgeInset.left),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                                 constant: contentEdgeInset.right),
            titleSecLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor,
                                               constant: 3),
            titleSecLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            titleSecLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor)
        ])
        
        view.addSubview(stack)
        stack.addArrangedSubview(nameTextField)
        stack.addArrangedSubview(descriptionTextField)
        
        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                           constant: contentEdgeInset.left),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                            constant: -contentEdgeInset.right),
            stack.topAnchor.constraint(equalTo: titleSecLabel.bottomAnchor,
                                       constant: 60)
        ])
        
        view.addSubview(datePicker)
        NSLayoutConstraint.activate([
            datePicker.topAnchor.constraint(equalTo: stack.bottomAnchor, constant: 30),
            datePicker.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        
        
        view.addSubview(uploadPictureButton)
        NSLayoutConstraint.activate([
            uploadPictureButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            uploadPictureButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            
        ])
        
        view.addSubview(eventImageView)
        NSLayoutConstraint.activate([
            eventImageView.topAnchor.constraint(equalTo: datePicker.bottomAnchor, constant: 30),
            eventImageView.bottomAnchor.constraint(equalTo: uploadPictureButton.topAnchor, constant: -30),
            eventImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                                    constant: contentEdgeInset.left),
            eventImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                                    constant: -contentEdgeInset.right),
            
        ])
        
        
        uploadPictureButton.addTarget(self, action: #selector(didTapUploadPicture(_:)), for: .touchUpInside)
    }
}

extension CreateSocialVC: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        let imageName = UUID().uuidString
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
        
        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath)
        }
    
        dismiss(animated: true)
        
        // Save the image uploaded into eventImage property
        eventImageView.image = UIImage(contentsOfFile: imagePath.path)
        eventImageView.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor
        eventImageView.layer.borderWidth = 2
        eventImageView.layer.cornerRadius = 2
        
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}

extension CreateSocialVC: UINavigationControllerDelegate {
    
}
