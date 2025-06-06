// HNSwift/SafariView.swift

import SwiftUI
import SafariServices
import WebKit

// 创建一个 SwiftUI 视图来包装 SFSafariViewController
struct SafariView: UIViewControllerRepresentable {
    
    let url: URL
    
    @AppStorage(DefaultKeys.enableReaderMode) private var enableReaderMode = false
    func makeUIViewController(context: UIViewControllerRepresentableContext<SafariView>) -> SFSafariViewController {
        let configuration = SFSafariViewController.Configuration()
        configuration.entersReaderIfAvailable = enableReaderMode
        print("loading url: \(url)")
        let sfViewController = SFSafariViewController(url: url, configuration: configuration)
        sfViewController.delegate = context.coordinator
        return sfViewController
    }

    func updateUIViewController(_ uiViewController: SFSafariViewController, context: UIViewControllerRepresentableContext<SafariView>) {
        // 不需要更新
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    class Coordinator: NSObject, SFSafariViewControllerDelegate  {
        var parent: SafariView
        
        init(parent: SafariView) {
            self.parent = parent
        }
        
        func safariViewController(_ controller: SFSafariViewController, didCompleteInitialLoad didLoadSuccessfully: Bool) {
            print("did finish initial load.")
        }
        
        func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
            // safari dismissed.
            print("did finish.")
        }
    }
    
}

// 添加一个 SwiftUI 视图包装器
struct SafariViewWrapper: View {
    let url: URL
    
    var body: some View {
        SafariView(url: url)
            .id(url)
    }
}

class WebCacheManager {
    static let shared = WebCacheManager()
    private let cache = NSCache<NSURL, WKWebView>()
    
    private init() {
        cache.countLimit = 10 // 限制缓存页面数量
    }
    
    func getCachedWebView(for url: URL) -> WKWebView? {
        return cache.object(forKey: url as NSURL)
    }
    
    func cacheWebView(_ webView: WKWebView, for url: URL) {
        cache.setObject(webView, forKey: url as NSURL)
    }
}
