//
//  ViewController.swift
//  ErrorExample
//
//  Created by rokihiro on 2018/08/20.
//  Copyright © 2018年 rokihiro. All rights reserved.
//

import UIKit
import Result

class ViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var ResultErrorLabel: UILabel!
    @IBOutlet weak var DoCatchErrorLabel: UILabel!
    let nameLengthMax = 10
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func tapRegisterButton(_ sender: Any) {
        // use Result
        let result = validateNameWithResult(name: self.nameTextField.text)
        switch result{
        case let .success(name): self.ResultErrorLabel.text = "\(name)を登録しました。"
        case let .failure(error):
            switch error{
            case .Empty: self.ResultErrorLabel.text = "からです。"
            case .InvalidChar: self.ResultErrorLabel.text = "無効な文字が含まれています。"
            case .TooLong(let length): self.ResultErrorLabel.text = "名前が長すぎます。max:\(nameLengthMax) length: \(length)"
            }
        }
        
        // use do-catch
        
        do {
            let name = try validateNameWithDoCatch(name: self.nameTextField.text)
            self.DoCatchErrorLabel.text = "\(name)を登録しました。"
        }catch ValidationError.Empty{
            self.DoCatchErrorLabel.text = "からです。"
        }catch ValidationError.InvalidChar{
            self.DoCatchErrorLabel.text = "無効な文字が含まれています。"
        }catch ValidationError.TooLong(let length){
            self.DoCatchErrorLabel.text = "名前が長すぎます。max:\(nameLengthMax) length: \(length)"
        }catch{
            self.DoCatchErrorLabel.text = "不明なエラー。"
        }
    }
    
    // Errorプロトコルに準拠。エラーを示すだけで実装は不要
    enum ValidationError : Error{
        case Empty
        case TooLong(length:Int) //値を渡すこともできる
        case InvalidChar
    }
    
    func validateNameWithResult(name:String?) -> Result<String,ValidationError>{
        guard let _name = name else{
            return .failure(.Empty)
        }
        
        if _name.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            return .failure(.Empty)
        }
        
        let invalidChars = ["@","\'","\"",",","."]
        for char in invalidChars{
            if _name.contains(char){
                return .failure(.InvalidChar)
            }
        }
        
        let nameLengthMax = 10
        if _name.count > nameLengthMax{
            return .failure(.TooLong(length: _name.count))
        }
        
        return .success(_name)
    }
    
    func validateNameWithDoCatch(name:String?) throws -> String {
        guard let _name = name else{
            throw ValidationError.Empty
        }
        
        if _name.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            throw ValidationError.Empty
        }
        
        let invalidChars = ["@","\'","\"",",","."]
        for char in invalidChars{
            if _name.contains(char){
                throw ValidationError.InvalidChar
            }
        }
        
        
        if _name.count > nameLengthMax{
            throw ValidationError.TooLong(length: _name.count)
        }
        
        return _name
    }
    
    
}

