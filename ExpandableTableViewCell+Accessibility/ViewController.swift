//
//  ViewController.swift
//  ExpandableTableViewCell+Accessibility
//
//  Created by Matheus Pedrosa on 11/01/20.
//  Copyright © 2020 Matheus Pedrosa. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    lazy private var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.register(TableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    let cells: [Cell] = [
        Cell(title: "Banana", description: "Banana amerela."),
        Cell(title: "Maçã", description: "Maçã vermelha."),
        Cell(title: "Abacate", description: "Abacate verde.")
    ]
    
    private var arrExpandedCells = [Bool]()

    override func viewDidLoad() {
        super.viewDidLoad()
        buildViewHierarchy()
        setupConstraints()
        forceLightMode()
        for _ in cells {
            arrExpandedCells.append(false)
        }
    }
    
    private func forceLightMode() {
        overrideUserInterfaceStyle = .light
    }

    private func buildViewHierarchy() {
        self.view.addSubview(tableView)
    }
    
    private func setupConstraints() {
        tableView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
        tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0).isActive = true
        tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0).isActive = true
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell",
                                                 for: indexPath) as! TableViewCell
        cell.setupCell(cell: cells[indexPath.row],
                       delegate: self,
                       index: indexPath,
                       isExpanded: arrExpandedCells[indexPath.row])
        return cell
    }
    
}

extension ViewController: TableViewCellDelegate {
    func didTouchExpandButton(at index: IndexPath, isExpanded: Bool) {
        arrExpandedCells[index.row] = isExpanded
        tableView.reloadRows(at: [index], with: .automatic)
    }

}
