//
//  gopenpgpTests.swift
//  gopenpgpTests
//
//  Created by Vinoth Ramiah on 05/06/2019.
//  Copyright © 2019 Vinoth Ramiah. All rights reserved.
//

import XCTest
import Crypto
import CryptoSwift
@testable import gopenpgp

class gopenpgpTests: XCTestCase {
    private let testBundle = Bundle(for: gopenpgpTests.self)

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
    """ // x25519 private key, 256 bits, passphrase "1234", user1@tripup.app

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
    """ // x25519 private key, 256 bits, passphrase "1234", user2@tripup.app

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

    private var pgp: CryptoGopenPGP!
    private var myKeyring: CryptoKeyRing!
    private var error: NSError?

    override func setUp() {
        super.setUp()
        pgp = CryptoGopenPGP()
        myKeyring = try! pgp.buildKeyRingArmored(myPrivateKey)
    }

    override func tearDown() {
        pgp = nil
        myKeyring = nil
        error = nil
        super.tearDown()
    }

    func testUnlockKeychainValidPass() {
        XCTAssertNoThrow(try myKeyring.unlock("1234".data(using: .utf8)))
    }

    func testUnlockKeychainInvalidPass() {
        XCTAssertThrowsError(try myKeyring.unlock("123".data(using: .utf8))) { error in
            XCTAssertEqual((error as NSError).domain, "go")
            XCTAssertEqual(error.localizedDescription, "openpgp: invalid data: private key checksum failure")
        }
    }

    func testDerivePublicKey() {
        let senderKeyring = try! pgp.buildKeyRingArmored(senderPrivateKey)
        XCTAssertEqual(senderKeyring.getArmoredPublicKey(&error), senderPublicKey)
    }
}

// MARK: Decryption Tests
extension gopenpgpTests {
    func testDecryptWithWrongKey() {
        let _ = "message for user2\n" // but try to decrypt using my key
        let cipher = """
        -----BEGIN PGP MESSAGE-----

        wV4DVKZRq7MPB0sSAQhAUiOEc9VvibaevfOBcU4yu4rgaFb+ttBJ8J9H2PPUZVAw
        oYhEBlnb4cwiWVen8AObmkauVglIiVPXu2twZCwXYfyrEMqmh0JtYuXYembq+YPm
        0rIB04g0LzSfPvI3s7a0IjPEBP9mr8FJ44yopBH02J659BkdfJNNO0LjIzGrDCN+
        IkLzGV+Gtr7nteheqn4v0VljfZ2/c60aBApdtn0L6sagzzoM+l2/StJFT1lyf3LK
        YOHRCUA8w7fozs8fPRCarLoHECvyqPOOBdU3V0WTBvaQP7/doiyQtGg5efRvaBwI
        4OuLtAtI5CetcOWsclqWcVfg237RehVBjbRm2ruEb42Q/GJ8
        =XR9h
        -----END PGP MESSAGE-----
        """

        XCTAssertThrowsError(try pgp.decryptMessageVerify(cipher, verifierKey: myKeyring, privateKeyRing: myKeyring, passphrase: "1234", verifyTime: pgp.getTimeUnix())) { error in
            XCTAssertEqual((error as NSError).domain, "go")
            XCTAssertEqual(error.localizedDescription, "openpgp: incorrect key")
        }

        XCTAssertThrowsError(try pgp.decryptMessageVerify(cipher, verifierKey: nil, privateKeyRing: myKeyring, passphrase: "1234", verifyTime: pgp.getTimeUnix())) { error in
            XCTAssertEqual((error as NSError).domain, "go")
            XCTAssertEqual(error.localizedDescription, "openpgp: incorrect key")
        }
    }

    func testDecryptSignedBySelf() {
        let message = "from me to me\n"
        let cipher = """
        -----BEGIN PGP MESSAGE-----

        wV4DvI2vni2pMvMSAQhAS+Geom8DkcI2oY29tLuBl4rMJvjIo4ZE0Qeeuzl6w1Ew
        hPpYfdBqMWo0HhxrMQkOF0ozd8i6HckGAX8uvr9cEW8dZ6RWSyAc3rCUIq3mOOFm
        0q4BxV6kgt0ASoTAUntcYDeitjPpRwh1GoF69KRtPOSHmuZ/X1GCBRtLRW8mx3Nj
        q+wlD0UMae7F9gSnkptLzhIvJzc2C7YWRz5xgZwlLqiRERlo2NJHIfWOmN7Q829H
        McnDsc45Zldol483lOc1Q/gLWKE5YSWv98V0bwJQ1l53IUJDCMlDY/cJ8uy8qKL5
        Sv12WR9tB9I1XfSIuU8Fblgfm25HcVJ9CtHj7DycF60=
        =UtSj
        -----END PGP MESSAGE-----
        """

        let pgpDecrypted = try! pgp.decryptMessageVerify(cipher, verifierKey: myKeyring, privateKeyRing: myKeyring, passphrase: "1234", verifyTime: pgp.getTimeUnix())
        XCTAssertEqual(pgpDecrypted.plaintext, message)
        XCTAssertEqual(pgpDecrypted.verify, 0)
    }

    func testDecryptUnsignedBySelf() {
        let message = "from me to me\n"
        let cipher = """
        -----BEGIN PGP MESSAGE-----

        wV4DvI2vni2pMvMSAQhARl2NtTxPHoMzWwcSTmXHoM4DYh14hG+C5QTZKDWnPSsw
        1+ohlimsg9BG6zIv9KUjvrQso4GDW0CUucsp6PmuCkXStvq2rUM+nRP1yGpWZwu2
        0j8BdGkNeuLhm+/XdIPK2ZO562DNDZZs562tr0100g/GIQgxxqq5HKWDc0BSy2+y
        ygMXbX0UVlBXtndTddL0NS4=
        =/nKj
        -----END PGP MESSAGE-----
        """

        let pgpDecrypted = try! pgp.decryptMessageVerify(cipher, verifierKey: myKeyring, privateKeyRing: myKeyring, passphrase: "1234", verifyTime: pgp.getTimeUnix())
        XCTAssertEqual(pgpDecrypted.plaintext, message)
        XCTAssertNotEqual(pgpDecrypted.verify, 0)
    }

    func testDecryptSignedByOther() {
        let message = "message from user2\n"
        let cipher = """
        -----BEGIN PGP MESSAGE-----

        wV4DvI2vni2pMvMSAQhAWY0yhqwG8sKFbUk52Su8g1fh6Bq6oNcVut2sSbpLKB4w
        r8YYd4RCVnlYQW4SRX63xSG8HaMYyDlmzhGCmpv/O5bILEPmndr0viyOEGCcQk1v
        0rMB9lFqZlmDy4T9oQ+hdZW7uBb/ocWDCoNAJ9SljZjz213UZVGRNFFlosSbKjQG
        2qwzlBCnP/nV9lYjPlmIdwfRkHa5A1OK9jClf3xiByBVfokEMOWzmA4yjdRzNSjz
        bKMBQjCmD33PtJoqCAYj+uG/5dgLf9eiPL/mh9dJeIhStI6oMOyQwG7csGhSUxV8
        mD72mwXfynCDOC91TVZDIpr9IHsVIcQPB6Wlc4gDdx3uMVh4mQ==
        =sijM
        -----END PGP MESSAGE-----
        """

        let senderKeyring = try! pgp.buildKeyRingArmored(senderPublicKey)
        let pgpDecrypted = try! pgp.decryptMessageVerify(cipher, verifierKey: senderKeyring, privateKeyRing: myKeyring, passphrase: "1234", verifyTime: pgp.getTimeUnix())
        XCTAssertEqual(pgpDecrypted.plaintext, message)
        XCTAssertEqual(pgpDecrypted.verify, 0)
    }

    func testDecryptUnsignedByOther() {
        let message = "message from user2\n"
        let cipher = """
        -----BEGIN PGP MESSAGE-----

        wV4DvI2vni2pMvMSAQhA+MRr61BE+hphKiFM/M3pJ012oLLu4TYl7hHnogIUOx0w
        W25F/EFlRhZdoMwgSgbuD4s9KHigP4yG1Ix3+JpY48jkkLQ9SBCjJ+QNVM4/Qe5n
        0kQBNVMBcXhVSPgHVGdyYnVKWx4qZsnuw5ti3Bt9vpXISQGedgnl1JXpast9PHhB
        Ta+ASNvNCRsoubVuRG84lIvQQq6mSQ==
        =i7mi
        -----END PGP MESSAGE-----
        """

        let senderKeyring = try! pgp.buildKeyRingArmored(senderPublicKey)
        let pgpDecrypted = try! pgp.decryptMessageVerify(cipher, verifierKey: senderKeyring, privateKeyRing: myKeyring, passphrase: "1234", verifyTime: pgp.getTimeUnix())
        XCTAssertEqual(pgpDecrypted.plaintext, message)
        XCTAssertNotEqual(pgpDecrypted.verify, 0)
    }

    func testDecryptInvalidSignature() {
        let message = "message from user2\n" // but signed by self instead of by sender
        let cipher = """
        -----BEGIN PGP MESSAGE-----

        wV4DvI2vni2pMvMSAQhACI3OZVgXDhYarU1Jhrv5NURGJofUwmHtwCBxLupCnGww
        OWzn8lvrLKh+fP64NV1BIZeb5uyXiFV8+SWSY3rqcgTR/APStgkq83wz0Umv8m6D
        0rMB89r0aiZYfX1e8zI4XT7VKhvOh6snE0TnqfbY/iTIml1A5vi3XM8qH1A/lpb9
        HDArwD6ofE+Ffyj3mbvcvmJvPNVQE/2zAvyy5Ar0CRgdtEaTWz5mchATNdcouSKA
        PiMKaWQtplSwg34bJ4OZ4gxYYD57leQANijSBwe2typttaUXOmxrFA/majo1DN0Z
        yNTD8TtgFikGzPdP0DguAnbcTXjbQ4foFVdESJbRlI7ZkVTI1g==
        =vyZr
        -----END PGP MESSAGE-----
        """

        let senderKeyring = try! pgp.buildKeyRingArmored(senderPublicKey)
        let pgpDecrypted = try! pgp.decryptMessageVerify(cipher, verifierKey: senderKeyring, privateKeyRing: myKeyring, passphrase: "1234", verifyTime: pgp.getTimeUnix())
        XCTAssertEqual(pgpDecrypted.plaintext, message)
        XCTAssertNotEqual(pgpDecrypted.verify, 0)
    }
}

// MARK: Encryption Tests
extension gopenpgpTests {
    func testEncryptSignedToSelf() {
        let message = "from me to me\n"
        try! myKeyring.unlock("1234".data(using: .utf8))
        let cipher = myKeyring.encryptMessage(message, sign: myKeyring, error: &error)

        let pgpDecrypted = try! pgp.decryptMessageVerify(cipher, verifierKey: myKeyring, privateKeyRing: myKeyring, passphrase: "1234", verifyTime: pgp.getTimeUnix())
        XCTAssertEqual(pgpDecrypted.plaintext, message)
        XCTAssertEqual(pgpDecrypted.verify, 0)
    }

    func testEncryptSignedToOther() {
        let message = "from me to you\n"
        try! myKeyring.unlock("1234".data(using: .utf8))
        let senderPublicKeyring = try! pgp.buildKeyRingArmored(senderPublicKey)
        let cipher = senderPublicKeyring.encryptMessage(message, sign: myKeyring, error: &error)

        let senderPrivateKeyring = try! pgp.buildKeyRingArmored(senderPrivateKey)
        let myPublicKeyring = try! pgp.buildKeyRingArmored(myKeyring.getArmoredPublicKey(&error))
        let pgpDecrypted = try! pgp.decryptMessageVerify(cipher, verifierKey: myPublicKeyring, privateKeyRing: senderPrivateKeyring, passphrase: "1234", verifyTime: pgp.getTimeUnix())
        XCTAssertEqual(pgpDecrypted.plaintext, message)
        XCTAssertEqual(pgpDecrypted.verify, 0)
    }
}

// MARK: Encrypt/Decrypt File Tests
extension gopenpgpTests {
    func testDecryptFile() {
        let mediaKey = """
        -----BEGIN PGP PRIVATE KEY BLOCK-----
        Version: GopenPGP 0.0.1 (ddacebe0)
        Comment: https://gopenpgp.org

        xYYEXPwqsBYJKwYBBAHaRw8BAQhAFM+cCGkHLlYopWeSkykdxSN/o9GlvcwVWr8k
        Id7Y2b/+CQMIqlyMn8TZTk5gWgs1nLttY06IT4w3g1j3VMrGvmmXI8ywGeywnRwe
        faxBigwesWtIgJp79BKNM//r8XuzhoNjwiUd3t2ZgZjb6M4ydaauPs0hbG9nb0B0
        cmlwdXAuYXBwIDxsb2dvQHRyaXB1cC5hcHA+wmoEExYIABwFAlz8KrAJEHj5SmCo
        fqhYAhsDAhkBAgsJAhUIAAA3pwEAM6faP3L7rIHtRCIM9lRKxQXTC3jjAmkHVpMR
        b6AsJ/kBANGSPe8ZMKoojvsG77oUHjbPFsb1eVEiqcfpgemC1IEGx4sEXPwqsBIK
        KwYBBAGXVQEFAQEIQKPxp07MTFA+zEXf+wBMtTBQckkfALNQk41bOWRcAnlHAwEK
        Cf4JAwg4d7ml0FEDrWBEk+y3Ayyq61CsWrXga7Ao0n8zUeEZFcfjUFLnXGL1/k+1
        6tqG1Ls7LloSpBf4/Ba6uhIzc7Cwgn/c9FQvLtQjZkHBQQMkwmEEGBYIABMFAlz8
        KrAJEHj5SmCofqhYAhsMAAB6+QEAdXSvK+BaicumJLZPWQmWt2kA4W8BWOrHwNvn
        1H1afvYBACXROqaEAFBlU0g2XT1TMdRKhjpCCdCsCQjBED+BreMD
        =Iuzr
        -----END PGP PRIVATE KEY BLOCK-----
        """
        let mediaKeyring = try! pgp.buildKeyRingArmored(mediaKey)
        let encryptedURL = URL(fileURLWithPath: testBundle.path(forResource: "logo", ofType: "pb")!)
        let binaryData = try! Data(contentsOf: encryptedURL)
        let encryptedData = try! PGPData(serializedData: binaryData)
        let decryptedData = try! pgp.decryptAttachment(encryptedData.keyPacket, dataPacket: encryptedData.dataPacket, kr: mediaKeyring, passphrase: nil)

        XCTAssertEqual(decryptedData.sha256().toHexString(), "40b614d357ca6d3c5030bb58857629db49ccca6ecd213e431b7d28049ce70054")
    }

    func testDecryptFileWrongKey() {
        let mediaKey = pgp.generateKey("logo.jpg", domain: "tripup.app", passphrase: nil, keyType: "x25519", bits: 256, error: &error)
        let mediaKeyring = try! pgp.buildKeyRingArmored(mediaKey)
        let encryptedURL = URL(fileURLWithPath: testBundle.path(forResource: "logo", ofType: "pb")!)
        let binaryData = try! Data(contentsOf: encryptedURL)
        let encryptedData = try! PGPData(serializedData: binaryData)

        XCTAssertThrowsError(try pgp.decryptAttachment(encryptedData.keyPacket, dataPacket: encryptedData.dataPacket, kr: mediaKeyring, passphrase: nil)) { error in
            XCTAssertEqual((error as NSError).domain, "go")
            XCTAssertEqual(error.localizedDescription, "openpgp: incorrect key")
        }
    }

    func testDecryptFileNoKey() {
        let mediaKeyring = CryptoKeyRing()
        let encryptedURL = URL(fileURLWithPath: testBundle.path(forResource: "logo", ofType: "pb")!)
        let binaryData = try! Data(contentsOf: encryptedURL)
        let encryptedData = try! PGPData(serializedData: binaryData)

        XCTAssertThrowsError(try pgp.decryptAttachment(encryptedData.keyPacket, dataPacket: encryptedData.dataPacket, kr: mediaKeyring, passphrase: nil)) { error in
            XCTAssertEqual((error as NSError).domain, "go")
            XCTAssertEqual(error.localizedDescription, "gopenpgp: cannot decrypt attachment: gopenpgp: cannot unlock key ring, no private key available")
        }
    }

    func testEncryptFile() {
        let url = URL(fileURLWithPath: testBundle.path(forResource: "logo", ofType: "jpg")!)
        let data = try! Data(contentsOf: url)

        let mediaKey = pgp.generateKey("logo.jpg", domain: "tripup.app", passphrase: nil, keyType: "x25519", bits: 256, error: &error)
        let mediaKeyring = try! pgp.buildKeyRingArmored(mediaKey)
        let encryptedPackage = try! pgp.encryptAttachment(data, fileName: "logo.jpg", publicKey: mediaKeyring)
        let encryptedDataOutput = PGPData.with {
            $0.algo = encryptedPackage.algo
            $0.keyPacket = encryptedPackage.keyPacket!
            $0.dataPacket = encryptedPackage.dataPacket!
        }
        let binaryDataOutput = try! encryptedDataOutput.serializedData()
        let destinationURL = FileManager.default.temporaryDirectory.appendingPathComponent("logo.pb")
        try! binaryDataOutput.write(to: destinationURL)

        let sourceURL = destinationURL
        let binaryDataInput = try! Data(contentsOf: sourceURL)
        let encryptedDataInput = try! PGPData(serializedData: binaryDataInput)
        let decryptedData = try! pgp.decryptAttachment(encryptedDataInput.keyPacket, dataPacket: encryptedDataInput.dataPacket, kr: mediaKeyring, passphrase: nil)

        XCTAssertEqual(data.sha256().toHexString(), decryptedData.sha256().toHexString())
    }
}
