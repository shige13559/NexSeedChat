//
//  LoginViewController.swift
//  NexSeedChat
//
//  Created by 原田茂大 on 2019/12/10.
//  Copyright © 2019 geshi. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import RevealingSplashView

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        GIDSignIn.sharedInstance()?.delegate = self
        GIDSignIn.sharedInstance()?.presentingViewController = self
        
        let splashView = RevealingSplashView(
            iconImage: UIImage(named: "seedkun")!,
            iconInitialSize: CGSize(width: 250, height: 250),
            backgroundColor: UIColor(red: 79/255, green: 171/255, blue: 255/255, alpha: 1)
        )
        
        //スプラッシュのアニメーションの設定
        splashView.animationType = .swingAndZoomOut
        //画面に表示
        self.view.addSubview(splashView)
        //アニメーション開始
        splashView.startAnimation{
            //アニメ終了時の処理
            //スプラッシュを表示したので、「true:表示したと設定」
            didDisplaySplashFlg = true
        }
    }


}

//LoginViewControllerをログインできるように拡張
extension LoginViewController: GIDSignInDelegate{
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        //エラーがないかちてチェック
        if let err = error{
            //変数がnilでない場合
            //エラー情報を取得
            print(error.localizedDescription)
            return
        }
        
        //認証情報を取得
        guard let authentication = user.authentication else {
            //認証情報が取れなければ、処理を中断
            return
        }
        
        //Firebaseに認証情報を登録
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
        accessToken: authentication.accessToken)
        
        Auth.auth().signIn(with: credential) { (result, error) in
            
            if let error = error{
                //エラーがある場合
                print(error.localizedDescription)
            }else{
                //ログインが成功した場合
                print("ログイン成功")
                self.performSegue(withIdentifier: "toHome", sender: nil)
            }
        }
        
    }
    
   
    
    
    
}
