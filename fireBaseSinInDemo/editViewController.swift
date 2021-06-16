//
//  editViewController.swift
//  fireBaseSinInDemo
//
//  Created by 翁燮羽 on 2021/6/16.
//

import UIKit
import Firebase

class editViewController: UIViewController {
    //讀輸入的密碼 0＝舊密碼 1＝新密碼 2再次確認密碼
    @IBOutlet var passWordTeex: [UITextField]!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    //執行更換密碼
    func changPassWord(){
        
        if passWordTeex[0].text?.isEmpty == false,
           passWordTeex[1].text?.isEmpty == false{ //確定有輸入內容
            //確認字數高於6
            if passWordTeex[0].text!.count > 6,
               //確認新密碼 兩次都是輸入正確
               passWordTeex[0].text == passWordTeex[1].text{
                
                //用sendPasswordReset 來修改密碼
                Auth.auth().sendPasswordReset(withEmail: self.passWordTeex[0].text!) { error in
                    if error == nil{
                        print(error?.localizedDescription)
                    }else{
                        self.errorAler(title: "修改成功", message: "")
                    }
                    
                }
            }else if passWordTeex[0].text != passWordTeex[1].text{//如果新密碼跟舊密碼一樣
                errorAler(title: "密碼確認錯誤", message: "請確認再次輸入密碼是否與設定密碼相符")
            }else{
                print("失敗")
            }


        }else{ //如果都沒輸入值
            errorAler(title: "錯誤", message: "請輸入內容")
        }
       
    }
    //彈跳通知
    func errorAler(title:String,message:String){
        let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "確定", style: .default, handler: nil)
        controller.addAction(action)
        present(controller, animated: true, completion: nil)
    }
    
    //確認
    @IBAction func enter(_ sender: Any) {
        changPassWord()
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
