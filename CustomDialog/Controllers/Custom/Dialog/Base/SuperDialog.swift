//
//  SuperDialog.swift
//  CustomDialog
//
//  Created by JackYe on 2019/6/25.
//  Copyright © 2019 JackYe. All rights reserved.
//

import UIKit
import RxSwift
import SnapKit

/// 按钮样式
///
/// - `default`: 弹框底部左右对齐
/// - center: 居中
/// - horizontal: 水平排列
enum BtnsStyle {
    case `default`
    case center
    case horizontal
}

enum CloseStyle {
    case right
    case bottom
}

protocol DialogDataSource {
    
    /// 容器视图
    func contentView(dialog: UIViewController) -> UIView
}

class SuperDialog: UIViewController, DialogDataSource {
    
    var disposeBag = DisposeBag()
    
    typealias OnListenBlock = () -> ()
    
    /// The custom transition presentation manager
    fileprivate var presentationManager: PresentationManager!
    fileprivate lazy var interactor = InteractiveTransition()

    public fileprivate(set) var actions: [DialogAction] = []
    public var buttons: [UIButton] = []
    
    /// 点击背景消失弹框
    var tapOutsideDismiss: Bool = true
    var closeStyle: CloseStyle = .right
    var btnsStyle: BtnsStyle = .default
    
    var dismissBlock: OnListenBlock?
    
    private var _contentView: UIView?
    var contentView: UIView {
        get{
            guard let view = _contentView else {
                _contentView = self.contentView(dialog: self)
                return _contentView!
            }
            return view
        }
    }
    
    init(_ transitionStyle: PopupDialogTransitionStyle = .zoomIn) {
        super.init(nibName: nil, bundle: nil)
        
        // Init the presentation manager
        presentationManager     = PresentationManager(transitionStyle: transitionStyle, interactor: interactor)
        transitioningDelegate   = presentationManager
        modalPresentationStyle  = .custom
    }
    

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        setupBtnsLayout()
    }
    
    override func loadView() {
        super.loadView()
        
        setupViews()
        setupLayout()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    //MARK: - DialogDataSource
    func contentView(dialog: UIViewController) -> UIView {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }
    
    func setupViews() {
        
        view.addSubview(contentView)
    }
    
    func setupLayout() {
        
        contentView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    //MARK: - Method
    public func addAction(_ action: DialogAction) {
        actions.append(action)
        creatButton(action: action)
    }
    
    public func addButtons(_ buttons: [DialogAction]) {
        actions += buttons
        creatButtons()
    }
    
    func creatButtons() {
        
        for action in actions {
            self.creatButton(action: action)
        }
    }
    
    /// 创建按钮
    func creatButton(action: DialogAction) { }
    
    /// 设置按钮布局
    func setupBtnsLayout() {}
    
    // MARK: - Action
    @objc func buttonTapped(_ sender: UIButton) {
        
        let action = actions[sender.tag]
        dismissWithCompletion { () -> Void in
            action.handler?(action)
        }
    }
    
    func actionTapped(_ action: DialogAction) {
        
        dismissWithCompletion { () -> Void in
            action.handler?(action)
        }
    }
    
    @objc func dismissWithCompletion(_ completion: (() -> Void)?) {
        presentingViewController?.dismiss(animated: true, completion: {
            
            completion?()
            self.dismissBlock?()
        })
    }
    
    @objc func _dismiss() {
        dismissWithCompletion(nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        guard let t = touches.first ,let touchView = t.view , touchView == self.view else {
            return
        }
        
        guard tapOutsideDismiss == true else {
            return
        }
        
        self._dismiss()
    }
    
    deinit {
        
        print("销毁")
    }
}
