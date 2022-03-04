//
//  ViewController.swift
//  SearchSweetsApp
//
//  Created by 中野翔太 on 2022/03/03.
//

import UIKit
// JSONの構造
struct ResultJson: Codable {
    let item: [ItmeJson]?
}
struct ItmeJson: Codable {
    let name: String?
    let maker: String?
    let url: URL?
    let image: URL?
}
var okashiList: [ResultJson] = []

class ViewController: UIViewController, UISearchBarDelegate, UITableViewDataSource {

    @IBOutlet private weak var searchText: UISearchBar!
    @IBOutlet private weak var tableView: UITableView!

    // 画面表示の際に１回しか呼ばれない
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
             // dataとresponseが取れなかったら早期リターン&オプショナルバインディングの役割
        guard let response = response, let data = data else {
                return
            }

            do {
                let json = try JSONDecoder().decode(ResultJson.self, from: data)
                okashiList.append(json)
//                self.tableView.reloadData()
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
//        cell.configure(titleImage: , titleLabel: <#T##String#>)
        return cell
    }
}
