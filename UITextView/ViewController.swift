//
//  ViewController.swift
//  UITextView
//
//  Created by Дмитрий Данилин on 16.07.2020.
//  Copyright © 2020 Дмитрий Данилин. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var textViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var progressView: UIProgressView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //назначсем делегата, для функцианирования методов из расширения
        textView.delegate = self
        
        // Настраиваем прозрачность текста при активном индикатора активности
        textView.isHidden = true
//        // Устанавливаем прозрачность текста
//        textView.alpha = 0
        
        // Кастомизируем view
        view.backgroundColor = .systemGreen
        
        // Кастомизируем textView
        //textView.text = nil
        textView.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 17)
        textView.backgroundColor = view.backgroundColor
        // Скругляем углы текстового поля
        textView.layer.cornerRadius = 10
        
        // Кастомизируем stepper
        stepper.value = 17
        stepper.minimumValue = 10
        stepper.maximumValue = 25
        stepper.tintColor = .white
        stepper.backgroundColor = .gray
        stepper.layer.cornerRadius = 10
        
        // Индикатор исчезнет по окончанию его действия
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = #colorLiteral(red: 0.4233732877, green: 0.4787296661, blue: 1, alpha: 1)
        activityIndicator.startAnimating()
        // Деактивация интерфейса
        self.view.isUserInteractionEnabled = false
        
        progressView.setProgress(0, animated: true)
        
        // Поднимаем или опускаем текст, в зависимости от активации и деактивации клавиатуры (0)
        // Наблюдатель за появлением клавиатуры
        NotificationCenter.default.addObserver(self, selector: #selector(updateTextView(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        // Наблюдатель за скрытием клавиатуры
        NotificationCenter.default.addObserver(self, selector: #selector(updateTextView(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
//        // Логика анимации индикатора активности
//        UIView.animate(withDuration: 0, delay: 3, options: .curveLinear, animations: {
//            self.textView.alpha = 1
//        }) { (finished) in
//            self.activityIndicator.stopAnimating()
//            self.textView.isHidden = false
//            // Активация интерфейса
//            self.view.isUserInteractionEnabled = true
//        }
        
        // Таймер для заполнения индикатора прогресса
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if self.progressView.progress != 1 {
                self.progressView.progress += 0.2
            } else {
                self.activityIndicator.stopAnimating()
                self.textView.isHidden = false
                // Активация интерфейса
                self.view.isUserInteractionEnabled = true
                self.progressView.isHidden = true
            }
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        self.view.endEditing(true) // Скрытие клавиатуры вызванной для любого объекта
    }
    
    // Поднимаем или опускаем текст, в зависимости от активации и деактивации клавиатуры (1)
    @objc func updateTextView(notification: Notification) {
        
        guard let userInfo = notification.userInfo as? [String: Any], let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            textView.contentInset = UIEdgeInsets.zero
        } else {
            textView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardFrame.height - textViewBottomConstraint.constant, right: 0)
            // Сдвигаем индикатор прокрутки
            textView.scrollIndicatorInsets = textView.contentInset
        }
        
        // Определяем зону видимости скроллинга
        textView.scrollRangeToVisible(textView.selectedRange)
    }
    @IBAction func sizeFont(_ sender: UIStepper) {
        
        let font = textView.font?.fontName
        let fontSize = CGFloat(sender.value)
        
        textView.font = UIFont(name: font!, size: fontSize)
    }
}

extension ViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.backgroundColor = .white
        textView.textColor = .gray
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        textView.backgroundColor = view.backgroundColor
        textView.textColor = .black
    }
    
    // Метод для подсчета количества вводимых символов
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        countLabel.text = "\(textView.text.count)"
        // Ограничиваем количество вводимых символов
        return true //textView.text.count + (text.count - range.length) <= 60
    }
}

