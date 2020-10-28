//
//  ComposeViewController.swift
//  BasicMemo
//
//  Created by Fenta on 2020/10/27.
//

import UIKit

class ComposeViewController: UIViewController {
    
    var editTarget: Memo?
    var originalMemoContent: String?

    @IBOutlet var memoTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let memo = editTarget {
            navigationController?.title = "Edit Memo"
            memoTextView.text = memo.content
            originalMemoContent = memo.content
        } else {
            navigationController?.title = "New Memo"
            memoTextView.text = ""
        }

        memoTextView.delegate = self
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.presentationController?.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.presentationController?.delegate = nil
    }
    
    @IBAction func cancel(_ sender: Any) { dismiss(animated: true) }
    
    @IBAction func save(_ sender: Any) {
        guard let content = memoTextView.text, content.count > 0 else {
            alert(title: "내용 없음", message: "빈 메모는 저장할 수 없습니다")
            return
        }
        
        if let target = editTarget {
            target.content = content
            DataManager.shared.saveContext()
            NotificationCenter.default.post(name: ComposeViewController.memoDidChange, object: nil)
        } else {
            DataManager.shared.addNewMemo(content)
            NotificationCenter.default.post(name: ComposeViewController.newMemoDidInsert, object: nil)
        }
        
        dismiss(animated: true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ComposeViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if let original = originalMemoContent, let edited = textView.text {
            if #available(iOS 13.0, *) {
                isModalInPresentation = original != edited
            } else {
                // Fallback on earlier versions
            }
        }
    }
}

extension ComposeViewController: UIAdaptivePresentationControllerDelegate {
    func presentationControllerDidAttemptToDismiss(_ presentationController: UIPresentationController) {
        let alert = UIAlertController(title: "알림",
                                      message: "편집한 내용을 저장할까요?",
                                      preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "저장",
                                     style: .default) { [weak self] (action) in
            self?.save(action)
        }
        
        let cancelAction = UIAlertAction(title: "저장 안함",
                                         style: .cancel) { [weak self] (action) in
            self?.cancel(action)
        }
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
}

extension ComposeViewController {
    static let newMemoDidInsert = Notification.Name(rawValue: "newMemoDidInsert")
    static let memoDidChange = Notification.Name(rawValue: "memoDidChange")
}
