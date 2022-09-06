//
//  CopyData.swift
//  MacClips
//
//  Created by blank on 2022/8/26.
//

import Foundation
import AppKit

class CopyData:ObservableObject {
    @Published var CopyList: [CopyItem]
    var isadd:Bool=true
    var count:Int=500
    init(CopyList: [CopyItem],isadd:Bool,count:Int) {
        self.CopyList = CopyList
        self.isadd=true
        self.count=count
    }
    func addItem(copyItem:CopyItem){
        self.CopyList.insert(copyItem,at:0)
    }
    func setadd(isadd:Bool){
        self.isadd=isadd
    }
}

struct CopyItem:Identifiable {
    var id=UUID()
    var value: String?=nil
    var times:Date
    var type:Int
    var image:NSImage? = nil
}
