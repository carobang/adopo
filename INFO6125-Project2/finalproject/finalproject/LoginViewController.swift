//
//  LoginViewController.swift
//  finalproject
//
//  Created by Yi & Yutong on 2022-03-29.
//

import UIKit
import Firebase

class LoginViewController: UIViewController,UITextFieldDelegate {
    
    //set return key to end editing
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()// dismiss keyboard
           return true
       }

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var loginImageView: UIImageView!

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var usernameErrorLabel: UILabel!
    @IBOutlet weak var passwordErrorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        
        // Do any additional setup after loading the view.
        setupDefaultView()
    }
    
    private func setupDefaultView(){
        usernameErrorLabel.isHidden = true
        passwordErrorLabel.isHidden = true
        enabledButtonLogin()
    }
    
    // login button is enabled when both email address and the password has text
    private func enabledButtonLogin(){
        loginButton.isEnabled = usernameTextField.hasText && passwordTextField.hasText
    }
    
    // show password error if the password textfield is empty
    private func showPasswordError(){
        passwordErrorLabel.isHidden = passwordTextField.hasText
    }
    
    // show user name error if the user name textfield is empty
    private func showUserError(){
        usernameErrorLabel.isHidden = usernameTextField.hasText
    }
    
    // @IBAction for username textfield on editing changed
    @IBAction func onUsernameEditing(_ sender: UITextField) {
        // check button enabled status
        enabledButtonLogin()
        // check if need to show password error or user name error
        showPasswordError()
        showUserError()
    }
    
    @IBAction func onPasswordEditing(_ sender: UITextField) {
        // check button enabled status
        enabledButtonLogin()
        // check if need to show password error or user name error
        showPasswordError()
        showUserError()
    }
    
    private func showAlert(message:String){
        let myAlert = UIAlertController(title: "Authentication" , message: message, preferredStyle: .alert)
        // with ok button
        let okButton = UIAlertAction(title: "Ok", style:.default) { _ in
                       print("Ok button was pressed")
                        self.passwordTextField.text = ""
                    }
        //            // add ok button to success alter event
        myAlert.addAction(okButton)
        // add successAlert
        self.show(myAlert,sender:nil)
    }
    
    //var userIdentifier: String?
    var homeSegue:String = "goToHome"
    
    @IBAction func onLoginButtonTapped(_ sender: UIButton) {
        let email = usernameTextField.text ?? ""
        let password = passwordTextField.text ?? ""

        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in guard let strongSelf = self else { return }
            
            if let error = error, let errorCode = AuthErrorCode(rawValue:error._code){
                switch errorCode{
                    case .userNotFound: strongSelf.showAlert(message:"User does not exist")
                    case .wrongPassword: strongSelf.showAlert(message:"Incoreect Password")
                    default: strongSelf.showAlert(message: "Error authenticating user")
                }
                return
            }
            
                //strongSelf.userIdentifier = authResult?.user.uid
                //strongSelf.showAlert(message: "Login Succeed!")
                strongSelf.performSegue(withIdentifier: strongSelf.homeSegue, sender: strongSelf)
            }
    }
    
    var registerSegue:String = "goToRegister"
    @IBAction func onRegisterButtonTapped(_ sender: UIButton) {
        
        /* TODO */
    self.performSegue(withIdentifier: self.registerSegue, sender:self)
    }

    
}

