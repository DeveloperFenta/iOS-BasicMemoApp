//
//  DetailViewController.swift
//  BasicMemo
//
//  Created by Fenta on 2020/10/28.
//

import UIKit

class DetailViewController: UIViewController {
    
    var memo: Memo?
    
    @IBOutlet var memoTableView: UITableView!
    
    let formatter: DateFormatter = {
        let f = DateFormatter()
        f.dateStyle = .long
        f.timeStyle = .short
        f.locale = Locale(identifier: "Ko_kr")
        
        return f
    }()
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination.children.first as? ComposeViewController {
            vc.editTarget = memo
        }
    }
    
    var token: NSObjectProtocol?
    
    deinit {
        if let token = token {
            NotificationCenter.default.removeObserver(token)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        token = NotificationCenter.default.addObserver(forName: ComposeViewController.memoDidChange, object: nil, queue: OperationQueue.main) { [weak self] (noti) in
            self?.memoTableView.reloadData()
        }

        // Do any additional setup after loading the view.
    }
    
    @IBAction func deleteMemo(_ sender: Any) {
        let alert = UIAlertController(title: "삭제 확인",
                                      message: "메모를 삭제할까요?",
                                      preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "삭제",
                                     style: .destructive) { [weak self] (action) in
            DataManager.shared.deleteMemo(self?.memo)
            self?.navigationController?.popViewController(animated: true)
        }
        
        let cancelAction = UIAlertAction(title: "취소",
                                         style: .cancel)
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    @IBAction func shareMemo(_ sender: Any) {
        guard let memo = memo?.content else { return }
        
        let shareVC = UIActivityViewController(activityItems: [memo], applicationActivities: nil)
        
        present(shareVC, animated: true)
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

extension DetailViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell =  tableView.dequeueReusableCell(withIdentifier: "memoContentCell", for: indexPath)
            
            cell.textLabel?.text = memo?.content
            
            return cell
        case 1:
            let cell =  tableView.dequeueReusableCell(withIdentifier: "memoDateCell", for: indexPath)
            
            cell.textLabel?.text = formatter.string(for: memo?.insertDate)
            
            return cell
        default:
            fatalError()
        }
    }
    
}
