//
//  TableViewCell.swift
//  ExpandableTableViewCell+Accessibility
//
//  Created by Matheus Pedrosa on 11/01/20.
//  Copyright © 2020 Matheus Pedrosa. All rights reserved.
//

import UIKit

protocol TableViewCellDelegate: class {
    func didTouchExpandButton(at index: IndexPath, isExpanded: Bool)
}

class TableViewCell: UITableViewCell {

    weak var delegate: TableViewCellDelegate?
    private var index: IndexPath = IndexPath()
    private var isExpanded = Bool()
    private var hiddenDescriptionLabelHeightConstraint = CGFloat()
    private var cell: Cell?
    
    lazy private var containerView: UIView = {
        let view = UIView(frame: .zero)
        view.isAccessibilityElement = false
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy private var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.isAccessibilityElement = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.accessibilityTraits = .staticText
        return label
    }()
    
    lazy private var expandButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.isAccessibilityElement = true
        button.addTarget(self,
                         action: #selector(expandButtonWasTapped),
                         for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .systemBlue
        button.setTitleColor(.systemBlue, for: .normal)
        return button
    }()
    
    lazy private var hiddenDescriptionLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.isAccessibilityElement = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.accessibilityTraits = .staticText
        return label
    }()
    
    public func setupCell(cell: Cell,
                          delegate: TableViewCellDelegate,
                          index: IndexPath,
                          isExpanded: Bool) {
        self.delegate = delegate
        self.index = index
        self.isExpanded = isExpanded
        self.cell = cell
        configureCell(isExpanded)
        configureViews()
    }
    
    @objc
    private func expandButtonWasTapped() {
        isExpanded.toggle()
        delegate?.didTouchExpandButton(at: index, isExpanded: isExpanded)
    }
    
    private func configureCell(_ isExpanded: Bool) {
        titleLabel.text = cell?.title
        if isExpanded {
            hiddenDescriptionLabelHeightConstraint = 48
            hiddenDescriptionLabel.text = cell?.description
            hiddenDescriptionLabel.accessibilityElementsHidden = !isExpanded
            expandButton.setTitle("ocultar", for: .normal)
        } else {
            hiddenDescriptionLabelHeightConstraint = 0
            hiddenDescriptionLabel.text = ""
            hiddenDescriptionLabel.accessibilityElementsHidden = !isExpanded
            expandButton.setTitle("expandir", for: .normal)
        }
    }
    
    private func configureViews() {
        buildViewHierarchy()
        setupConstraints()
        isAccessibilityElement = false
        selectionStyle = .none
        accessibilityElements = isExpanded ? [titleLabel, expandButton, hiddenDescriptionLabel] : [titleLabel, expandButton]
    }
    
    private func buildViewHierarchy() {
        containerView.addSubview(titleLabel)
        containerView.addSubview(expandButton)
        if isExpanded {
            containerView.addSubview(hiddenDescriptionLabel)
        }
        
        contentView.addSubview(containerView)
    }
    
    private func setupConstraints() {
        setupContainerViewConstraints()
        setupTitleLabelConstraints()
        setupExpandButtonConstraints()
        if isExpanded {
            setupHiddenDescriptionLabelConstraints()
        }
    }
    
    private func setupContainerViewConstraints() {
        containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0).isActive = true
        containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0).isActive = true
        containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0).isActive = true
        containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0).isActive = true
        if isExpanded {
            containerView.heightAnchor.constraint(equalToConstant: 120).isActive = true
        } else {
            containerView.heightAnchor.constraint(equalToConstant: 64).isActive = true
        }
    }
    
    private func setupTitleLabelConstraints() {
        titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: expandButton.leadingAnchor, constant: -8).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 24).isActive = true
    }
    
    private func setupHiddenDescriptionLabelConstraints() {
        hiddenDescriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8).isActive = true
        hiddenDescriptionLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20).isActive = true
        hiddenDescriptionLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: 20).isActive = true
        hiddenDescriptionLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20).isActive = true
        hiddenDescriptionLabel.heightAnchor.constraint(equalToConstant: hiddenDescriptionLabelHeightConstraint).isActive = true
    }
    
    private func setupExpandButtonConstraints() {
        expandButton.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20).isActive = true
        expandButton.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 8).isActive = true
        expandButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20).isActive = true
        expandButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
        expandButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
    }
    
}
