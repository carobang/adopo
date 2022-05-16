//
//  ContactViewController.swift
//  finalproject
//
//  Created by caro on 2022-04-15.
//

import UIKit
import MessageUI

class ContactViewController: UIViewController, MFMailComposeViewControllerDelegate,UITextFieldDelegate {
    
    //set return key to end editing
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()// dismiss keyboard
           return true
       }

    @IBOutlet weak var userPhoneNumber: UITextField!
    @IBOutlet weak var userEmail: UITextField!
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var userConcerns: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        userName.delegate = self
        userEmail.delegate = self
        userPhoneNumber.delegate = self
        userConcerns.delegate = self
        // Do any additional setup after loading the view.
    }

    @IBAction func submit(_ sender: Any) {
        if MFMailComposeViewController.canSendMail(){
        let toRecipents = ["caro1203401@gmail.com","yzha1998@gmail.com"]
        let mailController: MFMailComposeViewController = MFMailComposeViewController()
        mailController.mailComposeDelegate = self

        mailController.setToRecipients(toRecipents)
        mailController.setSubject("My Comment for Apopo  \(userName.text!)")
        mailController.setMessageBody("Name: \(userName.text!) \n\n Email: \(userEmail.text!) \n\n User Phone Number: \(userPhoneNumber.text!) \n\n User Concerns: \(userConcerns.text!)", isHTML: false)
            present(mailController, animated: true, completion: nil)
        }
            else {
                        print("Application is not able to send an email")
                    }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
            controller.dismiss(animated: true)
        }
    
    @IBAction func dismissKeyboard(_ sender: Any) {
        self.resignFirstResponder()
    }
}



    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

