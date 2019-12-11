//
//  ChatUser.swift
//  NexSeedChat
//
//  Created by 原田茂大 on 2019/12/11.
//  Copyright © 2019 geshi. All rights reserved.
//

import Foundation
import MessageKit

struct ChatUser: SenderType {
    //ユーザーID
    //FirebaseのAuthenticationのuidを使う
    var senderId: String
    
    //表示名
    var displayName: String
    
    //アイコン画像のURL
    let photoUrl: String
}
