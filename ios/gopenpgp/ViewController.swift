//
//  ViewController.swift
//  gopenpgp
//
//  Created by Vinoth Ramiah on 01/06/2019.
//  Copyright © 2019 Vinoth Ramiah. All rights reserved.
//

import UIKit
import Crypto

class ViewController: UIViewController {

    @IBOutlet var textLabel: UILabel!
    
    @IBOutlet var keyField: UITextView!
    @IBOutlet var messageField: UITextView!

    private let myPrivateKey = """
    -----BEGIN PGP PRIVATE KEY BLOCK-----
    Comment: https://gopenpgp.org
    Version: GopenPGP 0.0.1 (ddacebe0)

    xYYEXPwFYxYJKwYBBAHaRw8BAQhANU+PaCXTIa9y+ZHiIJXjuCvjK3y1VAO98G0Y
    rR/Ogar+CQMIWRuQudiE/EpgT10QJ/0ono7gkGgtCd9TdhwUizSZqFsEYGZ/81yI
    HMfd0plCTleJqROm7o086IsyJ3jc9GWlN6gbC1WtHa+Y6Rn+Ux6+ds0jdXNlcjFA
    dHJpcHVwLmFwcCA8dXNlcjFAdHJpcHVwLmFwcD7CagQTFggAHAUCXPwFYwkQYXn+
    QFwRPPgCGwMCGQECCwkCFQgAAIIDAQB8Ap+WxBZWwT1ZxsjjaZTmYucfCTXy2GLO
    3CZRiuwVvQEA3sVLQ9N2OrzXARXxb5vyAqw/FOvnoB7lBugXJDuIDAXHiwRc/AVj
    EgorBgEEAZdVAQUBAQhANTCLg3iTi67Og2gRrLyExZeT5+8EN7jHPNy4gyF6HAMD
    AQoJ/gkDCGQmhvhgUC9wYGpCWgXGQQld77csLcJKSzUggpThOSlnzzUXcCdOzMqT
    Yaz61Ozj5GUtkyQN2npvPLV5HAIhg9354ZuClN8pu/cb2/BgUhjCYQQYFggAEwUC
    XPwFYwkQYXn+QFwRPPgCGwwAAAHtAQDrX6hisOgctRAFl25fuoUiunod3alrhn3e
    8CPXOzToLwEATeRkr7p0V9CGXVKpKuBLnNhVasLYUy4D8jd3wQue4gI=
    =zv1M
    -----END PGP PRIVATE KEY BLOCK-----
    """ // x25519 private key, 256 bits, passphrase "1234"

    private let senderPrivateKey = """
    -----BEGIN PGP PRIVATE KEY BLOCK-----
    Version: GopenPGP 0.0.1 (ddacebe0)
    Comment: https://gopenpgp.org

    xYYEXPwFYxYJKwYBBAHaRw8BAQhADnYWdmVrBxtKA7AXL3k5CkrTMhTrMYH35hqu
    BZYFr5z+CQMIL1sOOz7v32hg068sfGfiXJ5frMZmSP3Cy/QslP1/7EovLBCblHHe
    tGgA4KAdEXnX2OdYEzACIUDzzDuy95EpMHdyYDL8sYToCFPq23rge80jdXNlcjJA
    dHJpcHVwLmFwcCA8dXNlcjJAdHJpcHVwLmFwcD7CagQTFggAHAUCXPwFYwkQaM4B
    FJbSryACGwMCGQECCwkCFQgAADwuAQBC546C8sx+/jsIRwJZgurQQulfXG1Mq/QU
    q+bB/uRhMwEAZWJS1+qUbv9cmXgq2c2GcVPn0obJeoVfvuGiFWDFYAHHiwRc/AVj
    EgorBgEEAZdVAQUBAQhAx2dowhsnxa6+U19PSwKqCuqYlkwy2OOztiLHJs+7034D
    AQoJ/gkDCAyt/bGgMfhXYLTNlHex/mzTGQMU6ntQteD4SYEyJu9lxti67fPNZRAj
    2rrARup/05VpFIAxwhf8RqZgxcCFe7X5XUu3bBJd9+b+o5UGkKzCYQQYFggAEwUC
    XPwFYwkQaM4BFJbSryACGwwAAE5DAQDs4iB8vY5wd3eA35Lx7holVKRJn4J480vy
    UK/ksgXeBQEA5PHT6+/adXH2JdbFYaDYaU0ATIN/Pi6FRXp+alCqlQM=
    =XTNB
    -----END PGP PRIVATE KEY BLOCK-----
    """ // x25519 private key, 256 bits, passphrase "1234"

    private let senderPublicKey = """
    -----BEGIN PGP PUBLIC KEY BLOCK-----

    xjMEXPwFYxYJKwYBBAHaRw8BAQhADnYWdmVrBxtKA7AXL3k5CkrTMhTrMYH35hqu
    BZYFr5zNI3VzZXIyQHRyaXB1cC5hcHAgPHVzZXIyQHRyaXB1cC5hcHA+wmoEExYI
    ABwFAlz8BWMJEGjOARSW0q8gAhsDAhkBAgsJAhUIAAA8LgEAQueOgvLMfv47CEcC
    WYLq0ELpX1xtTKv0FKvmwf7kYTMBAGViUtfqlG7/XJl4KtnNhnFT59KGyXqFX77h
    ohVgxWABzjgEXPwFYxIKKwYBBAGXVQEFAQEIQMdnaMIbJ8WuvlNfT0sCqgrqmJZM
    Mtjjs7YixybPu9N+AwEKCcJhBBgWCAATBQJc/AVjCRBozgEUltKvIAIbDAAATkMB
    AOziIHy9jnB3d4DfkvHuGiVUpEmfgnjzS/JQr+SyBd4FAQDk8dPr79p1cfYl1sVh
    oNhpTQBMg38+LoVFen5qUKqVAw==
    =6RaT
    -----END PGP PUBLIC KEY BLOCK-----
    """

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

//        let pgp = CryptoGopenPGP()
//        var error: NSError?
//        let mediaKey = pgp.generateKey("logo", domain: "tripup.app", passphrase: nil, keyType: "x25519", bits: 256, error: &error)
//        let txturl = URL(fileURLWithPath: "/Users/vin/Downloads/key.txt")
//        let binurl = URL(fileURLWithPath: "/Users/vin/Downloads/key.bin")
//
//        try! mediaKey.write(to: txturl, atomically: true, encoding: .utf8)
//
//        let data = ArmorUnarmor(mediaKey, &error)!
//        try! data.write(to: binurl)
//
//        let myKeyring = try! pgp.buildKeyRingArmored(myPrivateKey)
//        try! myKeyring.unlock("1234".data(using: .utf8))
//        let msg = myKeyring.encryptMessage(mediaKey, sign: myKeyring, error: &error)
//        try! msg.write(to: URL(fileURLWithPath: "/Users/vin/Downloads/key.enc"), atomically: true, encoding: .utf8)
    }

    @IBAction func decrypt(_ sender: Any) {
        guard let key = keyField.text, key != "", let message = messageField.text, message != "" else { return }

        let encryptedURL = URL(fileURLWithPath: "/Users/vin/Downloads/logo.pb")
        let binaryData = try! Data(contentsOf: encryptedURL)
        let encryptedData = try! PGPData(serializedData: binaryData)

        let pgp = CryptoGopenPGP()
        let mediaKeyring = try! pgp.buildKeyRingArmored(key)
        let data = try! pgp.decryptAttachment(encryptedData.keyPacket, dataPacket: encryptedData.dataPacket, kr: mediaKeyring, passphrase: nil)

        let outputURL = URL(fileURLWithPath: "/Users/vin/Downloads/logo copy.jpg")
        try! data.write(to: outputURL)
    }

    @IBAction func encrypt(_ sender: UIButton) {
        guard let key = keyField.text, key != "", let message = messageField.text, message != "" else { return }

        let url = URL(fileURLWithPath: "/Users/vin/Downloads/logo.jpg")
        let data = try! Data(contentsOf: url)

        let pgp = CryptoGopenPGP()
//        var error: NSError?
//        let mediaKey = pgp.generateKey("logo", domain: "tripup.app", passphrase: nil, keyType: "x25519", bits: 256, error: &error)
//        print(mediaKey)
        let mediaKeyring = try! pgp.buildKeyRingArmored(key)

        let encrypted = try! pgp.encryptAttachment(data, fileName: "logo.jpg", publicKey: mediaKeyring)
        let encryptedData = PGPData.with {
            $0.algo = encrypted.algo
            $0.keyPacket = encrypted.keyPacket!
            $0.dataPacket = encrypted.dataPacket!
        }

        let binaryData: Data = try! encryptedData.serializedData()
        let encryptedURL = URL(fileURLWithPath: "/Users/vin/Downloads/logo.pb")
        try! binaryData.write(to: encryptedURL)
    }
}

class EncryptedData: Codable {
    let algo: String
    let keyPacket: Data
    let dataPacket: Data

    init?(_ model: ModelsEncryptedSplit) {
        guard let keyPacket = model.keyPacket, let dataPacket = model.dataPacket else { return nil }
        self.algo = model.algo
        self.keyPacket = keyPacket
        self.dataPacket = dataPacket
    }
}
