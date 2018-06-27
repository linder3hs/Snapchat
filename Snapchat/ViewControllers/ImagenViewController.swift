//
//  ImagenViewController.swift
//  Snapchat
//
//  Created by Linder on 5/23/18.
//  Copyright © 2018 Linder Hassinger. All rights reserved.
//

import UIKit
import Firebase
import AVFoundation

class ImagenViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descripcionTextField: UITextField!
    @IBOutlet weak var elegirContactoBoton: UIButton!
    @IBOutlet weak var grabarAudio: UIButton!
    
    var imagePicker = UIImagePickerController()
    var imagenID = NSUUID().uuidString
    var audioRecorder : AVAudioRecorder?
    var audioPlayer : AVAudioPlayer?
    var audioURL : URL?
    var urlf : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyBoardWhenTap()
        setupRecorder()
        imagePicker.delegate = self
        elegirContactoBoton.isEnabled = true
    }
    
    func setupRecorder() {
        do {
            //Creando una sesion de audio
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try session.overrideOutputAudioPort(.speaker)
            
            //Creando una direccion para el archivo de audio
            let basePath : String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            let pathComponets = [basePath, "audio.m4a"]
            audioURL = NSURL.fileURL(withPathComponents: pathComponets)!
            //Crear opciones para el grabador de audio
            var settings : [String:AnyObject] = [:]
            settings[AVFormatIDKey] = Int(kAudioFormatMPEG4AAC) as AnyObject?
            settings[AVSampleRateKey] = 44100.0 as AnyObject?
            settings[AVNumberOfChannelsKey] = 2 as AnyObject?
            
            //Crear el objeto de grabacion de audio
            audioRecorder = try AVAudioRecorder(url: audioURL!, settings: settings)
            audioRecorder!.prepareToRecord()
        } catch let error as NSError {
            print(error)
        }
    }
    
    @IBAction func grabarAudio(_ sender: Any) {
        if audioRecorder!.isRecording {
            //Detener la grabacion
            audioRecorder?.stop()
            //Cambiar el texto del boton grabar
            grabarAudio.setTitle("Record", for: .normal)
        } else {
            //empezar  grabar
            audioRecorder?.record()
            //cambiar el titulo del boton a detener
            grabarAudio.setTitle("Stop", for: .normal)
        }
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        imageView.image = image
        imageView.backgroundColor = UIColor.clear
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cameraTapped(_ sender: Any) {
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func elegirContactoTapped(_ sender: Any) {
        elegirContactoBoton.isEnabled = false
        let imagesFolder = Storage.storage().reference().child("imagenes")
        let imageData = UIImageJPEGRepresentation(imageView.image!, 0.25)
        
        imagesFolder.child("\(imagenID).jpg").putData(imageData!, metadata: nil, completion: { ( metadata, error ) in
            print("Intentando subir la imagen")
            if error != nil {
                print("Ocurrio un error \(String(describing: error))")
            } else {
                self.performSegue(withIdentifier: "seleccionarContactoSegue", sender: metadata?.downloadURL()?.absoluteString)
            }
        })
        
        let audioFolder = Storage.storage().reference().child("audios")
        let audioData = NSData(contentsOf: audioURL!)! as Data
        
        audioFolder.child("\(NSUUID().uuidString).mp4").putData(audioData, metadata: nil, completion: { (metadata, error) in
            self.urlf = (metadata?.downloadURL()?.absoluteString)!
            print("Subiendo el auidio")
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let siguienteVC = segue.destination as! ElegirUsuarioViewController
        siguienteVC.imagenURL = sender as! String
        siguienteVC.descrip = descripcionTextField.text!
        siguienteVC.imagenID = imagenID
        siguienteVC .audioURL = urlf
    }
    
}
