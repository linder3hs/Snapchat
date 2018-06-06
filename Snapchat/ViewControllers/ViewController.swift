//
//  ViewController.swift
//  Snapchat
//
//  Created by Linder on 5/16/18.
//  Copyright © 2018 Linder Hassinger. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {

    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Hola")
    }
    
    @IBAction func iniciarSessionTapped(_ sender: Any) {
        Auth.auth().signIn(withEmail: emailTextfield.text!, password: passwordTextfield.text!) { (user, error) in
            print("Intentamos iniciar sesión")
            if error != nil {
                print("Tenemos el siguiente error\(String(describing: error))")
                Auth.auth().createUser(withEmail: self.emailTextfield.text!, password: self.passwordTextfield.text!) { (user, error) in
                    print("Intentamos crear un usuario")
                    if error != nil {
                        print("Tenemos el siguiente error\(String(describing: error))")
                    }else{
                        print("El usuario fue creado exitosamente")
                        Database.database().reference().child("usuarios").child(user!.uid).child("email").setValue(user!.email)
                        
                        self.performSegue(withIdentifier: "iniciarSesionSegue", sender: nil)
                    }
                }
            }else{
                print("Inicio de sesión exitoso")
                self.performSegue(withIdentifier: "iniciarSesionSegue", sender: nil)
            }
        }
    }
}

