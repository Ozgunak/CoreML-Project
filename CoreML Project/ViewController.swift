//
//  ViewController.swift
//  CoreML Project
//
//  Created by ozgun on 8.05.2022.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var thirdLabel: UILabel!
    @IBOutlet weak var firstProbLabel: UILabel!
    @IBOutlet weak var secondProbLabel: UILabel!
    @IBOutlet weak var thirdProbLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var labelsView: UIView!
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
        labelsView.isHidden = true
    }
    
    
    
    
    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        present(imagePicker, animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            imageView.image = pickedImage
            
            guard let ciimage = CIImage(image: pickedImage) else { fatalError() }
            
            detect(image: ciimage)
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func detect(image: CIImage) {
        guard let model = try? VNCoreMLModel(for: SqueezeNet().model) else { fatalError("Some error ") }
        
        let request = VNCoreMLRequest(model: model) { request, error in
            guard let result = request.results as? [VNClassificationObservation] else { fatalError("failed request") }
            self.labelsView.isHidden = false
            if let firstResuts = result.first {
                self.firstLabel.text = firstResuts.identifier.components(separatedBy: ",").first
                self.firstProbLabel.text = String(firstResuts.confidence)
                print(firstResuts.identifier.components(separatedBy: ",").first!)
                print(firstResuts.confidence)
            }
            let secResuts = result[1]
            self.secondLabel.text = secResuts.identifier.components(separatedBy: ",").first
            self.secondProbLabel.text = String(secResuts.confidence)
            print(secResuts.identifier.components(separatedBy: ",").first!)
            print(secResuts.confidence)
            let thrResuts = result[2]
            self.thirdLabel.text = thrResuts.identifier.components(separatedBy: ",").first
            self.thirdProbLabel.text = String(thrResuts.confidence)
            print(thrResuts.identifier.components(separatedBy: ",").first!)
            print(thrResuts.confidence)
            
            
        }
        
        let handler = VNImageRequestHandler(ciImage: image)
        
        do {
            try handler.perform([request])
        } catch {
            print("Some error \(error)")
        }

    }
}

