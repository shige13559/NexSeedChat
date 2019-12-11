//
//  RoomViewController.swift
//  NexSeedChat
//
//  Created by 原田茂大 on 2019/12/10.
//  Copyright © 2019 geshi. All rights reserved.
//

import UIKit
import Firebase
import RevealingSplashView

class RoomViewController: UIViewController {
    
    var rooms: [Room] = []{
        didSet{
            //値が書き換わったらtableViewを更新する
            tableView.reloadData()
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tableView.dataSource = self
        tableView.delegate = self
        
        showSplashView()
        
        let db = Firestore.firestore()
        
        db.collection("rooms").order(by: "createdAt", descending: true).addSnapshotListener { (querySnapshot, error) in
            //最新のroomsのコレクションの中身(ドキュメント)を取得

            guard let documents = querySnapshot?.documents else{

                //roomsのコレクションの中身がnilの場合、処理を中断
                //中身がある場合、変数documentsの中身に全て入れる
                return
            }

            //結果を入れる配列
            var results: [Room] = []

            //ドキュメントをfor分を使ってループする
            for document in documents{
                let name = document.get("name") as! String
                let room = Room(name: name, documentId: document.documentID)
                results.append(room)

            }
            //テーブルに表示する変数roomsを全結果の入ったresultsで上書き
            self.rooms = results
        }
        
        
        
    }
    
    
    //追加ボタンが押された時の処理
    @IBAction func didClickButton(_ sender: UIButton) {
        
        //名前が空文字かてチェック
        if textField.text!.isEmpty{
        //処理を中断
        return
        }
        
        let db = Firestore.firestore()
        db.collection("rooms").addDocument(data: [   //[ db.collection("samples"):部屋を作った
            "name": textField.text!, //部屋の名前
            "createdAt": FieldValue.serverTimestamp() //作成日時
        ]) {error in
            if let err = error{
                print(err.localizedDescription)
            }
        }
        
        textField.text = ""
    }
    
    func showSplashView(){
        
        let splashView = RevealingSplashView(
            iconImage: UIImage(named: "seedkun")!,
            iconInitialSize: CGSize(width: 250, height: 250),
            backgroundColor: UIColor(red: 79/255, green: 171/255, blue: 255/255, alpha: 1)
        )
        
        //スプラッシュのアニメーションの設定
        splashView.animationType = .swingAndZoomOut
        //画面に表示
        //self.view.addSubview(splashView)
        self.tabBarController?.view.addSubview(splashView)
        //アニメーション開始
        splashView.startAnimation{
            //アニメ終了時の処理
        }
        
    
        
    }
    

}

extension RoomViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rooms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //セルを取得する
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let room = rooms[indexPath.row]
        
        cell.textLabel?.text = room.name
        
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let room = rooms[indexPath.row]
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        performSegue(withIdentifier: "toRoom", sender: room.documentId)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "toRoom"{
            let chatVC = segue.destination as! ChatViewController
            chatVC.documentId = sender as! String
            
        }
    }
    
    
}
