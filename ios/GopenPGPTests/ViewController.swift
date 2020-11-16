//
//  ViewController.swift
//  GopenPGPTests
//
//  Created by Vinoth Ramiah on 01/06/2019.
//  Copyright © 2019 Vinoth Ramiah. All rights reserved.
//

import UIKit
import Gopenpgp

class ViewController: UIViewController {

    @IBOutlet var keyField: UITextView!
    @IBOutlet var passwordField: UITextView!
    @IBOutlet var messageField: UITextView!
    @IBOutlet var signedSwitch: UISwitch!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func encrypt(_ sender: UIButton) {
        guard let keyString = keyField.text, keyString != "", let message = messageField.text, message != "" else { return }

        var error: NSError?
        var cipher: String?
        if signedSwitch.isOn {
            guard let password = passwordField.text, password != "" else { print("ERROR - signed message requires password\n"); return }
            cipher = HelperEncryptSignMessageArmored(keyString, keyString, password.data(using: .utf8), message, &error)
        } else {
            cipher = HelperEncryptMessageArmored(keyString, message, &error)
        }

        if let error = error {
            print(String(describing: error))
        } else {
            print("\(cipher ?? "❌ cypher is nil")\n")
        }
    }

    @IBAction func decrypt(_ sender: Any) {
        guard let keyString = keyField.text, keyString != "", let password = passwordField.text, password != "", let cipher = messageField.text, cipher != "" else { return }

        var error: NSError?
        if signedSwitch.isOn {
            let message = HelperDecryptVerifyMessageArmored(keyString, keyString, password.data(using: .utf8), cipher, &error)
            if let error = error {
                print(String(describing: error))
            } else {
                print("following message is signed by provided key...")
                print("\(message)\n")
            }
        } else {
            let message = HelperDecryptMessageArmored(keyString, password.data(using: .utf8), cipher, &error)
            if let error = error {
                print(String(describing: error))
            } else {
                print("\(message)\n")
            }
        }
    }

//    func encryptData() {
//        let encrypted = try! pgp.encryptAttachment(data, fileName: "logo.jpg", publicKey: mediaKeyring)
//        let encryptedData = PGPData.with {
//            $0.algo = encrypted.algo
//            $0.keyPacket = encrypted.keyPacket!
//            $0.dataPacket = encrypted.dataPacket!
//        }
//
//        let binaryData: Data = try! encryptedData.serializedData()
//        let encryptedURL = URL(fileURLWithPath: "/Users/vin/Downloads/logo.pb")
//        try! binaryData.write(to: encryptedURL)
//    }

//    func decryptData() {
//        let pgp = CryptoGopenPGP()
//        let mediaKeyring = try! pgp.buildKeyRingArmored(key)
//        let data = try! pgp.decryptAttachment(encryptedData.keyPacket, dataPacket: encryptedData.dataPacket, kr: mediaKeyring, passphrase: nil)
//
//        let outputURL = URL(fileURLWithPath: "/Users/vin/Downloads/logo copy.jpg")
//        try! data.write(to: outputURL)
//    }
}
