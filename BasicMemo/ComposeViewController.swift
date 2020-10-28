//
//  ComposeViewController.swift
//  BasicMemo
//
//  Created by Fenta on 2020/10/27.
//

import UIKit

class ComposeViewController: UIViewController {

    @IBOutlet var memoTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func cancel(_ sender: Any) { dismiss(animated: true) }
    
    @IBAction func save(_ sender: Any) {
        guard let text = memoTextView.text, text.count > 0 else {
            alert(title: "내용 없음", message: "빈 메모는 저장할 수 없습니다")
            return
        }
        
        DataManager.shared.addNewMemo(text)
        
        NotificationCenter.default.post(name: ComposeViewController.newMemoDidInsert, object: nil)
        
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

extension ComposeViewController {
    static let newMemoDidInsert = Notification.Name(rawValue: "newMemoDidInsert")
}
