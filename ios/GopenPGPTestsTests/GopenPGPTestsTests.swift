//
//  GopenPGPTestsTests.swift
//  GopenPGPTestsTests
//
//  Created by Vinoth Ramiah on 05/06/2019.
//  Copyright © 2019 Vinoth Ramiah. All rights reserved.
//

import XCTest
import Gopenpgp
import CryptoSwift
@testable import GopenPGPTests

class GopenPGPTestsTests: XCTestCase {
    private let testBundle = Bundle(for: GopenPGPTestsTests.self)

    private let myPrivateKey = """
    -----BEGIN PGP PRIVATE KEY BLOCK-----
    Version: GopenPGP 2.1.0
    Comment: https://gopenpgp.org

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

    private let myPrivateKeyOld = """
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
    Comment: https://gopenpgp.org
    Version: GopenPGP 2.1.0

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

    private let senderPublicKeyWithoutHeaders = """
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
    """ //  generated with GopenPGP 0.0.1

    private var error: NSError?
    private var passphrase: Data? {
        return "1234".data(using: .utf8)
    }

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        error = nil
        super.tearDown()
    }

    func testUnlockKeyValidPass() {
        let myKey = CryptoKey(fromArmored: myPrivateKey)
        XCTAssertNoThrow(try myKey?.unlock(passphrase))
    }

    func testUnlockKeyInvalidPass() {
        let myKey = CryptoKey(fromArmored: myPrivateKey)
        XCTAssertThrowsError(try myKey?.unlock(nil)) { error in
            XCTAssertEqual((error as NSError).domain, "go")
            XCTAssertEqual(error.localizedDescription, "gopenpgp: error in unlocking key: openpgp: invalid data: private key checksum failure")
        }
        XCTAssertThrowsError(try myKey?.unlock("123".data(using: .utf8))) { error in
            XCTAssertEqual((error as NSError).domain, "go")
            XCTAssertEqual(error.localizedDescription, "gopenpgp: error in unlocking key: openpgp: invalid data: private key checksum failure")
        }
    }

    func testDerivePublicKey() {
        let senderKey = CryptoKey(fromArmored: senderPrivateKey)
        XCTAssertEqual(senderKey?.getArmoredPublicKey(withCustomHeaders: nil, version: nil, error: &error), senderPublicKeyWithoutHeaders)
    }

    func testPublicKeyEquality() {
        let senderKey = CryptoKey(fromArmored: senderPublicKey)
        let senderKey2 = CryptoKey(fromArmored: senderPublicKeyWithoutHeaders)
        XCTAssertEqual(senderKey?.getFingerprint(), senderKey2?.getFingerprint())
    }

    func testPrivateKeyEquality() {
        let key = CryptoKey(fromArmored: myPrivateKey)
        let key2 = CryptoKey(fromArmored: myPrivateKeyOld)
        XCTAssertEqual(key?.getFingerprint(), key2?.getFingerprint())
    }

    func testKeyRingPublicKey() {
        let senderPublic1 = CryptoKey(fromArmored: senderPublicKey)
        let senderPublicKeyRing1 = CryptoKeyRing(senderPublic1)
        let cipher1 = try? senderPublicKeyRing1?.encrypt(CryptoNewPlainMessageFromString("hi"), privateKey: nil)
        XCTAssertNotNil(cipher1)

        // invalid – public key of public key
        let senderPublic2 = try? senderPublic1?.toPublic()
        XCTAssertNil(senderPublic2)

        // invalid – encrypt with a private key ring
        let myKey1 = CryptoKey(fromArmored: myPrivateKey)
        let myKeyRing1 = CryptoKeyRing(myKey1)
        let cipher2 = try? myKeyRing1?.encrypt(CryptoNewPlainMessageFromString("hi"), privateKey: nil)
        XCTAssertNil(cipher2)

        let myKey2 = try? myKey1?.toPublic()
        let myKeyRing2 = CryptoKeyRing(myKey2)
        let cipher3 = try? myKeyRing2?.encrypt(CryptoNewPlainMessageFromString("hi"), privateKey: nil)
        XCTAssertNotNil(cipher3)
    }

    func testKeyRingPrivateLock() {
        let key = CryptoKey(fromArmored: myPrivateKey)
        let keyRing1 = CryptoKeyRing(key)
        XCTAssertNil(keyRing1)

        let unlockedKey = try? key?.unlock(passphrase)
        let keyRing2 = CryptoKeyRing(unlockedKey)
        XCTAssertNotNil(keyRing2)
    }
}

// MARK: Decryption Tests
extension GopenPGPTestsTests {
    func testDecryptWithWrongKey() {
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
        """ // "message for user2\n", but try to decrypt using my key

        let _ = HelperDecryptVerifyMessageArmored(myPrivateKey, myPrivateKey, passphrase, cipher, &error)
        XCTAssertNotNil(error)
        XCTAssertEqual(error?.domain, "go")
        XCTAssertEqual(error?.localizedDescription, "gopenpgp: unable to decrypt message: gopenpgp: error in reading message: openpgp: incorrect key")

        // manually, using key + keyring
        let myKey = CryptoKey(fromArmored: myPrivateKey)
        XCTAssertThrowsError(try CryptoKeyRing(nil)?.decrypt(CryptoPGPMessage(fromArmored: cipher), verifyKey: CryptoKeyRing(myKey), verifyTime: CryptoGetUnixTime())) { error in
            XCTAssertEqual((error as NSError).domain, "go")
            XCTAssertEqual(error.localizedDescription, "gopenpgp: error in reading message: openpgp: incorrect key")
        }
        let unlockedCryptoKey = try? myKey?.unlock(passphrase)
        XCTAssertThrowsError(try CryptoKeyRing(unlockedCryptoKey)?.decrypt(CryptoPGPMessage(fromArmored: cipher), verifyKey: CryptoKeyRing(myKey), verifyTime: CryptoGetUnixTime())) { error in
            XCTAssertEqual((error as NSError).domain, "go")
            XCTAssertEqual(error.localizedDescription, "gopenpgp: error in reading message: openpgp: incorrect key")
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

        let decryptedMessage = HelperDecryptVerifyMessageArmored(myPrivateKey, myPrivateKey, passphrase, cipher, &error)
        XCTAssertNil(error)
        XCTAssertEqual(decryptedMessage, message)

        let decryptedMessageIgnoreSig = HelperDecryptMessageArmored(myPrivateKey, passphrase, cipher, &error)
        XCTAssertNil(error)
        XCTAssertEqual(decryptedMessageIgnoreSig, message)
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

        let decryptedMessage = HelperDecryptMessageArmored(myPrivateKey, passphrase, cipher, &error)
        XCTAssertNil(error)
        XCTAssertEqual(decryptedMessage, message)

        let decryptedMessageWithSig = HelperDecryptVerifyMessageArmored(myPrivateKey, myPrivateKey, passphrase, cipher, &error)
        XCTAssertNotNil(error)
        XCTAssertEqual(error?.domain, "go")
        XCTAssertEqual(error?.localizedDescription, "gopenpgp: unable to decrypt message: Signature Verification Error: No matching signature")
        XCTAssertEqual(decryptedMessageWithSig, "")
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

        let decryptedMessage = HelperDecryptVerifyMessageArmored(senderPublicKey, myPrivateKey, passphrase, cipher, &error)
        XCTAssertNil(error)
        XCTAssertEqual(decryptedMessage, message)

        let decryptedMessageIgnoreSig = HelperDecryptMessageArmored(myPrivateKey, passphrase, cipher, &error)
        XCTAssertNil(error)
        XCTAssertEqual(decryptedMessageIgnoreSig, message)
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

        let decryptedMessage = HelperDecryptMessageArmored(myPrivateKey, passphrase, cipher, &error)
        XCTAssertNil(error)
        XCTAssertEqual(decryptedMessage, message)

        let decryptedMessageWithSig = HelperDecryptVerifyMessageArmored(senderPublicKey, myPrivateKey, passphrase, cipher, &error)
        XCTAssertNotNil(error)
        XCTAssertEqual(error?.domain, "go")
        XCTAssertEqual(error?.localizedDescription, "gopenpgp: unable to decrypt message: Signature Verification Error: No matching signature")
        XCTAssertEqual(decryptedMessageWithSig, "")

        // manually, using key + keyring
        let myKey = CryptoKey(fromArmored: myPrivateKey)
        let unlockedKey = try? myKey?.unlock(passphrase)
        var decryptedMessageManual: CryptoPlainMessage?
        XCTAssertNoThrow(decryptedMessageManual = try CryptoKeyRing(unlockedKey)?.decrypt(CryptoPGPMessage(fromArmored: cipher), verifyKey: nil, verifyTime: CryptoGetUnixTime()))
        XCTAssertEqual(decryptedMessageManual?.getString(), message)
        decryptedMessageManual = nil

        XCTAssertThrowsError(decryptedMessageManual = try CryptoKeyRing(unlockedKey)?.decrypt(CryptoPGPMessage(fromArmored: cipher), verifyKey: CryptoKeyRing(CryptoKey(fromArmored: senderPublicKey)), verifyTime: CryptoGetUnixTime())) { error in
            XCTAssertEqual((error as NSError).domain, "go")
            XCTAssertEqual(error.localizedDescription, "Signature Verification Error: No matching signature")
        }
        XCTAssertNil(decryptedMessageManual)
    }

    func testDecryptInvalidSignature() {
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
        """ // "message from user2\n", but signed by self instead of by sender

        let decryptedMessage = HelperDecryptVerifyMessageArmored(senderPublicKey, myPrivateKey, passphrase, cipher, &error)
        XCTAssertNotNil(error)
        XCTAssertEqual(error?.domain, "go")
        XCTAssertEqual(error?.localizedDescription, "gopenpgp: unable to decrypt message: Signature Verification Error: No matching signature")
        XCTAssertEqual(decryptedMessage, "")

        // manually, using key + keyring
        let myKey = CryptoKey(fromArmored: myPrivateKey)
        let unlockedKey = try? myKey?.unlock(passphrase)
        var decryptedMessageManual: CryptoPlainMessage?
        XCTAssertNoThrow(decryptedMessageManual = try CryptoKeyRing(unlockedKey)?.decrypt(CryptoPGPMessage(fromArmored: cipher), verifyKey: nil, verifyTime: CryptoGetUnixTime()))
        XCTAssertEqual(decryptedMessageManual?.getString(), "message from user2\n")
        decryptedMessageManual = nil

        XCTAssertThrowsError(decryptedMessageManual = try CryptoKeyRing(unlockedKey)?.decrypt(CryptoPGPMessage(fromArmored: cipher), verifyKey: CryptoKeyRing(CryptoKey(fromArmored: senderPublicKey)), verifyTime: CryptoGetUnixTime())) { error in
            XCTAssertEqual((error as NSError).domain, "go")
            XCTAssertEqual(error.localizedDescription, "Signature Verification Error: No matching signature")
        }
        XCTAssertNil(decryptedMessageManual)
    }
}

// MARK: Encryption Tests
extension GopenPGPTestsTests {
    func testEncryptSignedToSelf() {
        let message = "from me to me\n"
        let cipher = HelperEncryptSignMessageArmored(myPrivateKey, myPrivateKey, passphrase, message, &error)
        XCTAssertNil(error)

        let decryptedMessage = HelperDecryptVerifyMessageArmored(myPrivateKey, myPrivateKey, passphrase, cipher, &error)
        XCTAssertNil(error)
        XCTAssertEqual(decryptedMessage, message)

        // manually, using key + keyring
        let myKey = CryptoKey(fromArmored: myPrivateKey)
        let unlockedKey = try? myKey?.unlock(passphrase)
        let unlockedKeyRing = CryptoKeyRing(unlockedKey)
        let publicKey = try? myKey?.toPublic()
        let publicKeyRing = CryptoKeyRing(publicKey)
        let cipher2 = try? publicKeyRing?.encrypt(CryptoNewPlainMessageFromString(message), privateKey: unlockedKeyRing).getArmored(&error)
        XCTAssertNil(error)
        XCTAssertNotNil(cipher2)

        let decryptedMessage2 = HelperDecryptVerifyMessageArmored(myPrivateKey, myPrivateKey, passphrase, cipher2, &error)
        XCTAssertNil(error)
        XCTAssertEqual(decryptedMessage2, message)
    }

    func testEncryptUnsignedToSelf() {
        let message = "from me to me\n"

        let publicKey = CryptoKey(fromArmored: senderPublicKey)
        let publicKeyRing = CryptoKeyRing(publicKey)
        let cipher = try? publicKeyRing?.encrypt(CryptoNewPlainMessageFromString(message), privateKey: nil).getArmored(&error)
        XCTAssertNil(error)
        XCTAssertNotNil(cipher)

        let decryptedMessage = HelperDecryptMessageArmored(senderPrivateKey, passphrase, cipher, &error)
        XCTAssertNil(error)
        XCTAssertEqual(decryptedMessage, message)
    }

    func testEncryptSignedToOther() {
        let message = "from me to you\n"
        let cipher = HelperEncryptSignMessageArmored(senderPublicKey, myPrivateKey, passphrase, message, &error)

        let decryptedMessage = HelperDecryptVerifyMessageArmored(myPrivateKey, senderPrivateKey, passphrase, cipher, &error)
        XCTAssertNil(error)
        XCTAssertEqual(decryptedMessage, message)
    }
}

// MARK: Encrypt/Decrypt File Tests
extension GopenPGPTestsTests {
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

        let encryptedURL = URL(fileURLWithPath: testBundle.path(forResource: "logo", ofType: "pb")!)
        let binaryData = try! Data(contentsOf: encryptedURL)
        let encryptedData = try! PGPData(serializedData: binaryData)

        let decryptedData = HelperDecryptAttachmentWithKey(mediaKey, nil, encryptedData.keyPacket, encryptedData.dataPacket, &error)
        XCTAssertNil(error)
        XCTAssertEqual(decryptedData?.sha256().toHexString(), "40b614d357ca6d3c5030bb58857629db49ccca6ecd213e431b7d28049ce70054")
    }

    func testDecryptFileWrongKey() {
        let encryptedURL = URL(fileURLWithPath: testBundle.path(forResource: "logo", ofType: "pb")!)
        let binaryData = try! Data(contentsOf: encryptedURL)
        let encryptedData = try! PGPData(serializedData: binaryData)

        let mediaKey = HelperGenerateKey("logo.jpg", "media@tripup.app", nil, "x25519", 256, &error)
        XCTAssertNil(error)

        let decryptedData = HelperDecryptAttachmentWithKey(mediaKey, nil, encryptedData.keyPacket, encryptedData.dataPacket, &error)
        XCTAssertNotNil(error)
        XCTAssertEqual(error?.domain, "go")
        XCTAssertEqual(error?.localizedDescription, "gopenpgp: unable to decrypt attachment: gopengpp: unable to read attachment: openpgp: incorrect key")
        XCTAssertNil(decryptedData)
        error = nil

        // with key ring
        let decryptedData2 = HelperDecryptAttachment(encryptedData.keyPacket, encryptedData.dataPacket, CryptoKeyRing(CryptoKey(fromArmored: mediaKey)), &error)
        XCTAssertNotNil(error)
        XCTAssertEqual(error?.domain, "go")
        XCTAssertEqual(error?.localizedDescription, "gopenpgp: unable to decrypt attachment: gopengpp: unable to read attachment: openpgp: incorrect key")
        XCTAssertNil(decryptedData2)
    }

    func testDecryptFileNoKey() {
        let encryptedURL = URL(fileURLWithPath: testBundle.path(forResource: "logo", ofType: "pb")!)
        let binaryData = try! Data(contentsOf: encryptedURL)
        let encryptedData = try! PGPData(serializedData: binaryData)

        let decryptedData = HelperDecryptAttachmentWithKey(nil, nil, encryptedData.keyPacket, encryptedData.dataPacket, &error)
        XCTAssertNotNil(error)
        XCTAssertEqual(error?.domain, "go")
        XCTAssertEqual(error?.localizedDescription, "gopenpgp: unable to parse private key: gopenpgp: error in reading key ring: openpgp: invalid argument: no armored data found")
        XCTAssertNil(decryptedData)
    }

    func testEncryptFile() {
        let url = URL(fileURLWithPath: testBundle.path(forResource: "logo", ofType: "jpg")!)
        let data = try! Data(contentsOf: url)

        let mediaKey = HelperGenerateKey("logo.jpg", "media@tripup.app", nil, "x25519", 256, &error)
        XCTAssertNil(error)
        let encryptedMessage = HelperEncryptAttachmentWithKey(mediaKey, nil, data, &error)
        XCTAssertNil(error)
        let pgpData = PGPData.with {
            $0.keyPacket = encryptedMessage!.keyPacket!
            $0.dataPacket = encryptedMessage!.dataPacket!
        }
        let encryptedData = try? pgpData.serializedData()
        let destinationURL = FileManager.default.temporaryDirectory.appendingPathComponent("logo.pb")
        try? encryptedData?.write(to: destinationURL)

        let sourceURL = destinationURL
        let binaryDataInput = try? Data(contentsOf: sourceURL)
        let pgpInput = try? PGPData(serializedData: binaryDataInput!)
        let decryptedData = HelperDecryptAttachmentWithKey(mediaKey, nil, pgpInput?.keyPacket, pgpInput?.dataPacket, &error)
        XCTAssertNil(error)
        XCTAssertEqual(data.sha256().toHexString(), decryptedData?.sha256().toHexString())
        try? FileManager.default.removeItem(at: destinationURL)

        // with key ring
        let encryptedMessage2 = HelperEncryptAttachment(data, nil, CryptoKeyRing(CryptoKey(fromArmored: mediaKey)), &error)
        XCTAssertNil(error)
        let pgpData2 = PGPData.with {
            $0.keyPacket = encryptedMessage2!.keyPacket!
            $0.dataPacket = encryptedMessage2!.dataPacket!
        }
        let encryptedData2 = try? pgpData2.serializedData()
        try? encryptedData2?.write(to: destinationURL)

        let binaryDataInput2 = try? Data(contentsOf: sourceURL)
        let pgpInput2 = try? PGPData(serializedData: binaryDataInput2!)
        let decryptedData2 = HelperDecryptAttachmentWithKey(mediaKey, nil, pgpInput2?.keyPacket, pgpInput2?.dataPacket, &error)
        XCTAssertNil(error)
        XCTAssertEqual(data.sha256().toHexString(), decryptedData2?.sha256().toHexString())
    }
}
