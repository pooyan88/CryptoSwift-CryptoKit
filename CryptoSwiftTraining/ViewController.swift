//
//  ViewController.swift
//  CryptoSwiftTraining
//
//  Created by Pooyan J on 11/1/1402 AP.
//

import UIKit
import CryptoSwift
import CryptoKit

class ViewController: UIViewController {
    
    let key = "2tC2H19lkVbQDfakxcrtNMQdd0FloLyw"
    let iv = "bbC2H19lkVbQDfak"
    let text = "Hello World"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let encrypted: String = try! text.aesEncrypt(key: key, iv: iv)
        print("ENCRYPTED DATA ===> ", encrypted)
        
       let decrypted = try! encrypted.aesDecrypt(key: key, iv: iv)
        print("DECRYPTED STRING ===> ", decrypted)
        
        
        
        let encryptedData = encryptData(data: Data(text.utf8), key: Data(key.utf8))
        let decodedData = decryptData(data: encryptedData!, key: Data(key.utf8))
        let pureSTR = String(decoding: decodedData!, as: UTF8.self)
        print(pureSTR)
    }
}

extension ViewController {
    
    func encryptData(data: Data, key: Data) -> Data? {
        let cipher = try! AES.GCM.seal(data, using: SymmetricKey(data: key))
        return cipher.combined
    }

    func decryptData(data: Data, key: Data) -> Data? {
        let sealedBox = try! AES.GCM.SealedBox(combined: data)
        let decryptedData = try! AES.GCM.open(sealedBox, using: SymmetricKey(data: key))
        return decryptedData
    }
}


extension String {

    func aesEncrypt(key: String, iv: String) throws -> String {
        let data = self.data(using: .utf8)!
        let encrypted = try! AES(key: key, iv: iv, padding: .pkcs7).encrypt([UInt8](data))
        let encryptedData = Data(encrypted)
        return encryptedData.toHexString()
    }

    func aesDecrypt(key: String, iv: String) throws -> String {
        let data = self.dataFromHexadecimalString()!
        let decrypted = try! AES(key: key, iv: iv, padding:.pkcs7).decrypt([UInt8](data))
        let decryptedData = Data(decrypted)
        return String(bytes: decryptedData.bytes, encoding: .utf8) ?? "Could not decrypt"
    }

    func dataFromHexadecimalString() -> Data? {
        var data = Data(capacity: count / 2)
        let regex = try! NSRegularExpression(pattern: "[0-9a-f]{1,2}", options: .caseInsensitive)
        regex.enumerateMatches(in: self, options: [], range: NSMakeRange(0, count)) { match, flags, stop in
            let byteString = (self as NSString).substring(with: match!.range)
            let num = UInt8(byteString, radix: 16)
            data.append(num!)
        }
            return data
    }
}

extension Data {

    var bytes: Array<UInt8> {
        return Array(self)
    }

    func toHexString() -> String {
        return bytes.toHexString()
    }

}
