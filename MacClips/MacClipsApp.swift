//
//  MacClipsApp.swift
//  MacClips
//
//  Created by blank on 2022/8/18.
//

import SwiftUI
import HotKey

class AppDelegate: NSObject, NSApplicationDelegate,ObservableObject {
    
    //快捷键初始化
    var popover = NSPopover.init()
    let hotKey = HotKey(key: .escape, modifiers: [.control])  // Global hotkey
    
    override class func awakeFromNib() {}
    
    //剪切板初始化
    let clipboard = Clipboard()
    
    
    //复制数据初始化
    @Published var copydata=CopyData(CopyList: [CopyItem(id:UUID(),value:"copy sample",times:Date(),type:1)],isadd:true,count:500)
    
    //app运行时调用
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        //剪切板监视
        clipboard.startListening()
        //新的剪切文字
        clipboard.onNewCopy { (content) in
            if(self.copydata.isadd==true)
            {
                let copyitem=CopyItem(id:UUID(),value:content,times:Date(),type:1)
                self.copydata.addItem(copyItem:copyitem)
                self.objectWillChange.send()
            }
            else
            {
                self.copydata.setadd(isadd: true)
            }
        }
        //新的剪切图片
        clipboard.onNewCopyImg { (content) in
            if(self.copydata.isadd==true)
            {
                let img=NSImage(data:content)
                let copyitem=CopyItem(id:UUID(),times:Date(),type:2,image: img)
                self.copydata.addItem(copyItem:copyitem)
                self.objectWillChange.send()
            }
            else
            {
                self.copydata.setadd(isadd: true)
            }
        }
        //快捷键响应
        hotKey.keyUpHandler = {                                 // Global hotkey handler
            self.togglePopover()
            
        }
    }
    
    //备用
    func applicationDidHide (_ notification: Notification) {
        print("hide")
        if let documentsPathURL = FileManager.default.urls(for: .applicationScriptsDirectory, in: FileManager.SearchPathDomainMask.userDomainMask).first {
            //This gives you the URL of the path
            print(documentsPathURL)
            
        }
        if let frontApp=NSWorkspace.shared.frontmostApplication{
            print (frontApp.bundleIdentifier!)
        }
    }
    //自动粘贴
    func applicationDidResignActive(_ notification:Notification)
    {
        print("ResignActive")
        if let documentsPathURL = FileManager.default.urls(for: .applicationScriptsDirectory, in: FileManager.SearchPathDomainMask.userDomainMask).first {
            //This gives you the URL of the path
            print(documentsPathURL)
           
            let scptFile=documentsPathURL.appendingPathComponent("copy.scpt")
            print(scptFile)
            let scp=try!NSUserScriptTask(url: scptFile)
            scp.execute()
        }
        if let frontApp=NSWorkspace.shared.frontmostApplication{
            print (frontApp.bundleIdentifier!)
        }
    }
    //重新恢复
    func applicationDidBecomeActive(_ notification: Notification) {
        
        if let window = NSApp.windows.first {
            window.deminiaturize(nil)
        }
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        
    }
    //快捷键激活
    func showPopover(_ sender: AnyObject? = nil) {
        print("show")
        
        NSApplication.shared.activate(ignoringOtherApps: true)
        
    }
    func closePopover(_ sender: AnyObject? = nil) {
        popover.performClose(sender)
    }
    
    func togglePopover(_ sender: AnyObject? = nil) {
        if popover.isShown {
            closePopover(sender)
        } else {
            showPopover(sender)
        }
    }
}

@main
struct MacClipsApp: App {
    
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    let persistenceController = PersistenceController.shared
    var body: some Scene {
        WindowGroup{
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
            
        }
    }
}


