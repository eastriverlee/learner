//
//  SVG.swift
//  SVG
//
//  Created by dan lee on 2021/09/15.
//
import SwiftUI
import WebKit

extension String {
	subscript(_ range: PartialRangeFrom<Int>) -> String {
		let start = self.index(self.startIndex, offsetBy: range.lowerBound)
		let end = self.index(self.startIndex, offsetBy: self.count)
		return String(self[start..<end])
	}
	subscript(_ range: PartialRangeUpTo<Int>) -> String {
		let start = self.startIndex
		let end = self.index(self.startIndex, offsetBy: range.upperBound)
		return String(self[start..<end])
	}
	subscript(_ range: Range<Int>) -> String {
		let start = self.index(self.startIndex, offsetBy: range.lowerBound)
		let end = self.index(self.startIndex, offsetBy: range.upperBound)
		return String(self[start..<end])
	}
}

extension CGFloat {
	init(_ string: String) {
		self = CGFloat((string as NSString).floatValue)
	}
}

struct SVG: View {
	private let content: String
	var height: CGFloat = 0
	var width: CGFloat = 0
	
	init(_ content: String) {
		self.content = content
		retrieveSize()
	}
	
	var body: some View {
		SVGView(content)
			.edgesIgnoringSafeArea(.all)
			.frame(width: width, height: height)
	}
	
	private mutating func retrieveSize() {
		let header = content[content.startIndex..<content.firstIndex(of: ">")!].components(separatedBy: " ")
		for word in header {
			if word.hasPrefix("height=") {
				var value = word[7...]
				value = value.trimmingCharacters(in: ["\"", "'"])
				height = CGFloat(value) + 20
			} else if word.hasPrefix("width=") {
				var value = word[6...]
				value = value.trimmingCharacters(in: ["\"", "'"])
				width = CGFloat(value) + 20
			}
		}
	}
}

struct SVGView: NSViewRepresentable {
	private let content: String
	
	init(_ content: String) {
		self.content = content
	}
	func makeNSView(context: Context) -> WKWebView {
		let webView = WKWebView()
		return webView
	}
	func updateNSView(_ webView: WKWebView, context: Context) {
		webView.loadHTMLString(content, baseURL: nil)
	}
}
