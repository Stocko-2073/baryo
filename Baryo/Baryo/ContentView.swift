import Cocoa
import HotKey

class AppDelegate: NSObject, NSApplicationDelegate {
    var searchWindow: SearchWindow?
    private var hotKey: HotKey = HotKey(key: .space, modifiers: [.option])
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        createSearchWindow()
        setupMenu()
        setupGlobalHotKey()
    }
    
    private func setupGlobalHotKey() {
        hotKey.keyDownHandler = { [weak self] in
            self?.showSearchWindow()
        }
    }
    
    private func setupMenu() {
        let menu = NSMenu()
        let showItem = NSMenuItem(title: "Show Bar", action: #selector(showSearchWindow), keyEquivalent: "b")
        showItem.keyEquivalentModifierMask = [.command, .shift]
        showItem.target = self
        menu.addItem(showItem)
        
        let quitItem = NSMenuItem(title: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q")
        quitItem.keyEquivalentModifierMask = .command
        menu.addItem(quitItem)
        
        NSApp.mainMenu = NSMenu()
        let appMenuItem = NSMenuItem()
        NSApp.mainMenu?.addItem(appMenuItem)
        appMenuItem.submenu = menu
    }
    
    private func createSearchWindow() {
        searchWindow = SearchWindow()
    }
    
    @objc func showSearchWindow() {
        guard let window = searchWindow else { return }
        window.showWindow()
    }
}

class SearchWindow: NSPanel {
    private let searchField = NSTextField()
    private let resultsController = SearchResultsController()
    
    override init(contentRect: NSRect, styleMask style: NSWindow.StyleMask, backing backingStoreType: NSWindow.BackingStoreType, defer flag: Bool) {
        super.init(contentRect: NSRect(x: 0, y: 0, width: 600, height: 50),
                  styleMask: [.nonactivatingPanel, .resizable],
                  backing: .buffered,
                  defer: false)
        
        setupWindow()
        setupSearchField()
        setupLayout()
    }
    
    private func setupWindow() {
        level = .floating
        backgroundColor = NSColor.controlBackgroundColor.withAlphaComponent(0.9)
        isOpaque = false
        hasShadow = true
        isMovableByWindowBackground = false
        
        let visualEffect = NSVisualEffectView()
        visualEffect.blendingMode = .behindWindow
        visualEffect.state = .active
        visualEffect.material = .hudWindow
        contentView = visualEffect
        
        center()
    }
    
    private func setupSearchField() {
        searchField.placeholderString = "Search Baryo..."
        searchField.font = NSFont.systemFont(ofSize: 18, weight: .medium)
        searchField.isBordered = false
        searchField.backgroundColor = NSColor.clear
        searchField.focusRingType = .none
        searchField.delegate = self
        
        contentView?.addSubview(searchField)
    }
    
    private func setupLayout() {
        searchField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            searchField.leadingAnchor.constraint(equalTo: contentView!.leadingAnchor, constant: 20),
            searchField.trailingAnchor.constraint(equalTo: contentView!.trailingAnchor, constant: -20),
            searchField.centerYAnchor.constraint(equalTo: contentView!.centerYAnchor),
            searchField.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    func showWindow() {
        let screenFrame = NSScreen.main?.frame ?? NSRect.zero
        let windowFrame = frame
        let x = (screenFrame.width - windowFrame.width) / 2
        let y = screenFrame.height * 0.8 - windowFrame.height / 2
        
        setFrame(NSRect(x: x, y: y, width: windowFrame.width, height: windowFrame.height), display: true)
        makeKeyAndOrderFront(nil)
        searchField.becomeFirstResponder()
        searchField.stringValue = ""
    }
    
    func hideWindow() {
        orderOut(nil)
        searchField.resignFirstResponder()
    }
}

extension SearchWindow: NSTextFieldDelegate {
    func controlTextDidChange(_ obj: Notification) {
        let query = searchField.stringValue
        
        if query.isEmpty {
            animateToHeight(50)
        } else {
            animateToHeight(200)
            resultsController.search(query: query)
        }
    }
    
    private func animateToHeight(_ height: CGFloat) {
        let currentFrame = frame
        let newFrame = NSRect(x: currentFrame.origin.x,
                            y: currentFrame.origin.y + (currentFrame.height - height),
                            width: currentFrame.width,
                            height: height)
        
        NSAnimationContext.runAnimationGroup { context in
            context.duration = 0.2
            context.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            animator().setFrame(newFrame, display: true)
        }
    }
}

class SearchResultsController {
    func search(query: String) {
        print("Searching for: \(query)")
    }
}
