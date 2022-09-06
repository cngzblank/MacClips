//
//  ContentView.swift
//  MacClips
//
//  Created by blank on 2022/8/18.
//

import SwiftUI
import AppKit
import CoreData

struct ContentView: View {
    @State var showAlert = false
    @State var value=""

    @EnvironmentObject var appdelegate:AppDelegate
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>
    
    var dateFormatter: DateFormatter {
        let df = DateFormatter()
        df.dateFormat = "MMM d, h:mm a"
        df.dateStyle = .medium
        df.timeStyle = .short
        df.doesRelativeDateFormatting = true
        return df
    }
    
    var body: some View {
        HStack {
            VStack {
                /*
                HStack{
                    TextField("请输入搜索内容", text: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Value@*/.constant("")/*@END_MENU_TOKEN@*/)
                    Button("Search") {
                        
                    }}
                 */
                List(appdelegate.copydata.CopyList){
                    dataitem in
                    switch(dataitem.type){
                    case 1:
                        HStack{
                            Text("\(dataitem.times,formatter:dateFormatter)")
                                .font(.title)
                                .fixedSize()
                            Text(dataitem.value ?? "").font(.title).multilineTextAlignment(.leading).lineLimit(nil).padding().frame( height: 1.5).frame(maxWidth: .infinity,alignment: .leading)}
                        .fixedSize(horizontal: false, vertical: false)        .frame(maxWidth:.infinity)
                        .onTapGesture(count: 2) {
                            self.showAlert = true
                            self.value=dataitem.value!
                            
                            let pasteboard = NSPasteboard.general
                            pasteboard.clearContents()
                            pasteboard.setString(self.value, forType: .string)
                            appdelegate.copydata.setadd(isadd:false)
                            NSApplication.shared.hide(nil)
                            
                        }
                        Divider()
                        
                    case 2:
                        HStack{
                            Text("\(dataitem.times,formatter:dateFormatter)")
                                .font(.title)
                                .fixedSize()
                            Image(nsImage: dataitem.image!)    .resizable()
                                .frame( height: 64)
                        }.onTapGesture {
                            self.showAlert = true
                            let pasteboard = NSPasteboard.general
                            pasteboard.clearContents()
                            pasteboard.writeObjects([dataitem.image!])
                            appdelegate.copydata.setadd(isadd:false)
                            NSApplication.shared.hide(nil)

                        }

                        Divider()
                    default:
                        HStack{
                            Text("\(dataitem.times,formatter:dateFormatter)")
                                .font(.title)
                                .fixedSize()
                            Text(dataitem.value ?? "").font(.title).multilineTextAlignment(.leading).lineLimit(nil).padding().frame( height: 1.5).frame(maxWidth: .infinity,alignment: .leading)}
                        
                        
                    }
                }.fixedSize(horizontal: false, vertical: false)
                
            }
            
        }
    }
    
}

struct Previews_ContentView_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Group {
            Text("Hello, World!")
            Text("Hello, World!")
        }/*@END_MENU_TOKEN@*/
    }
}
