//
//  TopViewController.swift
//  infinite_scroll
//
//  Created by yujin on 2022/02/06.
//

import UIKit

private let identifier = "cell"
class labelCell : UITableViewCell{
    
    @IBOutlet weak var label: UILabel!
}

class TopViewController: ViewController, UITableViewDataSource, UITableViewDelegate {
    
   
    var fruits : [String]? = nil
    var standingBy = true
    var isBottom = false
    var bottomOffsetY : CGFloat = 9999999.0
    var cellHeight : CGFloat? = nil
    
    @IBOutlet weak var recordTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        recordTable.delegate = self
        recordTable.dataSource = self

        fruits = ["nuts","lemon","grape","banana"]
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        fruits?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : labelCell = recordTable.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! labelCell
        
        cell.label.text = fruits?[indexPath.row]
        cellHeight = cell.bounds.height
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        if isBottom == true{
            bottomOffsetY = scrollView.contentOffset.y
        }
   
 
        if standingBy && scrollView.contentOffset.y < CGFloat(-60.0) {
            standingBy = false
            
            print("contentOffset", scrollView.contentOffset.y)
            
            let item_counter = fruits?.count
            fruits?.insert("up" + String(item_counter!+1), at: 0)
            
            let indexPath = NSIndexPath(item: Int(floor(Double(fruits!.count/2))), section: 0)
            recordTable.scrollToRow(at: indexPath as IndexPath, at: UITableView.ScrollPosition.middle, animated: true)
            recordTable.reloadData()
            Timer.scheduledTimer(timeInterval: 2, target:self, selector: #selector(timeUP), userInfo: nil, repeats: false)
            
            if cellHeight != nil{
                bottomOffsetY = (cellHeight! * CGFloat(fruits!.count+1)) + cellHeight!
                print("bottomOffset",bottomOffsetY)
            }
        }
        
        if standingBy && scrollView.contentOffset.y > bottomOffsetY {
            standingBy = false
            
            print("contentOffset", scrollView.contentOffset.y)
            let item_counter = fruits?.count
            fruits?.append("down" + String(item_counter!+1))
            
            let indexPath = NSIndexPath(item: Int(floor(Double(fruits!.count/2))), section: 0)
            recordTable.scrollToRow(at: indexPath as IndexPath, at: UITableView.ScrollPosition.middle, animated: true)
            recordTable.reloadData()
            Timer.scheduledTimer(timeInterval: 2, target:self, selector: #selector(timeUP), userInfo: nil, repeats: false)
        }
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if indexPath.row == fruits!.count-1 {
            isBottom = true
        }else{
            isBottom = false
        }
    }
    
    @objc func timeUP(){
        standingBy = true
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
