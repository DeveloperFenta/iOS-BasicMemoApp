//
//  Model.swift
//  BasicMemo
//
//  Created by Fenta on 2020/10/27.
//

import Foundation

class Memo {
    var content: String
    var insertDate: Date
    
    init(content: String) {
        self.content = content
        insertDate = Date()
    }
    
    static var dummyMemoList: [Memo] = {
        var memoList = [Memo]()
        
        for index in 0 ... 100 {
            memoList.append(Memo(content: "Dummy Memo \(index)"))
        }
        
        return memoList
    }()
}
