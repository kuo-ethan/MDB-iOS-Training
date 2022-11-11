//
//  CreateSocialVC.swift
//  MDB Social
//
//  Created by Ethan Kuo on 11/10/22.
//

import Foundation
import UIKit

class CreateSocialVC: UIViewController {
    
    let nameTextField: AuthTextField = {
        
    }()
    
    let uploadPictureButton: UIButton = {
        let button = UIButton()
    }()
    
    let descriptionTextField: AuthTextField = {
        
    }()
    
    let datePicker: UIDatePicker = {
        
    }()
    
    @objc private func didTapUploadPicture(_ sender: UIButton) {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        navigationController?.pushViewController(picker, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
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
        
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}

extension CreateSocialVC: UINavigationControllerDelegate {
    
}
