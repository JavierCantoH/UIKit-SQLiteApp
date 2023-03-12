//
//  ViewController.swift
//  SQLiteExample
//
//  Created by Luis Javier Canto Hurtado on 14/04/21.
//

import UIKit
import Cosmos
import TinyConstraints

class ViewController: UIViewController {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var nametxt: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    //@IBOutlet weak var reviewTxt: UITextField!
    
    var imageName: String?
    
    lazy var cosmosView: CosmosView = {
        var view = CosmosView()
        //view.settings.updateOnTouch = false
        //view.settings.totalStars = 10
        view.settings.starSize = 20
        view.settings.starMargin = 3.3
        view.settings.fillMode = .full
        
        view.text = "Rate Movie"
        view.settings.textColor = .red
        view.settings.textMargin = 10
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.addSubview(cosmosView)

        cosmosView.centerInSuperview()
        
        /*
        cosmosView.didTouchCosmos = { rating in
            print("Rated: \(rating)")
        }
        */
    }

    @IBAction func addMovie(_ sender: Any) {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
        
        let img = imageName ?? String()
        
        let isInserted = ModelManager.instance.addMovie(
            name: nametxt.text!, review: Int(cosmosView.rating) , image: img )
                if isInserted {
                    label.text = "Movie Added"
                    nametxt.text = ""
                    cosmosView.rating = 0.0
                    imageView.image = UIImage(named: "camara")
                }
                else {
                    label.text = "Error: Movie was NOT added"
                }
    }
    
    @IBAction func findMovie(_ sender: Any) {
        let img = imageName ?? String()
        
        let movie = ModelManager.instance.findMovie(name: nametxt.text!)
                if movie.id != 0 {
                    label.text = String("ID: \(movie.id)")
                    nametxt.text = movie.name
                    cosmosView.rating = Double(movie.review)
                    imageView.image = UIImage(named: img)
                }
                else {
                    label.text = "Movie NOT found"
                    imageView.image = UIImage(named: "camara")
                    cosmosView.rating = 0.0
                }
    }
    
    @IBAction func deleteMovie(_ sender: Any) {
        let isDeleted = ModelManager.instance.deleteMovie(name: nametxt.text!)
                if isDeleted {
                    label.text = "Movie Deleted"
                    nametxt.text = ""
                    cosmosView.rating = 0.0
                    imageView.image = UIImage(named: "camara")
                }
                else {
                    label.text = "Movie NOT found"
                    cosmosView.rating = 0.0
                    imageView.image = UIImage(named: "camara")
                }
    }
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage{
            imageView.image = image
            imageName = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? String
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
