//
//  ViewController.swift
//  SearchSweetsApp
//
//  Created by 中野翔太 on 2022/03/03.
//

import UIKit
import SafariServices
// JSONの構造
struct ResultJson: Codable {
    let item: [ItemJson]?
}
struct ItemJson: Codable {
    let name: String
    let maker: String
    let url: URL
    let image: URL
}
private var okashiList: [ItemJson] = []

class ViewController: UIViewController, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate, SFSafariViewControllerDelegate {
    @IBOutlet private weak var searchText: UISearchBar!
    @IBOutlet private weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
        if let searchWord = searchBar.text {
            print(searchWord)
            // 検索ボタンを押すと実行される
            searchOkashi(keyword: searchWord)
        }
    }
    func searchOkashi(keyword: String) {
                                                // 取得した文字列をエンコードしている
        guard let keywordEncode = keyword.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            return
        }
        guard let requestUrl = URL(string: "https://sysbird.jp/toriko/api/?apikey=guest&format=json&keyword=\(keywordEncode)&max=10&order=r") else {
            return
        }
        let task = URLSession.shared.dataTask(with: requestUrl){ data, response, error in
            if let error = error {
                return print(error.localizedDescription)
            }
             // dataとresponseが取得できなかったらこれ以上処理を進めたくないので早期リターンする。
        guard let response = response, let data = data else {
                return
            }

            do {
                let jsons = try JSONDecoder().decode(ResultJson.self, from: data)
                // 二次元配列となっているので一次元配列に変換して値を取り出しやすくする。
                jsons.item.map { json in
                    okashiList += json
                    print( json)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        okashiList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell1", for: indexPath) as? CustomCell else {
             fatalError()
        }
        cell.configureTitle(titleName: okashiList[indexPath.row].name)
        if let imageData = try? Data(contentsOf: okashiList[indexPath.row].image) {
                                                            // オプショナルの値が入って来ることがないので強制アンラップして良い？？
            cell.coufiureImage(imageData: UIImage(data: imageData)!)
        }

        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 選択解除
        tableView.deselectRow(at: indexPath, animated: true)
        let safariViewController = SFSafariViewController(url: okashiList[indexPath.row].url)
        // 通知先を自身にする
        safariViewController.delegate = self
        present(safariViewController, animated: true, completion: nil)
    }
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        dismiss(animated: true, completion: nil)
    }
}
