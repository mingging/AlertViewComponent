//
//  AlertView.swift
//  UI
//
//  Created by min on 2023/12/22.
//  Copyright © 2023 Kkonmo. All rights reserved.
//

import UIKit

public class AlertView: UIView {
    
    public enum ActionStyle {
        case `default`
        case cancel
        case destructive
    }
    
    private let contentView: UIView = {
        let view = UIView()
        view.frame = .init(x: 0, y: 0, width: UIScreen.main.bounds.width - 64, height: 180)
        view.backgroundColor = .white
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 15
        return view
    }()
    
    private let contentTitle: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .black
        return label
    }()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .black
        return label
    }()
    
    var actionViewArray: [UIView] = []
    var actionHandlerArray: [() -> ()] = []
    
    @objc func selectActionButton(_ sender: UIButton) {
        self.dismiss()
        // handler 가 없는 경우를 위함
        if actionHandlerArray.count > sender.tag {
            actionHandlerArray[sender.tag]()
        }
    }
    
    public func present() {
        let rootView = UIApplication.shared.keyWindow?.rootViewController?.view
        rootView?.addSubview(self)
        self.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    public func dismiss() {
        guard let _ = self.superview else { return }
        self.removeFromSuperview()
    }
    
    // title, description, oneButton, twoButton, okbutton, okHandler, cancelButton, cancelHandler
    public init(title: String, message: String) {
        super.init(frame: .zero)
        setUI()
        setLayout()
        setData(title: title, message: message)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func addAction(title: String, style: ActionStyle, handler: (() -> ())? = nil) {
        // action 갯수 만큼 뷰 만들기
        makeAction(title: title, style: style, handler: handler)
    }
    
    private func setData(title: String, message: String) {
        self.contentTitle.text = title
        self.messageLabel.text = message
    }
    
    private func setUI() {
        self.backgroundColor = .black.withAlphaComponent(0.3)
        self.addSubview(contentView)
        
        [
            contentTitle,
            messageLabel
        ].forEach {
            contentView.addSubview($0)
        }
    }
    
    private func setLayout() {
        contentTitle.snp.makeConstraints {
            $0.top.equalToSuperview().inset(32)
            $0.leading.trailing.equalToSuperview().inset(24)
        }
    
        messageLabel.snp.makeConstraints {
            $0.top.equalTo(contentTitle.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview().inset(74)
        }
        
        contentView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(32)
            $0.center.equalToSuperview()
            $0.bottom.equalTo(messageLabel.snp.bottom).offset(74)
        }
    }
    
    private func makeAction(title: String, style: ActionStyle, handler: (() -> ())?) {
        
        // 추가
        let actionView: UIView = {
            let view = UIView()
            view.backgroundColor = .white
            view.accessibilityLabel = title
            return view
        }()
        
        let actionButton: UIButton = {
            let button = UIButton()
            button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
            button.setTitle(title, for: .normal)
            button.addTarget(self, action: #selector(selectActionButton), for: .touchUpInside)
            return button
        }()
        
        actionViewArray.append(actionView)
        
        // handler 가 있는 경우 handler 추가
        // handler 가 없는데 style 이 .cancel 일 경우 dismiss 추가
        // handler 가 없는 경우 아무것도 실행 안함
        
        // handler 가 있는 경우
        if let handler = handler {
            // handler 추가
            actionHandlerArray.append(handler)
        } else {
            // handler 없는 경우 style 이 dismiss 인 경우
            if style == .cancel || style == .default {
                actionHandlerArray.append(dismiss)
            }
        }
        
        // 태그 추가
        actionButton.tag = actionViewArray.count - 1
        
        // 스타일에 따라 버튼 색상 수정
        switch style {
        case .default:
            actionButton.setTitleColor(.primaryNormal, for: .normal)
        case .cancel:
            actionButton.setTitleColor(.textSub, for: .normal)
        case .destructive:
            actionButton.setTitleColor(.statusNegative, for: .normal)
        }
        
        actionView.addSubview(actionButton)
        contentView.addSubview(actionView)
        
        actionButton.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        // 액션이 한 개 일때
        if actionViewArray.count > 1 {
            if let firstActionView = actionViewArray.first {
                firstActionView.snp.makeConstraints {
                    $0.bottom.equalToSuperview()
                    $0.leading.equalToSuperview()
                    $0.width.equalToSuperview().multipliedBy(0.5)
                    $0.height.equalTo(60)
                }
            }
            
            if let lastActionView = actionViewArray.last {
                lastActionView.snp.makeConstraints {
                    $0.bottom.equalToSuperview()
                    $0.trailing.equalToSuperview()
                    $0.width.equalToSuperview().multipliedBy(0.5)
                    $0.height.equalTo(60)
                }
            }
        } else {
            if let firstActionView = actionViewArray.first {
                firstActionView.snp.makeConstraints {
                    $0.bottom.equalToSuperview()
                    $0.leading.trailing.equalToSuperview()
                    $0.height.equalTo(60)
                }
            }
        }
    }
}
