//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Ricardo Boccato Alves on 9/6/15.
//  Copyright (c) 2015 Ricardo Boccato Alves. All rights reserved.
//

import Foundation

final class RecordedAudio: NSObject {
    var filePathUrl: NSURL
    var title: String
    init(filePathUrl: NSURL, title: String) {
        self.filePathUrl = filePathUrl
        self.title = title
    }
}
