//
//  ContentView.swift
//  SwiftUICompressionFolder
//
//  Created by Angelos Staboulis on 26/11/24.
//

import SwiftUI
import AppleArchive
import Foundation
import System
import Cocoa
struct ContentView: View {
    @State var sourceFolder:String
    @State var destinationFolder:String
    var body: some View {
        VStack {
            Text("Enter source path for folder").frame(width:350,height:25,alignment: .leading)
            TextField("Enter source path for folder",text:$sourceFolder).frame(width:350,height:25,alignment: .leading)
            Text("Enter destination path for folder").frame(width:350,alignment: .leading)
            TextField("Enter destination path for folder",text:$destinationFolder).frame(width:350,height:25,alignment: .leading)
            HStack{
                Button {
                    compressionFolder(source: sourceFolder, destination: destinationFolder)
                } label: {
                    Text("Compress Folder").frame(width:340,height:45,alignment: .center)
                }
            }.padding(10)
        }
        
    }
    func compressionFolder(source:String,destination:String){
        let src = source
        let archiveDestination = destination
        let archiveFilePath = FilePath(archiveDestination)
        guard let writeFileStream = ArchiveByteStream.fileStream(
                path: archiveFilePath,
                mode: .writeOnly,
                options: [ .create ],
                permissions: FilePermissions(rawValue: 0o644)) else {
            return
        }
        defer {
            try? writeFileStream.close()
        }
        guard let compressStream = ArchiveByteStream.compressionStream(
                using: .lzfse,
                writingTo: writeFileStream) else {
            return
        }
        defer {
            try? compressStream.close()
        }
        guard let encodeStream = ArchiveStream.encodeStream(writingTo: compressStream) else {
            return
        }
        defer {
            try? encodeStream.close()
        }
        guard let keySet = ArchiveHeader.FieldKeySet("TYP,PAT,LNK,DEV,DAT,UID,GID,MOD,FLG,MTM,BTM,CTM") else {
            return
        }
        do {
            try encodeStream.writeDirectoryContents(
                archiveFrom: FilePath(src),
                keySet: keySet)
        } catch {
            fatalError("Write directory contents failed.")
        }

    }
}

#Preview {
    ContentView(sourceFolder: "", destinationFolder: "")
}
