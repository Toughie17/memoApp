//
//  ViewController.swift
//  MemoApp
//
//  Created by KimChoonSik on 2023/03/01.
//

import UIKit

final class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let memoManager = CoreDataManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNaviBar()
        setupTableView()
    }
    
    //화면에 다시 진입 할 때마다 테이블뷰 리로드 (데이터 업데이트)
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

     func setupNaviBar() {
        self.title = "메모"
        
        // 우측에 plus 버튼 추가(메모 추가)
        let plusButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(plusButtonTapped))
        plusButton.tintColor = .black
        navigationItem.rightBarButtonItem = plusButton
    }
    

    
     func setupTableView() {
        tableView.dataSource = self
//        tableView.delegate   = self
        //테이블뷰의 선 없애는 코드
        tableView.separatorStyle = .none
    }
    
    @objc func plusButtonTapped() {
        performSegue(withIdentifier: "MemoCell", sender: nil)
    }
    

}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memoManager.getMemoDataList().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemoCell", for: indexPath) as! MemoCell
        //셀에 데이터 전달
        let memoData = memoManager.getMemoDataList()
        cell.memoData = memoData[indexPath.row]
        
        //셀 위의 업데이트 버튼이 눌렀을 때 클로저를 전달
        // 강한참조를 방지하기 위해 캡처리스트
        cell.updateButtonPressed = { [weak self] (senderCell) in
            //뷰컨트롤러의 세그웨이 실행
            self?.performSegue(withIdentifier: "MemoCell", sender: indexPath)
        }
        cell.selectionStyle = .none
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    //called when the user taps a row in a table view, indicating that the user has selected that row.
    //유저가 테이블뷰의 로우를 선택했을때 호출되는 함수 (뷰컨(테이블뷰의 delegate)아 유저가 테이블뷰의 어떤 로우를 선택했어!)
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "MemoCell", sender: indexPath)
        //해당 셀로 넘어가는 segue 실행
    }
    
    //(세그웨이를 실행 할 때) 실제 데이터 전달(MemoData)
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MemoCell" {
            let detailVC = segue.destination as! DetailViewController
            
            //해당 row의 데이터를 detailVC의 memoData 변수에 넘겨줌
            guard let indexPath = sender as? IndexPath else { return }
            detailVC.memoData = memoManager.getMemoDataList()[indexPath.row]
        }
    }
    
    // 유저가 텍스트를 많이 입력하면 셀의 세로 길이가 길어질 수 있기에 오토레이아웃 부분에 미리 설정해 두었음.
    // 테이블뷰의 높이를 자동적으로 추정하도록 하는 메서드
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
