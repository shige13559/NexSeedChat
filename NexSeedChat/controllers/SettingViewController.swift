//
//  SettingViewController.swift
//  NexSeedChat
//
//  Created by 原田茂大 on 2019/12/12.
//  Copyright © 2019 geshi. All rights reserved.
//

import UIKit
import Firebase

class SettingViewController: UIViewController {
    
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var emailLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //現在ログインしている人を取得
        let user = Auth.auth().currentUser!
        nameLabel.text = user.displayName
        emailLabel.text = user.email
        
        //URLをもとに画像データを取得
        let data = try! Data(contentsOf: user.photoURL!)
        
        //取得したデータをもとに、Imageを作成
        let image = UIImage(data: data)
        
        imageView.image = image
        
        
    }
    
    //ログアウトボタンが押された時の処理
    @IBAction func didClickLogoutButton(_ sender: UIButton) {
        
        try! Auth.auth().signOut()
        
        performSegue(withIdentifier: "toBack", sender: nil)
        
        
    }
    

    

}
