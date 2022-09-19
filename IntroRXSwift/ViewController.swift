//
//  ViewController.swift
//  IntroRXSwift
//
//  Created by Alex Kulish on 19.09.2022.
//

import UIKit
import RxSwift
import RxCocoa

struct Item {
    let imageString: String
    let title: String
}

struct ItemViewModel {
    var items = PublishSubject<[Item]>()
    
    func fetchItems() {
        let products = [
        Item(imageString: "house", title: "Home"),
        Item(imageString: "gear", title: "Settings"),
        Item(imageString: "person.circle", title: "Profile"),
        Item(imageString: "airplane", title: "Flights"),
        Item(imageString: "bell", title: "Activity"),
        ]
        
        items.onNext(products)
        items.onCompleted()
    }
}

class ViewController: UIViewController {
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    private var viewModel = ItemViewModel()
    private var bag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.frame = view.bounds
        bindTableData()
    }
    
    func bindTableData() {
        
        // Bind items to table
        viewModel.items.bind(to: tableView.rx.items( cellIdentifier: "cell", cellType: UITableViewCell.self)) { row, model, cell in
            cell.textLabel?.text = model.title
            cell.imageView?.image = UIImage(systemName: model.imageString)
        }.disposed(by: bag)
        // Bind a model selected handler
        tableView.rx.modelSelected(Item.self).bind { item in
            print(item.title)
        }.disposed(by: bag)
        // fetch items
        viewModel.fetchItems()
    }
    

}

