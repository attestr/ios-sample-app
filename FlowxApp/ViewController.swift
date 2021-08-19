//
//  ViewController.swift
//  FlowxApp
//
//  Created by Tushar Kalra
//  Copyright (c) 2021 Pegadroid IQ Solutions Pvt. Ltd.

import UIKit
import attestr_flowx

class ViewController: UIViewController {
    
    let defaults = UserDefaults.standard
    
    //MARK:- UI Elements
    private let textlabel: UILabel = {
        let textlabel = UILabel()
        textlabel.text = "Attestr Flowx"
        textlabel.textColor = .black
        textlabel.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        textlabel.numberOfLines = 2
        return textlabel
    }()
    
    private let button: UIButton = {
        let button = UIButton()
        button.setTitle("Initiate", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(hexString: "#004ef4")
        button.layer.cornerRadius = 12
        button.addTarget(self, action: #selector(initiateConnection), for: .touchUpInside)
        return button
    }()
    
    private let hsTextField: UITextField = {
        let hsTextField = UITextField()
        hsTextField.layer.cornerRadius = 12
        hsTextField.layer.borderWidth = 0.5
        hsTextField.placeholder = "Enter handshake key"
        hsTextField.setLeftPaddingPoints(8)
        hsTextField.setRightPaddingPoints(8)
        return hsTextField
    }()
    
    private let clTextField: UITextField = {
        let clTextField = UITextField()
        clTextField.layer.cornerRadius = 12
        clTextField.layer.borderWidth = 0.5
        clTextField.placeholder = "Enter client key"
        clTextField.setLeftPaddingPoints(8)
        clTextField.setRightPaddingPoints(8)
        return clTextField
        
    }()
    
    private let retrylabel: UILabel = {
        let textlabel = UILabel()
        textlabel.text = "Retry"
        textlabel.textColor = .black
        textlabel.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        textlabel.numberOfLines = 0
        textlabel.translatesAutoresizingMaskIntoConstraints = false
        return textlabel
    }()
    
    private let retrySwitch: UISwitch = {
        let retrySwitch = UISwitch()
        retrySwitch.isOn = false
        retrySwitch.addTarget(self, action: #selector(retrySwitchChanged), for: .valueChanged)
        retrySwitch.translatesAutoresizingMaskIntoConstraints = false
        return retrySwitch
    }()
    
    private let retryView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray.withAlphaComponent(0.2)
        view.layer.cornerRadius = 12
        view.layer.borderWidth = 0.5
        return view
    }()
    
    private let logo: UIImageView = {
        let logo = UIImageView()
        logo.image = UIImage(named: "logo")
        logo.translatesAutoresizingMaskIntoConstraints = false
        return logo
    }()
    private let copyrightText: UILabel = {
        let text = UILabel()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.text = "Copyright © Attestr"
        text.textColor = .black
        text.font = UIFont.systemFont(ofSize: 16, weight: .light)
        return text
    }()
    
    private let footerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var retry = false
    
    private var const: CGFloat = 70
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    //MARK:- View did load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        
        if UIScreen.main.bounds.height > 800 {
            const = 100
        }
        
        if UIScreen.main.bounds.height == 568 {
            const = 50
        }
        
        view.addSubview(textlabel)
        view.addSubview(hsTextField)
        view.addSubview(clTextField)
        
        retryView.addSubview(retrylabel)
        retryView.addSubview(retrySwitch)
        
        view.addSubview(retryView)
        view.addSubview(button)
        
        footerView.addSubview(logo)
        footerView.addSubview(copyrightText)
        
        view.addSubview(footerView)
        
        clTextField.text = defaults.string(forKey: "cl")
        
        
        clTextField.delegate = self
        hsTextField.delegate = self
        
    }
    
    //MARK:- View did layout subviews
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let size = view.width
        
        textlabel.frame = CGRect(x: view.left + 16, y: view.top + const, width: size - 32, height: const)
        clTextField.frame = CGRect(x: view.left + 16, y: textlabel.bottom + 10, width: size - 32, height: 50)
        hsTextField.frame = CGRect(x: view.left + 16, y: clTextField.bottom + 8, width: size - 32, height: 50)
        retryView.frame = CGRect(x: view.left + 16, y: hsTextField.bottom + 8, width: size - 32, height: 50)
        button.frame = CGRect(x: view.left + 16, y: retryView.bottom + 30, width: size - 32, height: 50)
        
        let retryConstraints = [      retrylabel.topAnchor.constraint(equalTo: retryView.topAnchor),
                                      retrylabel.leadingAnchor.constraint(equalTo: retryView.leadingAnchor,constant: 8),
                                      retrylabel.heightAnchor.constraint(equalToConstant: 50),
                                      retrylabel.widthAnchor.constraint(equalTo: retryView.widthAnchor, multiplier: 0.5),
                                      
                                      retrySwitch.topAnchor.constraint(equalTo: retryView.topAnchor,constant: 8),
                                      retrySwitch.trailingAnchor.constraint(equalTo: retryView.trailingAnchor,constant: -8),
                                      retrySwitch.heightAnchor.constraint(equalToConstant: 50)
                                      
        ]
        
        if #available(iOS 11.0, *) {
            footerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        } else {
            footerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        }
        
        let footerConstraints = [ footerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                                  footerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                                  footerView.heightAnchor.constraint(equalToConstant: 100),
                                  
                                  logo.centerXAnchor.constraint(equalTo: footerView.centerXAnchor),
                                  logo.topAnchor.constraint(equalTo: footerView.topAnchor, constant: 16),
                                  logo.heightAnchor.constraint(equalToConstant: 50),
                                  logo.widthAnchor.constraint(equalToConstant: 50),
                                  
                                  copyrightText.centerXAnchor.constraint(equalTo: footerView.centerXAnchor),
                                  copyrightText.topAnchor.constraint(equalTo: logo.bottomAnchor, constant: 8)
                                  
        ]
        
        NSLayoutConstraint.activate(retryConstraints)
        NSLayoutConstraint.activate(footerConstraints)
        
    }
    
    //MARK:- Retry switch action handler
    @objc func retrySwitchChanged(_ sender: UISwitch!){
        if sender.isOn {
            retry = true
        }else{
            retry = false
        }
    }
    
    //MARK:- Initiate Button Pressed
    @objc func initiateConnection(){
        defaults.setValue(clTextField.text, forKey: "cl")
        
        let p = AttestrFlowx().initialize(cl: clTextField.text!, hs: hsTextField.text!, self)
        p?.launch(lc: "en", retry: retry, qr: nil)
        
        if !retry {
            hsTextField.text = ""
        }
    }
    
}

//MARK:- AttestrFlowxEvent Delegate methods
extension ViewController: AttestrFlowxEventProtocol {
    
    func onFlowxSuccess(_ data: [String : AnyObject]) {
        let alert = UIAlertController(title: "Success!", message: "The verification process was completed successfully.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true)
    }
    
    func onFlowxSkip(_ data: [String : AnyObject]) {
        let alert = UIAlertController(title: "Skipped", message: "The verification process was skipped. Some parts of it might be repeated.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true)
    }
    
    func onFlowxError(_ data: [String : AnyObject]) {
        let code = data["code"] as! Int
        let alert = UIAlertController(title: "Error \(code)", message: data["message"] as? String, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true)
    }
    
}

//MARK:- Textfield Delegate methods
extension ViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == clTextField{
            hsTextField.becomeFirstResponder()
        }
        else {
            textField.resignFirstResponder()
        }
        return true
    }
}
