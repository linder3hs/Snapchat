//
//  VerSnapViewController.swift
//  Snapchat
//
//  Created by Linder on 5/30/18.
//  Copyright © 2018 Linder Hassinger. All rights reserved.
//

import UIKit
import SDWebImage
import Firebase
import AVFoundation

class VerSnapViewController: UIViewController {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var reproducirAudio: UIButton!
    
    var snap = Snap()
    var audioPlayer : AVAudioPlayer?
    override func viewDidLoad() {
        super.viewDidLoad()
        label.text? = snap.descrip
        imageView.sd_setImage(with: URL(string: snap.imagenURL))
    }
    
    
    @IBAction func playAudio(_ sender: Any) {
        do {
            let audioURL: URL = NSURL(string: snap.audioURL)! as URL
            try audioPlayer = AVAudioPlayer(contentsOf: audioURL)
            audioPlayer!.play()
        } catch {}
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        Database.database().reference().child("usuarios")
            .child(Auth.auth().currentUser!.uid).child("snaps").child(snap.id).removeValue()
        Storage.storage().reference().child("imagenes").child("\(snap.imagenID).jpg").delete{(error) in
            print("Se elemino la imagen correctamente")
        }
    }
}
