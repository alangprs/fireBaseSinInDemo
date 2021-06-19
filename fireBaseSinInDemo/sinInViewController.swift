//
//  sinInViewController.swift
//  fireBaseSinInDemo
//
//  Created by 翁燮羽 on 2021/6/16.
//

import UIKit
import Firebase
import FacebookCore
import FacebookLogin
import GoogleSignIn


class sinInViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    //讀選擇註冊還是登入
    @IBOutlet weak var chooseView: UISegmentedControl!
    
    @IBOutlet weak var emailTexField: UITextField!
    
    @IBOutlet weak var passWordTextField: UITextField!
    
    @IBOutlet weak var nameTexField: UITextField!
    
    //FB
    let manager = LoginManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTexField.alpha = 0 //一開始在登入選項，所以使用者名稱隱藏
        nameLabel.alpha = 0
        // Do any additional setup after loading the view.
    }
    //判斷目前選擇 0=登入 1=註冊
    @IBAction func judgmentChoose(_ sender: UISegmentedControl) {
        if chooseView.selectedSegmentIndex == 0 { //登入執行
            nameTexField.alpha = 0
            nameLabel.alpha = 0
        }else{//註冊執行
            nameTexField.alpha = 1
            nameLabel.alpha = 1
        }
    }
    
    //跳出錯誤訊息
    func texAler(title:String,message:String){
        let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "確定", style: .default, handler: nil)
        controller.addAction(action)
        present(controller, animated: true, completion: nil)
    }
    
    //執行註冊動作
    func sinInUp(){
        //判斷有無輸入資料
        if emailTexField.text?.isEmpty == false,
           passWordTextField.text?.isEmpty == false,
           nameTexField.text?.isEmpty == false{
            //使用createUser 註冊
            Auth.auth().createUser(withEmail: self.emailTexField.text!, password: self.passWordTextField.text!) { result, error in
                //使用guard 確認 1.讀到註冊成功資料 2.沒有錯誤
                guard let user = result?.user,
                      error == nil else {
                    print("印出錯誤",error?.localizedDescription)
                    self.texAler(title: "錯誤", message: "確認資料是否填寫正確")
                    return
                }
                //註冊成功後，設定使用者名稱
                //currentUser = 當前用戶 createProfileChangeRequest = 配置修改
                let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                //displayName ＝ 修改名稱
                changeRequest?.displayName = self.nameTexField.text!
                //commitChanges 請求修改
                changeRequest?.commitChanges(completion: { error in
                    guard error == nil else{
                        print(error?.localizedDescription)
                        return
                    }
                })
                print("註冊成功",user.uid)
                self.emailTexField.text = ""
                self.passWordTextField.text = ""
                self.nameTexField.text = ""
                self.texAler(title: "註冊成功", message: "")
            }
        }else{//如果沒輸入資料跳出通知
            if emailTexField.text?.isEmpty == true{
                texAler(title: "內容未填寫", message: "請確認信箱是否填寫")
            }else if passWordTextField.text?.isEmpty == true{
                texAler(title: "內容未填寫", message: "請填寫六位數字密碼")
                
            }else if nameTexField.text?.isEmpty == true{
                texAler(title: "內容未填寫", message: "請確認使用者名稱是否填寫")
            }
            
        }
    }
    
    //執行登入動作
    func sinIn(){
        if emailTexField.text?.isEmpty == false,
           passWordTextField.text?.isEmpty == false{
            //使用signIn 登入
            Auth.auth().signIn(withEmail: self.emailTexField.text!, password: self.passWordTextField.text!) { result, error in
                guard let user = result?.user,
                      error == nil else {
                    print(error?.localizedDescription)
                    self.texAler(title: "登入失敗", message: "請確認登入資料是否正確 \n 如未註冊，請先註冊帳號")
                    return
                }
                //讀取登入者資料
                if let user = Auth.auth().currentUser{
                    self.texAler(title: "登入成功", message: "歡迎\(user.displayName!)回來")
                }
                self.emailTexField.text = ""
                self.passWordTextField.text = ""
                print("登入成功")
                
            }
        }
    }

    
    //確認
    @IBAction func enter(_ sender: UIButton) {
        if chooseView.selectedSegmentIndex == 0{ //登入
            sinIn()
        }else{//註冊
            sinInUp()
        }
        
    }
    
    //判斷是否跳到下一頁
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        guard Auth.auth().currentUser != nil else {
            texAler(title: "未登入", message: "請先登入之後才有資料修改啊大佬")
            return false
        }
        return true
    }
    //修改密碼
    @IBAction func eidtPassWord(_ sender: UIButton) {

        }
    
    //登出
    @IBAction func sinOut(_ sender: UIButton) {
        //使用do 嘗試登出 因為signOut 有 throws 可能失敗
        do {
            try Auth.auth().signOut()
            texAler(title: "已登出", message: "等你回來")
        } catch {
            print(error.localizedDescription)
        }
        //fb登出
//        manager.logOut()
    }
    
    //ＦＢ登入func
        func logIn(permissions: [Permission] = [.publicProfile],
                     viewController: UIViewController? = nil,
                     completion: LoginResultBlock? = nil){
            
        }
    //fb登入
    func fBlogin() {
        
            let manager = LoginManager()
            manager.logIn(permissions: [.publicProfile], viewController: self) { (result) in
                if case LoginResult.success(granted: _, declined: _, token: _) = result {
                    print("fb login ok")
                    
                    let credential =  FacebookAuthProvider.credential(withAccessToken: AccessToken.current!.tokenString)
                        Auth.auth().signIn(with: credential) { [weak self] (result, error) in
                        guard let self = self else { return }
                        guard error == nil else {
                            print(error?.localizedDescription)
                            return
                        }
                        print("login ok")
                    }
                    
                } else {
                    print("login fail")
                }
            }
    }
     //FB登入
    @IBAction func fbSinIn(_ sender: UIButton) {
       fBlogin()
       
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
