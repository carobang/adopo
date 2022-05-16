//
//  RegisterViewController.swift
//  finalproject
//
//  Created by caro on 2022-04-15.
//

import UIKit
import FirebaseAuth

class RegisterViewController: UIViewController,UITextFieldDelegate {
    
    //set return key to end editing
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()// dismiss keyboard
           return true
       }


    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var passwordError: UILabel!
    
    @IBOutlet weak var emailError: UILabel!
    @IBOutlet weak var userPassword: UITextField!
    @IBOutlet weak var userEmail: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       setupDefaultView()
        userPassword.delegate = self
        userEmail.delegate = self
        // Do any additional setup after loading the view.
    }
    private func setupDefaultView(){
      passwordError.isHidden = true
        emailError.isHidden = true
        registerButton.isEnabled = false

    }
    private func setButtonAvalible(){
       
        registerButton.isEnabled = userPassword.hasText && userEmail.hasText
       
    }
    private func setEmailError(){
        emailError.isHidden =  userEmail.hasText
    }
    private func setPasswordError(){
        passwordError.isHidden = userPassword.hasText
    }
    
    @IBAction func emailEditing(_ sender: UITextField) {
        setButtonAvalible()
        setEmailError()
        setPasswordError()
    }
    
    @IBAction func passwordEditing(_ sender: UITextField) {
        setButtonAvalible()
        setEmailError()
        setPasswordError()
    }
    
    
    var toLoginSegue:String = "backToLogin"
    @IBAction func onButtonRegister(_ sender: UIButton) {
        
        Auth.auth().createUser(withEmail: self.userEmail.text!, password: self.userPassword.text!) {(user, error) in
            if user != nil {
                print("User Has SignUp")
            }
            if error != nil {
                print(":(",error)
            }
        }
           Auth.auth().signIn(withEmail: self.userEmail.text!, password: self.userPassword.text!) {(user, error) in
                if user != nil {
                    print("User Has Sign In")
                }
                if error != nil {
                    print(":(",error)
                }
    }
        self.performSegue(withIdentifier: self.toLoginSegue, sender:self)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
